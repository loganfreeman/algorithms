# Enter your code here. Read input from STDIN. Print output to STDOUT
t = gets.strip.to_i


t.times do
  cash = gets.to_i
  number_of_flavours = gets.to_i
  flavours = gets.chomp.strip.split(' ').map(&:to_i)

  hash = Hash[flavours.map.with_index { |e, i| [e, i] }]

  flavours.each.with_index do |e, i|
    if i2 = hash[cash - e] 
      next if i+1 == i2+1
      puts "#{i + 1} #{i2 + 1}"
      break  
    end
  end
end
