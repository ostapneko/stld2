{-# LANGUAGE OverloadedStrings #-}

module Presenters.RecurringTask where

import           Data.Aeson
import qualified Data.Text as T

import qualified Models.RecurringTask as M

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

fromModel :: M.RecurringTask -> RecurringTask
fromModel model =
    RecurringTask { recurringTaskId          = M.taskId model
                  , recurringTaskDescription = M.description model
                  , recurringTaskActive      = True
                  , recurringTaskEnabled     = M.enabled model
                  , recurringTaskFrequency   = M.frequency model
                  }
