# Enter your code here. Read input from STDIN. Print output to STDOUT
require 'prime'
n = gets.strip.to_i
def divisors_of(num)
    (1..num).select { |n|num % n == 0}
end
def solve(towers, height)
    if height == 1 || (towers % 2 == 0)
        puts 2
    else
        puts 1
    end
end
while n > 0
    n -= 1
    towers, height = gets.strip.split(' ').map(&:to_i)
    solve(towers, height)
end
