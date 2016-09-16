A Decent Number has the following properties:

Its digits can only be 3's and/or 5's.
The number of 3's it contains is divisible by 5.
The number of 5's it contains is divisible by 3.
If there are more than one such number, we pick the largest one.


```ruby
#!/bin/ruby
def check(n)
    fives = (n/3).floor
    times = fives.downto(1).find do |i| 
        remaining = n - (i*3)
        remaining % 5 == 0
    end
    
    if times.nil?
        if n % 5 == 0
            puts '3' * n
        else
            puts -1
        end   
        
    else
        
        remaining = n - 3 * times
        if remaining % 5 == 0
            puts '5' *(3 * times) + '3' * remaining
        else
            puts -1
        end
    end
    

end

t = gets.strip.to_i
for a0 in (0..t-1)
    n = gets.strip.to_i
    check(n)
end
```
