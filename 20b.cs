// d=$(mktemp -d) && pushd $d >/dev/null && dotnet new console >/dev/null && popd >/dev/null && cp 20b.cs $d/Program.cs && dotnet run --project $d

class Program {
    enum Kind {
        BEGIN, FLIP, CONJ, OTHER,
    }

    static long Solve(int[][] g, int[][] gt, Kind[] kind, int end) {
        var n = g.Length;

        var mem = new bool[n][];
        for (var i = 0; i < n; i++) {
            var len = kind[i] == Kind.BEGIN || kind[i] == Kind.OTHER ? 0 : kind[i] == Kind.FLIP ? 1 : gt[i].Length;
            mem[i] = new bool[len];
        }

        var index = new int[n, n];
        for (var i = 0; i < n; i++) {
            for (var j = 0; j < n; j++) if (kind[j] == Kind.CONJ) {
                index[i, j] = -1;
                for (var k = 0; k < gt[j].Length; k++) {
                    if (gt[j][k] == i) {
                        index[i, j] = k;
                    }
                }
            }
        }

        var begin = 0;
        while (kind[begin] != Kind.BEGIN) begin++;

        var queue = new Queue<int>();
        for (var it = 1L;; it++) {
            var lows = 0;
            queue.Clear();
            queue.Enqueue(begin * 2);
            while (queue.Count > 0) {
                var value = queue.Dequeue();
                var v = value / 2;
                var high = (value & 1) == 1;

                if (v == end) {
                    if (!high) lows++;
                    continue;
                }
                var k = kind[v];
                var sendHigh = false;
                if (k == Kind.FLIP) {
                    if (high) continue;
                    mem[v][0] = !mem[v][0];
                    sendHigh = mem[v][0];
                } else if (k == Kind.CONJ) {
                    sendHigh = mem[v].Any(x => !x);
                }
                foreach (var target in g[v]) {
                    if (kind[target] == Kind.CONJ) {
                        mem[target][index[v, target]] = sendHigh;
                    }
                    queue.Enqueue(target * 2 + (sendHigh ? 1 : 0));
                }
            }

            if (lows == 1) return it;
        }
    }

    static void Main() {
        var v2i = new Dictionary<string, int>();
        var i2v = new Dictionary<int, string>();
        var g = new Dictionary<int, List<int>>();
        var gt = new Dictionary<int, List<int>>();
        var kind = new Dictionary<int, Kind>();
        int vertex(string name) {
            if (!v2i.ContainsKey(name)) {
                var v = v2i.Count;
                v2i[name] = v;
                i2v[v] = name;
                g[v] = new List<int>();
                gt[v] = new List<int>();
                kind[v] = Kind.OTHER;
            }
            return v2i[name];
        }

        void addEdge(int x, int y) {
            g[x].Add(y);
            gt[y].Add(x);
        }

        while (true) {
            var line = Console.In.ReadLine();
            if (line == null) break;
            var str = line.Split(" -> ");
            var nk = str[0];
            var (name, k) =
                nk[0] == '%' ? (nk.Substring(1), Kind.FLIP) :
                nk[0] == '&' ? (nk.Substring(1), Kind.CONJ) :
                (nk, Kind.BEGIN);
            var v = vertex(name);
            kind[v] = k;
            foreach (var u in str[1].Split(", ")) {
                addEdge(v, vertex(u));
            }
        }

        var end = v2i["rx"];
        var gl = new int[g.Count][];
        var gtl = new int[gt.Count][];
        var kl = new Kind[kind.Count];
        for (var i = 0; i < g.Count; i++) gl[i] = g[i].ToArray();
        for (var i = 0; i < gt.Count; i++) gtl[i] = gt[i].ToArray();
        for (var i = 0; i < kind.Count; i++) kl[i] = kind[i];

        /*
        for (var i = 0; i < g.Count; i++) {
            var it = i == end ? "" : kind[i] == Kind.FLIP ? "%" : kind[i] == Kind.CONJ ? "&" : "";
            foreach (var j in g[i]) {
                var jt = j == end ? "" : kind[j] == Kind.FLIP ? "%" : kind[j] == Kind.CONJ ? "&" : "";
                Console.WriteLine(it + i2v[i] + " " + jt + i2v[j]);
            }
        }

        // See 20b.png. (Drawn with https://csacademy.com/app/graph_editor/)
        */

        var result = 1L;
        for (var i = 0; i < g.Count; i++) {
            if (kind[i] == Kind.CONJ && g[i].Count == 1 && gt[i].Count == 1) {
                result *= Solve(gl, gtl, kl, i);
            }
        }
        Console.WriteLine(result);
    }
}
