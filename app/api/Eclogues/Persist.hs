{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -fno-warn-unused-binds #-}

module Eclogues.Persist ( PersistAction, PersistContext
                        , withPersistDir, atomically
                        , insert, updateState, delete, scheduleIntent, deleteIntent
                        , allIntents, allJobs )
                        where

import Eclogues.Persist.Stage1 ()
import Eclogues.Scheduling.Command (ScheduleCommand)
import Eclogues.JobSpec (Name, JobSpec, JobStatus (JobStatus))
import qualified Eclogues.JobSpec as Job

import Control.Lens ((^.))
import Control.Monad.Logger (LoggingT, runStderrLoggingT)
import Control.Monad.Trans.Reader (ReaderT)
import Data.Monoid ((<>))
import qualified Data.Text as T
import Data.UUID (UUID)
import Database.Persist.TH (mkPersist, sqlSettings, mkMigrate, share, persistLowerCase)
import Database.Persist ((==.), (=.))
import qualified Database.Persist as P
import qualified Database.Persist.Sql as PSql
import Database.Persist.Sqlite (withSqlitePool)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Job
    name Name
    spec JobSpec
    state Job.JobState
    uuid UUID
    UniqueName name
ScheduleIntent
    command ScheduleCommand
    UniqueCommand command
|]

newtype PersistContext  = PersistContext PSql.ConnectionPool
newtype PersistAction r = PersistAction (ReaderT PSql.SqlBackend IO r)
                          deriving (Functor, Applicative, Monad)

instance Monoid (PersistAction ()) where
    mempty = pure ()
    mappend = (*>)

withPersistDir :: FilePath -> (PersistContext -> LoggingT IO a) -> IO a
withPersistDir path f = runStderrLoggingT $ withSqlitePool ("WAL=off " <> (T.pack path) <> "/eclogues.db3") 1 act where
    act pool = do
        PSql.runSqlPool (PSql.runMigration migrateAll) pool
        f (PersistContext pool)

atomically :: PersistContext -> PersistAction r -> IO r
atomically (PersistContext pool) (PersistAction a) = PSql.runSqlPool a pool

insert :: JobStatus -> PersistAction ()
insert (JobStatus spec st uuid) = PersistAction $ P.insert_ job where
    job = Job { jobName = spec ^. Job.name
              , jobSpec = spec
              , jobState = st
              , jobUuid = uuid }

updateState :: Name -> Job.JobState -> PersistAction ()
updateState name st = PersistAction $ P.updateWhere [JobName ==. name] [JobState =. st]

delete :: Name -> PersistAction ()
delete = PersistAction . P.deleteBy . UniqueName

scheduleIntent :: ScheduleCommand -> PersistAction ()
scheduleIntent = PersistAction . P.insert_ . ScheduleIntent

deleteIntent :: ScheduleCommand -> PersistAction ()
deleteIntent = PersistAction . P.deleteBy . UniqueCommand

getAll :: (PSql.SqlBackend ~ PSql.PersistEntityBackend a, PSql.PersistEntity a) => (a -> b) -> PersistAction [b]
getAll f = PersistAction $ fmap (f . P.entityVal) <$> P.selectList [] []

allIntents :: PersistAction [ScheduleCommand]
allIntents = getAll scheduleIntentCommand

allJobs :: PersistAction [JobStatus]
allJobs = getAll toStatus where
    toStatus (Job _ spec st uuid) = JobStatus spec st uuid