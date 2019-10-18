{-# LANGUAGE ScopedTypeVariables #-}

import qualified Commit
import qualified Init
import           OptionParser
import           System.Environment
import           System.Exit
import           Text.Printf

main :: IO ExitCode
main = parseOptions >>= runCmd

runCmd :: Command -> IO ExitCode
runCmd (Init maybePath) = Init.run maybePath
runCmd Commit           = Commit.run
