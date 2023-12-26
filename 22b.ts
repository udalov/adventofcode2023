// tsc 22b.ts && node 22b.js

class Vec {
    x: number
    y: number
    z: number

    constructor(x: number, y: number, z: number) {
        this.x = x
        this.y = y
        this.z = z
    }

    copy(): Vec {
        return new Vec(this.x, this.y, this.z)
    }
}

class Brick {
    p1: Vec
    p2: Vec

    constructor(p1: Vec, p2: Vec) {
        this.p1 = p1
        this.p2 = p2
    }

    static create(v: number[]): Brick {
        return new Brick(new Vec(v[0], v[1], v[2]), new Vec(v[3], v[4], v[5]))
    }

    copy(): Brick {
        return new Brick(this.p1.copy(), this.p2.copy())
    }
}

function direction(from: Vec, to: Vec): Vec {
    const dx = from.x < to.x ? 1 : from.x > to.x ? -1 : 0
    const dy = from.y < to.y ? 1 : from.y > to.y ? -1 : 0
    const dz = from.z < to.z ? 1 : from.z > to.z ? -1 : 0
    return new Vec(dx, dy, dz)
}

function traverse(b: Brick, block: (Vec) => void) {
    let cur = b.p1
    const dir = direction(b.p1, b.p2)
    while (true) {
        const end = cur.x == b.p2.x && cur.y == b.p2.y && cur.z == b.p2.z
        block(cur)
        cur = new Vec(cur.x + dir.x, cur.y + dir.y, cur.z + dir.z)
        if (end) break
    }
}

function traverseUnder(b: Brick, block: (Vec) => void) {
    if (b.p1.z == b.p2.z) {
        traverse(b, (v) => block(new Vec(v.x, v.y, v.z - 1)))
    } else {
        block(new Vec(b.p1.x, b.p1.y, Math.min(b.p1.z, b.p2.z) - 1))
    }
}

function mark(a: number[][][], b: Brick, value: number) {
    traverse(b, (p) => {
        a[p.x][p.y][p.z] = value
    })
}

function isFalling(a: number[][][], b: Brick): boolean {
    let result = true
    traverseUnder(b, (p) => {
        if (p.z <= 0 || a[p.x][p.y][p.z] != -1) result = false
    })
    return result
}

function run(bricks: Brick[], hidden: number) {
    const X = 10
    const Y = 10
    const Z = 1000

    const a: number[][][] = Array.from({ length: X }, () =>
        Array.from({ length: Y }, () =>
            Array.from({ length: Z }, () => -1)
        )
    )

    for (let i = 0; i < bricks.length; i++) {
        if (i == hidden) continue
        mark(a, bricks[i], i)
    }

    while (true) {
        let upd = false
        for (let z = 2; z < Z; z++) {
            for (let x = 0; x < X; x++) {
                for (let y = 0; y < Y; y++) {
                    const v = a[x][y][z]
                    if (v == -1) continue
                    const b = bricks[v]
                    if (isFalling(a, b)) {
                        mark(a, b, -1)
                        b.p1.z--
                        b.p2.z--
                        mark(a, b, v)
                        upd = true
                    }
                }
            }
        }
        if (!upd) break
    }
}

function solve(bricks: Brick[]) {
    run(bricks, -1)

    let result = 0
    const n = bricks.length
    for (let hide = 0; hide < n; hide++) {
        const w = bricks.map((b) => b.copy())
        run(w, hide)

        for (let i = 0; i < n; i++) {
            const p = bricks[i].p1
            const q = w[i].p1
            if (p.x != q.x || p.y != q.y || p.z != q.z) result++
        }
    }
    return result
}

function main() {
    const input = require("fs").readFileSync(0)
    const lines = input.toString().trim().split("\n")
    const bricks = lines.map((line) => {
        return Brick.create(line.split(/~|,/).map((x) => Number(x)))
    })
    console.log(solve(bricks))
}

main()
