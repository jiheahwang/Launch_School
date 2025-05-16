puts "==> Enter the first number:"
first_number = gets.chomp.to_i
puts "==> Enter the second number:"
second_number = gets.chomp.to_i

numbers = [first_number, second_number]
operators = [:+, :-, :*, :/, :%, :**]

operators.each do |operator|
  puts "==> #{numbers[0]} #{operator} #{numbers[1]} = #{numbers.reduce(operator)}"
end