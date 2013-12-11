{-# LANGUAGE EmptyDataDecls    #-}
{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE GADTs             #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}

module Models.UniqueTask.TH where

import Data.Text

import Database.Persist.TH

import Models.UniqueTask.Fields

share [mkPersist sqlSettings, mkMigrate "migrateUniqueTasks"] [persistLowerCase|
UniqueTask sql=unique_tasks
    description   Text
    status        UniqueStatus
    UniqueUniqueTaskDescription description
    deriving Show

|]
