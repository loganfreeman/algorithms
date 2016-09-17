module Hacker
    def self.quicksort(array)
      return [] if array.empty? || array.nil?
      pv = array.shift
      quicksort(array.select { |e| e < pv }) + [pv] + quicksort(array.select { |e| e >= pv })
    end

    def self.insertion_sort(array)
      1.upto(array.length - 1) do |i|
        x = array[i]
          j = i - 1
          while j >= 0 && array[j] > x

              array[j+1] = array[j]

              j -= 1
          end
          array[j+1] = x
      end

      array
    end
    def self.insertionSort(array)
        1.upto(array.length - 1) do |i|
            j = i
            while j > 0 && array[j] < array[j - 1]

                # swap array[j] and array[j-1]
                temp = array[j]
                array[j] = array[j - 1]
                array[j - 1] = temp

                j -= 1
            end
        end

        array
    end
end

module Sortable
    def bubble_sort(&block)
        array = map { |x| x }
        array.each_index do |i|
            j = i + 1
            while j < array.length
                swap(i, j, array) if compare(array[i], array[j], &block) == 1
                j += 1
            end
        end
        array
    end

    def insertion_sort(&block)
        array = map { |x| x }
        h_sort(array, 1, &block)
    end

    def merge_sort(&block)
        array = map { |x| x }
        aux = Array.new(array.length)
        recursive_sort(array, aux, 0, array.length - 1, &block)
    end

    def quick_sort(&block)
        array = map { |x| x }.shuffle
        q_recursive_sort(array, 0, array.length - 1, &block)
    end

    def selection_sort(&block)
        array = map { |x| x }
        array.each_index do |i|
            min_idx = i
            j = i
            while j < array.length
                min_idx = j if compare(array[j], array[min_idx], &block) == -1
                j += 1
            end
            swap(i, min_idx, array) unless i == min_idx
        end
        array
    end

    def shell_sort(&block)
        array = map { |x| x }
        h = 1
        h = h * 3 + 1 while h < array.length / 3
        while h >= 1
            array = h_sort(array, h, &block)
            h /= 3
        end
        array
    end

    private

    def compare(a, b)
        return yield(a, b) if block_given?
        a < b ? -1 : a == b ? 0 : 1
    end

    def swap(key1, key2, array = self)
        array[key1], array[key2] = array[key2], array[key1]
        array
    end

    def h_sort(array, h, &block)
        array.each_index do |i|
            j = i
            while j > h - 1 && compare(array[j], array[j - h], &block) == -1
                swap(j, j - h, array)
                j -= h
            end
        end
        array
    end

    def recursive_sort(array, aux, lo, hi, &block)
        return if hi <= lo
        mid = lo + (hi - lo) / 2
        recursive_sort(array, aux, lo, mid, &block)
        recursive_sort(array, aux, mid + 1, hi, &block)
        merge(array, aux, lo, mid + 1, hi, &block)
    end

    def merge(part_sorted_arry, aux, lo, mid, hi, &block)
        i = lo
        while i <= hi
            aux[i] = part_sorted_arry[i]
            i += 1
        end
        i = lo
        j = mid
        k = lo
        while k <= hi
            part_sorted_arry[(k += 1) - 1] = if i >= mid
                                                 aux[(j += 1) - 1]
                                             elsif j > hi then aux[(i += 1) - 1]
                                             elsif compare(aux[j], aux[i], &block) == -1 then aux[(j += 1) - 1]
                                             else aux[(i += 1) - 1]
            end
        end
        part_sorted_arry
    end

    def q_recursive_sort(array, lo, hi, &block)
        return array if lo >= hi
        j = partition(array, lo, hi, &block)
        q_recursive_sort(array, lo, j - 1, &block)
        q_recursive_sort(array, j + 1, hi, &block)
    end

    def partition(array, lo, hi, &block)
        i = lo
        j = hi + 1
        while i < j
            while compare(array[i += 1], array[lo], &block) == -1
                break if i == hi
            end
            while compare(array[lo], array[j -= 1], &block) == -1
                break if j == lo
            end
            swap(i, j, array) unless i >= j
        end
        swap(lo, j, array)
        j
    end
end


class QuickSort

  # O(n) space complexity
  def self.sort1(array)
    return array if array.length <= 1

    pivot_idx = rand(array.length)
    array[0], array[pivot_idx] = array[pivot_idx], array[0]
    pivot = array.first

    array = array.drop(1)

    left, right = [], []

    array.each do |el|
      el <= pivot ? left << el : right << el
    end

    sort1(left) + [pivot] + sort1(right)
  end

  # In-place [ O(1) space ]
  def self.sort2!(array, start = 0, length = array.length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }
    return array if length <= 1

    pivot = self.partition(array, start, length, &prc)

    left_length = pivot - start
    right_length = length - (left_length + 1)

    self.sort2!(array, start, left_length, &prc)
    self.sort2!(array, pivot + 1, right_length, &prc)
    array
  end

  def self.partition(array, start, length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }

    pivot_idx = start + rand(length)
    array[start], array[pivot_idx] = array[pivot_idx], array[start]
    pivot = array[start]

    (start + 1).upto(start + length - 1).each do |idx|

      val = prc.call(array[idx], pivot)

      if val <= 0
        array[start + 1], array[idx] = array[idx], array[start + 1]
        array[start], array[start + 1] = array[start + 1], array[start]
        start += 1
      end
    end

    return start
  end
end
