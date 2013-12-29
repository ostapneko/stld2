{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Models.RecurringTask
    ( RecurringTaskStatus(..)
    , RecurringTask(..)
    ) where

import           Control.Applicative


import           Data.Typeable
import qualified Data.Text as T

import           Database.PostgreSQL.Simple.FromField
import           Database.PostgreSQL.Simple.FromRow

data RecurringTaskStatus
    = Todo
    | Done
    | Skip
    deriving (Show, Eq, Typeable)

instance FromField RecurringTaskStatus where
    fromField f mdata = do
        text <- fromField f mdata :: Conversion T.Text
        case text of
            "todo" -> return Todo
            "done" -> return Done
            "skip" -> return Skip
            _      -> do
                let err = "Valid values are todo, done and skip"
                returnError ConversionFailed f err

data RecurringTask = RecurringTask
    { taskId        :: Int
    , description   :: T.Text
    , frequency     :: Int
    , enabled       :: Bool
    , status        :: RecurringTaskStatus
    , startedAtWeek :: Int
    , startedAtYear :: Int
    }

instance FromRow RecurringTask where
    fromRow = RecurringTask
          <$> field
          <*> field
          <*> field
          <*> field
          <*> field
          <*> field
          <*> field
