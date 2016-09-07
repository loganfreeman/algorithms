Sid is obsessed with reading short stories. Being a CS student, he is doing some interesting frequency analysis with the books. He chooses strings  and  in such a way that .

Your task is to help him find the minimum number of characters of the first string he needs to change to enable him to make it an anagram of the second string.

Note: A word x is an anagram of another word y if we can produce y by rearranging the letters of x.

```ruby
# Enter your code here. Read input from STDIN. Print output to STDOUT
n = gets.strip.to_i
strings = []
while n > 0
    strings.push(gets.strip)
    n -= 1
end
def anagram s
    l = s.length
    if l % 2 == 1
        puts -1
        return 
    end
    m = l / 2
    pairs = [s[0..m-1], s[m..l-1]]
    frequency = Hash.new
    array = pairs[0].chars.to_a 
    while !array.empty?
        c = array.shift
        if frequency.key? c 
            frequency[c] += 1
        else
            frequency[c] = 1
        end
    end

    array = pairs[1].chars.to_a
    while !array.empty?
        c = array.shift
        if frequency.key?(c) && frequency[c] > 0
            frequency[c] -= 1
        end
    end
    result = frequency.values.inject(0) do |sum, f| 
        sum + f.abs
    end
    puts result
end

strings.each { |s| anagram s }
```
