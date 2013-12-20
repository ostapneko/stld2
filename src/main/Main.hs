{-# LANGUAGE OverloadedStrings #-}

import           Control.Monad.Trans

import           Database.PostgreSQL.Simple

import           Persistence.DBConnection

import           Response

import           Services.Task

import           System.Environment
import           System.Exit

import           Web.Scotty

main :: IO ()
main = runApp $ \ conn -> do
    get "/tasks" $ do
        Response st payload <- liftIO (taskList conn)
        setHeader "Content-Type" "application/json"
        status st
        text payload

    post "/unique-task" $ do
        body' <- body
        Response st payload <- liftIO (createUniqueTask body' conn)
        setHeader "Content-Type" "application/json"
        status st
        text payload

runApp :: (Connection -> ScottyM ()) -> IO ()
runApp action = do
    args <- getArgs
    if length args == 1
    then do
        let confFile = head args
        eConnInfo <- loadConnection confFile
        case eConnInfo of
            Left err       -> putStrLn err >> exitFailure
            Right connInfo -> do
                conn <- connect connInfo
                scotty 3000 (action conn)
    else usage

usage :: IO ()
usage = do
    putStrLn "Usage: stld DATABASE_CONFIG_FILE"
    exitFailure
