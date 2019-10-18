module Types where

import qualified Data.ByteString.Char8 as ByteString.Char8
import qualified Data.ByteString.Lazy as ByteString.Lazy

type Blob = String
type ObjectType = String
type ObjectId = ByteString.Char8.ByteString
data Object = Object { objectType :: ObjectType, objectId :: ObjectId }
data Entry = Entry { path :: FilePath, oid :: ObjectId }
type ObjectContent = String
type FileSize = Int
type BlobContent = String
type CompressedContent = ByteString.Lazy.ByteString
