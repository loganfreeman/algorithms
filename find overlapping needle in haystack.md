You are given a string . 
Your task is to find the indices of the start and end of string  in .

Input Format

The first line contains the string . 
The second line contains the string .

Constraints

 

Output Format

Print the tuple in this format: (start _index, end _index). 
If no match is found, print (-1, -1).


#### Sample Input

aaadaa
aa

#### Sample Output

(0, 1)  
(1, 2)
(4, 5)



```py
# Enter your code here. Read input from STDIN. Print output to STDOUT
haystack = raw_input()
needle  = raw_input()
import re
m = re.search(needle, haystack)

if m == None:
    print '(-1, -1)'
else:
    matches = re.finditer(r'(?=(%s))' % re.escape(needle), haystack)
    for m in matches:
        print("(%s, %s)" % (m.start(1), m.start(1) + len(needle) - 1))
```
