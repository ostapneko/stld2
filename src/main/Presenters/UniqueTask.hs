{-# LANGUAGE OverloadedStrings #-}

module Presenters.UniqueTask where

import           Data.Aeson
import qualified Data.Text as T

import qualified Models.UniqueTask as M

data UniqueTask = UniqueTask
    { uniqueTaskId          :: Int
    , uniqueTaskDescription :: T.Text
    , uniqueTaskActive      :: Bool
    }

instance ToJSON UniqueTask where
    toJSON (UniqueTask uId uTd uTa) =
        object [ "id"          .= uId
               , "description" .= uTd
               , "active"      .= uTa
               ]

fromModel :: M.UniqueTask -> UniqueTask
fromModel (M.UniqueTask uId uTd uSt) =
    UniqueTask { uniqueTaskId = uId
               , uniqueTaskDescription = uTd
               , uniqueTaskActive = uSt == M.Todo
               }
