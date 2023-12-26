// scala 18a.scala

import scala.io.Source
import scala.collection.mutable.ArrayBuffer

object Solution {
    val N = 1000
    val DX = Array[Int](1, 0, -1, 0)
    val DY = Array[Int](0, 1, 0, -1)

    def solve(lines: ArrayBuffer[String]) = {
        val a = Array.fill(N) { Array.fill(N) { false } }

        var cur = (N / 2, N / 2)
        a(cur._1)(cur._2) = true

        for (line <- lines) {
            val Array(dirStr, lenStr, _) = line.split(" ")
            val dir = "DRUL".indexOf(dirStr)
            for (it <- 0 until lenStr.toInt) {
                cur = (cur._1 + DX(dir), cur._2 + DY(dir))
                a(cur._1)(cur._2) = true
            }
        }

        val q = new ArrayBuffer[(Int, Int)]()
        var qb = 0
        q.append((N / 2 + 1, N / 2 + 1))
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

        (0 until N).map { i =>
            (0 until N).map { j => if (a(i)(j)) 1 else 0 }.sum
        }.sum
    }

    def main(args: Array[String]) = {
        println(solve(Source.stdin.getLines.to(ArrayBuffer)))
    }
}
