{-# LANGUAGE OverloadedStrings #-}

import Control.Monad.Trans

import Services.Task
import Web.Scotty

main :: IO ()
main = scotty 3000 $ do
    get "/tasks" $ do
        resp <- liftIO taskListResponse
        json resp
