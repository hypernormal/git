{-# LANGUAGE QuasiQuotes #-}
module AuthorSpec where

import Author
import Test.Hspec
import System.Environment
import Text.RE.TDFA.String

spec :: Spec
spec = do
  describe "Show" $
    before_ showSetup $ do
    it "returns a printable form of Author" $ do
      author <- getAuthor
      let regexResult = matched $ (show author) ?=~ [re|James Vaughan <jamesv@riseup.net> [0-9]{10} \+0000|] 
      regexResult `shouldBe` True

showSetup :: IO ()
showSetup = do
  setEnv "GIT_AUTHOR_NAME" "James Vaughan"
  setEnv "GIT_AUTHOR_EMAIL" "jamesv@riseup.net"
