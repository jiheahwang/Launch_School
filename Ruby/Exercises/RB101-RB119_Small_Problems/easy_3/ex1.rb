def get_number_into_array(array)
  array << gets.chomp.to_i
end

number_array = []

puts "==> Enter the 1st number:"
get_number_into_array(number_array)
puts "==> Enter the 2nd number:"
get_number_into_array(number_array)
puts "==> Enter the 3rd number:"
get_number_into_array(number_array)
puts "==> Enter the 4th number:"
get_number_into_array(number_array)
puts "==> Enter the 5th number:"
get_number_into_array(number_array)
puts "==> Enter the last number:"
last_number = gets.chomp.to_i

if number_array.include?(last_number)
  puts "The number #{last_number} appears in #{number_array}."
else
  puts "The number #{last_number} does not appear in #{number_array}."
end
