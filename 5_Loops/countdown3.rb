puts "Enter a number less than 10"
x = gets.chomp.to_i

for i in 1..x do
  puts x - i
end

puts "Done!"