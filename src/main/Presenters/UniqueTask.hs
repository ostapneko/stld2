{-# LANGUAGE TemplateHaskell #-}

module Presenters.UniqueTask
    ( UniqueTask(..)
    , fromModel
    ) where

import           Data.Aeson.TH
import qualified Data.Text as T

import qualified Models.UniqueTask as M

import           Presenters.JSONOptions

data UniqueTask = UniqueTask
    { taskId      :: Int
    , description :: T.Text
    , active      :: Bool
    } deriving Show

$(deriveJSON uniqueTaskJsonOptions ''UniqueTask)

fromModel :: M.UniqueTask -> UniqueTask
fromModel (M.UniqueTask mId mDesc mStatus) =
    UniqueTask { taskId      = mId
               , description = mDesc
               , active      = mStatus == M.Todo
               }
