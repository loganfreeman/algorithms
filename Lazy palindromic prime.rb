
# Enter your code here. Read input from STDIN. Print output to STDOUT
require 'prime'
n = gets.strip.to_i

def palindrome?(string)
  if string.length == 1 || string.length == 0
    true
  else
    if string[0] == string[-1]
      palindrome?(string[1..-2])
    else
      false
    end
  end
end

palindromie_prime_array = -> (size) do
    series = Prime.lazy.each
    count = 0
    result = []
    while count < size
        p = series.next
        if palindrome?(p.to_s)
            result.push(p)
            count += 1
        end
    end
    return result
end



puts palindromie_prime_array.(n).to_s
