module InitSpec where

import           Data.List
import           Init
import           System.Directory
import           System.Environment
import           System.Exit
import           System.FilePath
import           System.IO.Silently
import           Test.Hspec

spec :: Spec
spec = do
  describe "run" $
    before_ createGitDirsCleanup $
    after_ createGitDirsCleanup $ do
    it "runs with passed in path" $
      silence $ run (Just "test/init") `shouldThrow` (== ExitSuccess)
    it "runs with no passed in path" $ do
      pwd <- getEnv "PWD"
      createDirectory $ pwd </> "test/init"
      setCurrentDirectory $ pwd </> "test/init"
      silence $ run Nothing `shouldThrow` (== ExitSuccess)
    it "fails if there is an existing git directory" $ do
      _ <- silence $ doRun (Just "test/init")
      silence $ run (Just "test/init") `shouldThrow` (== ExitFailure 1)

  describe "selectPath" $ do
    it "selects passed in path" $ do
      let test = "test" :: FilePath
      path <- selectPath (Just test)
      path `shouldBe` test
    it "selects current directory when no path passed in" $ do
      cwd <- getCurrentDirectory
      path <- selectPath Nothing
      path `shouldBe` cwd

  describe "createGitDirs" $
    after_ createGitDirsCleanup $
    it "creates refs and objects subdirs" $ do
      createGitDirs "test/init"
      dirs <- listDirectory "test/init"
      sort dirs `shouldBe` ["objects", "refs"]

  describe "printSuccess" $
    it "prints out the success message with filepath" $ do
      (output, ()) <- capture $ printSuccess ("test" :: FilePath)
      output `shouldBe` "Initialized empty Jit repository in test\n"

createGitDirsCleanup :: IO ()
createGitDirsCleanup = removePathForcibly "test/init"
