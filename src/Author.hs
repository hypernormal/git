module Author where

import           Data.Time.Clock
import           Data.Time.Format
import           System.Environment

data Author = Author String String String

instance Show Author where
  show (Author name email time) = unwords [name, email, time]

getAuthor :: IO Author
getAuthor = Author <$> getName <*> getEmail <*> getTime

getName :: IO String
getName = getEnv "GIT_AUTHOR_NAME"

getEmail :: IO String
getEmail = do
  email <- getEnv "GIT_AUTHOR_EMAIL"
  return $ "<" ++ email ++ ">"

getTime :: IO String
getTime = getCurrentTime >>= \time -> return $ formatTime defaultTimeLocale "%s %z" time
