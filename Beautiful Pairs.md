You are given two arrays,  and , both containing  integers.

A pair of indices  is beautiful if the  element of array  is equal to the  element of array . In other words, pair  is beautiful if and only if .

Given  and , there are  pairs of beautiful indices . A pair of indices in this set is pairwise disjoint if and only if for each  it holds that  and .

Change exactly  element in  so that the resulting number of pairwise disjoint beautiful pairs is maximal, and print this maximal number to stdout.


```ruby
# Enter your code here. Read input from STDIN. Print output to STDOUT
n = gets.strip.to_i
a = gets.strip.split(' ').map(&:to_i)
b = gets.strip.split(' ').map(&:to_i)
hasha = Hash.new { |h, k| h[k]  = 0}
hashb = Hash.new { |h, k| h[k]  = 0}
a.each do |c| 
    hasha[c] += 1
end

b.each do |c| 
    hashb[c] += 1
end
count = 0
need_add = false
hasha.each do |k,v|
    other = hashb[k]
    shared = [v, other].min
    count += shared
    hashb[k] -= shared
    hasha[k] -= shared
    need_add = true if hashb[k] > 0 || hasha[k] > 0
end

if !need_add 
    puts n - 1
else
    count += 1 if count < n 
    puts count
end
```
