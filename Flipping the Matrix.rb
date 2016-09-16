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
        solve(grid, size)
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
    half = size/2
    1.upto(half).each do |r|
        1.upto(half).each do |c|
            top = [r-1, c-1]
            right = [r-1, size - c]
            left = [size - r, c-1]
            bottom = [size -r, size -c]
            max = [top, right, left, bottom].map { |r, c| grid[r][c] }.max 
            count += max
        end
    end
    count
end

def need_reverse(array)
    array[0, array.length/2].reduce(:+) < array[array.length/2, array.length/2].reduce(:+)
end

def reverse_row(grid, row)
    return if !need_reverse(grid[row])
    grid[row].reverse!
end

def reverse_col(grid, col)
    array = 1.upto(grid.length).map do |r|
        grid[r-1][col]
    end
    return if !need_reverse(array)
    reversed = array.reverse!
    reversed.each_with_index do |v, r|
        grid[r][col] = v
    end
    grid
end



def solve(grid, size)

    puts get_max(grid, size)
end

read
