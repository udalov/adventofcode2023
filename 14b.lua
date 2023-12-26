-- lua 14b.lua

function replace(lines, i, j, c)
    lines[i] = lines[i]:sub(1, j - 1) .. c .. lines[i]:sub(j + 1)
end

function move(lines, x1, y1, x2, y2)
    replace(lines, x1, y1, '.')
    replace(lines, x2, y2, 'O')
end

function rotate(lines)
    local n = #lines
    local m = #lines[1]
    local function get(i, j) return lines[i]:sub(j, j) end

    for j = 1, m do
        local ii = 1
        for i = 1, n do
            if get(i, j) == '#' then
                ii = i + 1
            elseif get(i, j) == 'O' then
                move(lines, i, j, ii, j)
                ii = ii + 1
            end
        end
    end

    for i = 1, n do
        local jj = 1
        for j = 1, m do
            if get(i, j) == '#' then
                jj = j + 1
            elseif get(i, j) == 'O' then
                move(lines, i, j, i, jj)
                jj = jj + 1
            end
        end
    end

    for j = 1, m do
        local ii = n
        for i = n, 1, -1 do
            if get(i, j) == '#' then
                ii = i - 1
            elseif get(i, j) == 'O' then
                move(lines, i, j, ii, j)
                ii = ii - 1
            end
        end
    end

    for i = 1, n do
        local jj = m
        for j = m, 1, -1 do
            if get(i, j) == '#' then
                jj = j - 1
            elseif get(i, j) == 'O' then
                move(lines, i, j, i, jj)
                jj = jj - 1
            end
        end
    end
end

function hash(lines)
    local result = 0
    for i = 1, #lines do
        for j = 1, #lines[i] do
            local c = lines[i]:sub(j, j)
            result = result * 31 + string.byte(c)
        end
    end
    return result
end

function count(lines)
    local n = #lines
    local result = 0
    for j = 1, #lines[1] do
        for i = 1, n do
            if lines[i]:sub(j, j) == 'O' then
                result = result + n - i + 1
            end
        end
    end
    return result
end

function solve(lines)
    local prev = {}
    local ans = {}
    prev[hash(lines)] = 0
    ans[0] = count(lines)
    local iter = 1
    while true do
        rotate(lines)
        local h = hash(lines)
        if prev[h] then
            local period = iter - prev[h]
            local target = (1000000000 - prev[h]) % period
            return ans[prev[h] + target]
        end
        prev[h] = iter
        ans[iter] = count(lines)
        iter = iter + 1
    end
end

function main()
    local lines = {}
    for line in io.lines() do
        lines[#lines + 1] = line
    end

    print(solve(lines))
end

main()
