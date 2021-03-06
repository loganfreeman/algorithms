module Hacker

  def self.median(array)
    sorted = array.sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end
  
  # Return the sum of the values.
  def self.sum(values)
    values.inject(0){|x,y| x+=y}
  end

  # Return first subset of values that sum to want, using the meet in the
  # middle algorithm (O(n * 2^(n/2)).
  def self.subset_sum(values, want, max_seconds=nil)
    raise(TypeError, "values must be an array of Integers") unless values.is_a?(Array)
    raise(TypeError, "want must be an Integer") unless want.is_a?(Integer)

    # Optimization by removing 0 values and doing some simple checks
    values = values.reject{|x| x == 0}
    values.each{|value| return [value] if value == want}
    return values if sum(values) == want
    pos, neg = values.partition{|x| x > 0}
    sp, sn = sum(pos), sum(neg)
    return pos if sp == want
    return neg if sn == want

    # Use the C version if it exists and all values will be inside the machine
    # limits
    return _subset_sum(values, want, max_seconds.to_i) if \
      respond_to?(:_subset_sum, true) and want.is_a?(Fixnum) and \
      sum(pos).is_a?(Fixnum) and sum(neg).is_a?(Fixnum) and \
      max_seconds.to_i.is_a?(Fixnum)

    # The pure ruby version
    sums = {}
    start_time = Time.now if max_seconds
    l = values.length/2
    subsets(values[0...l]) do |subset|
      raise(TimeoutError, "timeout expired") if max_seconds and Time.now - start_time > max_seconds
      sums[sum(subset)] = subset
    end
    subsets(values[l..-1]) do |subset|
      raise(TimeoutError, "timeout expired") if max_seconds and Time.now - start_time > max_seconds
      if subset2 = sums[want - sum(subset)]
        return subset2 + subset
      end
    end
    nil
  end

  # Yield all subsets of the array to the block.
  def self.subsets(array, skip = 0, &block)
    yield(array)
    (array.length-1).downto(skip){|i| subsets(array[0...i] + array[i+1..-1], i, &block)}
  end
  
  
  def self.comp_set(array, subset)
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

  def self.find_subset(input_array)
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

  def self.track(array, p, i, j, set = [])


      begin
          if !p[i][j-1]
              sum = i - array[j-1]
              set.push(j-1)
              track(array, p, sum, j-1, set) if i >= array[j-1]
          else
              track(array, p, i, j-1, set) if j > 1

          end

      rescue => exception
          puts "***#{i} #{j-1}****"
          raise exception
      end
      set
  end
  
  def self.can_subset_sum(array, sum)
      rows = sum + 1
      n = array.length
      pre = Array.new(rows)
      (1..rows).each { |i| pre[i - 1] = false }
      pre[0] = true
      (1..n).each do |j|
          current = Array.new(rows)
          current[0] = true
          (1..sum).each do |i|
              current[i] = pre[i]
              current[i] = pre[i] || pre[i - array[j - 1]] if i - array[j - 1] >= 0
          end
          pre = current
      end
      pre
  end
  
  def self.find_partition(array)
      n = array.length
      if n <= 1
          return [false, nil]
      end
      k = array.reduce(:+)
      if k % 2 == 1
          return [false, nil]
      end
      rows = k/2 + 1
      p = Array.new(rows) { Array.new(n+1)}

      (1..n+1).each { |i| p[0][i-1] = true }
      (1..rows).each { |i| p[i-1][0] = false }
      p[0][0] = true
      (1..(k/2)).each do |i|
          (1..n).each do |j|
              p[i][j] = p[i][j-1]
              p[i][j] = p[i][j-1] || p[i - array[j-1]][j-1] if i - array[j-1] >= 0
          end

      end
      subset = track(array, p, (k/2), n)
      can_partition = p[(k/2)][n]
      parts = []
      if can_partition
          left = []
          right = []
          parts.push(left)
          parts.push(right)
          array.each_with_index do |item, index|
              if subset.include? index
                  left.push(item)
              else
                  right.push(item)
              end
          end
      end
      [can_partition , parts]
  end

  def self.max_partition(array)
      can_partition , parts = find_partition(array)
      if can_partition
          1 + [max_partition(parts[0]), max_partition(parts[1])].max
      else
          0
      end
  end

  def self.find_partition_efficient(array)
      n = array.length
      if n <= 1
          return false
      end
      k = array.reduce(:+)
      if k % 2 == 1
          return false
      end
      rows = k/2 + 1
      pre = Array.new(rows)
      (1..rows).each { |i| pre[i-1] = false }
      pre[0] = true
      (1..n).each do |j|
          current = Array.new(rows)
          (1..(k/2)).each do |i|
              current[i] = pre[i]
              if i - array[j-1] >= 0
                  current[i] = pre[i] || pre[i - array[j-1]]
              end
          end
          pre = current

      end
      pre[(k/2)]

  end
  
    def self.max_partition_efficient(array)
        n = array.length
        array = array.reject { |i| i == 0 }
        return n - 1 if array.empty?
        total = array.reduce(:+)
        return 0 if total.odd?
        pre = can_subset_sum(array, total /= 2)
        count = 0
        while pre[total]
            count += 1
            total /= 2
            break if total.odd?
        end
        count
    end

end
