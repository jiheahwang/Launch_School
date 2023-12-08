# In the previous two exercises, you developed methods that convert simple numeric strings to signed Integers. In this exercise and the next, you're going to reverse those methods.

# Write a method that takes a positive integer or zero, and converts it to a string representation.

# You may not use any of the standard conversion methods available in Ruby, such as Integer#to_s, String(), Kernel#format, etc. Your method should do this the old-fashioned way and construct the string by analyzing and manipulating the number.

STRING_DIGITS = ("0".."9").to_a

# def integer_to_string(int)
#   counter = 1
#   digits = []
#   loop do
#     quotient, remainder = int.divmod(10 ** counter)
#     digits.prepend(remainder / 10 **(counter-1))
#     break if quotient == 0
#     counter += 1
#   end
#   digits.join
# end

# def integer_to_string(integer)
#   integer.digits.reverse.map { |digit| STRING_DIGITS[digit] }.join
# end

def integer_to_string(integer)
  integer.digits.each_with_object('') do |digit, obj|
    obj.prepend(STRING_DIGITS[digit])
  end
end

p integer_to_string(4321) == '4321'
p integer_to_string(0) == '0'
p integer_to_string(5000) == '5000'