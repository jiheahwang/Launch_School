# If you take a number like 735291, and rotate it to the left, you get 352917. If you now keep the first digit fixed in place, and rotate the remaining digits, you get 329175. Keep the first 2 digits fixed in place and rotate again to 321759. Keep the first 3 digits fixed in place and rotate again to get 321597. Finally, keep the first 4 digits fixed in place and rotate the final 2 digits to get 321579. The resulting number is called the maximum rotation of the original number.

# Write a method that takes an integer as argument, and returns the maximum rotation of that argument. You can (and probably should) use the rotate_rightmost_digits method from the previous exercise.

# Note that you do not have to handle multiple 0s.

# def rotate_array(array)
#   (array.size-1).downto(0).map { |index| array[-index] }
# end

# def rotate_rightmost_digits(number, digit_to_rotate)
#   digits_array = number.digits.reverse
#   rotated_digits = rotate_array(digits_array.slice!(-digit_to_rotate..-1))
#   (digits_array + rotated_digits).join.to_i
# end

# def max_rotation(integer)
#   number_of_digits = integer.digits.size
#   number_of_digits.downto(1) do |digit_to_rotate|
#     integer = rotate_rightmost_digits(integer, digit_to_rotate)
#   end
#   integer
# end

def max_rotation(integer)
  digits_array = integer.digits.reverse
  digits_array.each_index do |index|
    digits_array << digits_array.delete_at(index)
  end.join.to_i
end

p max_rotation(735291) == 321579
p max_rotation(3) == 3
p max_rotation(35) == 53
p max_rotation(105) == 15 # the leading zero gets dropped
p max_rotation(8_703_529_146) == 7_321_609_845
