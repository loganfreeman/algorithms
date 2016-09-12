# Enter your code here. Read input from STDIN. Print output to STDOUT
require 'pp'

def max_subarray_all(numbers) 
    if numbers.length == 1
        return numbers[0]
    end
    n = numbers.shift 
    max = max_subarray_all(numbers)
    max = [max + n, n, max].max
    max
end

def max_subarray(numbers)
    len = numbers.length
    i = 0
    max_so_far = -Float::INFINITY
    max_ending_here = -Float::INFINITY
    while i < len
        current = numbers[i]
        max_ending_here = [max_ending_here, max_ending_here + current, current].max 
        max_so_far = [max_so_far, max_ending_here].max
        i += 1
    end
    max_so_far
end


def sub_arr(numbers)
    i = 0
    n = numbers.length
    results = []
    while i < n
      j = i
      while j < n
        results.push(numbers[i..j])
        j += 1
      end
      i += 1
    end
    results.map { |a| a.reduce(:+) }.max
end

def max_subarray_cont(numbers)
    len = numbers.length
    i = 0
    max_so_far = -Float::INFINITY
    max_ending_here = -Float::INFINITY
    while i < len
        current = numbers[i]
        max_ending_here = [max_ending_here + current, current].max 
        max_so_far = [max_so_far, max_ending_here].max
        i += 1
    end
    max_so_far
end

def solve
    n = gets.strip.to_i
    numbers = gets.gsub(/\s+/m, ' ').strip.split(" ").map(&:to_i)
    x = max_subarray_cont(numbers)
    y = max_subarray(numbers)

    puts "#{x} #{y}"
end

cases = gets.strip.to_i

while cases > 0
    solve 
    cases -= 1
end
