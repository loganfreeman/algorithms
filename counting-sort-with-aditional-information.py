from collections import defaultdict
n = int(raw_input().strip()) 
limit, count = n/2, defaultdict(list)

# Sort the input
[count[x[0]].append(x[1]) if i >= limit else count[x[0]].append('-') for i, x in enumerate([raw_input().strip().split() for _ in xrange(n)])]

# Print it out
print ' '.join([' '.join(count[str(a)]) for a in xrange(100) if count[str(a)] !=[]])
