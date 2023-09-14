PASSWORD = "password"

loop do
  puts ">> Please enter your password:"
  answer = gets.chomp
  break puts "Welcome!" if answer == PASSWORD
  puts ">> Invalid password"
end