module Database where

import qualified Codec.Compression.Zlib   as Zlib
import qualified Crypto.Hash.SHA1         as SHA1
import qualified Data.ByteString.Base16   as ByteString.Base16
import qualified Data.ByteString.Builder  as ByteString.Builder
import qualified Data.ByteString.Char8    as ByteString.Char8
import qualified Data.ByteString.Internal as ByteString.Internal
import qualified Data.ByteString.Lazy     as ByteString.Lazy
import qualified Data.Text.Encoding       as Text.Encoding
import qualified GHC.Word                 as Word
import           System.Directory
import           System.FilePath
import           System.IO
import           System.Random
import           Types
import           Util

store :: FilePath -> ObjectContent -> ObjectType -> IO ObjectId
store dbPath objectContent objectType = do
  let (objectId, blobContent) = buildObject objectContent objectType
  writeObject dbPath objectId blobContent
  return objectId

buildObject :: ObjectContent -> ObjectType -> (ObjectId, BlobContent)
buildObject object objectType =
  let objectSize = length object
      content = buildContent objectSize object objectType
      objectId = ByteString.Base16.encode $ SHA1.hash $ ByteString.Char8.pack content
  in (objectId, content)

writeObject :: FilePath -> ObjectId -> BlobContent -> IO ()
writeObject dbPath objectId blobContent = do
  let (objectPathDirName, objectPathFileName) = objectIdToDirAndFileNames objectId
  let objectDirPath = dbPath </> objectPathDirName
  let objectFilePath = dbPath </> objectPathDirName </> objectPathFileName
  createDir objectDirPath
  tempObjectPath <- createTempCompressedFile objectDirPath blobContent
  renameFile tempObjectPath objectFilePath

buildContent :: FileSize -> ObjectContent -> ObjectType -> BlobContent
buildContent objectSize object objectType =
  objectType ++ " " ++ show objectSize ++ "\0" ++ object

generateTempName :: IO String
generateTempName = do
  g <- newStdGen
  return $ "tmp_obj_" ++ take 6 (randomRs ('a', 'z') g)

objectIdToDirAndFileNames :: ObjectId -> (FilePath, FilePath)
objectIdToDirAndFileNames objectId =
  let [objectPathDirName, objectPathFileName] =
        map (\fn -> (fn . ByteString.Char8.unpack) objectId) [take 2, drop 2]
  in (objectPathDirName, objectPathFileName)

createTempCompressedFile :: FilePath -> BlobContent -> IO FilePath
createTempCompressedFile objectDirPath blobContent = do
  tempName <- generateTempName
  let tempObjectPath = objectDirPath </> tempName
  let compressedBlob = Zlib.compress $ ByteString.Lazy.pack (strToWord8s blobContent)
  writeCompressedContentToFile tempObjectPath compressedBlob
  return tempObjectPath

writeCompressedContentToFile :: FilePath -> CompressedContent -> IO ()
writeCompressedContentToFile filepath compressedBlob = do
  fileHandler <- openFile filepath ReadWriteMode
  ByteString.Lazy.hPutStr fileHandler compressedBlob
  hClose fileHandler

readCompressedContentFromFile :: FilePath -> IO String
readCompressedContentFromFile filePath = do
  fileHandler <- openFile filePath ReadMode
  contents <- ByteString.Lazy.hGetContents fileHandler
  let decompressedBlob = Zlib.decompress contents
  return $ word8sToStr $ ByteString.Lazy.unpack decompressedBlob

strToWord8s :: String -> [Word.Word8]
strToWord8s = ByteString.Internal.unpackBytes . ByteString.Char8.pack

word8sToStr :: [Word.Word8] -> String
word8sToStr = ByteString.Char8.unpack . ByteString.Internal.packBytes
