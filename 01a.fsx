// dotnet fsi 01a.fsx

open System

let rec main result =
    let line = Console.In.ReadLine()
    match line with
     | null -> result
     | some ->
          let toInt c = int c - int '0'
          let digits = some |> Seq.filter Char.IsDigit |> Seq.toList
          let first = digits.Head |> toInt
          let last = digits[digits.Length - 1] |> toInt
          main (result + first * 10 + last)

printfn "%d" (main 0)
