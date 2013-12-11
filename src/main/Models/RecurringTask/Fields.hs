{-# LANGUAGE TemplateHaskell #-}

module Models.RecurringTask.Fields where

import Database.Persist.TH

data RecurringStatus = Todo | Done | Skip
                     deriving (Show, Read, Eq)
derivePersistField "RecurringStatus"
