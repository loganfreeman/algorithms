Given a string, , of lowercase letters, determine the index of the character whose removal will make  a palindrome. If  is already a palindrome or no such character exists, then print . There will always be a valid solution, and any correct answer is acceptable. For example, if  "bcbc", we can either remove 'b' at index  or 'c' at index .


```ruby
# Enter your code here. Read input from STDIN. Print output to STDOUT
n = gets.strip.to_i
strings = []
while n > 0
    strings.push(gets.strip)
    n -= 1
end
def palindrome? s
    array = s.chars.to_a 
    n = array.length
    index = 0
    while index < (n - index - 1)
        if array[index] != array[n-index-1]
            break
        else
            index += 1
        end
    end
    if index >= (n - index - 1)
        true
    else
        false
    end
end

def fix_palindrome s 
    array = s.chars.to_a 
    n = array.length
    index = 0
    while index < (n - index - 1)
        if array[index] != array[n-index-1]
            break
        else
            index += 1
        end
    end
    if index >= (n - index - 1)
        puts -1
    else
        
        array.delete_at (index)
        if palindrome? array.join('')
            puts index
        else
            puts (n-index-1)
        end
    end
end
strings.each do |s|
    fix_palindrome s
end
```
