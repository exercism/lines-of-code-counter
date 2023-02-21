module Anagram (anagramsFor) where

import Helper (isProperAnagramOf)

anagramsFor :: String -> [String] -> [String]
anagramsFor = filter . isProperAnagramOf
