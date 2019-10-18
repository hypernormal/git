module Tree where

import qualified Data.ByteString.Base16 as Base16
import qualified Data.ByteString.Char8  as Char8
import           Data.List              (sortOn)
import           Data.Monoid
import           Data.Ord               (comparing)
import qualified Data.Text              as Text (justifyLeft, pack, unpack)
import           Types

newtype Tree = Tree [Entry]

instance Show Tree where
  show (Tree entries) = concatMap showableEntry (sortOn path entries)

mode = "100644"
showableEntry = Char8.unpack . packedEntry
packedEntry entry = packedMode <> packedPath entry <> packedNullByte <> packedOid entry
packedMode = (Char8.pack . padStringWithSpaces) mode
packedPath = Char8.pack . path
packedOid = fst . Base16.decode . oid
packedNullByte = Char8.pack "\0"
padStringWithSpaces = Text.unpack . Text.justifyLeft 7 ' ' . Text.pack
