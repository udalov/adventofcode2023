// dotnet fsi 01b.fsx

open System

let digits = ["one"; "two"; "three"; "four"; "five"; "six"; "seven"; "eight"; "nine"]

let translate (s: String) =
    let rec replace (s: String) i list =
        match list with
            | [] -> s
            | name :: rest -> replace (s.Replace(name, name + (string i) + name)) (i + 1) rest
    replace s 1 digits

let rec main result =
    let line = Console.In.ReadLine()
    match line with
        | null -> result
        | some ->
            let toInt c = int c - int '0'
            let digits = some |> translate |> Seq.filter Char.IsDigit |> Seq.toList
            let first = digits.Head |> toInt
            let last = digits[digits.Length - 1] |> toInt
            main (result + first * 10 + last)

printfn "%d" (main 0)
