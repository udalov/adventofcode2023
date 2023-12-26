# julia 08b.jl

function gcd(x, y)
    if x == 0 y else gcd(y % x, x) end
end

function lcm(x, y)
    x * div(y, gcd(x, y))
end

function main()
    route = readline()
    readline()

    edges = Dict()
    for line in readlines()
        start, left, right = split(line, r" = \(|, |\)")
        edges[start] = left, right
    end

    result = 1
    for start in edges
        if !endswith(start.first, "A") continue end
        current = start.first
        dir = 0
        part = 0
        while !endswith(current, "Z")
            current = edges[current][if route[dir + 1] == 'L' 1 else 2 end]
            dir = (dir + 1) % length(route)
            part += 1
        end
        result = lcm(result, part)
    end

    println(result)
end

main()
