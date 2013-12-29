{-# LANGUAGE OverloadedStrings #-}

module Presenters.TaskList
    ( TaskList(..)
    ) where

import           Data.Aeson

import           Presenters.UniqueTask
import           Presenters.RecurringTask

data TaskList = TaskList
    { uniqueTasks    :: [UniqueTask]
    , recurringTasks :: [RecurringTask]
    }

instance ToJSON TaskList where
    toJSON (TaskList ut rt) =
        object [ "uniqueTasks"    .= ut
               , "recurringTasks" .= rt
               ]
