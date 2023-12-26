// kotlinc 25a.kt && kotlin _25aKt

class Edge(val start: Int, val end: Int) {
    var enabled: Boolean = true
    lateinit var opposite: Edge

    fun flip() {
        enabled = !enabled
        opposite.enabled = !opposite.enabled
    }
}

class Timer(var time: Int)

fun add(g: MutableMap<Int, MutableList<Edge>>, u: Int, v: Int) {
    val from = Edge(u, v)
    val to = Edge(v, u)
    from.opposite = to
    to.opposite = from
    g.getOrPut(u) { mutableListOf() }.add(from)
    g.getOrPut(v) { mutableListOf() }.add(to)
}

fun go(g: List<List<Edge>>, v: Int, parent: Int, used: BooleanArray, timer: Timer, tin: IntArray, fup: IntArray): Edge? {
    used[v] = true
    tin[v] = timer.time++
    fup[v] = tin[v]
    for (u in g[v]) {
        if (!u.enabled || u.end == parent) continue
        if (used[u.end]) {
            fup[v] = minOf(fup[v], tin[u.end])
        } else {
            val result = go(g, u.end, v, used, timer, tin, fup)
            if (result != null) return result
            if (fup[u.end] > tin[v]) return u
            fup[v] = minOf(fup[v], fup[u.end])
        }
    }
    return null
}

fun go2(g: List<List<Edge>>, v: Int, used: BooleanArray): Int {
    used[v] = true
    var result = 1
    for (u in g[v]) if (u.enabled && !used[u.end]) result += go2(g, u.end, used)
    return result
}

fun solve(g: List<List<Edge>>): Int {
    val n = g.size
    val used = BooleanArray(n)
    val tin = IntArray(n)
    val fup = IntArray(n)
    var found = false
    outer@ for (firstVertex in 0..<n) for (firstEdge in g[firstVertex]) {
        if (firstEdge.start > firstEdge.end) continue
        firstEdge.flip()
        for (secondVertex in 0..<firstVertex) for (secondEdge in g[secondVertex]) {
            if (secondEdge.start > secondEdge.end) continue
            secondEdge.flip()
            used.fill(false)
            val result = go(g, 0, -1, used, Timer(0), tin, fup)
            if (result != null) {
                result.flip()
                found = true
                break@outer
            }
            secondEdge.flip()
        }
        firstEdge.flip()
    }
    if (!found) return -1
    used.fill(false)
    val m = go2(g, 0, used)
    return m * (n - m)
}

fun main() {
    val index = hashMapOf<String, Int>()
    fun String.index(): Int = index.getOrPut(this, index::size)

    val g = hashMapOf<Int, MutableList<Edge>>()
    while (true) {
        val line = readLine() ?: break
        val u = line.substringBefore(": ")
        for (v in line.substringAfter(": ").split(" ")) {
            add(g, u.index(), v.index())
        }
    }

    println(solve((0..<g.size).map(g::getValue)))
}
