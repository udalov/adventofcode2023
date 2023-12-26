-- ghc 05a.hs

data SeedRange = SeedRange Int Int Int

parseRange :: String -> SeedRange
parseRange line =
    case (map read . words $ line) of
        (dest:src:len:[]) -> SeedRange dest src len

parseMapsImpl :: [String] -> [[SeedRange]] -> [[SeedRange]]
parseMapsImpl [] result = result
parseMapsImpl (line:rest) result =
    if line == ""
    then parseMapsImpl (drop 1 rest) ([]:result)
    else case result of
        (ranges:rest2) -> parseMapsImpl rest (((parseRange line):ranges):rest2)
        _ -> parseMapsImpl rest result

parseMaps :: [String] -> [[SeedRange]]
parseMaps lines = parseMapsImpl lines []

parse :: [String] -> ([Int], [[SeedRange]])
parse (seedStr:rest) = (map read . drop 1 . words $ seedStr, parseMaps rest)

traverseRanges :: [SeedRange] -> Int -> Int
traverseRanges [] seed = seed
traverseRanges ((SeedRange dest src len):rest) seed =
    if src <= seed && seed < src + len
    then seed - src + dest
    else traverseRanges rest seed

traverseMaps :: [[SeedRange]] -> Int -> Int
traverseMaps [] seed = seed
traverseMaps (ranges:rest) seed = traverseMaps rest (traverseRanges ranges seed)

calculate :: ([Int], [[SeedRange]]) -> Int
calculate (seeds, maps) = minimum (map (traverseMaps (reverse maps)) seeds)

solve :: [String] -> String
solve = (++ "\n") . show . calculate . parse

main = interact (solve . lines)
