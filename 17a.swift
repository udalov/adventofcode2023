// swift 17a.swift

let DX = [1, 0, -1, 0]
let DY = [0, 1, 0, -1]

struct State : Hashable {
    let x, y, d, mv: Int
}

struct Queue {
    var data: [(State, Int)] = [(State, Int)](repeating: (State(x:0, y:0, d:0, mv:0), 0), count: 10000000)
    var size: Int = 0

    mutating func append(_ value: (State, Int)) {
        var k = size
        data[size] = value
        size += 1
        while k > 0 {
            let parent = (k - 1) / 2
            if data[k].1 >= data[parent].1 { break }
            data.swapAt(k, parent)
            k = parent
        }
    }

    mutating func get() -> (State, Int) {
        let result = data[0]
        size -= 1
        data.swapAt(0, size)
        var k = 0
        while true {
            let c1 = 2 * k + 1
            let c2 = 2 * k + 2
            if c1 < size && data[c1].1 < data[k].1 && (c2 >= size || data[c1].1 < data[c2].1) {
                data.swapAt(k, c1)
                k = c1
            } else if c2 < size && data[c2].1 < data[k].1 {
                data.swapAt(k, c2)
                k = c2
            } else {
                break
            }
        }
        return result
    }
}

func valueAt(_ lines: inout Array<String>, _ x: Int, _ y: Int) -> Int {
    let line = lines[x]
    let index = line.index(line.startIndex, offsetBy: y)
    return Int(line[index...index])!
}

func solve(_ lines: inout Array<String>) -> Int {
    let n = lines.count
    let m = lines[0].count

    var distance: [State: Int] = [:]
    var queue = Queue()
    for dir in 0..<2 {
        let start = State(x:0, y:0, d:dir, mv:0)
        distance[start] = 0
        queue.append((start, 0))
    }

    while queue.size > 0 {
        let (v, dist) = queue.get()
        if dist != distance[v]! { continue }

        if v.x == n - 1 && v.y == m - 1 { return dist }
        if v.mv == 3 { continue }

        let x = v.x + DX[v.d]
        let y = v.y + DY[v.d]
        if !(0..<n ~= x && 0..<m ~= y) { continue }

        let newDist = dist + valueAt(&lines, x, y)

        for d in 0..<4 {
            if (d - v.d + 4) % 4 == 2 { continue }

            let w = State(x: x, y: y, d: d, mv: d == v.d ? v.mv + 1 : 0)
            if let prev = distance[w] {
                if prev <= newDist { continue }
            }

            distance.updateValue(newDist, forKey: w)
            queue.append((w, newDist))
        }
    }

    return -1
}

func main() {
    var lines = Array<String>()
    while (true) {
        if let line = readLine() {
            lines.append(line)
        } else {
            break
        }
    }
    print(solve(&lines))
}

main()
