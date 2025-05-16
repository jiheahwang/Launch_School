class Board
  attr_reader :squares

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  CORNER_SQUARES = [1, 3, 7, 9]
  CENTER_SQUARE = 5
  TOTAL_NUMBER_OF_SQUARES = 9

  def initialize
    @squares = {}
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Layout/LineLength
  def draw
    puts "     |     |"
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}  "
    puts "    #{square_number(7)}|    #{square_number(8)}|    #{square_number(9)}"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}  "
    puts "    #{square_number(4)}|    #{square_number(5)}|    #{square_number(6)}"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}  "
    puts "    #{square_number(1)}|    #{square_number(2)}|    #{square_number(3)}"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Layout/LineLength

  def square_number(number)
    unmarked_keys.include?(number) ? number : ' '
  end

  def []=(number, marker)
    squares[number].marker = marker
  end

  def [](number)
    squares[number].marker
  end

  def unmarked_keys
    squares.select { |_, square| square.unmarked? }.keys
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  # returns winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      if line_marked?(line) && three_identical_markers?(line)
        return squares[line.first].marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| squares[key] = Square.new }
  end

  private

  def three_identical_markers?(line)
    line.map { |square_number| squares[square_number].marker }.uniq.size == 1
  end

  def line_marked?(line)
    line.all? { |square_number| squares[square_number].marked? }
  end
end

class Square
  attr_accessor :marker

  INITIAL_MARKER = " "

  def initialize
    @marker = INITIAL_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end

  private

  def to_s
    marker
  end
end

module Promptable
  private

  def joinor(array)
    case array.size
    when 0..2 then  array.join(' or ')
    else            "#{array[0..-2].join(', ')}, or #{array.last}"
    end
  end

  def obtain_valid_alphabet_input(message, input_type,
                                  valid_choices_array = nil)
    loop do
      puts message
      input = gets.chomp.delete('^A-Za-z')

      if valid_choices_array
        return input if valid_alphabet_choice?(input, valid_choices_array)
      else
        return input unless input.empty?
      end
      puts "Please enter a valid #{input_type}."
    end
  end

  def valid_alphabet_choice?(input, valid_choices_array)
    valid_choices_array.any? do |choice|
      choice == input.upcase || choice == input.downcase
    end
  end

  def obtain_valid_number_input(message, valid_choices)
    loop do
      puts message
      input = gets.chomp
      return input.to_i if valid_number?(input, valid_choices)
      puts "#{input} is not valid. Enter a valid number."
    end
  end

  def integer?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
  end

  def valid_number?(input, valid_choices)
    integer?(input) && valid_choices.include?(input.to_i)
  end

  def generate_numbered_list_string(array)
    result_string = ""
    array.each.with_index(1) do |element, number|
      result_string << "#{number}. #{element}\n"
    end
    result_string
  end

  def obtain_user_choice_from_numbered_list(prompt, choices_array)
    numbered_list = generate_numbered_list_string(choices_array)
    message = prompt + numbered_list
    valid_choice_numbers = (1..choices_array.size)
    user_choice = obtain_valid_number_input(message, valid_choice_numbers)
    choices_array[user_choice.to_i - 1]
  end

  def obtain_player_input_for_new_game_options
    display_new_game_options
    valid_choices = (1..3)
    message = "Enter a number between 1-3"
    obtain_valid_number_input(message, valid_choices)
  end

  def play_again?(message)
    input_type = "response (y/n)"
    valid_choices_array = %w(y n yes no)
    answer = obtain_valid_alphabet_input(message, input_type,
                                         valid_choices_array)
    answer.start_with?('y')
  end
end

class Player
  attr_reader :board, :name, :marker
  attr_accessor :score

  MARKERS = ["X", "O"]

  def initialize(board)
    @board = board
    @name = obtain_valid_name
    @marker = obtain_marker_choice
    @score = 0
  end

  private

  attr_writer :marker
end

class Human < Player
  include Promptable

  def mark_a_square
    unused_square_numbers = board.unmarked_keys
    message = "Choose a square (#{joinor(unused_square_numbers)}): "
    square = obtain_valid_number_input(message, unused_square_numbers)
    board[square] = marker
  end

  def reset_marker
    self.marker = obtain_marker_choice
  end

  private

  def obtain_valid_name
    message = "What's your name? (alphabets only)"
    input_type = "name"
    obtain_valid_alphabet_input(message, input_type).capitalize
  end

  def obtain_marker_choice
    valid_choices_array = MARKERS
    message = "Please choose your marker: #{joinor(valid_choices_array)}"
    input_type = "marker"
    obtain_valid_alphabet_input(message, input_type, valid_choices_array).upcase
  end

  def to_s
    name
  end
