// v 04a.v

import os

fn solve(line string) !int {
    winners := line.substr(line.index(":")! + 2, line.index("|")! - 1).split(" ")
    numbers := line.substr(line.index("|")! + 2, line.len_utf8())
    mut result := 1
    for number in numbers.split(" ") {
        if !number.is_blank() && number in winners {
            result *= 2
        }
    }
    return result / 2
}

fn main() {
    mut result := 0
    for {
        line := os.get_line()
        if line.is_blank() { break }
        result += solve(line)!
    }
    println(result)
}
