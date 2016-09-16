# Enter your code here. Read input from STDIN. Print output to STDOUT
n = gets.strip.to_i
def solve(array)
    if array.length < 3
        return 'NO'
    end
    left = array.shift
    right = array.pop
    while array.length >= 1
        diff = (left-right).abs
        if left > right 
            right = array.pop
            
        elsif right > left
            left = array.shift
        else
            left = array.shift
            right = array.pop
        end
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
