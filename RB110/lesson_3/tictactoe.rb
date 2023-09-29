WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]]              # diagonals

GRAND_WINNING_SCORE = 3

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

CENTER_SQUARE = 5

FIRST_MOVE_CHOICE = {
  "1" => "Player",
  "2" => "Computer",
  "3" => ["Player", "Computer"]
}

# display related
def prompt(message)
  puts "=> #{message}"
end

def screen_clear
  Gem.win_platform? ? (system 'cls') : (system 'clear')
end

def display_game_explanation
  screen_clear
  puts <<-HEREDOC
  Let's play Tic Tac Toe!

  Here are the rules:
  - Match will continue until either you or computer reaches 3 wins.
  - You will also get to choose who goes first for the first game.
    After the first game, the first move will alternate between players.

  Press Enter to continue and choose who goes first.
  HEREDOC

  gets
end

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
def display_board(board, score)
  screen_clear
  puts "MARKERS - You : 'X',  Computer: 'O'"
  puts "SCORE   - You :  #{score['Player']} ,  Computer : #{score['Computer']}"
  puts ""
  puts "     |     |"
  puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}  "
  puts "    #{square_number(board, 7)}|    #{square_number(board, 8)}|    #{square_number(board, 9)}"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}  "
  puts "    #{square_number(board, 4)}|    #{square_number(board, 5)}|    #{square_number(board, 6)}"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}  "
  puts "    #{square_number(board, 1)}|    #{square_number(board, 2)}|    #{square_number(board, 3)}"
  puts ""
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

def display_winning_message(grand_winner)
  winner_phrase = grand_winner == "Player" ? "You are" : "Computer is"
  prompt "#{winner_phrase} the grand winner!"
end

def display_next_round_countdown
  puts ""
  prompt "Get ready for next round!"
  prompt "3.."
  sleep 0.5
  prompt "2.."
  sleep 0.5
  prompt "1.."
  sleep 0.5
end

def joinor(array, punctuation = ', ', word = 'or')
  case array.size
  when 0 then ""
  when 1 then (array[0]).to_s
  when 2 then array.join(" #{word} ")
  else array[0..-2].join(punctuation) + punctuation + word + " #{array[-1]}"
  end
end

# getting user input
def determine_first_player
  screen_clear

  puts <<-HEREDOC
  Choose one (enter 1, 2, or 3)

  1. I will make the first move.
  2. Computer can make the first move.
  3. Randomly choose who gets to go first.
  HEREDOC

  choice = ""

  loop do
    choice = gets.chomp
    break if FIRST_MOVE_CHOICE.keys.include?(choice)
    puts "Please input a valid choice (enter 1, 2, or 3)."
  end

  choice == "3" ? FIRST_MOVE_CHOICE[choice].sample : FIRST_MOVE_CHOICE[choice]
end

def get_player_marker_choice(board)
  loop do
    prompt "Choose a square (#{joinor(empty_squares(board))}):"
    square = gets.chomp
    return square.to_i if valid_input?(square, board)
    prompt "Sorry, that's not a valid choice."
  end
end

# board and squares
def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(board)
  board.keys.select { |num| board[num] == INITIAL_MARKER }
end

def square_number(board, number)
  board[number] == INITIAL_MARKER ? number : ' '
end

def detect_square_to_win(board, marker)
  WINNING_LINES.map do |line|
    if line.map { |num| board[num] }.count(marker) == 2
      line.find { |num| board[num] == INITIAL_MARKER }
    end
  end.compact.sample
end

# scores and winning
def update_score!(winner, score)
  score[winner] += 1
end

def detect_winner(board)
  WINNING_LINES.each do |line|
    if (line.map { |num| board[num] }).all?(PLAYER_MARKER)
      return 'Player'
    elsif (line.map { |num| board[num] }).all?(COMPUTER_MARKER)
      return 'Computer'
    end
  end
  nil
end

def detect_grand_winner(score)
  if score['Player'] == GRAND_WINNING_SCORE
    return "Player"
  elsif score['Computer'] == GRAND_WINNING_SCORE
    return "Computer"
  end
  nil
end

# checks returning booleans
def valid_input?(input, board)
  input == input.to_i.to_s && empty_squares(board).include?(input.to_i)
end

def board_full?(board)
  empty_squares(board).empty?
end

def someone_won?(board)
  !!detect_winner(board)
end

def grand_winner?(score)
  !!detect_grand_winner(score)
end

def play_again?
  loop do
    prompt "Do you want to play again? (y)es or (n)o"
    answer = gets.chomp
    if ['y', 'yes'].include?(answer.downcase)
      return true
    elsif ['n', 'no'].include?(answer.downcase)
      return false
    else
      prompt "Please answer yes or no"
    end
  end
end

# play actions and related
def player_places_piece!(board)
  square = get_player_marker_choice(board)
  board[square] = PLAYER_MARKER
end

def computer_places_piece!(board)
  square = detect_square_to_win(board, COMPUTER_MARKER)

  if !square
    square = detect_square_to_win(board, PLAYER_MARKER)
  end

  if !square
    square = empty_squares(board).include?(CENTER_SQUARE) ? CENTER_SQUARE : empty_squares(board).sample
  end

  board[square] = COMPUTER_MARKER
end

def place_piece!(board, current_player)
  if current_player == "Player"
    player_places_piece!(board)
  else
    computer_places_piece!(board)
  end
end

def alternate_player(current_player)
  current_player == "Player" ? "Computer" : "Player"
end

def fill_board_until_winner(board, score, current_player)
  loop do
    display_board(board, score)
    sleep 0.5
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end
end

def play_one_round(board, score, current_player)
  fill_board_until_winner(board, score, current_player)

  display_board(board, score)

  if someone_won?(board)
    winner = detect_winner(board)
    update_score!(winner, score)
    display_board(board, score)
    prompt "#{winner} won!"
  else
    prompt "It's a tie!"
  end
end

# main
display_game_explanation

loop do
  score = { "Player" => 0, "Computer" => 0 }
  first_move_player = determine_first_player

  loop do
    board = initialize_board
    play_one_round(board, score, first_move_player)
    first_move_player = alternate_player(first_move_player)

    if grand_winner?(score)
      grand_winner = detect_grand_winner(score)
      break display_winning_message(grand_winner)
    end

    display_next_round_countdown
  end

  break unless play_again?
end

prompt "Thank you for playing Tic Tac Toe. Goodbye!"
