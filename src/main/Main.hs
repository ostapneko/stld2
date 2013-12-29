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
        res <- liftIO (taskList conn)
        respond res

    post "/unique-task" $ do
        body' <- body
        res   <- liftIO (createUniqueTask conn body')
        respond res

    delete "/unique-task/:taskId" $ do
        taskId <- param "taskId"
        res    <- liftIO (deleteUniqueTask conn taskId)
        respond res

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

respond :: Response -> ActionM ()
respond (Response st payload) = do
    setHeader "Content-Type" "application/json"
    status st
    text payload
