{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Persistence.DBConnection
    ( loadConnection
    ) where

import           Control.Applicative
import           Control.Monad

import           Data.Aeson

import qualified Data.ByteString.Lazy.Char8 as BSL

import           Database.PostgreSQL.Simple

instance FromJSON ConnectInfo where
    parseJSON (Object v) = ConnectInfo
                       <$> v .: "host"
                       <*> v .: "port"
                       <*> v .: "user"
                       <*> v .: "password"
                       <*> v .: "dbname"
    parseJSON _          = mzero

loadConnection :: String -> IO (Either String ConnectInfo)
loadConnection file = eitherDecode <$> BSL.readFile file
