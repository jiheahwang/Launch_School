MOVES = {
  'rock' => { abbreviation: 'r', beats: ['scissors', 'lizard'] },
  'paper' => { abbreviation: 'p', beats: ['spock', 'rock'] },
  'scissors' => { abbreviation: 'sc', beats: ['paper', 'lizard'] },
  'lizard' => { abbreviation: 'l', beats: ['spock', 'paper'] },
  'spock' => { abbreviation: 'sp', beats: ['scissors', 'rock'] }
}

GRAND_WINNING_SCORE = 3

def screen_clear
  Gem.win_platform? ? (system 'cls') : (system 'clear')
end

def prompt(message)
  Kernel.puts("=> #{message}")
end

def display_game_explanation
  prompt("Let's play rock, paper, scissors, lizard, spock!
  Match will continue until either you or computer reaches 3 wins.")
end

def valid_input?(input)
  if MOVES.include?(input) || MOVES.any? do |_key, value|
       value[:abbreviation] == input
     end
    true
  else
    false
  end
end

def get_choice
  loop do
    prompt("Choose one: #{MOVES.keys.join(', ')}.
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
  if input.length <= 2
    MOVES.each do |key, value|
      if value[:abbreviation] == input
        break key
      end
    end
  else
    input
  end
end

def display_choice_confirmation(player, computer)
  prompt("You chose: #{player}, Computer chose: #{computer}")
end

def win?(first, second)
  MOVES[first][:beats].include?(second)
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

def update_score(player, computer, score)
  if win?(player, computer)
    score[:user] += 1
  elsif win?(computer, player)
    score[:computer] += 1
  end

  score
end

def display_current_score(score)
  prompt("Current score - you: #{score[:user]}, computer: #{score[:computer]}")
end

def grand_winning_score?(score)
  score.value?(GRAND_WINNING_SCORE)
end

def display_winning_message(score)
  if score[:user] == GRAND_WINNING_SCORE
    prompt("You are the grand winner!")
  elsif score[:computer] == GRAND_WINNING_SCORE
    prompt("Computer is the grand winner!")
  end
end

def play_until_grand_winner(score)
  loop do
    choice = get_choice
    choice = user_choice_full_word(choice)
    computer_choice = MOVES.keys.sample

    display_choice_confirmation(choice, computer_choice)

    display_results(choice, computer_choice)

    score = update_score(choice, computer_choice, score)

    display_current_score(score)

    if grand_winning_score?(score)
      break display_winning_message(score)
    end
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

screen_clear

display_game_explanation

loop do
  current_score = { user: 0, computer: 0 }

  play_until_grand_winner(current_score)

  break unless play_again?

  screen_clear

  prompt("Let's play again!")
end

prompt("Thank you for playing. Goodbye!")
