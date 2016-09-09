# Enter your code here. Read input from STDIN. Print output to STDOUT
from __future__ import print_function
import re
import sys
n = int(raw_input())
def transform(m):
    if m.group(0) == '&&':
        return 'and'
    if m.group(0) == '||':
        return 'or'
    
for line in sys.stdin:
   print(re.sub(r"((?<= )&&(?= )|(?<= )\|\|(?= ))", transform, line), end='')
