module Workspace where

import           Control.Monad
import           System.Directory
import           System.FilePath

listFiles :: FilePath -> IO [FilePath]
listFiles fp = do
  files <- listDirectory fp
  return $ filter filterIgnoredFiles files

toIgnore :: [FilePath]
toIgnore =
  [".git", "_build", "jit", "test", ".stack-work"]

filterIgnoredFiles :: FilePath -> Bool
filterIgnoredFiles file = file `notElem` toIgnore
