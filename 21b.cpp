// c++ -std=c++20 -O2 21b.cpp && ./a.out

#include <iostream>
#include <map>
#include <ranges>
#include <set>
#include <string>
#include <vector>

using namespace std;
using std::ranges::iota_view;

const int STEPS = 26501365;

const int DX[] = {1, 0, -1, 0};
const int DY[] = {0, 1, 0, -1};

map<int, long> mem;

long go(const vector<string>& a, int sx, int sy, int steps) {
    if (steps < 0) return 0;
    int n = a.size();
    if (steps > 3 * n) steps = steps % 2 == 0 ? 3 * n + 1 : 3 * n;

    auto key = (sx << 24) + (sy << 16) + steps;
    auto existing = mem.find(key);
    if (existing != mem.end()) return existing->second;

    auto f = vector<vector<bool>>(n, vector<bool>(n));
    auto ff = vector<vector<bool>>(n, vector<bool>(n));

    for (int i : iota_view { 0, n })
        for (int j : iota_view { 0, n })
            f[i][j] = sx == i && sy == j;

    for (int it : iota_view { 0, steps }) {
        for (int i : iota_view { 0, n }) {
            for (int j : iota_view { 0, n }) {
                if (a[i][j] == '#') continue;
                ff[i][j] = false;
                for (int d : iota_view { 0, 4 }) {
                    int x = i + DX[d];
                    int y = j + DY[d];
                    if (0 <= x && x < n && 0 <= y && y < n && f[x][y]) {
                        ff[i][j] = true;
                        break;
                    }
                }
            }
        }
        f = ff;
    }

    long result = 0;
    for (int i : iota_view { 0, n })
        for (int j : iota_view { 0, n })
            if (f[i][j]) result++;
    return mem[key] = result;
}

long solve(vector<string> a) {
    int n = a.size();

    long result = go(a, 0, 0, STEPS);
    for (int m = 1; m <= STEPS / n; m++) {
        auto left = STEPS + n / 2 - m * n;
        result += go(a, 0, n / 2, left);
        result += go(a, n - 1, n / 2, left);
        result += go(a, n / 2, 0, left);
        result += go(a, n / 2, n - 1, left);
    }
    for (long dx = 1; dx <= STEPS / n; dx++) {
        auto c = STEPS / n - dx + 1;
        if (c > 2) {
            auto odd = STEPS + dx;
            result += (c - 2) / 2 *
                (go(a, 0, 0, odd) + go(a, 0, n - 1, odd) + go(a, n - 1, 0, odd) + go(a, n - 1, n - 1, odd));
            auto even = STEPS + 1 + dx;
            result += (c - 1) / 2 *
                (go(a, 0, 0, even) + go(a, 0, n - 1, even) + go(a, n - 1, 0, even) + go(a, n - 1, n - 1, even));
        }
        for (long dy = max(c - 1, 1L); dy <= c; dy++) {
            auto left = STEPS + n - 1 - dx * n - dy * n;
            result += go(a, 0, 0, left);
            result += go(a, 0, n - 1, left);
            result += go(a, n - 1, 0, left);
            result += go(a, n - 1, n - 1, left);
        }
    }

    return result;
}

int main() {
    vector<string> lines;
    string line;
    while (cin >> line) lines.push_back(line);
    cout << solve(lines) << endl;
    return 0;
}
