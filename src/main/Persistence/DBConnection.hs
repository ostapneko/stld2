{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Persistence.DBConnection
    ( DBConnection
    , toConnectionString
    ) where

import           Data.Aeson.TH

import           Data.Monoid
import qualified Data.ByteString.Char8 as BS


data DBConnection = DBConnection
                  { host     :: BS.ByteString
                  , dbname   :: BS.ByteString
                  , user     :: BS.ByteString
                  , password :: BS.ByteString
                  , port     :: Int
                  } deriving Show

$(deriveJSON defaultOptions ''DBConnection)

-- | Create a connection string with the format
--
-- > "host=localhost dbname=dbname ..."
toConnectionString :: DBConnection -> BS.ByteString
toConnectionString conn
    =  "host="      <> host conn
    <> " dbname="   <> dbname conn
    <> " user="     <> user conn
    <> " password=" <> password conn
    <> " port="     <> (BS.pack . show $ port conn)
