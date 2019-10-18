module Refs where

import           Types

updateHead :: ObjectId -> IO ()
updateHead oid = puts $ show oid
