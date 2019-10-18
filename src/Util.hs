module Util where

import qualified Data.ByteString.Char8 as ByteString.Char8
import           System.Directory
import           System.Exit
import           System.FilePath
import           System.IO.Error
import           Text.Printf
import           Types

gitPath :: FilePath -> FilePath
gitPath path = path </> ".git"

dbPath :: FilePath -> FilePath
dbPath path = gitPath path </> "objects"

headPath :: FilePath -> FilePath
headPath path = gitPath path </> "HEAD"

objectIdToPaths :: ObjectId -> (FilePath, FilePath)
objectIdToPaths objectId =
  let [objectPathDirName, objectPathFileName] =
        map (\fn -> (fn . ByteString.Char8.unpack) objectId) [take 2, drop 2]
  in (objectPathDirName, objectPathFileName)

objectIdToDbPath :: FilePath -> ObjectId -> FilePath
objectIdToDbPath dbPath objectId =
  let (objectPathDirName, objectPathFileName) = objectIdToPaths objectId
  in dbPath </> objectPathDirName </> objectPathFileName

createDir :: FilePath -> IO ()
createDir path = do
  result <- tryIOError $ createDirectoryIfMissing True path
  case result of
    Left e -> do
      printf "fatal: %s\n" (show e)
      exitFailure
    Right _ -> return ()
