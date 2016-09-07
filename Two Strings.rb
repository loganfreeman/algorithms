# Enter your code here. Read input from STDIN. Print output to STDOUT

n = gets.strip.to_i
pairs = []
while n > 0
    pairs.push([gets.strip, gets.strip])
    n -= 1
end

require 'set'



def find_longest_common_substring(s1, s2)
    if (s1 == "" || s2 == "")
        return ""
    end
    m = Array.new(s1.length){ [0] * s2.length }
    longest_length, longest_end_pos = 0,0
    (0 .. s1.length - 1).each do |x|
        (0 .. s2.length - 1).each do |y|
            if s1[x] == s2[y]
                m[x][y] = 1
                if (x > 0 && y > 0)
                    m[x][y] += m[x-1][y-1]
                end
                if m[x][y] > longest_length
                    longest_length = m[x][y]
                    longest_end_pos = x
                end
            end
        end
    end
    if longest_length == 0
        puts 'NO'
    else
        puts 'YES'
    end
end

def has_common_substring(s1, s2)
    set = s1.chars.to_a.to_set
    array = s2.chars.to_a 
    short_cut = false
    while !array.empty?
        c = array.shift
        if set.include?(c)
            puts 'YES'
            short_cut = true
            break
        end
    end
    puts "NO" unless short_cut
end


pairs.each do |pair|
    has_common_substring(pair[0], pair[1])
end
