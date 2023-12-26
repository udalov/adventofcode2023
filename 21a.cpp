// c++ -std=c++20 -O2 21a.cpp && ./a.out

#include <iostream>
#include <ranges>
#include <string>
#include <vector>

using namespace std;
using std::ranges::iota_view;

const int DX[] = {1, 0, -1, 0};
const int DY[] = {0, 1, 0, -1};

int solve(vector<string> a) {
    int n = a.size();

    auto f = vector<vector<bool>>(n, vector<bool>(n));
    auto ff = vector<vector<bool>>(n, vector<bool>(n));

    for (int i : iota_view { 0, n })
        for (int j : iota_view { 0, n })
            f[i][j] = a[i][j] == 'S';

    for (int it : iota_view { 0, 64 }) {
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

    int result = 0;
    for (int i : iota_view { 0, n })
        for (int j : iota_view { 0, n })
            if (f[i][j]) result++;
    return result;
}

int main() {
    vector<string> lines;
    string line;
    while (cin >> line) lines.push_back(line);
    cout << solve(lines) << endl;
    return 0;
}
