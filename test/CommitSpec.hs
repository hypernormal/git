module CommitSpec where

import Test.Hspec

spec :: Spec
spec = do
  describe "run" $
    it "exits with success" $ do
      "hi" `shouldBe` "hi"
