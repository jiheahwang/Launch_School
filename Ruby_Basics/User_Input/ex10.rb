def valid_number?(number_string)
  number_string.to_i.to_s == number_string && number_string.to_i != 0
end

def get_integer
  loop do
    puts ">> Please enter a positive or negative integer:"
    integer = gets.chomp
    break integer.to_i if valid_number?(integer)
    puts ">> Invalid input. Only non-zero integers are allowed."
  end
end

integer1 = nil
integer2 = nil

loop do
  integer1 = get_integer
  integer2 = get_integer
  break if (integer1 < 0 || integer2 < 0) && (integer1 > 0 || integer2 > 0)
  puts ">> Sorry. One integer must be positive, one must be negative. \n" \
       ">> Please start over."
end

puts "#{integer1} + #{integer2} = #{integer1 + integer2}"