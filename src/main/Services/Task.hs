{-# LANGUAGE OverloadedStrings #-}

module Services.Task
    ( taskListResponse
    ) where

import           Database.PostgreSQL.Simple

import qualified Presenters.UniqueTask as PU
import qualified Presenters.RecurringTask as PR

import           Responses.TaskList

taskListResponse ::Connection -> IO TaskListResponse
taskListResponse conn = do
    uModels <- query_ conn "select * from unique_tasks"
    let uPresenters = map PU.fromModel uModels

    rModels <- query_ conn "select * from recurring_tasks"
    let rPresenters = map PR.fromModel rModels

    return TaskListResponse
        { uniqueTasks    = uPresenters
        , recurringTasks = rPresenters
        }
