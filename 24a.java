// java 24a.java

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

class Solution {
    static BigDecimal MIN = BigDecimal.valueOf(200000000000000L);
    static BigDecimal MAX = BigDecimal.valueOf(400000000000000L);

    static boolean intersect(long[] a, long[] b) {
        var x1 = BigDecimal.valueOf(a[0]);
        var y1 = BigDecimal.valueOf(a[1]);
        var dx1 = BigDecimal.valueOf(a[3]);
        var dy1 = BigDecimal.valueOf(a[4]);
        var x2 = BigDecimal.valueOf(b[0]);
        var y2 = BigDecimal.valueOf(b[1]);
        var dx2 = BigDecimal.valueOf(b[3]);
        var dy2 = BigDecimal.valueOf(b[4]);

        var D = dx2.multiply(dy1).subtract(dx1.multiply(dy2));
        if (D.equals(BigDecimal.ZERO)) return false;

        var x21 = x2.subtract(x1);
        var y21 = y2.subtract(y1);

        var p = y21.multiply(dx2).subtract(x21.multiply(dy2)).divide(D, 100, RoundingMode.FLOOR);
        var q = y21.multiply(dx1).subtract(x21.multiply(dy1)).divide(D, 100, RoundingMode.FLOOR);
        if (p.compareTo(BigDecimal.ZERO) <= 0 || q.compareTo(BigDecimal.ZERO) <= 0) return false;

        var x = x1.add(p.multiply(dx1));
        var y = y1.add(p.multiply(dy1));

        return MIN.compareTo(x) <= 0 && x.compareTo(MAX) <= 0 &&
                MIN.compareTo(y) <= 0 && y.compareTo(MAX) <= 0;
    }

    static int solve(List<long[]> rays) {
        var result = 0;
        for (int i = 0; i < rays.size(); i++) {
            for (int j = 0; j < i; j++) {
                if (intersect(rays.get(i), rays.get(j))) result++;
            }
        }
        return result;
    }

    public static void main(String[] args) throws IOException {
        var stdin = new BufferedReader(new InputStreamReader(System.in));
        var rays = new ArrayList<long[]>();
        while (true) {
            var line = stdin.readLine();
            if (line == null) break;
            rays.add(Arrays.stream(line.split("(, +)|( @ +)")).mapToLong(Long::parseLong).toArray());
        }
        System.out.println(solve(rays));
    }
}
