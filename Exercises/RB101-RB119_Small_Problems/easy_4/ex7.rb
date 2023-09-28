DIGITS = ('0'..'9').to_a

def string_to_integer(numeric_string)
  number = 0
  digits_array = numeric_string.chars.reverse
  digits_array.each_with_index do |num_str, idx|
    number += DIGITS.index(num_str) * (10 ** idx)
  end
  number
end


p string_to_integer('4321') #== 4321
p string_to_integer('570') #== 570