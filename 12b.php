<?php
// php 12b.php

function check(string $s, int $begin, int $operational_end, int $damaged_end) {
    for ($i = $begin; $i < $operational_end; $i++)
        if ($s[$i] == '#') return false;
    for ($i = $operational_end; $i < $damaged_end; $i++)
        if ($s[$i] == '.') return false;
    return true;
}

function rec(array &$mem, string &$s, array &$a, int $i, int $j, int $n, int $m) {
    $key = $i * 1000 + $j;
    if (array_key_exists($key, $mem)) return $mem[$key];

    if ($i >= $n)
        return $mem[$key] = $j == $m ? 1 : 0;
    
    if ($j == $m)
        return $mem[$key] = check($s, $i, $n, $n) ? 1 : 0;

    $ans = 0;
    $len = $a[$j];
    for ($k = $i; $k <= $n - $len; $k++)
        if (check($s, $i, $k, $k + $len) && ($k + $len == $n || $s[$k + $len] != '#'))
            $ans += rec($mem, $s, $a, $k + $len + 1, $j + 1, $n, $m);

    return $mem[$key] = $ans;
}

function solve(string $line) {
    [$p, $n] = explode(" ", $line);
    $pattern = "$p?$p?$p?$p?$p";
    $numbers = "$n,$n,$n,$n,$n";
    $values = array_map("intval", explode(",", $numbers));
    $mem = array();
    return rec($mem, $pattern, $values, 0, 0, strlen($pattern), count($values));
}

function main() {
    $result = 0;
    while ($line = fgets(STDIN)) {
        $result += solve(rtrim($line));
    }
    echo "$result\n";
}

main();
