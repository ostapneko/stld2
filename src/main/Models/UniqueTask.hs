{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Models.UniqueTask
    ( Status(..)
    , UniqueTask(..)
    ) where

import           Control.Applicative


import           Data.Typeable
import qualified Data.Text as T

import           Database.PostgreSQL.Simple.FromField
import           Database.PostgreSQL.Simple.ToField
import           Database.PostgreSQL.Simple.FromRow

data Status
    = Todo
    | Done
    | NotStarted
    deriving (Show, Eq, Typeable)

instance FromField Status where
    fromField f mdata = do
        text <- fromField f mdata :: Conversion T.Text
        case text of
            "todo"        -> return Todo
            "done"        -> return Done
            "not_started" -> return NotStarted
            _             -> do
                let err = "Valid values are todo, done and not_started"
                returnError ConversionFailed f err

instance ToField Status where
    toField Todo       = toField ("todo" :: T.Text)
    toField Done       = toField ("done" :: T.Text)
    toField NotStarted = toField ("not_started" :: T.Text)

data UniqueTask = UniqueTask
    { taskId      :: Int
    , description :: T.Text
    , status      :: Status
    }

instance FromRow UniqueTask where
    fromRow = UniqueTask
          <$> field
          <*> field
          <*> field
