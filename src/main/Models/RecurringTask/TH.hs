{-# LANGUAGE EmptyDataDecls    #-}
{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE GADTs             #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}

module Models.RecurringTask.TH where

import Data.Text

import Database.Persist.TH

import Models.RecurringTask.Fields

share [mkPersist sqlSettings, mkMigrate "migrateRecurringTasks"] [persistLowerCase|
RecurringTask sql=recurring_tasks
    description   Text
    frequency     Int
    enabled       Bool
    status        RecurringStatus
    startedAtWeek Int sql=started_at_week
    startedAtYear Int sql=started_at_year

    UniqueRecurringTaskDescription description
    deriving Show

|]
