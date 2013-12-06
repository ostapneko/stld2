{-# LANGUAGE OverloadedStrings #-}

module Services.Task
    ( taskListResponse
    ) where

import Responses.TaskList

taskListResponse :: IO TaskListResponse
taskListResponse = do
    let uts = [ UniqueTask 1 "Buy tickets" True
              , UniqueTask 2 "Buy rat food" False
              ]

    let rts = [ RecurringTask 1 "Cooking" True True 1
              , RecurringTask 2 "Running" False False 2
              ]

    return TaskListResponse
        { uniqueTasks    = uts
        , recurringTasks = rts
        }
