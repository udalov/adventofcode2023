// v 04b.v

import os
import arrays

fn solve(line string, index int, mut counts []i64)! {
    winners := line.substr(line.index(":")! + 2, line.index("|")! - 1).split(" ")
    numbers := line.substr(line.index("|")! + 2, line.len_utf8())
    mut result := 0
    for number in numbers.split(" ") {
        if !number.is_blank() && number in winners {
            result++
        }
    }
    for i in index .. (index + result) {
        counts[i + 1] += counts[index]
    }
}

fn main() {
    mut lines := []string{}
    mut counts := []i64{}
    for {
        line := os.get_line()
        if line.is_blank() { break }
        lines << line
        counts << 1
    }
    for i, line in lines {
        solve(line, i, mut counts)!
    }
    println(arrays.sum(counts)!)
}
