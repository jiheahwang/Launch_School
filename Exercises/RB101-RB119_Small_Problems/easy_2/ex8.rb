def get_integer
  loop do
    puts ">> Please enter an integer greater than 0:"
    integer = gets.chomp.to_i
    return integer if integer > 0
    puts "Invalid input."
  end
end

def get_operator
  loop do
    puts ">> Enter 's' to compute the sum, 'p' to compute the product."
    operation = gets.chomp.downcase
    return operation if operation == 's' || operation == 'p'
    puts "Invalid input."
  end
end

integer = get_integer
operation = get_operator

number_range = (1..integer)
sum = number_range.inject(:+)
product = number_range.inject(:*)

if operation == 's'
  puts "The sum of the integers between 1 and #{integer} is #{sum}."
elsif operation == 'p'
  puts "The product of the integers between 1 and #{integer} is #{product}."
end