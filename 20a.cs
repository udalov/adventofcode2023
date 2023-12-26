// d=$(mktemp -d) && pushd $d >/dev/null && dotnet new console >/dev/null && popd >/dev/null && cp 20a.cs $d/Program.cs && dotnet run --project $d

class Program {
    enum Kind {
        BEGIN, FLIP, CONJ,
    }

    static int Solve(Dictionary<int, List<int>> g, Dictionary<int, List<int>> gt, Dictionary<int, Kind> kind) {
        var n = g.Count;
        var mem = new List<bool[]>();
        for (var i = 0; i < n; i++) {
            var len = kind[i] == Kind.BEGIN ? 0 : kind[i] == Kind.FLIP ? 1 : gt[i].Count;
            mem.Add(new bool[len]);
        }

        var begin = kind.Keys.Where(x => kind[x] == Kind.BEGIN).First();

        var queue = new Queue<(int, int, bool)>();
        var highs = 0;
        var lows = 0;
        for (var it = 0; it < 1000; it++) {
            queue.Enqueue((-1, begin, false));
            while (queue.Count > 0) {
                var (u, v, high) = queue.Dequeue();
                if (high) highs++; else lows++;

                if (!kind.TryGetValue(v, out Kind k)) continue;
                var sendHigh = default(bool?);
                if (k == Kind.FLIP) {
                    if (!high) {
                        mem[v][0] = !mem[v][0];
                        sendHigh = mem[v][0];
                    }
                } else if (k == Kind.CONJ) {
                    sendHigh = mem[v].Any(x => !x);
                } else {
                    sendHigh = false;
                }
                if (sendHigh != null) {
                    foreach (var target in g[v]) {
                        if (kind.TryGetValue(target, out Kind res) && res == Kind.CONJ) {
                            for (var i = 0; i < gt[target].Count; i++) {
                                if (gt[target][i] == v) {
                                    mem[target][i] = (bool) sendHigh;
                                }
                            }
                        }
                        queue.Enqueue((v, target, (bool) sendHigh));
                    }
                }
            }
        }

        return highs * lows;
    }

    static void Main() {
        var v2i = new Dictionary<string, int>();
        int vertex(string name) {
            if (!v2i.ContainsKey(name)) v2i[name] = v2i.Count;
            return v2i[name];
        }

        var g = new Dictionary<int, List<int>>();
        var gt = new Dictionary<int, List<int>>();
        var kind = new Dictionary<int, Kind>();
        void addEdge(int x, int y) {
            if (!g.ContainsKey(x)) g[x] = new List<int>();
            if (!gt.ContainsKey(y)) gt[y] = new List<int>();
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

        Console.WriteLine(Solve(g, gt, kind));
    }
}
