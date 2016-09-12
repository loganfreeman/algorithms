class Utils
  def self.sub_arr(numbers)
    i = 0
    n = numbers.length
    results = []
    while i < n
      j = i
      while j < n
        results.push(numbers[i..j])
        j += 1
      end
      i += 1
    end
    results
  end

  def self.count(numbers, k)
    sets = sub_arr(numbers)
    sets.reject { |a| a.reduce(:*) >= k }.count
  end
end
