# Enter your code here. Read input from STDIN. Print output to STDOUT
n = gets.strip.to_i

def track(array, p, i, j, set = [])
    if !p[i][j-1]
        sum = i - array[j-1]
        set.push(j-1)
        track(array, p, sum, j-1, set)
    else
        track(array, p, i, j-1, set) if j > 1
    end
    set
end
def find_partition(array)
    n = array.length
    if n <= 1
        return [false, nil]
    end
    k = array.reduce(:+)
    if k % 2 == 1
        return [false, nil]
    end
    rows = (k/2).floor + 1
    p = Array.new(rows) { Array.new(n+1)}
    (1..n+1).each { |i| p[0][i-1] = true }
    (1..rows).each { |i| p[i-1][0] = false }
    p[0][0] = true
    (1..(k/2).floor).each do |i|
        (1..n).each do |j|
            p[i][j] = p[i][j-1] || p[i - array[j-1]][j-1]
        end
        
    end
    subset = track(array, p, (k/2).floor, n)
    can_partition = p[(k/2).floor][n]
    parts = []
    if can_partition
        left = []
        right = []
        parts.push(left)
        parts.push(right)
        array.each_with_index do |item, index|
            if subset.include? index
                left.push(item)
            else
                right.push(item)
            end
        end
    end
    [can_partition , parts]
end

def max_partition(array)
    can_partition , parts = find_partition(array)
    if can_partition
        1 + [max_partition(parts[0]), max_partition(parts[1])].max
    else
        0
    end
end

def process
    n = gets.strip.to_i
    array = gets.strip.split(' ').map(&:to_i)
    total = array.reduce(:+)
    result = max_partition(array)
    puts result
end
while n > 0
    process
    n -= 1
end
