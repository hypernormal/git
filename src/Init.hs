module Init where

import           System.Directory
import           System.Exit
import           System.FilePath
import           Text.Printf
import qualified Util

run :: Maybe FilePath -> IO ExitCode
run maybePath = do
  doRun maybePath
  exitSuccess

doRun :: Maybe FilePath -> IO ()
doRun maybePath = do
  path <- selectPath maybePath
  let gitPath = Util.gitPath path
  checkForExistingGitDir gitPath
  createGitDirs gitPath
  printSuccess path

selectPath :: Maybe FilePath -> IO FilePath
selectPath Nothing     = getCurrentDirectory
selectPath (Just path) = return path

createGitDirs :: FilePath -> IO ()
createGitDirs gitPath = do
  Util.createDir (gitPath </> "objects")
  Util.createDir (gitPath </> "refs")

checkForExistingGitDir :: FilePath -> IO ()
checkForExistingGitDir gitPath = do
  gitExists <- doesDirectoryExist gitPath
  if gitExists then exitFailure else return ()

printSuccess :: FilePath -> IO ()
printSuccess = printf "Initialized empty Jit repository in %s\n"
