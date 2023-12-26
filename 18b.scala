// scala 18b.scala

import scala.io.Source
import scala.collection.mutable.{ArrayBuffer, HashMap, TreeSet}

class Coords {
    val all = TreeSet[Int]()
    val to = HashMap[Int, Int]()
    val from = HashMap[Int, Int]()

    def add(value: Int) = {
        all.add(value)
    }

    def compute() = {
        for ((ov, nv) <- all.zip(LazyList.from(0))) {
            to.put(ov, nv)
            from.put(nv, ov)
        }
    }
}

object Solution {
    val N = 1000
    val DX = Array[Int](1, 0, -1, 0)
    val DY = Array[Int](0, 1, 0, -1)

    def solve(lines: ArrayBuffer[String]) = {
        val a = Array.fill(N) { Array.fill(N) { false } }

        val moves = new ArrayBuffer[(Int, Int)]()
        for (line <- lines) {
            val Array(_, _, hex) = line.split(" ")
            val dir = "1032".indexOf(hex(7))
            val len = Integer.parseInt(hex.substring(2, 7), 16)
            moves.append((len, dir))
        }

        val xs = new Coords()
        val ys = new Coords()
        var cur = (0, 0)
        xs.add(0)
        ys.add(0)
        for ((len, dir) <- moves) {
            cur = (cur._1 + len * DX(dir), cur._2 + len * DY(dir))
            for (shift <- 0 to 1) {
                xs.add(cur._1 + shift)
                ys.add(cur._2 + shift)
            }
        }
        xs.compute()
        ys.compute()

        cur = (xs.to(0), ys.to(0))
        a(cur._1)(cur._2) = true

        for ((len, dir) <- moves) {
            val target = (xs.to(xs.from(cur._1) + len * DX(dir)), ys.to(ys.from(cur._2) + len * DY(dir)))
            while (cur != target) {
                cur = (cur._1 + DX(dir), cur._2 + DY(dir))
                a(cur._1)(cur._2) = true
            }
        }

        val q = new ArrayBuffer[(Int, Int)]()
        var qb = 0
        q.append((xs.to(1), ys.to(1)))
        while (qb < q.size) {
            val (x, y) = q(qb)
            qb += 1
            if (!a(x)(y)) {
                a(x)(y) = true
                for (d <- 0 until 4) {
                    val (xx, yy) = (x + DX(d), y + DY(d))
                    if ((0 until N contains xx) && (0 until N contains yy) && !a(xx)(yy)) {
                        q.append((xx, yy))
                    }
                }
            }
        }

        var result = 0L
        for (i <- 0 until N) {
            for (j <- 0 until N) if (a(i)(j)) {
                val dx = xs.from(i + 1) - xs.from(i)
                val dy = ys.from(j + 1) - ys.from(j)
                result += dx.toLong * dy
            }
        }
        result
    }

    def main(args: Array[String]) = {
        println(solve(Source.stdin.getLines.to(ArrayBuffer)))
    }
}
