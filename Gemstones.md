John has discovered various rocks. Each rock is composed of various elements, and each element is represented by a lower-case Latin letter from 'a' to 'z'. An element can be present multiple times in a rock. An element is called a gem-element if it occurs at least once in each of the rocks.

Given the list of  rocks with their compositions, display the number of gem-elements that exist in those rocks.

### Input Format

The first line consists of an integer, , the number of rocks. 
Each of the next  lines contains a rock's composition. Each composition consists of lower-case letters of English alphabet.

### Output Format

Print the number of gem-elements that are common in these rocks. If there are none, print 0.

```ruby
# Enter your code here. Read input from STDIN. Print output to STDOUT
n = gets.chomp.to_i
result = nil
while n > 0
    n -= 1
    sentence = gets.chomp.chars.to_a.uniq
    if result.nil?
        result = sentence
    else
        result = result & sentence
    end
end
puts result.length
```
