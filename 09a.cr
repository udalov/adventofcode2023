# crystal 09a.cr

def solve(line)
    a = line.split(" ").map { |x| x.to_i }
    recurse!(a)
    a.last
end

def recurse!(a)
    if a.all? { |x| x == 0 }
        return
    end
    b = a.clone()
    b.pop()
    (0...b.size).each do |i|
        b[i] = a[i + 1] - a[i]
    end
    recurse!(b)
    a << a.last + b.last
    return
end

result = 0
while true
    line = gets
    break if line.nil?
    result += solve(line)
end
puts result
