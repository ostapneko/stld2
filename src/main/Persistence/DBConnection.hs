{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Persistence.DBConnection
    ( DBConnection
    , toConnectionString
    , loadConnectionString
    ) where

import           Data.Aeson
import           Data.Aeson.TH
import qualified Data.ByteString.Lazy.Char8 as BSL

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

loadConnectionString :: String -> IO (Either String BS.ByteString)
loadConnectionString file = do
    content <- BSL.readFile file
    let eConnString = eitherDecode content
    return $ case eConnString of
      Left err   -> Left err
      Right conn -> Right $ toConnectionString conn
