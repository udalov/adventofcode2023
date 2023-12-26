// d=$(mktemp -d) && cp 07a.hx $d/Solution.hx && haxe -C $d --main Solution --interp

using StringTools;

class Solution {
    static function getStrength(card: String): Int {
        return "23456789TJQKA".indexOf(card);
    }

    static function getType(hand: String): Int {
        var count = [for (i in 0...13) 0];
        for (card in hand.split("")) {
            count[getStrength(card)]++;
        }
        var max = 0;
        var pairs = 0;
        for (val in count) {
            if (val > max) max = val;
            if (val == 2) pairs++;
        }
        return max > 3 ? max + 1 :
            max == 3 && pairs == 1 ? 4 :
            max == 3 ? 3 : pairs;
    }

    static function compare(a: String, b: String): Int {
        var types = getType(b) - getType(a);
        if (types != 0) return types;

        for (i in 0...5) {
            var strengths = getStrength(b.charAt(i)) - getStrength(a.charAt(i));
            if (strengths != 0) return strengths;
        }

        return 0;
    }

    public static function main() {
        var lines = Sys.stdin().readAll().toString().trim().split("\n").map(s -> s.split(" "));
        var hands = lines.map(line -> line[0]);
        var bids = lines.map(line -> Std.parseInt(line[1]));
        var n = lines.length;
        var p = [for (i in 0...n) i];
        p.sort((i, j) -> compare(hands[i], hands[j]));
        var result = 0;
        for (i in 0...n) result += (n - i) * bids[p[i]];
        Sys.println(result);
    }
}
