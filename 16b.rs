// rustc 16b.rs

use std::collections::HashSet;
use std::io::{self, BufRead};
use std::cmp::max;

type Point = (usize, usize, usize);

const DX: [i64; 4] = [1, 0, -1, 0];
const DY: [i64; 4] = [0, 1, 0, -1];

fn just_passing(c: char, d: usize) -> bool {
    c == '.' ||
        (c == '|' && d % 2 == 0) ||
        (c == '-' && d % 2 == 1)
}

fn is_splitter(c: char, d: usize) -> bool {
    (c == '|' && d % 2 == 1) ||
        (c == '-' && d % 2 == 0)
}

fn mirror(c: char, d: usize) -> usize {
    if c == '/' {
        3 - d
    } else {
        ((3 - d) + 2) % 4
    }
}

fn move_to(x: usize, y: usize, d: usize, n: usize, m: usize) -> Option<(usize, usize)> {
    let xx = (x as i64) + DX[d];
    let yy = (y as i64) + DY[d];
    if 0 <= xx && xx < (n as i64) && 0 <= yy && yy < (m as i64) {
        Some((xx as usize, yy as usize))
    } else {
        None
    }
}

fn solve(lines: &Vec<Vec<char>>, start: Point) -> usize {
    let n = lines.len();
    let m = lines[0].len();

    let mut q: Vec<Point> = vec![];
    let mut visited: HashSet<Point> = HashSet::new();
    let mut qb = 0;
    q.push(start);
    visited.insert(start);
    while qb < q.len() {
        let (x, y, d) = q[qb];
        qb += 1;
        let passing = just_passing(lines[x][y], d);
        let split = is_splitter(lines[x][y], d);
        for turn in 0..4 {
            let dd = (d + turn) % 4;
            let good =
                if passing { turn == 0 }
                else if split { turn == 1 || turn == 3 }
                else { mirror(lines[x][y], d) == dd };
            if good {
                if let Some((xx, yy)) = move_to(x, y, dd, n, m) {
                    let new = (xx, yy, dd);
                    if !visited.contains(&new) {
                        q.push(new);
                        visited.insert(new);
                    }
                }
            }
        }
    }

    let mut result = 0;
    for i in 0..n {
        for j in 0..m {
            if (0..4).any(|d| visited.contains(&(i, j, d))) {
                result += 1;
            }
        }
    }

    result
}

fn main() {
    let lines: Vec<Vec<char>> = io::stdin().lock().lines().map (|x| x.unwrap().chars().collect()).collect();
    let n = lines.len();
    let m = lines[0].len();

    let mut result = 0;
    for i in 0..n {
        result = max(result, solve(&lines, (i, 0, 1)));
        result = max(result, solve(&lines, (i, m - 1, 3)));
    }
    for j in 0..m {
        result = max(result, solve(&lines, (0, j, 0)));
        result = max(result, solve(&lines, (n - 1, j, 2)));
    }
    println!("{}", result);
}
