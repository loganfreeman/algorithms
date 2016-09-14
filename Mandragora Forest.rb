# Enter your code here. Read input from STDIN. Print output to STDOUT
n = gets.strip.to_i

class Array
  def delete_first item
    delete_at(index(item) || length)
  end
end

def subsets(array, skip = 0, &block)
    yield(array)
    (array.length-1).downto(skip){|i| subsets(array[0...i] + array[i+1..-1], i, &block)}
end


def find_subset(input_array)
    no_of_subsets = 2**input_array.length - 1
    all_subsets = []
    expected_length_of_binary_no = input_array.length
    for i in 1..(no_of_subsets) do 
        binary_string = i.to_s(2)
        binary_string = binary_string.rjust(expected_length_of_binary_no, '0')
        binary_array = binary_string.split('')
        subset = []
        binary_array.each_with_index do |bin, index|
            if bin.to_i == 1
                subset.push(input_array[index]) 
            end
        end
        all_subsets.push(subset)
    end
    all_subsets
end

def comp_set(array, subset)
    n = subset.length
    m = array.length
    i = j = 0
    comp = []
    while j < m
        if i < n
            if subset[i] != array[j]
                comp.push(array[j])
                j += 1
            else
                i += 1
                j += 1
            end
        else
            comp.push(array[j])
            j += 1
        end
    end
    comp
end

def solve(m, array)
    max = 0
    find_subset(array).each do |subset|
        s = 1
        p = 0
        comp = comp_set(array, subset)
        s += subset.length
        comp.each do |point| 
            p += s * point
        end
        
        max = p if p > max
        
    end
    puts max
end
def solve_smart(m, array)
    array = array.sort 
    max = 0
    len = array.length
    (1..len).each do |i|
        s = 1 + i
        p = array[i..-1].reduce(0, :+)*s
        max = [p, max].max
    end
    puts max
end

def read
    m = gets.strip.to_i 
    array = gets.strip.split(' ').map(&:to_i)
    solve_smart(m, array)
end
(1..n).each do |i|
    read
end
