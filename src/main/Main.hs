{-# LANGUAGE OverloadedStrings #-}

import           Control.Monad.Trans

import           Database.PostgreSQL.Simple

import           Persistence.DBConnection

import           Services.Task

import           System.Environment
import           System.Exit

import           Web.Scotty

main :: IO ()
main = runApp $ \ conn -> do
    get "/tasks" $ do
        resp <- liftIO (taskListResponse conn)
        json resp

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
