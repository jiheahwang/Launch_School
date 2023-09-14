number_of_lines = nil

loop do
  loop do
    puts '>> How many output lines do you want? Enter a number >= 3 (Q to quit):'
    number_of_lines = gets.chomp
    break if number_of_lines.to_i >= 3 || number_of_lines.downcase == "q"
    puts ">> That's not enough lines."
  end
  
  break if number_of_lines.downcase == "q"
   
  number = number_of_lines.to_i
  
  while number > 0
    puts 'Launch School is the best!'
    number -= 1
  end
end