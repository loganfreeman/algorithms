Sandy likes palindromes. A palindrome is a word, phrase, number, or other sequence of characters which reads the same backward as it does forward. For example, madam is a palindrome.

On her  birthday, Sandy's uncle, Richie Rich, offered her an -digit check which she refused because the number was not a palindrome. Richie then challenged Sandy to make the number palindromic by changing no more than  digits. Sandy can only change  digit at a time, and cannot add digits to (or remove digits from) the number.

Given  and an -digit number, help Sandy determine the largest possible number she can make by changing  digits.

Note: Treat the integers as numeric strings. Leading zeros are permitted and can't be ignored (So 0011 is not a palindrome, 0110 is a valid palindrome). A digit can be modified more than once.

Input Format

The first line contains two space-separated integers,  (the number of digits in the number) and  (the maximum number of digits that can be altered), respectively. 
The second line contains an -digit string of numbers that Sandy must attempt to make palindromic.


```ruby
#!/bin/ruby

n,k = gets.strip.split(' ')

n = n.to_i
k = k.to_i
number = gets.strip

result = []

def is_palindrome? s, index 
    median = (s.length/2).round
    is_palindrome = true
    length = s.length
    while index <= median
        if (s[index] != s[length-index-1])
            is_palindrome = false
            break
        end
        index += 1
    end
    is_palindrome
end

def convert s, k, n, index, result=[]
    median = (n/2).round
    if k == 0 
        result.push(s) if is_palindrome?(s, index) # add to result array if the remaining satisfies rule of palindrome
    elsif (index) >= (n-index-1)
        result.push(s)
        if k > 0 && (n-index-1) == index
            array = s.chars.to_a
            array[index] = '9'
            result.push(array.join(''))
        end

    else
        
        array = s.chars.to_a.map(&:to_i)
        if array[index] == array[n-index-1]
            # case 3:no mutation
            convert(s, k, n, index+1, result)
        else
            array[index] = array[n-index-1] = [array[index], array[n-index-1]].max
            # case 1: one mutation
            convert(array.join(''), k-1, n, index+1, result)
        end

        
        if array[index] != 9 && k > 1
            array = s.chars.to_a 
            array[index] = array[n-index-1] = 9
            # case 2: two mutation
            convert(array.join(''), k-2, n, index+1, result)
        end 



    end
    
end

convert(number, k, number.length, 0, result)

if result.empty?
    puts -1
else
    puts result.max
end


```


non recursive version
```ruby
#!/bin/ruby

n,k = gets.strip.split(' ')

n = n.to_i
k = k.to_i
number = gets.strip

result = []

def is_palindrome? s, index 
    median = (s.length/2).round
    is_palindrome = true
    length = s.length
    while index <= (length-index-1)
        if (s[index] != s[length-index-1])
            is_palindrome = false
            break
        end
        index += 1
    end
    is_palindrome
end

def mutation_needed s
    median = (s.length/2).round
    length = s.length
    mutations = 0
    index = 0
    while index <= (length-index-1)
        if (s[index] != s[length-index-1])
            mutations += 1
        end
        index += 1
    end
    mutations
end


mutations = mutation_needed number
median = (n/2).round
if mutations > k
    puts -1
else
    array = number.chars.to_a.map(&:to_i)
    index = 0
    while k > mutations && (index <= (n-index-1))
        array[index] = array[n-index-1] = '9'
        k -= 1
        index += 1
    end
    while mutations > 0 && (index <= (n-index-1))
        if array[index] == array[n-index-1]
            index += 1
            next
        end
        array[index] = array[n-index-1] = [array[index], array[n-index-1]].max
        mutations -= 1
        index += 1
        
    end
    
    puts array.join('')
end
```
