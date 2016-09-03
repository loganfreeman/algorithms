Alice has a binary string, , of length . She thinks a binary string is beautiful if and only if it doesn't contain the substring .

In one step, Alice can change a  to a  (or vice-versa). Count and print the minimum number of steps needed to make Alice see the string as beautiful.

### Input Format

The first line contains an integer,  (the length of binary string ). 
The second line contains a single binary string, , of length .


### Output Format

Print the minimum number of steps needed to make the string beautiful.


### solution

```ruby
#!/bin/ruby

n = gets.strip.to_i
B = gets.strip
i = 0
step = 0
while i < n 
    if B[i..i+2] == '010'
        step += 1
        i += 3
    else
       i += 1 
    end
end
puts step
```
