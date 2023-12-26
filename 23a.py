# python 23a.py

import sys

DX = [1, 0, -1, 0]
DY = [0, 1, 0, -1]

def ok(c, d):
    return c != '#' and (c != '>' or d != 3) and (c != 'v' or d != 2)

def go(a, n, x, y, px, py, mem):
    if x == n - 1 and y == n - 2:
        return 0
    if mem[x][y] != -1:
        return mem[x][y]

    l = []
    for d in range(4):
        xx = x + DX[d]
        yy = y + DY[d]
        if (xx != px or yy != py) and xx in range(0, n) and yy in range(0, n) and ok(a[xx][yy], d):
            l.append(d)

    result = 0
    for d in l:
        xx = x + DX[d]
        yy = y + DY[d]
        result = max(result, 1 + go(a, n, xx, yy, x, y, mem))
    mem[x][y] = result
    return result

def solve(a):
    n = len(a)
    return go(a, n, 0, 1, -1, -1, [[-1 for y in range(n)] for x in range(n)])

def main():
    sys.setrecursionlimit(20000)
    lines = sys.stdin.readlines()
    print(solve(lines))

main()
