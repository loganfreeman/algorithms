def brute_contiguous_subset(set) 

	if set.empty? 
		return nil
	elsif set.length == 1
		return set[0]
	else

	#initialize the best sum to be the value of the first element
	best_sum = set[0]
	current_sum = 0
	best_start = 0
	best_end = 0

	#check the sum of every contiguous subset to see if it beats the best_sum. This will
	#be O(n^2) 
		set.each_with_index do |outer_el, outer_i|
			current_sum = 0
			inner_set = set[outer_i..set.length-1]
			inner_set.each_with_index do |inner_el, inner_i|
				current_sum = current_sum + inner_set[inner_i]
				if current_sum >= best_sum
					best_start = outer_i
					best_end = outer_i + inner_i
					best_sum = current_sum
				end
			end
		end
	end

	return set[best_start..best_end]
end

def better_contiguous_subset(set)

	if set.empty?
		return nil
	elsif set.length == 1
		return set[0]
	else

		best_sum = set[0]
		best_start = 0
		best_end = 0
		current_sum = 0

	#loop over the set one time 0(n). For each element, check if that element itself is >= (best_sum plus the current element).
	#If it is, then throw out the best_sum so far and start a new best_sum with the current element as the best_start and best_end.

		set.each_with_index do |el, i|
			current_sum = current_sum + el
			if el > current_sum
				best_start = i
				best_end = i
				best_sum = el
			elsif current_sum >= best_sum
				best_end = i
				best_sum = current_sum
			end
		end
	end

	return set[best_start..best_end]
end

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
