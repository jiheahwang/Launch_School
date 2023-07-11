def countdown(number)
  if number <= 0
    puts number
  else
    puts number
    countdown(number-1)
  end
end

puts "Enter a number less than 10."
number = gets.chomp.to_i
countdown(number)