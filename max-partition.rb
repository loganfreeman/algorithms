# Enter your code here. Read input from STDIN. Print output to STDOUT
require 'pp'
n = gets.strip.to_i

def display_table(table)
    table.each do |row| 
        puts row.map {|i| i ? 1 : 0 }.join(' ')
    end
end

def track(array, p, i, j, set = [])
    
        
    begin
        if !p[i][j-1]
            sum = i - array[j-1]
            set.push(j-1)
            track(array, p, sum, j-1, set) if i >= array[j-1]
        else
            track(array, p, i, j-1, set) if j > 1

        end
    
    rescue => exception
        puts "***#{i} #{j-1}****"
        raise exception
    end
    set
end

def find_partition_efficient(array)
    n = array.length
    if n <= 1
        return false
    end
    k = array.reduce(:+)
    if k % 2 == 1
        return false
    end
    rows = k/2 + 1
    pre = Array.new(rows)
    set = []
    (1..rows).each { |i| pre[i-1] = false }
    pre[0] = true
    (1..n).each do |j|
        current = Array.new(rows)
        (1..(k/2)).each do |i|
            current[i] = pre[i]
            if i - array[j-1] >= 0
                current[i] = pre[i] || pre[i - array[j-1]]
            end
        end
        puts pre.map { |b| b ? 1 : 0 } .join(' ')
        pre = current
        
    end
    puts pre.map { |b| b ? 1 : 0 } .join(' ')
    pre[(k/2)]

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
    rows = k/2 + 1
    p = Array.new(rows) { Array.new(n+1)}
    
    (1..n+1).each { |i| p[0][i-1] = true }
    (1..rows).each { |i| p[i-1][0] = false }
    p[0][0] = true
    (1..(k/2)).each do |i|
        (1..n).each do |j|
            p[i][j] = p[i][j-1]
            p[i][j] = p[i][j-1] || p[i - array[j-1]][j-1] if i - array[j-1] >= 0
        end
        
    end
    subset = track(array, p, (k/2), n)
    can_partition = p[(k/2)][n]
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
    display_table p
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


def can_subset_sum(array, sum)
    rows = sum + 1
    n = array.length
    pre = Array.new(rows)
    (1..rows).each { |i| pre[i-1] = false }
    pre[0] = true
    (1..n).each do |j|
        current = Array.new(rows)
        current[0] = true
        (1..sum).each do |i|
            current[i] = pre[i]
            if i - array[j-1] >= 0
                current[i] = pre[i] || pre[i - array[j-1]]
            end
        end
        pre = current

    end
    pre[sum]
end


def max_partition_efficient(array)
    n = array.length
    array = array.reject { |i| i == 0 }
    if array.empty?
        return n - 1
    end
    total = array.reduce(:+)
    if total % 2 == 1
        return 0
    end
    can = can_subset_sum(array, total = total / 2)
    count = 0
    while can
        count += 1
        if total % 2 == 0
            can = can_subset_sum(array, total = total / 2)
        else
            can = false
        end
    end
    count
end

def process
    n = gets.strip.to_i
    array = gets.strip.split(' ').map(&:to_i)
    total = array.reduce(:+)
    if total.odd?
        pp 0
    else
        pre = can_subset_sum(array, total /= 2)
        count = 0
        while pre[total]
            count += 1
            break if total.odd?
            total /= 2
        end
        pp count
    end
    
end
while n > 0
    process
    n -= 1
end
