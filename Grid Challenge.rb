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
    puts '##########'
    grid.each do |row|
        puts row.join('')
    end
end

def swap(grid, i, j)
    grid[i][j], grid[i][j+1] = grid[i][j+1], grid[i][j]
end

def check_column(grid, col, size)
    sorted = true
    1.upto(size-1).each do |r|
        if grid[r-1][col] > grid[r][col]
            sorted = false
        end
    end
    sorted
end

def solve(grid, size)
    1.upto(size).each do |r|
        row = grid[r-1]
        row.sort!
    end
    # display(grid)
    first = (1..size).find do |col|
        !check_column(grid, col-1, size)
    end
    if !first.nil?
        puts 'NO'
    else
        puts 'YES'
    end
end

read
