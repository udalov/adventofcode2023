# elixir 03b.exs

defmodule Solution do
    def is_digit(x) do
        x in ?0..?9
    end

    def is_symbol(x) do
        !is_digit(x) && x != ?. && x != nil
    end

    def find_gears(a, x, y0, result) do
        if x == map_size(a) do
            result
        else
            m = map_size(a[x]) - 1
            y1 = Enum.find(y0..m, fn y -> is_digit(a[x][y]) end)
            if y1 == nil do
                find_gears(a, x + 1, 0, result)
            else
                y2 = Enum.find(y1..m, fn y -> !is_digit(a[x][y]) end) - 1
                number = List.foldl(Enum.to_list(y1..y2), 0, fn y, acc -> acc * 10 + (a[x][y] - 48) end)
                pairs = Enum.flat_map((y1 - 1)..(y2 + 1), fn y ->
                    Enum.map(max(x - 1, 0)..min(x + 1, map_size(a) - 1), fn x ->
                        {x, y}
                    end)
                end)
                gears = Enum.filter(pairs, fn xy ->
                    {x, y} = xy
                    a[x][y] == ?*
                end)
                result = List.foldl(gears, result, fn gear, map ->
                    prev = map[gear]
                    if prev == nil do
                        Map.put(map, gear, [number])
                    else
                        Map.put(map, gear, prev ++ [number])
                    end
                end)
                find_gears(a, x, y2 + 1, result)
            end
        end
    end

    def solve(a) do
        gears = find_gears(a, 0, 0, %{})
        List.foldl(Map.values(gears), 0, fn ratios, result ->
            if length(ratios) == 2 do
                result + Enum.product(ratios)
            else
                result
            end
        end)
    end

    def to_array(line) do
        line
        |> String.to_charlist
        |> Enum.with_index
        |> Enum.map(fn({char, index}) -> {index, char} end)
        |> Map.new
    end

    def main() do
        input = IO.read(:stdio, :all)
            |> String.split("\n")
            |> Enum.with_index
            |> Enum.map(fn({line, index}) -> {index, to_array("." <> line <> ".")} end)
            |> Map.new
        IO.inspect(solve(input))
    end
end

Solution.main()
