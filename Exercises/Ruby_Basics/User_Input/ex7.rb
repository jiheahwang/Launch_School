USERNAME = "user"
PASSWORD = "password"

loop do
  puts ">> Please enter your username:"
  a_username = gets.chomp
  puts ">> Please enter your password:"
  a_password = gets.chomp
  
  break puts "Welcome!" if a_username == USERNAME && a_password == PASSWORD
  puts ">> Authorization failed!"
end