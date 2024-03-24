class Move
  include Comparable
  attr_reader :name

  WIN_AGAINST = {
    'rock' => ['scissors', 'lizard'],
    'paper' => ['spock', 'rock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['spock', 'paper'],
    'spock' => ['scissors', 'rock']
  }

  NAMES = WIN_AGAINST.keys

  def initialize(name)
    @name = name
  end

  def self.random
    NAMES.sample
  end

  def self.valid?(input)
    NAMES.one? { |name| name.start_with?(input) }
  end

  def self.convert_full_name(input)
    NAMES.find { |name| name.start_with?(input) }
  end

  def self.valid_user_choice
    loop do
      puts "Choose one: #{NAMES.join(', ')} (r, p, sc, l, or sp)"
      choice = gets.chomp.strip.downcase
      next puts "Please type sc for scissors or sp for spock." if choice == 's'
      return convert_full_name(choice) if valid?(choice)
      puts "Sorry, invalid choice."
    end
  end

  private

  attr_writer :name

  def <=>(other_move)
    if WIN_AGAINST[name].include?(other_move.name)
      1
    elsif name == other_move.name
      0
    else
      -1
    end
  end

  def to_s
    name
  end
end

class Score
  include Comparable
  attr_reader :value

  def initialize
    @value = 0
  end

  def increment
    self.value += 1
  end

  def reset
    self.value = 0
  end

  private

  attr_writer :value

  def <=>(other_score)
    value <=> other_score.value
  end

  def to_s
    value.to_s
  end
end

class Player
  attr_reader :name, :move, :score

  def initialize
    @name = valid_name
    @move = nil
    @score = Score.new
  end

  def choose_move
    self.move = Move.new(valid_move_choice)
  end

  private

  attr_writer :move
end

class Human < Player
  private

  def valid_move_choice
    Move.valid_user_choice
  end

  def valid_name
    Display.clear_screen
    max_character_count = Table::COLUMN_WIDTH
    loop do
      puts "What's your name? (max #{max_character_count} characters)"
      name = gets.chomp.delete('^A-Za-z').capitalize
      return name unless name.empty? || name.size > max_character_count
      puts "Please enter a valid name (only alphabets accepted)."
    end
  end
end

class Computer < Player
  def initialize(opponent, history)
    super()
    @opponent = opponent
    @history = history
  end

  private

  attr_reader :opponent, :history

  def valid_name
    self.class.to_s
  end

  def opponent_move_history
    history.current_game[opponent.name]
  end
end

# Randomizer just picks any move randomly
class Randomizer < Computer
  def valid_move_choice
    Move.random
  end
end

# Dwight picks paper most of the time
# until he detects that you've made many anti-paper moves
class Dwight < Computer
  private

  def valid_move_choice
    anti_paper_move_count = opponent_move_history.count do |move|
      %w(scissors lizard).include?(move)
    end

    if anti_paper_move_count >= 3
      %w(rock paper).sample
    else
      rand(3) == 0 ? Move.random : 'paper'
    end
  end
end

# Copycat copies your last move until it ties or loses 2 consecutive times;
# if so, it picks a random move for its next move then goes back to copying
class Copycat < Computer
  private

  def valid_move_choice
    return Move.random if opponent_move_history.empty?
    if lost_twice_consecutively? || tied_twice_consecutively?
      Move.random
    else
      opponent_move_history.last
    end
  end

  def winner_last_two_rounds?(player_name)
    last_two_winners = history.current_game['Winner'].last(2)
    last_two_winners.size == 2 && last_two_winners.all?(player_name)
  end

  def lost_twice_consecutively?
    winner_last_two_rounds?(opponent.name)
  end

  def tied_twice_consecutively?
    winner_last_two_rounds?(nil)
  end
end

# Analyzer looks at your past moves to see if you have any
# tendencies to pick certain moves and picks a move based on that
class Analyzer < Computer
  private

  def valid_move_choice
    return Move.random if opponent_move_history.empty?

    Move::WIN_AGAINST.max_by do |_winning_move, losing_moves_array|
      losing_moves_array.sum { |move| opponent_move_history.count(move) }
    end.first
  end
end

# Sauron sees your current move and will beat you
# unless you make the move that debilitates him that round
class Sauron < Computer
  private

  def valid_move_choice
    debilitating_move = Move.random
    opponent_move = opponent.move.name
    losing_move = Move::WIN_AGAINST[debilitating_move].sample
    winning_move = Move::WIN_AGAINST.each do |beating_move, losing_moves_array|
      break beating_move if losing_moves_array.include?(opponent_move)
    end

    opponent_move == debilitating_move ? losing_move : winning_move
  end
end

module Table
  COLUMN_WIDTH = 12
  NUMBER_OF_COLUMNS = 4
  TABLE_WIDTH = (COLUMN_WIDTH + 1) * NUMBER_OF_COLUMNS
  HEADER_BORDER = "#{('-' * (TABLE_WIDTH + 1))}\n"
  TABLE_BORDER = "#{('=' * (TABLE_WIDTH + 1))}\n"

  def generate_header(game_result_hash, game_number)
    game_number_cell = "|#{"Game #{game_number}".center(COLUMN_WIDTH)}|"
    players_and_winner_cells = game_result_hash.keys.map do |header|
      "#{header.center(COLUMN_WIDTH)}|"
    end.join
    "#{game_number_cell}#{players_and_winner_cells}\n"
  end

  def generate_row(round_number, game_result_hash)
    round_cell = "|#{"Round #{round_number}".center(COLUMN_WIDTH)}|"
    index = round_number - 1
    result_cells = game_result_hash.values.map do |result_array|
      result = result_array[index].nil? ? "-" : result_array[index]
      "#{result.center(COLUMN_WIDTH)}|"
    end.join
    "#{round_cell}#{result_cells}\n"
  end

  def generate_one_table(game_result_hash, game_number, row_size = 'full')
    header = generate_header(game_result_hash, game_number)
    in_game_message = " (Displaying the results of last #{row_size} rounds)\n"
    header.prepend(in_game_message) if row_size != 'full'
    rows = []
    number_of_rounds = game_result_hash["Winner"].size
    1.upto(number_of_rounds) do |round_number|
      rows << generate_row(round_number, game_result_hash)
    end
    rows = (row_size == 'full' ? rows.join : rows.last(row_size).join)
    header + HEADER_BORDER + rows + TABLE_BORDER
  end

  def generate_full_table
    results.map.with_index(1) do |game_result_hash, game_number|
      generate_one_table(game_result_hash, game_number)
    end.join
  end
end

class Display
  include Table

  ROUND_RESULTS_DISPLAY_LIMIT = 3

  def initialize(human, computer, history)
    @human = human
    @computer = computer
    @history = history
  end

  def self.clear_screen
    system 'clear'
  end

  def self.pause
    sleep(0.6)
  end

  def reset(computer)
    self.computer = computer
  end

  def upper_panels
    Display.clear_screen
    title_and_rules
    history_panel if history.first_round_completed?
    score_panel
  end

  def moves
    puts "#{human.name} chose #{human.move}."
    Display.pause
    puts "#{computer.name} chose #{computer.move}."
    Display.pause
  end

  def winner
    winner_name = history.current_round_winner
    puts winner_name ? "#{winner_name} won!" : "It's a tie!"
    Display.pause
  end

  def grand_winner
    winner_name = history.current_game_grand_winner
    if winner_name
      puts "#{winner_name} is the grand winner!"
    else
      puts "No grand winner yet!"
    end
  end

  def goodbye
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
  end

  private

  attr_reader :human, :history
  attr_accessor :computer

  def title_and_rules
    puts <<-TITLE_AND_RULES
*||Welcome to Rock, Paper, Scissors, Lizard, Spock||*
=====================================================
| RULES |  Key:  'Winning Move'  >  'Losing Moves'  |
-----------------------------------------------------
| rock > scissors, lizard  | lizard > spock, paper  |
| paper > spock, rock      | spock > scissors, rock |
| scissors > paper, lizard |                        |
=====================================================
  TITLE_AND_RULES
  end

  def score_panel
    puts <<-SCORE_PANEL
| **SCORE** |  #{human.name} : #{human.score}   |  #{computer.name} : #{computer.score}
=====================================================
  SCORE_PANEL
  end

  def history_panel
    puts generate_one_table(history.current_game, history.results.size,
                            ROUND_RESULTS_DISPLAY_LIMIT)
  end
end

class History
  include Table

  attr_reader :results, :grand_winners

  def initialize
    # in the results array, each element is a hash that represents a game
    # inside each hash, there are 3 key-value pairs:
    # 2 of the keys are the player names and the 3rd is 'Winner'
    # each value is an array:
    # for the players, each element represents their moves each round
    # for the 'Winner' key, each element is the winner of each round
    @results = [new_game_hash]
    @grand_winners = []
  end

  def add_new_game
    results << new_game_hash
  end

  def add_round_results(human, computer, winner)
    current_game[human.name] << human.move.name
    current_game[computer.name] << computer.move.name
    current_game["Winner"] << winner&.name
  end

  def update_grand_winner(winner)
    grand_winners[current_game_index] = winner&.name
  end

  def current_game_grand_winner
    grand_winners[current_game_index]
  end

  def current_game
    results.last
  end

  def current_game_index
    results.size - 1
  end

  def current_round_winner
    current_game["Winner"].last
  end

  def first_round_completed?
    current_game.size == 3 # checks if all three keys exist in the hash
  end

  private

  def new_game_hash
    Hash.new { |hash, key| hash[key] = [] }
  end

  def to_s
    Display.clear_screen
    generate_full_table
  end
end

class RPSGame
  ROUND_LIMIT = 15

  def initialize
    @history = History.new
    @human = Human.new
    @computer = choose_computer_personality.new(human, history)
    @number_of_rounds = choose_round_count
    @display = Display.new(human, computer, history)
  end

  def play
    loop do # main game loop
      number_of_rounds.times { play_one_round }
      play_until_grand_winner # optional extra rounds in case of no grand winner
      show_game_history
      play_again?("Would you like to play another game?") ? reset_game : break
    end
    display.goodbye
  end

  private

  attr_reader :human, :history, :display
  attr_accessor :number_of_rounds, :computer

  def show_game_history
    puts "Press Enter to view the history of all the games played so far."
    gets
    puts history
  end

  def choose_computer_personality
    Display.clear_screen
    prompt = "Please choose your opponent: (enter the number)\n"
    personalities_choice_string = ""

    personalities = Computer.subclasses
    personalities.each.with_index(1) do |personality, number|
      personalities_choice_string << "#{number}. #{personality}\n"
    end

    message = prompt + personalities_choice_string
    user_choice = get_valid_number_input(message, personalities.size)
    personalities[user_choice.to_i - 1]
  end

  def determine_grand_winner
    if human.score > computer.score
      human
    elsif human.score < computer.score
      computer
    end
  end

  def reset_game
    human.score.reset
    history.add_new_game
    self.number_of_rounds = choose_round_count
    self.computer = choose_computer_personality.new(human, history)
    display.reset(computer)
  end

  def integer?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
  end

  def valid_number?(input, upper_limit)
    integer?(input) && (1..upper_limit).include?(input.to_i)
  end

  def get_valid_number_input(message, upper_limit)
    loop do
      puts message
      input = gets.chomp
      return input.to_i if valid_number?(input, upper_limit)
      Display.clear_screen
      puts "#{input} is not valid. Enter a valid number (1-#{upper_limit})"
    end
  end

  def choose_round_count
    upper_limit = ROUND_LIMIT
    message = "How many rounds would you like to play? " \
              "(enter a number between 1-#{upper_limit})"
    get_valid_number_input(message, upper_limit)
  end

  def play_until_grand_winner
    loop do
      grand_winner = determine_grand_winner
      history.update_grand_winner(grand_winner)
      display.grand_winner
      break if grand_winner
      message = "Play more rounds until a grand winner can be determined?"
      next play_one_round if play_again?(message)
      break puts "No grand winner for this game..."
    end
  end

  def play_player_turn(player)
    display.upper_panels
    player.choose_move
  end

  def play_one_round
    play_player_turn(human)
    play_player_turn(computer)
    display.upper_panels
    display.moves
    winner = determine_winner
    winner&.score&.increment
    history.add_round_results(human, computer, winner)
    display.upper_panels
    display.winner
  end

  def determine_winner
    if human.move > computer.move
      human
    elsif human.move < computer.move
      computer
    end
  end

  def play_again?(message)
    loop do
      puts "#{message} (y/n)"
      answer = gets.chomp.strip.downcase[0]
      return answer == 'y' if ['y', 'n'].include?(answer)
      puts "Sorry, please enter yes or no (y/n)"
    end
  end
end

RPSGame.new.play
