{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Models.UniqueTask
    ( UniqueTaskStatus(..)
    , UniqueTask(..)
    ) where

import           Control.Applicative


import           Data.Typeable
import qualified Data.Text as T

import           Database.PostgreSQL.Simple.FromField
import           Database.PostgreSQL.Simple.FromRow

data UniqueTaskStatus
    = Todo
    | Done
    | NotStarted
    deriving (Show, Eq, Typeable)

instance FromField UniqueTaskStatus where
    fromField f mdata = do
        text <- fromField f mdata :: Conversion T.Text
        case text of
            "todo"        -> return Todo
            "done"        -> return Done
            "not_started" -> return NotStarted
            _             -> do
                let err = "Valid values are todo, done and not_started"
                returnError ConversionFailed f err

data UniqueTask = UniqueTask
    { taskId      :: Int
    , description :: T.Text
    , status      :: UniqueTaskStatus
    }

instance FromRow UniqueTask where
    fromRow = UniqueTask
          <$> field
          <*> field
          <*> field
