# julia 08a.jl

function main()
    route = readline()
    readline()

    edges = Dict()
    for line in readlines()
        start, left, right = split(line, r" = \(|, |\)")
        edges[start] = left, right
    end

    current = "AAA"
    dir = 0
    result = 0
    while current != "ZZZ"
        current = edges[current][if route[dir + 1] == 'L' 1 else 2 end]
        dir = (dir + 1) % length(route)
        result += 1
    end

    println(result)
end

main()
