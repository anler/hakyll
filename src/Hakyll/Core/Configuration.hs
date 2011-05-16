-- | Exports a datastructure for the top-level hakyll configuration
--
module Hakyll.Core.Configuration
    ( HakyllConfiguration (..)
    , shouldIgnoreFile
    , defaultHakyllConfiguration
    ) where

import System.FilePath (takeFileName)
import Data.List (isPrefixOf, isSuffixOf)

data HakyllConfiguration = HakyllConfiguration
    { -- | Directory in which the output written
      destinationDirectory :: FilePath
    , -- | Directory where hakyll's internal store is kept
      storeDirectory       :: FilePath
    , -- | Function to determine ignored files
      --
      -- In 'defaultHakyllConfiguration', the following files are ignored:
      --
      -- * files starting with a @.@
      --
      -- * files ending with a @~@
      --
      -- * files ending with @.swp@
      --
      -- Note that the files in @destinationDirectory@ and @storeDirectory@ will
      -- also be ignored. Note that this is the configuration parameter, if you
      -- want to use the test, you should use @shouldIgnoreFile@.
      --
      ignoreFile           :: FilePath -> Bool
    }

-- | Default configuration for a hakyll application
--
defaultHakyllConfiguration :: HakyllConfiguration
defaultHakyllConfiguration = HakyllConfiguration
    { destinationDirectory = "_site"
    , storeDirectory       = "_cache"
    , ignoreFile           = ignoreFile'
    }
  where
    ignoreFile' path
        | "." `isPrefixOf` fileName = True
        | "~" `isSuffixOf` fileName = True
        | ".swp" `isSuffixOf` fileName = True
        | otherwise = False
      where
        fileName = takeFileName path

-- | Check if a file should be ignored
--
shouldIgnoreFile :: HakyllConfiguration -> FilePath -> Bool
shouldIgnoreFile conf path =
    destinationDirectory conf `isPrefixOf` path ||
    storeDirectory conf `isPrefixOf` path ||
    ignoreFile conf path
