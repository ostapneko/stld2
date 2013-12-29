{-# LANGUAGE OverloadedStrings #-}

module Services.Task
    ( taskList
    , createUniqueTask
    ) where

import           Data.Aeson
import           Data.Monoid
import           Data.Text.Lazy.Encoding
import qualified Data.ByteString.Lazy.Char8 as BSL
import qualified Data.HashMap.Strict        as HM
import qualified Data.Text                  as T

import           Database.PostgreSQL.Simple

import qualified Models.UniqueTask as MU

import           Network.HTTP.Types.Status

import qualified Presenters.UniqueTask    as PU
import qualified Presenters.TaskList      as PL
import qualified Presenters.RecurringTask as PR

import           Response


taskList :: Connection -> IO Response
taskList conn = do
    uModels <- query_ conn "select * from unique_tasks"
    let uPresenters = map PU.fromModel uModels

    rModels <- query_ conn "select * from recurring_tasks"
    let rPresenters = map PR.fromModel rModels

    let tl = PL.TaskList
           { PL.uniqueTasks    = uPresenters
           , PL.recurringTasks = rPresenters
           }
    return $ Response status200 (decodeUtf8 $ encode tl)

createUniqueTask :: Connection -> BSL.ByteString -> IO Response
createUniqueTask conn payload = do
    let mInfo = parseNewTaskInfo payload
    case mInfo of
        Nothing -> return $ Response badRequest400 "Unparseable payload"
        Just (desc, status) -> createUniqueTaskInDB conn desc status

parseNewTaskInfo :: BSL.ByteString -> Maybe (T.Text, MU.Status)
parseNewTaskInfo payload = do
    obj           <- decode payload
    (String desc) <- HM.lookup ("description" :: T.Text) obj
    (Bool active) <- HM.lookup "active" obj
    let status = if active then MU.Todo else MU.NotStarted
    return (desc, status)

createUniqueTaskInDB :: Connection -> T.Text -> MU.Status -> IO Response
createUniqueTaskInDB conn d s = do
    let sql = "insert into unique_tasks (description, status) " <>
              "values (?, ?) " <>
              "returning id, description, status"
    [(taskId, desc, st)] <- query conn sql (d, s) :: IO [(Int, T.Text, MU.Status)]
    let model     = MU.UniqueTask taskId desc st
    let presenter = PU.fromModel model
    let obj       = object [ "task" .= presenter ]
    return $ Response created201 (decodeUtf8 $ encode obj)
