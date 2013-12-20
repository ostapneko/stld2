module Presenters.JSONOptions where

import           Data.Aeson.TH

uniqueTaskJsonOptions :: Options
uniqueTaskJsonOptions = defaultOptions { fieldLabelModifier = flm }
    where flm "taskId" = "id"
          flm f        = f
