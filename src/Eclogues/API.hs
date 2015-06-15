{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators #-}

module Eclogues.API where

import Eclogues.TaskSpec (JobStatus, JobState, TaskSpec, Name)

import Data.Aeson.TH (deriveJSON, defaultOptions)
import Servant.API ((:>), (:<|>), Get, Post, Put, Delete, ReqBody, Capture, JSON)

type Get' = Get '[JSON]

type VAPI =  "jobs"   :> Get' [JobStatus]
        :<|> "job"    :> Capture "name" Name :> Get' JobStatus
        :<|> "job"    :> Capture "name" Name :> "state" :> Get' JobState
        :<|> "job"    :> Capture "name" Name :> "state" :> ReqBody '[JSON] JobState :> Put '[JSON] ()
        :<|> "job"    :> Capture "name" Name :> "scheduler" :> Get' ()
        :<|> "job"    :> Capture "name" Name :> Delete '[JSON] ()
        :<|> "create" :> ReqBody '[JSON] TaskSpec  :> Post '[JSON] ()
        :<|> "health" :> Get' Health

data JobError = JobNameUsed
              | NoSuchJob
              | JobMustExist Name
              | JobCannotHaveFailed Name
              | JobMustBeTerminated Bool
              | OutstandingDependants [Name]
              | InvalidStateTransition String
              | SchedulerRedirect String
              | SchedulerInaccessible
                deriving (Show)

data Health = Health { schedulerAccessible :: Bool }

$(deriveJSON defaultOptions ''JobError)
$(deriveJSON defaultOptions ''Health)
