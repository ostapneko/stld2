{-# LANGUAGE TemplateHaskell #-}

module Models.UniqueTask.Fields where

import Database.Persist.TH

data UniqueStatus = Todo | Done | NotStarted
                     deriving (Show, Read, Eq)
derivePersistField "UniqueStatus"