end

class Computer < Player
  def initialize(opponent, board)
    @opponent = opponent
    super(board)
  end

  def mark_a_square
    board[choose_square] = marker
  end

  private

  attr_reader :opponent, :board

  def obtain_valid_name
    self.class.to_s
  end

  def obtain_marker_choice
    MARKERS.each { |marker| return marker if marker != opponent.marker }
  end

  def to_s
    "Computer: #{name}"
  end
end

module Minimax
  private

  def evaluate_move(key, moves_remaining, computer_turn)
    board[key] = (computer_turn ? marker : opponent.marker)
    value = -negamax(moves_remaining - 1, !computer_turn)
    board[key] = Square::INITIAL_MARKER
    value
  end

  def negamax(moves_remaining, computer_turn)
    multiplier = computer_turn ? 1 : -1
    if moves_remaining == 0 || board.someone_won?
      return multiplier * heuristic_value(moves_remaining)
    end

    best_value = -Float::INFINITY

    board.unmarked_keys.each do |key|
      key_value = evaluate_move(key, moves_remaining, computer_turn)
      best_value = [best_value, key_value].max
    end

    best_value
  end

  def get_best_move(moves_remaining, computer_turn)
    best_value = -Float::INFINITY
    best_move = nil

    board.unmarked_keys.shuffle.each do |key|
      key_value = evaluate_move(key, moves_remaining, computer_turn)
      if key_value > best_value
        best_value = key_value
        best_move = key
      end
    end

    best_move
  end

  def heuristic_value(moves_remaining)
    if board.winning_marker == marker
      1 + moves_remaining
    elsif board.winning_marker == opponent.marker
      -(1 + moves_remaining)
    else
      0
    end
  end
end

# Unbeatable AI
class Expert < Computer
  include Minimax

  def choose_square
    moves_remaining = board.unmarked_keys.size
    if moves_remaining == Board::TOTAL_NUMBER_OF_SQUARES
      (Board::CORNER_SQUARES + [Board::CENTER_SQUARE]).sample
    else
      computer_turn = true
      get_best_move(moves_remaining, computer_turn)
    end
  end
end

# AI from RB110
class Enthusiast < Computer
  def choose_square
    defense_square = nil
    center_square = Board::CENTER_SQUARE if center_square_available?

    Board::WINNING_LINES.each do |line|
      mapped_line = change_square_numbers_to_markers(line)
      empty_square_number = find_empty_square_number(line)
      return empty_square_number if offense_opportunity?(mapped_line)
      defense_square = empty_square_number if defense_opportunity?(mapped_line)
    end

    defense_square || center_square || board.unmarked_keys.sample
  end

  private

  def offense_opportunity?(mapped_line)
    mapped_line == [Square::INITIAL_MARKER, marker, marker]
  end

  def defense_opportunity?(mapped_line)
    mapped_line == [Square::INITIAL_MARKER, opponent.marker, opponent.marker]
  end

  def center_square_available?
    board.squares[Board::CENTER_SQUARE].unmarked?
  end

  def find_empty_square_number(line)
    line.find { |number| board[number] == Square::INITIAL_MARKER }
  end

  def change_square_numbers_to_markers(line)
    line.map { |number| board[number] }.sort
  end
end

class Novice < Computer
  def choose_square
    board.unmarked_keys.sample
  end
end

module Displayable
  private

  def clear_screen
    system 'clear'
  end

  def pause
    sleep(0.5)
  end

  def display_intro_screen
    clear_screen
    puts <<-INTRODUCTION
    Let's play Tic Tac Toe! After this screen, you'll choose the following:

    1. your marker
    2. your opponent's skill level
    3. how many rounds you want to play and who goes first
       (after the first round, the first move will alternate between players)

    Press Enter to continue.
    INTRODUCTION

    gets
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def clear_screen_and_display_game_screen
    clear_screen
    game_title
    marker_panel
    score_panel
    board_display
  end

  def game_title
    puts <<-TITLE
***||  Let's Play TIC TAC TOE  ||***
====================================
  TITLE
  end

  def marker_panel
    puts <<-MARKER_PANEL
