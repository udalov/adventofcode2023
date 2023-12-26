// zig run 10a.zig

const std = @import("std");

const N = 150;
const stdin = std.io.getStdIn().reader();
const print = std.debug.print;
const assert = std.debug.assert;

const DX = [_]i8{ 1, 0, -1, 0 };
const DY = [_]i8{ 0, 1, 0, -1 };

const Point = struct {
    const Self = @This();

    x: i64,
    y: i64,

    fn move(self: Self, dir: u8) Point {
        return Point{ .x = self.x + DX[dir], .y = self.y + DY[dir] };
    }

    fn isValid(self: Self, n: usize, m: usize) bool {
        return 0 <= self.x and self.x < n and 0 <= self.y and self.y < m;
    }
};

fn canGoTo(a: *[N][N]u8, p: Point, dir: u8) bool {
    return canComeFrom(a, p, (dir + 2) % 4);
}

fn canComeFrom(a: *[N][N]u8, p: Point, dir: u8) bool {
    const c: u8 = a[@intCast(p.x)][@intCast(p.y)];
    if (c == 'S') return true;
    return switch (dir) {
        0 => c == '|' or c == 'J' or c == 'L',
        1 => c == '-' or c == '7' or c == 'J',
        2 => c == '|' or c == '7' or c == 'F',
        3 => c == '-' or c == 'L' or c == 'F',
        else => unreachable(),
    };
}

pub fn main() !void {
    var a = [_][N]u8{[_]u8{0} ** N} ** N;
    var n: usize = 0;
    var m: usize = undefined;
    var start: Point = Point{ .x = 0, .y = 0 };
    while (true) : (n += 1) {
        const line = try stdin.readUntilDelimiterOrEof(&a[n], '\n');
        m = if (line) |l| l.len else break;
        for (line.?, 0..) |c, j| {
            if (c == 'S') start = Point{ .x = @intCast(n), .y = @intCast(j) };
        }
    }

    var dir: u8 = 0;
    while (true) : (dir += 1) {
        var next: Point = start.move(dir);
        if (next.isValid(n, m) and canComeFrom(&a, next, dir)) break;
    }
    assert(dir < 4);

    var cur: Point = start.move(dir);
    var dist: u64 = 1;
    while (!std.meta.eql(cur, start)) {
        var nextDir: u8 = 0;
        while (true) : (nextDir += 1) {
            const next = cur.move(nextDir);
            if (nextDir != (dir + 2) % 4 and next.isValid(n, m) and canGoTo(&a, cur, nextDir) and canComeFrom(&a, next, nextDir)) break;
        }
        assert(nextDir < 4);
        dir = nextDir;
        cur = cur.move(dir);
        dist += 1;
    }

    print("{}\n", .{@divExact(dist, 2)});
}
