// go run 19b.go

package main

import (
    "fmt"
    "slices"
    "strconv"
    "strings"
)

type Rule struct {
    category int
    bound int
    less bool
    verdict string
}

func parseRule(text string) Rule {
    colon := strings.Index(text, ":")
    if colon == -1 {
        return Rule{0, 0, false, text}
    }
    category := 0
    switch text[0:1] {
    case "m": category = 1
    case "a": category = 2
    case "s": category = 3
    }
    verdict := text[colon + 1:]
    bound, _ := strconv.Atoi(text[2:colon])
    less := true
    if text[1] == '>' {
        less = false
        bound += 1
    }
    return Rule{category, bound, less, verdict}
}

func traverse(workflows map[string][]Rule, xmas *[4]int) bool {
    cur := "in"
    for {
        for _, rule := range workflows[cur] {
            value := xmas[rule.category]
            if (rule.less && value < rule.bound) || (!rule.less && value >= rule.bound) {
                cur = rule.verdict
                break
            }
        }
        if cur == "A" { return true }
        if cur == "R" { return false }
    }
}

func solve(data []string) int {
    workflows := map[string][]Rule{}
    for _, line := range data {
        brace := strings.Index(line, "{")
        rules := []Rule{}
        for _, text := range strings.Split(line[brace + 1 : (len(line) - 1)], ",") {
            rules = append(rules, parseRule(text))
        }
        workflows[line[0:brace]] = rules
    }

    boundsMap := map[int]map[int]bool{}
    for cat := 0; cat < 4; cat++ {
        boundsMap[cat] = map[int]bool{}
        boundsMap[cat][1] = true
        boundsMap[cat][4001] = true
    }
    for _, rules := range workflows {
        for _, rule := range rules {
            if rule.bound > 0 {
                boundsMap[rule.category][rule.bound] = true
            }
        }
    }

    bounds := map[int][]int{}
    for cat := 0; cat < 4; cat++ {
        bounds[cat] = []int{}
        for number, _ := range boundsMap[cat] {
            bounds[cat] = append(bounds[cat], number)
        }
        slices.Sort(bounds[cat])
    }

    result := 0

    bx := bounds[0]
    bm := bounds[1]
    ba := bounds[2]
    bs := bounds[3]

    xmas := [4]int{0, 0, 0, 0}
    for ix, vx := range bx[:len(bx) - 1] {
        xmas[0] = vx
        for im, vm := range bm[:len(bm) - 1] {
            xmas[1] = vm
            for ia, va := range ba[:len(ba) - 1] {
                xmas[2] = va
                d := (bx[ix + 1] - vx) * (bm[im + 1] - vm) * (ba[ia + 1] - va)
                for is, vs := range bs[:len(bs) - 1] {
                    xmas[3] = vs
                    if traverse(workflows, &xmas) {
                        result += d * (bs[is + 1] - vs)
                    }
                }
            }
        }
    }

    return result
}

func main() {
    var data = []string{}
    var line string
    for {
        _, err := fmt.Scanln(&line)
        if err != nil { break }
        data = append(data, line)
    }
    fmt.Println(solve(data))
}
