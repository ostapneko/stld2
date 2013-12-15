import           Data.Aeson

import System.Environment
import System.Exit

import Database.Persist.Postgresql

import Persistence.DBConnection

import Models.RecurringTask.TH
import Models.UniqueTask.TH

main :: IO ()
main = do
    args <- getArgs
    if length args == 1
    then migrateDB (head args)
    else usage

migrateDB :: String -> IO ()
migrateDB file = do
        eConnString <- loadConnectionString file
        case eConnString of
            Left err      -> putStrLn err >> exitFailure
            Right connStr -> do
                withPostgresqlConn connStr $ runSqlPersistM (runMigration migrateAll)
    where migrateAll = do
              migrateUniqueTasks
              migrateRecurringTasks

usage :: IO ()
usage = do
    putStrLn "Usage: migrate DATABASE_CONFIG_FILE"
    exitFailure
