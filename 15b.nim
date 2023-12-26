# d=$(mktemp -d) && cp 15b.nim $d/main.nim && nim r --hints:off $d/main.nim

import strutils

type Lens = object
    label: string
    flen: int

proc hash(s: string): int =
    for c in s:
        result = (result + ord(c)) * 17 mod 256

proc findLens(box: seq[Lens], label: string): int =
    result = -1
    for i, lens in box:
        if lens.label == label:
            result = i

proc solve(): int =
    let line = readLine(stdin)
    var boxes: array[256, seq[Lens]]
    for step in line.split(","):
        if "=" in step:
            let args = step.split("=")
            let label = args[0]
            let flen = parseInt(args[1])
            let i = hash(label)
            let j = findLens(boxes[i], label)
            if j != -1:
                boxes[i][j].flen = flen
            else:
                boxes[i].add(Lens(label: label, flen: flen))
        else:
            let label = step[0..<len(step) - 1]
            let i = hash(label)
            let j = findLens(boxes[i], label)
            if j != -1:
                boxes[i].delete(j)
    for i, box in boxes:
        for j, lens in box:
            result += (i + 1) * (j + 1) * lens.flen

echo solve()
