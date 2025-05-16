puts "Type something. If you want to stop, type 'STOP.'"
x = gets.chomp
while x != "STOP"
  puts "#{x.upcase}!!"
  puts "Type something. If you want to stop, type 'STOP.'"
  x = gets.chomp
end