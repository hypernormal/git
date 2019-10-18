module UtilSpec where

import Util
import Test.Hspec
import System.IO.Silently
import System.Directory
import System.Exit

spec :: Spec
spec = do
  describe "gitPath" $ do
    it "returns the built gitPath" $
      gitPath "test" `shouldBe` "test/.git"

  describe "dbPath" $ do
    it "returns the built dbPath" $
      dbPath "test" `shouldBe` "test/.git/objects"

  describe "headPath" $ do
    it "returns the built headPath" $
      headPath "test" `shouldBe` "test/.git/HEAD"

  describe "createDir" $
    after_ createDirCleanup $ do
    it "creates a directory successfully" $ do
      silence $ createDir "test/util" `shouldReturn` ()
    it "handles failure to create dir" $
      silence $ createDir "/failpath" `shouldThrow` (== ExitFailure 1)

createDirCleanup :: IO ()
createDirCleanup = removePathForcibly "test/util"
