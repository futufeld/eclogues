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

module Api_Types2 where
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

data ResponseCode = INVALID_REQUEST|OK|ERROR|WARNING|AUTH_FAILED|LOCK_ERROR|ERROR_TRANSIENT  deriving (P.Show,P.Eq, TY.Typeable, P.Ord, P.Bounded)
instance P.Enum ResponseCode where
  fromEnum t = case t of
    INVALID_REQUEST -> 0
    OK -> 1
    ERROR -> 2
    WARNING -> 3
    AUTH_FAILED -> 4
    LOCK_ERROR -> 5
    ERROR_TRANSIENT -> 6
  toEnum t = case t of
    0 -> INVALID_REQUEST
    1 -> OK
    2 -> ERROR
    3 -> WARNING
    4 -> AUTH_FAILED
    5 -> LOCK_ERROR
    6 -> ERROR_TRANSIENT
    _ -> X.throw T.ThriftException
instance H.Hashable ResponseCode where
  hashWithSalt salt = H.hashWithSalt salt P.. P.fromEnum
instance QC.Arbitrary ResponseCode where
  arbitrary = QC.elements (P.enumFromTo P.minBound P.maxBound)

data ScheduleStatus = INIT|THROTTLED|PENDING|ASSIGNED|STARTING|RUNNING|FINISHED|PREEMPTING|RESTARTING|DRAINING|FAILED|KILLED|KILLING|LOST  deriving (P.Show,P.Eq, TY.Typeable, P.Ord, P.Bounded)
instance P.Enum ScheduleStatus where
  fromEnum t = case t of
    INIT -> 11
    THROTTLED -> 16
    PENDING -> 0
    ASSIGNED -> 9
    STARTING -> 1
    RUNNING -> 2
    FINISHED -> 3
    PREEMPTING -> 13
    RESTARTING -> 12
    DRAINING -> 17
    FAILED -> 4
    KILLED -> 5
    KILLING -> 6
    LOST -> 7
  toEnum t = case t of
    11 -> INIT
    16 -> THROTTLED
    0 -> PENDING
    9 -> ASSIGNED
    1 -> STARTING
    2 -> RUNNING
    3 -> FINISHED
    13 -> PREEMPTING
    12 -> RESTARTING
    17 -> DRAINING
    4 -> FAILED
    5 -> KILLED
    6 -> KILLING
    7 -> LOST
    _ -> X.throw T.ThriftException
instance H.Hashable ScheduleStatus where
  hashWithSalt salt = H.hashWithSalt salt P.. P.fromEnum
instance QC.Arbitrary ScheduleStatus where
  arbitrary = QC.elements (P.enumFromTo P.minBound P.maxBound)
