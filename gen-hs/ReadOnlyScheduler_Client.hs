{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-missing-fields #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
{-# OPTIONS_GHC -fno-warn-name-shadowing #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-----------------------------------------------------------------
-- Autogenerated by Thrift Compiler (0.9.2)                      --
--                                                             --
-- DO NOT EDIT UNLESS YOU ARE SURE YOU KNOW WHAT YOU ARE DOING --
-----------------------------------------------------------------

module ReadOnlyScheduler_Client(getRoleSummary,getJobSummary,getTasksStatus,getTasksWithoutConfigs,getPendingReason,getConfigSummary,getJobs,getQuota,populateJobConfig,getLocks,getJobUpdateSummaries,getJobUpdateDetails) where
import qualified Data.IORef as R
import Prelude (($), (.), (>>=), (==), (++))
import qualified Prelude as P
import qualified Control.Exception as X
import qualified Control.Monad as M ( liftM, ap, when )
import Data.Functor ( (<$>) )
import qualified Data.ByteString.Lazy as LBS
import qualified Data.Hashable as H
import qualified Data.Int as I
import qualified Data.Maybe as M (catMaybes)
import qualified Data.Text.Lazy.Encoding as E ( decodeUtf8, encodeUtf8 )
import qualified Data.Text.Lazy as LT
import qualified Data.Typeable as TY ( Typeable )
import qualified Data.HashMap.Strict as Map
import qualified Data.HashSet as Set
import qualified Data.Vector as Vector
import qualified Test.QuickCheck.Arbitrary as QC ( Arbitrary(..) )
import qualified Test.QuickCheck as QC ( elements )

import qualified Thrift as T
import qualified Thrift.Types as T
import qualified Thrift.Arbitraries as T


import Api_Types
import ReadOnlyScheduler
seqid = R.newIORef 0
getRoleSummary (ip,op) = do
  send_getRoleSummary op
  recv_getRoleSummary ip
send_getRoleSummary op = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("getRoleSummary", T.M_CALL, seqn)
  write_GetRoleSummary_args op (GetRoleSummary_args{})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_getRoleSummary ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_GetRoleSummary_result ip
  T.readMessageEnd ip
  P.return $ getRoleSummary_result_success res
getJobSummary (ip,op) arg_role = do
  send_getJobSummary op arg_role
  recv_getJobSummary ip
send_getJobSummary op arg_role = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("getJobSummary", T.M_CALL, seqn)
  write_GetJobSummary_args op (GetJobSummary_args{getJobSummary_args_role=arg_role})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_getJobSummary ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_GetJobSummary_result ip
  T.readMessageEnd ip
  P.return $ getJobSummary_result_success res
getTasksStatus (ip,op) arg_query = do
  send_getTasksStatus op arg_query
  recv_getTasksStatus ip
send_getTasksStatus op arg_query = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("getTasksStatus", T.M_CALL, seqn)
  write_GetTasksStatus_args op (GetTasksStatus_args{getTasksStatus_args_query=arg_query})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_getTasksStatus ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_GetTasksStatus_result ip
  T.readMessageEnd ip
  P.return $ getTasksStatus_result_success res
getTasksWithoutConfigs (ip,op) arg_query = do
  send_getTasksWithoutConfigs op arg_query
  recv_getTasksWithoutConfigs ip
send_getTasksWithoutConfigs op arg_query = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("getTasksWithoutConfigs", T.M_CALL, seqn)
  write_GetTasksWithoutConfigs_args op (GetTasksWithoutConfigs_args{getTasksWithoutConfigs_args_query=arg_query})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_getTasksWithoutConfigs ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_GetTasksWithoutConfigs_result ip
  T.readMessageEnd ip
  P.return $ getTasksWithoutConfigs_result_success res
getPendingReason (ip,op) arg_query = do
  send_getPendingReason op arg_query
  recv_getPendingReason ip
send_getPendingReason op arg_query = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("getPendingReason", T.M_CALL, seqn)
  write_GetPendingReason_args op (GetPendingReason_args{getPendingReason_args_query=arg_query})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_getPendingReason ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_GetPendingReason_result ip
  T.readMessageEnd ip
  P.return $ getPendingReason_result_success res
getConfigSummary (ip,op) arg_job = do
  send_getConfigSummary op arg_job
  recv_getConfigSummary ip
send_getConfigSummary op arg_job = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("getConfigSummary", T.M_CALL, seqn)
  write_GetConfigSummary_args op (GetConfigSummary_args{getConfigSummary_args_job=arg_job})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_getConfigSummary ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_GetConfigSummary_result ip
  T.readMessageEnd ip
  P.return $ getConfigSummary_result_success res
getJobs (ip,op) arg_ownerRole = do
  send_getJobs op arg_ownerRole
  recv_getJobs ip
send_getJobs op arg_ownerRole = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("getJobs", T.M_CALL, seqn)
  write_GetJobs_args op (GetJobs_args{getJobs_args_ownerRole=arg_ownerRole})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_getJobs ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_GetJobs_result ip
  T.readMessageEnd ip
  P.return $ getJobs_result_success res
getQuota (ip,op) arg_ownerRole = do
  send_getQuota op arg_ownerRole
  recv_getQuota ip
send_getQuota op arg_ownerRole = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("getQuota", T.M_CALL, seqn)
  write_GetQuota_args op (GetQuota_args{getQuota_args_ownerRole=arg_ownerRole})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_getQuota ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_GetQuota_result ip
  T.readMessageEnd ip
  P.return $ getQuota_result_success res
populateJobConfig (ip,op) arg_description = do
  send_populateJobConfig op arg_description
  recv_populateJobConfig ip
send_populateJobConfig op arg_description = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("populateJobConfig", T.M_CALL, seqn)
  write_PopulateJobConfig_args op (PopulateJobConfig_args{populateJobConfig_args_description=arg_description})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_populateJobConfig ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_PopulateJobConfig_result ip
  T.readMessageEnd ip
  P.return $ populateJobConfig_result_success res
getLocks (ip,op) = do
  send_getLocks op
  recv_getLocks ip
send_getLocks op = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("getLocks", T.M_CALL, seqn)
  write_GetLocks_args op (GetLocks_args{})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_getLocks ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_GetLocks_result ip
  T.readMessageEnd ip
  P.return $ getLocks_result_success res
getJobUpdateSummaries (ip,op) arg_jobUpdateQuery = do
  send_getJobUpdateSummaries op arg_jobUpdateQuery
  recv_getJobUpdateSummaries ip
send_getJobUpdateSummaries op arg_jobUpdateQuery = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("getJobUpdateSummaries", T.M_CALL, seqn)
  write_GetJobUpdateSummaries_args op (GetJobUpdateSummaries_args{getJobUpdateSummaries_args_jobUpdateQuery=arg_jobUpdateQuery})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_getJobUpdateSummaries ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_GetJobUpdateSummaries_result ip
  T.readMessageEnd ip
  P.return $ getJobUpdateSummaries_result_success res
getJobUpdateDetails (ip,op) arg_updateId = do
  send_getJobUpdateDetails op arg_updateId
  recv_getJobUpdateDetails ip
send_getJobUpdateDetails op arg_updateId = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("getJobUpdateDetails", T.M_CALL, seqn)
  write_GetJobUpdateDetails_args op (GetJobUpdateDetails_args{getJobUpdateDetails_args_updateId=arg_updateId})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_getJobUpdateDetails ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_GetJobUpdateDetails_result ip
  T.readMessageEnd ip
  P.return $ getJobUpdateDetails_result_success res
