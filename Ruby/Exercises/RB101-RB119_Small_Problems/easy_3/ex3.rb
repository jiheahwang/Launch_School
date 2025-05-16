puts "Please write word or multiple words:"
user_input = gets.chomp
characters_without_spaces = user_input.split(' ').join # or user_input.delete(' ')
character_count = characters_without_spaces.length

puts "There are #{character_count} characters in \"#{user_input}\"."