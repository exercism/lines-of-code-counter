{-# LANGUAGE ViewPatterns #-}

module Anagram (anagramsFor) where

import Data.Char (toLower)
import Data.MultiSet (fromList)

anagramsFor :: String -> [String] -> [String]
anagramsFor = filter . isProperAnagramOf
  where
    isProperAnagramOf (map toLower -> s) (map toLower -> t) =
      s /= t && fromList s == fromList t
