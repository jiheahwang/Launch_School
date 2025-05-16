(1..99).each {|number| puts number if number.odd?}

a = []
1.upto(99) {|number| a << number}
index = 0
while index < 99
  puts a[index]
  index += 2
end