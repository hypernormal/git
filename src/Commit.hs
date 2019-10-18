module Commit where

import           Author
import qualified Data.ByteString.Char8 as C8
import           Data.List             (intercalate)
import           Data.Monoid
import qualified Database              as DB
import           System.Directory
import           System.Exit
import           System.FilePath
import           System.IO
import           Tree
import           Types
import           Util
import           Workspace

data Commit = Commit { objectId :: ObjectId, author :: Author, message :: String }

instance Show Commit where
  show (Commit treeId author message) =
    intercalate "\n" [
      "tree " ++ C8.unpack treeId,
      "author " ++ show author,
      "committer " ++ show author,
      "",
      message
    ]

run :: IO ExitCode
run = do
  doRun
  exitSuccess

doRun :: IO ()
doRun = do
  (cwd, dbPath, headPath) <- getGitPaths
  storeBlobs cwd dbPath
    >>= storeTree dbPath
    >>= storeCommit headPath dbPath

getGitPaths :: IO (FilePath, FilePath, FilePath)
getGitPaths =
  getCurrentDirectory >>= \cwd ->
    return (cwd, dbPath cwd, headPath cwd)

storeBlobs :: FilePath -> FilePath -> IO Tree
storeBlobs currentDir dbPath = do
  files <- listFiles $ currentDir </> "src"
  entries <- mapM (storeBlob dbPath) files
  return $ Tree entries

storeBlob :: FilePath -> FilePath -> IO Entry
storeBlob dbPath filePath = do
  contents <- readFile $ "src" </> filePath
  objectId <- DB.store dbPath contents "blob"
  return $ Entry filePath objectId

storeTree :: FilePath -> Tree -> IO ObjectId
storeTree dbPath tree = DB.store dbPath (show tree) "tree"

storeCommit :: FilePath -> FilePath -> ObjectId -> IO ()
storeCommit headPath dbPath treeId = do
  commit <- buildCommit treeId
  commitId <- DB.store dbPath (show commit) "commit"
  putStrLn $ "[(root-commit) " ++ C8.unpack commitId ++ "] " ++ (head $ lines (message commit))
  writeFile headPath $ C8.unpack commitId

buildCommit :: ObjectId -> IO Commit
buildCommit treeId = Commit treeId <$> getAuthor <*> getContents
