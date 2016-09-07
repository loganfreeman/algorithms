Amanda has a string, , of  lowercase letters that she wants to copy into a new string, . She can perform the following operations any number of times to construct string :

Append a character to the end of string  at a cost of  dollar.
Choose any substring of  and append it to the end of  at no charge.
Given  strings (i.e., ), find and print the minimum cost of copying each  to  on a new line.

```ruby
#!/bin/ruby

n = gets.strip.to_i
require 'set'


def run s 
    array = s.chars.to_a
    result = ''
    cost = 0
    while array.length > 0
        c = array.shift
        if !result.include? c
            result = result + c
            cost += 1
            next
        else
            m = c
            if array.empty?
                result = result + m 
                next
            end
            n = array[0]
            m = m + n
            while result.include? m
                c = m
                array.shift
                break if array.empty?
                m = m + array[0]
            end
            result = result + c
        end
    end
    puts cost
end

def run_efficient s 
    array = s.chars.to_a
    result = ''
    set = Set.new
    cost = 0
    while array.length > 0
        c = array.shift
        if !set.include? c
            result = result + c
            set.add(c)
            cost += 1
            next
        else
            result = result + c
        end
    end
    puts cost
end

for a0 in (0..n-1)
    s = gets.strip
    run_efficient s
end
```
