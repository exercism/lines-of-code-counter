{-# LANGUAGE ViewPatterns #-}

module Helper (isProperAnagramOf) where

import Data.Char (toLower)
import Data.MultiSet (fromList)

isProperAnagramOf :: String -> String -> Bool
isProperAnagramOf (map toLower -> s) (map toLower -> t) =
  s /= t && fromList s == fromList t
