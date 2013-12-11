import qualified Data.ByteString.Lazy.Char8 as BSL
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
        content <- BSL.readFile file
        case decode content of
            Nothing   -> do
                putStrLn $ "Error parsing db config"
                exitFailure
            Just conn -> do
                let connStr = toConnectionString conn
                withPostgresqlConn connStr $ runSqlPersistM (runMigration migrateAll)
    where migrateAll = do
              migrateUniqueTasks
              migrateRecurringTasks

usage :: IO ()
usage = do
    putStrLn "Usage: migrate DATABASE_CONFIG_FILE"
    exitFailure
