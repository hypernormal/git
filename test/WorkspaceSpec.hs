module WorkspaceSpec where

import           System.Directory
import           System.Environment
import           Test.Hspec
import           Workspace

spec :: Spec
spec = do
  describe "toIgnore" $ do
    it "ignores correct dirs" $
      toIgnore `shouldBe` [".git", "_build", "jit", "test", ".stack-work"]

  describe "filterIgnoreFiles" $ do
    it "filters out ignored dirs and files" $
      filterIgnoredFiles "test" `shouldBe` False
    it "does not filter out non-ignored dirs and files" $
      filterIgnoredFiles "other" `shouldBe` True

  describe "listFiles" $ do
    it "lists files in a dir without ignored files" $ do
      pwd <- getEnv "PWD"
      setCurrentDirectory $ pwd
      files <- listFiles "test/workspace"
      files `shouldBe` ["valid"]
