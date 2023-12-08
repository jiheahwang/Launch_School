# In the previous exercise, you developed a method that converts non-negative numbers to strings. In this exercise, you're going to extend that method by adding the ability to represent negative numbers as well.

# Write a method that takes an integer, and converts it to a string representation.

# You may not use any of the standard conversion methods available in Ruby, such as Integer#to_s, String(), Kernel#format, etc. You may, however, use integer_to_string from the previous exercise.

STRING_DIGITS = ("0".."9").to_a

# def integer_to_string(integer)
#   integer.digits.reverse.map { |digit| STRING_DIGITS[digit] }.join
# end

def integer_to_string(integer)
  integer.digits.each_with_object('') do |digit, obj|
    obj.prepend(STRING_DIGITS[digit])
  end
end

def signed_integer_to_string(integer)
  string_numbers = integer_to_string(integer.abs)
  return string_numbers if integer == 0
  integer < 0 ? "-#{string_numbers}" : "+#{string_numbers}"
end

p signed_integer_to_string(4321) == '+4321'
p signed_integer_to_string(-123) == '-123'
p signed_integer_to_string(0) == '0'