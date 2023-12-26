-- ghc 05b.hs
-- Runtime: 92m27s :')

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

chunked :: [Int] -> [(Int, Int)]
chunked [] = []
chunked (x:y:xs) = ((x,y):(chunked xs))

parse :: [String] -> ([(Int, Int)], [[SeedRange]])
parse (seedStr:rest) = (chunked . map read . drop 1 . words $ seedStr, parseMaps rest)

traverseRanges :: [SeedRange] -> Int -> Int
traverseRanges [] seed = seed
traverseRanges ((SeedRange dest src len):rest) seed =
    if src <= seed && seed < src + len
    then seed - src + dest
    else traverseRanges rest seed

traverseMaps :: [[SeedRange]] -> Int -> Int
traverseMaps [] seed = seed
traverseMaps (ranges:rest) seed = traverseMaps rest (traverseRanges ranges seed)

minOf :: (Int -> Int) -> [(Int, Int)] -> Int
minOf f [] = 2^60
minOf f ((start, 0):rest) = minOf f rest
minOf f ((start, len):rest) =
    min (f start) (minOf f ((start + 1, len - 1):rest))

calculate :: ([(Int, Int)], [[SeedRange]]) -> Int
calculate (seeds, maps) = minOf (traverseMaps (reverse maps)) seeds

solve :: [String] -> String
solve = (++ "\n") . show . calculate . parse

main = interact (solve . lines)
