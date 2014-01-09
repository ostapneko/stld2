{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Persistence.Queries where

import           Data.Monoid
import qualified Data.ByteString.Char8      as BS

import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.Types

import           Models.UniqueTask
import           Models.RecurringTask

class ToTable a where
    data Table :: * -> *
    table      :: Table a
    tableName  :: Table a -> BS.ByteString

instance ToTable UniqueTask where
    data Table UniqueTask = TableUniqueTask
    table = TableUniqueTask
    tableName TableUniqueTask = "unique_tasks"

instance ToTable RecurringTask where
    data Table RecurringTask = TableRecurringTask
    table = TableRecurringTask
    tableName TableRecurringTask = "recurring_tasks"

getAll :: forall a. (ToTable a, FromRow a) => Connection -> IO [a]
getAll conn = do
    let sql = Query $ "select * from " <> (tableName :: Table a -> BS.ByteString) table
    query_ conn sql
