module OptionParser where

import Data.Semigroup ((<>))
import Options.Applicative

data Command = Init (Maybe FilePath) | Commit
newtype Opts = Opts { optCommand :: Command }

parseOptions = do
  opts <- execParser optsParser
  return $ optCommand opts

optsParser :: ParserInfo Opts
optsParser =
  info (helper <*> programOptions) (fullDesc <> header "jit - a small haskell git client")

programOptions :: Parser Opts
programOptions =
  Opts <$> hsubparser (initCommand <> commitCommand)

initCommand :: Mod CommandFields Command
initCommand =
  command "init" (info initOptions (progDesc "Create an empty Git repository"))

initOptions :: Parser Command
initOptions =
  Init <$> optional(strArgument (metavar "directory" <> help "Path of directory to initialize git repository"))

commitCommand :: Mod CommandFields Command
commitCommand =
  command "commit" (info (pure Commit) (progDesc "Record changes to the repository"))
