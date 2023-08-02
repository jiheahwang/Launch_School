VALID_CHOICES = %w(rock paper scissors lizard spock)

WINNING_CHOICE = {
  "rock" => ["scissors", "lizard"],
  "paper" => ["rock", "spock"],
  "scissors" => ["paper", "lizard"],
  "lizard" => ["paper", "spock"],
  "spock" => ["scissors", "rock"]
}

def prompt(message)
  Kernel.puts("=> #{message}")
end

def valid_input?(input)
  VALID_CHOICES.any? { |i| i.start_with?(input.downcase) }
end

def get_choice
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}.
    (you can type r, p, sc, l, or sp)")
    input = Kernel.gets().chomp()
    if input == 's'
      prompt("Please type sc for scissors or sp for spock.")
    elsif valid_input?(input)
      break input
    else
      prompt("That's not a valid choice.")
    end
  end
end

def user_choice_full_word(input)
  VALID_CHOICES[VALID_CHOICES.index { |i| i.start_with?(input.downcase) }]
end

def win?(first, second)
  WINNING_CHOICE[first].include?(second)
end

def display_results(player, computer)
  if win?(player, computer)
    prompt("You won!")
  elsif win?(computer, player)
    prompt("Computer won!")
  else
    prompt("It's a tie!")
  end
end

def play_again?
  loop do
    prompt("Do you want to play again?")
    answer = Kernel.gets().chomp()
    if answer.downcase().start_with?('y')
      break true
    elsif answer.downcase().start_with?('n')
      break false
    else
      prompt("Please answer yes or no")
    end
  end
end

prompt("Let's play rock, paper, scissors, lizard, spock!
Match will continue until either you or computer reaches 3 wins.")

loop do
  choice = ''
  user_score = 0
  computer_score = 0

  loop do
    choice = get_choice # gets user choice (incomplete word possible)
    choice = user_choice_full_word(choice) # turns user input into full word
    computer_choice = VALID_CHOICES.sample

    prompt("You chose: #{choice}, Computer chose: #{computer_choice}")

    display_results(choice, computer_choice)

    if win?(choice, computer_choice)
      user_score += 1
    elsif win?(computer_choice, choice)
      computer_score += 1
    end

    prompt("Current score - you: #{user_score}, computer: #{computer_score}")

    if user_score == 3
      break prompt("You are the grand winner!")
    elsif computer_score == 3
      break prompt("Computer is the grand winner!")
    end
  end

  break unless play_again?
end

prompt("Thank you for playing. Goodbye!")
