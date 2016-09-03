Suppose you have a String, , of length  that is indexed from  to . You also have some String, , that is the reverse of String .  is funny if the condition  is true for every character  from  to .

Note: For some String ,  denotes the ASCII value of the  -indexed character in . The absolute value of an integer, , is written as .

### Input Format

The first line contains an integer,  (the number of test cases). 
Each line  of the  subsequent lines contain a string, .

### Output 

For each String  (where ), print whether it is  or  on a new line.

```ruby
# Enter your code here. Read input from STDIN. Print output to STDOUT
n = gets.chomp.to_i
while n > 0 
    sentence = gets.chomp.chars.to_a
    n -= 1
    reverse = sentence.reverse
    funny = true
    length = sentence.length - 1
    
    while length > 0
        if (sentence[length-1].ord - sentence[length].ord).abs != (reverse[length-1].ord - reverse[length].ord).abs
            funny = false
            break
        end
        length -= 1
    end
    if funny
        puts 'Funny'
    else
        puts 'Not Funny'
    end
end
```
