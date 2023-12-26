// java 24b.java

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

class Solution {
    static long solve(List<long[]> rays) {
        long z = 0, dz = 0;
        outer: for (int i = 0; i < rays.size(); i++) {
            var a = rays.get(i);
            for (int j = 0; j < i; j++) {
                var b = rays.get(j);
                if (a[2] == b[2] && a[5] == b[5]) {
                    z = a[2];
                    dz = a[5];
                    break outer;
                }
            }
        }
        assert z != 0 && dz != 0;

        var r0 = rays.get(0);
        var r1 = rays.get(1);
        var t0 = BigInteger.valueOf((z - r0[2]) / (r0[5] - dz));
        var t1 = BigInteger.valueOf((z - r1[2]) / (r1[5] - dz));
        long result = z;
        for (int coord : Arrays.asList(0, 1)) {
            var x0 = BigInteger.valueOf(r0[coord]);
            var dx0 = BigInteger.valueOf(r0[coord + 3]);
            var x1 = BigInteger.valueOf(r1[coord]);
            var dx1 = BigInteger.valueOf(r1[coord + 3]);
            var dx = x1.add(dx1.multiply(t1)).subtract(x0).subtract(dx0.multiply(t0)).divide(t1.subtract(t0));
            result += x0.add(dx0.multiply(t0)).subtract(dx.multiply(t0)).longValueExact();
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
