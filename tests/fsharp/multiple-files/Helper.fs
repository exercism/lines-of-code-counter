module Helper

open System

let equals str other = String.Equals(str, other, StringComparison.InvariantCultureIgnoreCase)
let toLower str = str.ToLowerInvariant()
let normalize (str:string) = new string(toLower.ToCharArray() |> Array.sort)
let unequal str other = not (equals str other)
