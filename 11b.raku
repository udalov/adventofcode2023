# raku 11b.raku

my @a = lines();
my $n = @a.elems;
my $m = @a[0].chars;

my @row = True xx $n;
my @col = True xx $m;
for 0..^$n -> $i {
    my @galaxies = @a[$i].indices("#");
    if @galaxies { @row[$i] = False; }
    @col[@galaxies] = False xx $m;
}

my $result = 0;
for 0..^$n -> $x1 {
    for 0..^$m -> $y1 {
        next if substr(@a[$x1], $y1, 1) !eq "#";
        for 0..^$n -> $x2 {
            for 0..^$m -> $y2 {
                next if substr(@a[$x2], $y2, 1) !eq "#";

                my $rows = (grep { $_ }, @row[min($x1, $x2)..max($x1, $x2)]).elems;
                my $cols = (grep { $_ }, @col[min($y1, $y2)..max($y1, $y2)]).elems;
                $result += abs($x1 - $x2) + abs($y1 - $y2) + 999999 * ($rows + $cols);
            }
        }
    }
}

say $result / 2;
