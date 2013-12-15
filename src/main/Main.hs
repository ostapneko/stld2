{-# LANGUAGE OverloadedStrings #-}

import Control.Monad.Trans

import Database.Persist.Postgresql (withPostgresqlPool, ConnectionPool)

import Persistence.DBConnection

import System.Environment
import System.Exit

import Services.Task

import Web.Scotty

main :: IO ()
main = runApp $ \ pool -> do
    get "/tasks" $ do
        resp <- liftIO taskListResponse
        json resp

runApp :: (ConnectionPool -> ScottyM ()) -> IO ()
runApp action = do
    args <- getArgs
    if length args == 1
    then do
        let confFile = head args
        eConnString <- loadConnectionString confFile
        case eConnString of
            Left err      -> putStrLn err >> exitFailure
            Right connStr -> do
                withPostgresqlPool connStr 5 $ \ pool -> scotty 3000 (action pool)
    else usage

usage :: IO ()
usage = do
    putStrLn "Usage: stld DATABASE_CONFIG_FILE"
    exitFailure
