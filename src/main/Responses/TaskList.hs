{-# LANGUAGE OverloadedStrings #-}

module Responses.TaskList
    ( TaskListResponse(..)
    ) where

import           Data.Aeson
import qualified Data.Text  as T

import           Presenters.UniqueTask
import           Presenters.RecurringTask

data TaskListResponse = TaskListResponse
    { uniqueTasks    :: [UniqueTask]
    , recurringTasks :: [RecurringTask]
    }

instance ToJSON TaskListResponse where
    toJSON (TaskListResponse ut rt) =
        object [ "uniqueTasks"    .= ut
               , "recurringTasks" .= rt
               ]
