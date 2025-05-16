puts "What is your name?"
name = gets.chomp

name = "Teddy" if name.empty?

ages = (20..200).to_a

puts "#{name} is #{ages.sample} years old!"

puts "#{name} is #{rand(20..200)} years old!"