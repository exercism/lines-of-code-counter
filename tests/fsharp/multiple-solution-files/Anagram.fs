module Anagram

open System
open Helper

let findAnagrams sources target = 
    let normalizedTarget = normalize target
    let isMatch str = normalize str = normalizedTarget && unequal str target
    
    List.filter isMatch sources
