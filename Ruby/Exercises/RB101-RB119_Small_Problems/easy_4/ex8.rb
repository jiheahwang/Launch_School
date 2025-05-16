# In the previous exercise, you developed a method that converts simple numeric strings to Integers. In this exercise, you're going to extend that method to work with signed numbers.

# Write a method that takes a String of digits, and returns the appropriate number as an integer. The String may have a leading + or - sign; if the first character is a +, your method should return a positive number; if it is a -, your method should return a negative number. If no sign is given, you should return a positive number.

# You may assume the string will always contain a valid number.

# You may not use any of the standard conversion methods available in Ruby, such as String#to_i, Integer(), etc. You may, however, use the string_to_integer method from the previous lesson.

STRING_DIGITS = ("0".."9").to_a

def string_to_integer(string)
  integer_digits = string.chars.map do |char|
    STRING_DIGITS.index(char)
  end
  
  integer_digits.reverse.each_with_index.sum do |digit, index|
    digit * (10 ** index)
  end
end

def string_to_signed_integer(string)
  integer = string_to_integer(string.delete('+-'))
  string[0] == '-' ? -integer : integer
end

p string_to_signed_integer('4321') == 4321
p string_to_signed_integer('-570') == -570
p string_to_signed_integer('+100') == 100
