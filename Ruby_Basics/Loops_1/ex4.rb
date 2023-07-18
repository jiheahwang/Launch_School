loop do
  puts 'Should I stop looping?'
  answer = gets.chomp
  break if answer == "yes"
  puts 'Answer "yes" if you want the loop to stop.'
end