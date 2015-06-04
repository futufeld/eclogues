{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Eclogues.Persist.Stage1 where

import Eclogues.Scheduling.Command (ScheduleCommand)
import Eclogues.TaskSpec (TaskSpec, JobState)

import Data.Aeson (FromJSON, ToJSON, encode, eitherDecodeStrict)
import qualified Data.ByteString.Lazy as BSL
import Data.Either.Combinators (mapLeft)
import Data.Monoid ((<>))
import qualified Data.Text as T
import qualified Database.Persist as P
import qualified Database.Persist.Sql as PSql

jsonPersistValue :: (ToJSON a) => a -> P.PersistValue
jsonPersistValue = P.PersistByteString . BSL.toStrict . encode

jsonPersistParse :: (FromJSON a) => T.Text -> P.PersistValue -> Either T.Text a
jsonPersistParse _ (P.PersistByteString bs) = mapLeft T.pack $ eitherDecodeStrict bs
jsonPersistParse n e                        = Left . (("Invalid " <> n <> " persist value ") <>) . T.pack $ show e

instance P.PersistField JobState where
    toPersistValue = jsonPersistValue
    fromPersistValue = jsonPersistParse "JobState"

instance PSql.PersistFieldSql JobState where
    sqlType _ = PSql.SqlBlob

instance P.PersistField TaskSpec where
    toPersistValue = jsonPersistValue
    fromPersistValue = jsonPersistParse "TaskSpec"

instance PSql.PersistFieldSql TaskSpec where
    sqlType _ = PSql.SqlBlob

instance P.PersistField ScheduleCommand where
    toPersistValue = jsonPersistValue
    fromPersistValue = jsonPersistParse "ScheduleCommand"

instance PSql.PersistFieldSql ScheduleCommand where
    sqlType _ = PSql.SqlBlob