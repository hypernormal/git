module DatabaseSpec where

import Database
import Init
import Types
import Util
import System.Directory
import System.IO.Silently
import Test.Hspec

spec :: Spec
spec =
  describe "store" $
    before_ storeSetup $
    after_ storeCleanup $
    it "stores a blob" $ do
      let db = "test/database/.git/objects"
      let content = "Test Content" :: ObjectContent
      let objType = "blob"
      objId <- store db content objType
      contents <- readCompressedContentFromFile $ objectIdToDbPath db objId
      contents `shouldBe` "blob 12\NULTest Content"

storeSetup :: IO ()
storeSetup = silence $ doRun (Just "test/database")

storeCleanup :: IO ()
storeCleanup = removePathForcibly "test/database"
