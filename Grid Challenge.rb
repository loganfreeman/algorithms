# Enter your code here. Read input from STDIN. Print output to STDOUT
def read
    n = gets.strip.to_i
    1.upto(n).each do |i| 
        size = gets.strip.to_i
        grid = Array.new(size) { Array.new(size) }
        1.upto(size).each do |i|
            line = gets.strip.split('')
            line.each_with_index do |c, j|
                grid[i-1][j] = c
            end
        end
        solve(grid, size)
    end
end

def display(grid)
    grid.each do |row|
        puts row.join('')
    end
end
def solve(grid, size)
    display(grid)
end

read
