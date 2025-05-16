def is_odd?(integer)
  integer % 2 == 1
end

puts is_odd?(-8)

def is_odd_v2?(integer)
  integer.remainder(2) == 1 || integer.remainder(2) == -1
end

puts is_odd_v2?(-8)