{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TupleSections #-}

{-|
Module      : $Header$
Copyright   : (c) 2015 Swinburne Software Innovation Lab
License     : BSD3

Maintainer  : Shannon Pace <space@swin.edu.au>
Stability   : unstable
Portability : portable

Functions for obtaining total machine resources via Graphite.
-}

module Eclogues.Monitoring.Graphite where

import qualified Eclogues.Job as Job
import Eclogues.Monitoring.Cluster
import Units (Core, MiB, MB, mega, mebi, byte, core, second)
import qualified Units as U

import Control.Lens (view, (&), (.~))
import Control.Lens.TH (makeClassy)
import Control.Monad.Trans.Maybe (MaybeT(..), runMaybeT)
import Control.Monad.Trans.Reader (ReaderT(..), withReaderT)
import Data.Aeson (FromJSON, parseJSON, (.:))
import qualified Data.Aeson.Types as AT (Value(Object, Array))
import Data.ByteString.Lazy.Char8 (ByteString)
import Data.HashMap.Lazy (fromList)
import Data.List (intercalate)
import Data.Maybe (catMaybes)
import Data.Text (Text, pack, unpack)
import qualified Data.Vector as V
import Network.Wreq (Response, Options, param, defaults, getWith, asJSON, responseBody)
import Safe (headMay)

-- Structures for parsing Graphite data
data Result = Result { metricName :: Text }

instance FromJSON Result where
    parseJSON (AT.Object o) = Result <$> o .: "text"
    parseJSON _ = fail "Invalid graphite result"

data SeriesPoint = SeriesPoint { _value :: Integer
                               , _stamp :: Integer }

$(makeClassy ''SeriesPoint)

instance FromJSON (Maybe SeriesPoint) where
    parseJSON (AT.Array v)
        | V.length v == 2 = do
            x::Maybe Integer <- parseJSON $ v V.! 0
            y::Integer       <- parseJSON $ v V.! 1
            pure $ SeriesPoint <$> x <*> pure y
        | otherwise = fail "Unexpected number of elements in Graphite timestamp bucket"
    parseJSON _ = fail "Invalid Graphite timestamp bucket"

data SeriesData = SeriesData { _target :: String
                             , _points :: [SeriesPoint] }

$(makeClassy ''SeriesData)

instance FromJSON SeriesData where
    parseJSON (AT.Object o) = do
        t <- o .: "target"
        p <- o .: "datapoints"
        pure $ SeriesData t (catMaybes p)
    parseJSON _ = fail "Invalid Graphite series"

seriesState :: Num a => SeriesData -> Maybe a
seriesState = fmap (fromInteger . view value) . headMay . view points

-- Transformer stack for Graphite requests
type URLReaderT = ReaderT String

-- Convenience functions for building Graphite requests
singleParam :: Text -> Text -> Options -> Options
singleParam z x y = y & param z .~ [x]

findParam, targetParam, fromParam, formatParam ::
    Text -> Options -> Options
findParam = singleParam "query"
targetParam = singleParam "target"
fromParam = singleParam "from"
formatParam = singleParam "format"

graphitePath :: [String] -> Text
graphitePath = pack . intercalate "."

-- GET conveniences
bodyJSON :: FromJSON a => Response ByteString -> URLReaderT IO a
bodyJSON r = pure . view responseBody =<< asJSON r

getWith' :: [Options -> Options] -> URLReaderT IO (Response ByteString)
getWith' options = ReaderT $ \url -> getWith (foldr ($) defaults options) url

getWithEndpoint :: [String] -> [Options -> Options] -> URLReaderT IO (Response ByteString)
getWithEndpoint endpoint options = withReaderT (++ intercalate "/" endpoint) $ getWith' options

-- Graphite requests
getHosts :: Text -> URLReaderT IO [Text]
getHosts host = map metricName <$> (bodyJSON =<< getWithEndpoint ["metrics", "find"] [findParam host])

getSeries :: [String] -> URLReaderT IO [SeriesData]
getSeries path = bodyJSON =<< getWithEndpoint ["render"] options
    where options = [targetParam (graphitePath path), fromParam "-30sec", formatParam "json"]

getSeriesState :: Num a => [String] -> MaybeT (URLReaderT IO) a
getSeriesState path = MaybeT $ do
    series <- getSeries path
    pure $ do
        pts <- view points <$> headMay series
        val <- view value <$> headMay pts
        pure $ fromInteger val

monitorCores :: String -> MaybeT (URLReaderT IO) (U.Value Double Core)
monitorCores host = core <$> getSeriesState path
    where path = [host, "mesos-slave", "gauge-slave_cpus_total"]

monitorRam :: String -> MaybeT (URLReaderT IO) (U.Value Double MiB)
monitorRam host = mebi byte <$> getSeriesState path
    where path = [host, "mesos-slave", "gauge-slave_mem_total"]

monitorDisk :: String -> MaybeT (URLReaderT IO) (U.Value Double MB)
monitorDisk host = mega byte <$> getSeriesState path
    where path = [host, "mesos-slave", "gauge-slave_disk_total"]

monitorResources :: String -> MaybeT (URLReaderT IO) Job.Resources
monitorResources host = mResources <$> monitorDisk host <*> monitorRam host <*> monitorCores host
    where mResources disk ram cpu = Job.Resources disk ram cpu (second 0)

getResources :: String -> MaybeT (URLReaderT IO) (String, Job.Resources)
getResources host = (host,) <$> monitorResources host

getCluster :: URLReaderT IO Cluster
getCluster = fromList . catMaybes <$> (resources =<< getHosts "virgil-*")
    where resources = mapM (runMaybeT . getResources . unpack)
