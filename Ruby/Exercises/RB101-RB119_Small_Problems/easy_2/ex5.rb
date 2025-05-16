puts "What is your name?"
name = gets.chomp

if name[-1] == '!'
  puts "HELLO #{name.chop.upcase}. WHY ARE WE SCREAMING?"
else
  puts "Hello #{name}"
end

# Try modifying our solution to use String#chomp! and String#chop!, respectively.
puts "What is your name?"
name = gets
name.chomp!

if name[-1] == '!'
  name.chop!
  puts "HELLO #{name.upcase}. WHY ARE WE SCREAMING?"
else
  puts "Hello #{name}"
end