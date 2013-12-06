{-# LANGUAGE OverloadedStrings #-}

module Responses.TaskList
    ( TaskListResponse(..)
    , UniqueTask(..)
    , RecurringTask(..)
    ) where

import           Data.Aeson
import qualified Data.Text  as T

data TaskListResponse = TaskListResponse
    { uniqueTasks    :: [UniqueTask]
    , recurringTasks :: [RecurringTask]
    }

instance ToJSON TaskListResponse where
    toJSON (TaskListResponse ut rt) =
        object [ "uniqueTasks"    .= ut
               , "recurringTasks" .= rt
               ]

data UniqueTask = UniqueTask
    { uniqueTaskId          :: Int
    , uniqueTaskDescription :: T.Text
    , uniqueTaskActive      :: Bool
    }

instance ToJSON UniqueTask where
    toJSON (UniqueTask uId uTd uTa) =
        object [ "id"          .= uId
               , "description" .= uTd
               , "active"      .= uTa
               ]

data RecurringTask = RecurringTask
    { recurringTaskId          :: Int
    , recurringTaskDescription :: T.Text
    , recurringTaskActive      :: Bool
    , recurringTaskEnabled     :: Bool
    , recurringTaskFrequency   :: Int
    }

instance ToJSON RecurringTask where
    toJSON rt =
        object [ "id"          .= recurringTaskId rt
               , "description" .= recurringTaskDescription rt
               , "active"      .= recurringTaskActive rt
               , "enabled"     .= recurringTaskEnabled rt
               , "frequency"   .= recurringTaskFrequency rt
               ]
