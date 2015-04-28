{-# LANGUAGE OverloadedStrings #-}

module AuroraAPI ( Client, Result, JobConfiguration
                 , thriftClient, acquireLock, releaseLock, createJob
                 , getJobs, getTasksWithoutConfigs, killTasks ) where

import Api_Types ( Response (response_responseCode, response_result)
                 , JobConfiguration, getJobsResult_configs, result_getJobsResult
                 , SessionKey (..), LockValidation (UNCHECKED)
                 , Lock, result_acquireLockResult, acquireLockResult_lock
                 , TaskQuery (..), default_TaskQuery
                 , ScheduledTask, result_scheduleStatusResult,scheduleStatusResult_tasks )
import qualified Api_Types
import Api_Types2 (ResponseCode (OK))
import qualified AuroraSchedulerManager_Client as AClient
import qualified ReadOnlyScheduler_Client as ROClient

import AuroraConfig (auroraJobConfig, lockKey, defaultJobKey)
import TaskSpec (TaskSpec, Name)

import Control.Applicative ((<$>), pure)
import Control.Monad (void)
import Control.Monad.Trans.Except (ExceptT (..))
import Data.Foldable (toList)
import qualified Data.HashSet as HashSet
import Network.URI (URI)
import Thrift.Protocol.JSON (JSONProtocol (..))
import Thrift.Transport.HttpClient (HttpClient, openHttpClient)

type Client = (JSONProtocol HttpClient, JSONProtocol HttpClient)
type Result a = ExceptT Response IO a

onlyOK :: Response -> Either Response Response
onlyOK res = case response_responseCode res of
    Api_Types2.OK -> Right res
    _             -> Left res

onlyRes :: Response -> Either Response Api_Types.Result
onlyRes resp = case response_result <$> onlyOK resp of
    Right (Just res) -> Right res
    _                -> Left resp

-- TODO: output a list?
getJobs :: Client -> Result (HashSet.HashSet JobConfiguration)
getJobs client = do
    res <- ExceptT $ onlyRes <$> ROClient.getJobs client ""
    pure . getJobsResult_configs $ result_getJobsResult res

taskQuery :: [Name] -> TaskQuery
taskQuery names = default_TaskQuery { taskQuery_jobKeys = Just . HashSet.fromList $ defaultJobKey <$> names }

getTasksWithoutConfigs :: Client -> [Name] -> Result [ScheduledTask]
getTasksWithoutConfigs client names = do
    res <- ExceptT $ onlyRes <$> ROClient.getTasksWithoutConfigs client q
    pure $ tasks res
    where
        q = taskQuery names
        tasks = toList . scheduleStatusResult_tasks . result_scheduleStatusResult

unauthenticated :: SessionKey
unauthenticated = SessionKey (Just "UNAUTHENTICATED") (Just "UNAUTHENTICATED")

acquireLock :: Client -> Name -> Result Lock
acquireLock client name = do
    res <- ExceptT $ onlyRes <$> AClient.acquireLock client (lockKey name) unauthenticated
    pure . acquireLockResult_lock $ result_acquireLockResult res

releaseLock :: Client -> Lock -> Result ()
releaseLock client lock = void . ExceptT $ onlyOK <$> AClient.releaseLock client lock UNCHECKED unauthenticated

createJob :: Client -> TaskSpec -> Result ()
createJob client spec = void . ExceptT $ onlyOK <$> AClient.createJob client (auroraJobConfig spec) Nothing unauthenticated

killTasks :: Client -> [Name] -> Result ()
killTasks client names = void . ExceptT $ onlyOK <$> AClient.killTasks client (taskQuery names) Nothing unauthenticated

thriftClient :: URI -> IO Client
thriftClient uri = do
    transport <- openHttpClient uri
    let proto = JSONProtocol transport
    pure (proto, proto)
