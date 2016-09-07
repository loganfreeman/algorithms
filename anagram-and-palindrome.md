Dothraki are planning an attack to usurp King Robert's throne. King Robert learns of this conspiracy from Raven and plans to lock the single door through which the enemy can enter his kingdom.

door

But, to lock the door he needs a key that is an anagram of a certain palindrome string.

The king has a string composed of lowercase English letters. Help him figure out whether any anagram of the string can be a palindrome or not.

```ruby
# Enter your code here. Read input from STDIN. Print output to STDOUT

string = gets.chomp 

found = 0
# Assign found a value of 1 or 0 depending on whether or not you found what you were looking for.
require 'set'

array = string.chars.to_a

hash = Hash.new 

set = Set.new

while !array.empty?
    c = array.shift 
    if set.include?(c)
        set.delete(c)
    else
        set.add(c)
    end
end

found = set.size <= 1



if found
    puts "YES"
else
    puts "NO"
end
```
