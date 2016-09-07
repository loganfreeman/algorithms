James found a love letter his friend Harry has written for his girlfriend. James is a prankster, so he decides to meddle with the letter. He changes all the words in the letter into palindromes.

To do this, he follows two rules:

He can reduce the value of a letter, e.g. he can change d to c, but he cannot change c to d.
In order to form a palindrome, if he has to repeatedly reduce the value of a letter, he can do it until the letter becomes a. Once a letter has been changed to a, it can no longer be changed.
Each reduction in the value of any letter is counted as a single operation. Find the minimum number of operations required to convert a given string into a palindrome.
```ruby
# Enter your code here. Read input from STDIN. Print output to STDOUT
n = gets.strip.to_i
strings = []
while n > 0
    strings.push(gets.strip)
    n -= 1
end
def fix_palindrome s 
    array = s.chars.to_a
    n = array.length
    index = 0
    count = 0
    while index < (n - index - 1)
        if array[index] != array[n-index-1]
            count += (array[index].ord - array[n-index-1].ord).abs
        end
        index += 1
    end
    puts count

end
strings.each do |s|
    fix_palindrome s
end
```
