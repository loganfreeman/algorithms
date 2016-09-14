module Sets
  class MightySet
    attr_reader :numbers

    def largest_sum
      calculate unless defined? @largest_sum

      @largest_sum
    end

    def initialize numbers
      @numbers = numbers
    end

    private

    def calculate
      simplified_array = simplify_array(numbers)
      result_array = sum_items(simplified_array)

      @largest_sum = find_largest_number(result_array)
    end

    def find_largest_number(array)
      largest_number = nil

      array.each do |number|
        largest_number = number if largest_number.nil? || number > largest_number
      end

      largest_number
    end

    # Recursive function
    # Find a negative number surrounded by two positive numbers,
    # one on the left (number1) and one on the right (number2)
    # Then replace this trio and the following subsets IF
    # The absolute value of the sum of a contiguous subset
    # of numbers (starting from number1) to the left is greater than
    # the absolute value of the negative number
    # AND
    # the absolute value of a contiguous subset of numbers (starting
    # from number2) to the right is greater than the absolute
    # value of the negative number
    def sum_items(array)
      result_array = Array.new

      index = 0
      loop do
        break if index >= array.size

        # Number should be negative
        # Otherwise, just store it; it could be used to calculate
        # the greatest sum
        number = array[index]
        if number >= 0

          result_array << number

          index += 1
          next
        end

        # We know that the number is negative
        negative_number = number

        # Search the subset of numbers to the left
        previous_sum = 0
        found_previous_sum = false
        result_array.reverse.each do |previous_number|
          break if previous_number < 0

          previous_sum += previous_number
          if previous_sum >= -negative_number
            found_previous_sum = true
            break
          end
        end

        # Numbers to the left do not satisfy condition
        unless found_previous_sum
          result_array << negative_number

          index += 1
          next
        end

        # Search the subset of numbers to the right
        sum = 0
        found_sum = false
        (index+1..array.size-1).each do |look_ahead_index|
          next_number = array[look_ahead_index]
          sum += next_number

          if sum >= -negative_number
            # For the next iteration, discard the numbers
            # that have already been counted and aggregated
            found_sum = true
            index = look_ahead_index + 1
            result_array << negative_number + sum

            break
          end
        end

        # Number to the right do not satisfy condition
        unless found_sum
          result_array << negative_number

          index += 1
          next
        end
      end

      # Return the input array if all items that could be aggregated have been,
      # and the array cannot be simplified further
      simplified_result_array = simplify_array(result_array)
      array == result_array ? array : sum_items(simplified_result_array)
    end

    # Sum all contiguous positive numbers
    # Sum all contiguous negative numbers
    # Returns an array with alternating postive and negative numbers
    def simplify_array(array)
      simpler_array = Array.new
      is_positive_number = nil

      cumulative_sum = 0
      array.each do |number|
        if is_positive_number.nil? || is_positive_number == (number >= 0)
          cumulative_sum += number
        else
          simpler_array << cumulative_sum

          cumulative_sum = number
        end

        is_positive_number = number >= 0
      end

      simpler_array << cumulative_sum
    end
  end
end
