{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_jit (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/jamesvaughan/.cabal/bin"
libdir     = "/home/jamesvaughan/.cabal/lib/x86_64-linux-ghc-8.2.2/jit-0.1.0.0-B38fj2vKqsW8z5e1A2Mldf-spec"
dynlibdir  = "/home/jamesvaughan/.cabal/lib/x86_64-linux-ghc-8.2.2"
datadir    = "/home/jamesvaughan/.cabal/share/x86_64-linux-ghc-8.2.2/jit-0.1.0.0"
libexecdir = "/home/jamesvaughan/.cabal/libexec/x86_64-linux-ghc-8.2.2/jit-0.1.0.0"
sysconfdir = "/home/jamesvaughan/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "jit_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "jit_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "jit_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "jit_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "jit_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "jit_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
