# Enter your code here. Read input from STDIN. Print output to STDOUT
def Fibonacci(t1, t2, n)
    results = Array.new(n+1)
    results[0] = t1
    results[1] = t2
    i = 2
    while i < n
        results[i] = results[i-2] + results[i-1]**2
        i += 1
    end
    results[n-1]
end


def get_input 
    t1, t2, n = gets.strip.split(' ').map(&:to_i)
    [t1, t2, n]
end

t1, t2, n = get_input
puts Fibonacci(t1, t2, n)
