// go run 19a.go

package main

import (
    "fmt"
    "strconv"
    "strings"
)

type Rule struct {
    category string
    checker func(int) bool
    verdict string
}

func parseRule(text string) Rule {
    colon := strings.Index(text, ":")
    if colon == -1 {
        return Rule{"s", func(int) bool { return true }, text}
    }
    category := text[0:1]
    verdict := text[colon + 1:]
    bound, _ := strconv.Atoi(text[2:colon])
    if text[1] == '>' {
        return Rule{category, func(value int) bool { return value > bound }, verdict}
    } else {
        return Rule{category, func(value int) bool { return value < bound }, verdict}
    }
}

func solve(data []string, queries []string) int {
    workflows := map[string][]Rule{}
    for _, line := range data {
        brace := strings.Index(line, "{")
        rules := []Rule{}
        for _, text := range strings.Split(line[brace + 1 : (len(line) - 1)], ",") {
            rules = append(rules, parseRule(text))
        }
        workflows[line[0:brace]] = rules
    }

    result := 0

    for _, query := range queries {
        part := map[string]int{}
        for _, rating := range strings.Split(query[1 : len(query) - 1], ",") {
            number, _ := strconv.Atoi(rating[2:])
            part[rating[0:1]] = number
        }

        cur := "in"
        for {
            for _, rule := range workflows[cur] {
                if rule.checker(part[rule.category]) {
                    cur = rule.verdict
                    break
                }
            }
            if cur == "A" {
                sum := 0
                for _, value := range part {
                    sum += value
                }
                result += sum
                break
            }
            if cur == "R" { break }
        }
    }

    return result
}

func main() {
    var data = []string{}
    var queries = []string{}
    var line string
    for {
        _, err := fmt.Scanln(&line)
        if err != nil { break }
        data = append(data, line)
    }
    for {
        _, err := fmt.Scanln(&line)
        if err != nil { break }
        queries = append(queries, line)
    }
    fmt.Println(solve(data, queries))
}
