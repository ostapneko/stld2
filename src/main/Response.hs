{-# LANGUAGE OverloadedStrings #-}

module Response where

import qualified Data.Text.Lazy as T
import           Network.HTTP.Types.Status

data Response = Response Status T.Text
