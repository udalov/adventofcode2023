# python 23b.py

import sys

DX = [1, 0, -1, 0]
DY = [0, 1, 0, -1]

def go(a, x, y, px, py, t, dist, xings):
    dist[x][y] = t
    if (x, y) in xings and px != -1: return

    for d in range(4):
        xx = x + DX[d]
        yy = y + DY[d]
        if (xx != px or yy != py) and xx in range(0, len(a)) and yy in range(0, len(a)) and a[xx][yy] != '#':
            go(a, xx, yy, x, y, t + 1, dist, xings)

def go2(g, m, v, mask, dist):
    if v == m - 1:
        return dist

    result = 0
    for (u, z) in g[v]:
        if mask & (1 << u) == 0:
            result = max(result, go2(g, m, u, mask | (1 << u), dist + z))
    return result

def solve(a):
    n = len(a)
    xings = [(0, 1)]
    for x in range(1, n - 1):
        for y in range(1, n - 1):
            if a[x][y] != '.': continue
            slopes = 0
            for d in range(4):
                c = a[x + DX[d]][y + DY[d]]
                if c == 'v' or c == '>': slopes += 1
            if slopes >= 2:
                xings.append((x, y))
    xings.append((n - 1, n - 2))

    m = len(xings)
    g = [[] for x in range(m)]
    for xing in xings:
        dist = [[-1 for y in range(n)] for x in range(n)]
        go(a, xing[0], xing[1], -1, -1, 0, dist, xings)

        for other in xings:
            d = dist[other[0]][other[1]]
            if d != -1 and d != 0:
                g[xings.index(xing)].append((xings.index(other), d))

    return go2(g, m, 0, 0, 0)

def main():
    sys.setrecursionlimit(20000)
    lines = sys.stdin.readlines()
    print(solve(lines))

main()
