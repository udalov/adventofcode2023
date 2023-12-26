# d=$(mktemp -d) && cp 15a.nim $d/main.nim && nim r --hints:off $d/main.nim

import strutils

proc hash(s: string): int =
    for c in s:
        result = (result + ord(c)) * 17 mod 256

proc solve(): int =
    let line = readLine(stdin)
    for step in line.split(","):
        result += hash(step)

echo solve()
