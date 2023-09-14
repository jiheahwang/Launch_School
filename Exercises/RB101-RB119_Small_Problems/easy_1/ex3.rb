def stringy(integer, first_number = 1)
  string = ''
  if first_number == 1
    integer.times do |i|
      string << '1' if i.even?
      string << '0' if i.odd?
    end
  elsif first_number == 0
    integer.times do |i|
      string << '0' if i.even?
      string << '1' if i.odd?
    end
  end
  string
end

puts stringy(6) == '101010'
puts stringy(9) == '101010101'
puts stringy(4) == '1010'
puts stringy(7) == '1010101'
puts stringy(7, 0) == '0101010'