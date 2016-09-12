def subsets(arr)
  return [[]] if arr.empty?
  old_subsets = subsets(arr.drop(1))
  new_subsets = []
  old_subsets.each do |subset|
    new_subsets << subset + [arr.first]
  end
  old_subsets + new_subsets
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
