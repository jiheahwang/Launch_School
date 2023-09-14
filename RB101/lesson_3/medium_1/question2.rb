# The result of the following statement will be an error:

# puts "the value of 40 + 2 is " + (40 + 2)

# Why is this and what are two possible ways to fix this?
  #(40+2) hasn't been converted into a string.

puts "the value of 40 + 2 is " + "#{40 + 2}"
puts "the value of 40 + 2 is " + (40 + 2).to_s