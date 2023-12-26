-- lua 14a.lua

function main()
    local lines = {}
    for line in io.lines() do
        lines[#lines + 1] = line
    end

    local n = #lines
    local result = 0
    for j = 1, #lines[1] do
        local cur = n
        for i = 1, n do
            local c = lines[i]:sub(j, j)
            if c == 'O' then
                result = result + cur
                cur = cur - 1
            elseif c == '#' then
                cur = n - i
            end
        end
    end

    print(result)
end

main()
