def integer_to_string(int)
  counter = 1
  digits = []
  loop do
    quotient, remainder = int.divmod(10 ** counter)
    digits.prepend(remainder / 10 **(counter-1))
    break if quotient == 0
    counter += 1
  end
  digits.join
end


p integer_to_string(4321) #= '4321'
p integer_to_string(0) #== '0'
p integer_to_string(5000) #== '5000'