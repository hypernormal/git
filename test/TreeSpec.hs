module TreeSpec where

import Tree
import Types
import Test.Hspec
import qualified Data.ByteString.Char8 as Char8

spec :: Spec
spec = do
  describe "Show" $ do
    it "returns a printable form of Tree" $ do
      let entryA = Entry ("def" :: FilePath) (Char8.pack "def")
      let entryB = Entry ("abc" :: FilePath) (Char8.pack "abc")
      let entryC = Entry ("ghi" :: FilePath) (Char8.pack "ghi")
      let tree = Tree [entryA, entryC, entryB]
      show tree `shouldBe` "100644 abc\NUL\171\&100644 def\NUL\222\&100644 ghi\NUL"
