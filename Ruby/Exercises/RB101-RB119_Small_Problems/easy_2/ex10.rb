def negative(number)
  if number > 0
    -number
  elsif number <= 0
    number
  end
end

p negative(5) == -5
p negative(-3) == -3
p negative(0) == 0