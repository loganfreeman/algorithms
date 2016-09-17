# Enter your code here. Read input from STDIN. Print output to STDOUT
n = gets.strip.to_i
def solve(array)
    if array.length == 1
        puts 'YES'
        return
    end
    
    if array.length == 2
        puts 'NO'
        return
    end

    
    left = array.shift
    right = array.pop
    
    while !array.empty?

        diff = (left - right).abs
        
        array.unshift(diff) if left > right
        array.push(diff) if right > left

        break if array.length < 3
        left = array.shift
        right = array.pop
    end
    if array.length == 1
        puts 'YES'
    else
        puts 'NO'
    end
    
end
def read(n)
    while n > 0
        m = gets.strip.to_i
        array = gets.split(' ').map(&:to_i)
        solve(array)
        n -= 1
    end
end
read(n)
