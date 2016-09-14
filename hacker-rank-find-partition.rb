module Hacker


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
    (1..rows).each { |i| pre[i-1] = false }
    pre[0] = true
    (1..n).each do |j|
        current = Array.new(rows)
        (1..sum).each do |i|
            current[i] = pre[i]
            if i - array[j-1] >= 0
                current[i] = pre[i] || pre[i - array[j-1]]
            end
        end
        pre = current

    end
    pre[sum]
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
    total = array.reduce(:+)
    if total % 2 == 1
      return 0
    end
    can = can_subset_sum(array, total = total / 2)
    count = 0
    while can
      count += 1
      if total % 2 == 0
        can = can_subset_sum(array, total = total / 2)
      else
        can = false
      end
    end
    count
  end

end
