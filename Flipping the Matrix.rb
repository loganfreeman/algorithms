# Enter your code here. Read input from STDIN. Print output to STDOUT
def read
    n = gets.strip.to_i
    1.upto(n).each do |i| 
        size = gets.strip.to_i * 2
        grid = Array.new(size) { Array.new(size) }
        1.upto(size).each do |i|
            line = gets.strip.split(' ').map(&:to_i)
            line.each_with_index do |c, j|
                grid[i-1][j] = c
            end
        end
        display(grid)
    end
end

def display(grid)
    puts '##########'
    grid.each do |row|
        puts row.join(' ')
    end
end

def get_max(grid, size)
    count = 0
    1.upto(size).each do |r|
        1.upto(size).each do |c|
            count += grid[r-1][c-1]
        end
    end
    count
end

def reverse_row(grid, row)
    grid[row].reverse!
end

def reverse_col(grid, col)
    reversed = 1.upto(grid.length).map do |r|
        grid[r-1][col]
    end.reverse!
    reversed.each_with_index do |v, r|
        grid[r][col] = v
    end
    grid
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