|MARKERS| #{human.name}: #{human.marker} | #{computer.name}: #{computer.marker}
------------------------------------
    MARKER_PANEL
  end

  def score_panel
    puts <<-SCORE_PANEL
|SCORES | #{human.name}: #{human.score} | #{computer.name}: #{computer.score}
====================================
  SCORE_PANEL
  end

  def board_display
    puts ""
    board.draw
    puts ""
  end

  def display_result
    clear_screen_and_display_game_screen

    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "#{computer} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_grand_winner(grand_winner)
    if grand_winner
      puts "#{grand_winner} is the grand winner!"
    else
      puts "No grand winner yet!"
    end
  end

  def display_next_round_countdown
    pause
    puts "Get ready for next round!"
    puts "3.."
    pause
    puts "2.."
    pause
    puts "1.."
    pause
  end

  def display_play_again_message
    puts "Let's play again!"
    2.times { pause }
  end

  def display_new_game_options
    clear_screen
    puts <<-NEW_GAME_OPTIONS
For the new game, what would you like to do?
  1. Keep the current settings
  2. Change the computer's skill level
  3. Change all settings
     (marker, computer skill, number of rounds, first player)

NEW_GAME_OPTIONS
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end
end

class TTTGame
  include Promptable
  include Displayable

  ROUND_LIMIT = 5

  def initialize
    display_intro_screen
    @board = Board.new
    @human = Human.new(board)
    @computer = choose_computer_skill_level.new(human, board)
    @number_of_rounds = choose_round_count
    @current_marker = choose_first_player.marker
  end

  def main_game
    loop do
      number_of_rounds.times do |t|
        play_one_round
        display_next_round_countdown unless t == number_of_rounds - 1
      end
      play_until_grand_winner # optional extra rounds in case of no grand winner
      break unless play_again?("Would you like to play again? (y/n)")
      display_play_again_message
      reset_game
    end
  end

  def play
    clear_screen
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private

  attr_reader :board, :human
  attr_accessor :computer, :number_of_rounds, :current_marker

  def choose_computer_skill_level
    prompt = "Please choose your opponent's skill level: (enter the number)\n"
    skill_levels = Computer.subclasses
    clear_screen
    obtain_user_choice_from_numbered_list(prompt, skill_levels)
  end

  def choose_first_player
    prompt = "Choose who will make the first move: (enter the number)\n"
    first_player_choices = [human, computer]
    clear_screen
    obtain_user_choice_from_numbered_list(prompt, first_player_choices)
  end

  def choose_round_count
    upper_limit = ROUND_LIMIT
    valid_choices = (1..upper_limit)
    message = "How many rounds would you like to play? " \
              "(enter a number between 1-#{upper_limit})"
    obtain_valid_number_input(message, valid_choices)
  end

  def determine_winner
    case board.winning_marker
    when human.marker     then human
    when computer.marker  then computer
    end
  end

  def determine_grand_winner
    if human.score > computer.score
      human
    elsif human.score < computer.score
      computer
    end
  end

  def play_until_grand_winner
    loop do
      grand_winner = determine_grand_winner
      display_grand_winner(grand_winner)
      break if grand_winner
      message = "Play more rounds until a grand winner can be determined?"
      next play_one_round if play_again?(message)
      break puts "No grand winner for this game..."
    end
  end

  def play_one_round
    board.reset
    loop do
      clear_screen_and_display_game_screen
      pause
      current_player_moves
      break if board.someone_won? || board.full?
    end
    winner = determine_winner
    winner&.score += 1
    display_result
  end

  def current_player_moves
    if human_turn?
      human.mark_a_square
      self.current_marker = computer.marker
    else
      computer.mark_a_square
      self.current_marker = human.marker
    end
  end

  def human_turn?
    current_marker == human.marker
  end

  def reset_scores
    human.score = 0
    computer.score = 0
  end

  def reset_game
    reset_scores

    player_choice = obtain_player_input_for_new_game_options
    case player_choice
    when 1 # Keeping the current settings so do nothing
    when 2 then self.computer = choose_computer_skill_level.new(human, board)
    when 3 then reset_all_settings
    end
  end

  def reset_all_settings
    human.reset_marker
    self.computer = choose_computer_skill_level.new(human, board)
    self.number_of_rounds = choose_round_count
    self.current_marker = choose_first_player.marker
  end
end

game = TTTGame.new
game.play
