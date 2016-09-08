The Combinations Calculator will find the number of possible combinations that can be obtained by taking a sub-set of items from a larger set. Basically, it shows how many different possible sub-sets can be made from the larger set. For this calculator, the order of the items chosen in the sub-set does not matter.

Combinations Formula:

Calculate the combinations for C(n,r) = n! / ( r!(n - r)! ). For 0 <= r <= n.

“n choose r” = C(n,r) = n! / ( r! (n - r)! )


```ruby
combination = -> (n) do
   -> (m) do
       (1..n).to_a.combination(m).to_a.length
   end
end
n = gets.to_i
r = gets.to_i
nCr = combination.(n)
puts nCr.(r)
```
