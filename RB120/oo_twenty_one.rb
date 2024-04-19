module TwentyOneDisplay
  private

  def clear_screen
    system 'clear'
  end

  def short_pause
    sleep 0.5
  end

  def long_pause
    sleep 1
  end

  # rubocop:disable Metrics/MethodLength
  def display_intro_screen
    clear_screen
    puts <<-RULES
  Let's play #{TwentyOne::MAX_ALLOWED_VALUE}!

  Here are the rules:
  - Your goal is to try to get as close to #{TwentyOne::MAX_ALLOWED_VALUE} as possible without going over.
    If you go over #{TwentyOne::MAX_ALLOWED_VALUE}, it's a 'bust' and you lose!

  - Jack, queen, and king are each worth 10.
    Ace can be worth 1 or 11 depending on your hand total.

  - You can 'hit'(get another card) or 'stay'. You can keep hitting as
    many times as you want. Once you choose 'stay', it's dealer's turn.

  - Dealer will hit until the total is at least #{TwentyOne::DEALER_STAY_MIN}.

  - Keep playing until either you or the dealer reaches #{TwentyOne::GRAND_WINNING_SCORE} wins.

  Press Enter to play.
    RULES
    gets
  end
  # rubocop:enable Metrics/MethodLength

  def clear_screen_and_display_game_screen(dealer_card_reveal: true)
    clear_screen
    game_title
    score_panel
    cards_and_hand_total(dealer_card_reveal)
  end

  def game_title
    puts <<-TITLE
***||Welcome to the Game of #{TwentyOne::MAX_ALLOWED_VALUE}||***
===================================
  TITLE
  end

  def score_panel
    puts <<-SCORE_PANEL
|SCORES| #{player}: #{player.score}  | #{dealer}: #{dealer.score}
===================================
  SCORE_PANEL
  end

  def hand_total_display(dealer_card_reveal)
    dealer_total = dealer_card_reveal ? dealer.hand_total : "?"
    puts <<-HAND_TOTAL_DISPLAY
Dealer Cards (Current Hand Total: #{dealer_total})
#{'  '}
#{'  '}
Your Cards (Current Hand Total: #{player.hand_total})
    HAND_TOTAL_DISPLAY
  end

  def cards_and_hand_total(dealer_card_reveal)
    dealer_card_reveal ? dealer.show_hand : dealer.show_only_one_card_from_hand
    hand_total_display(dealer_card_reveal)
    player.show_hand
    puts ""
  end

  def display_result(winner)
    puts winner ? "#{winner} won!" : "It's a tie!"
  end

  def display_grand_winner(grand_winner)
    puts "#{grand_winner} is the grand winner!"
  end

  def display_next_round_prompt
    puts ""
    puts "Press Enter to continue to the next round!"
    gets
  end

  # TODO: choose one
  def display_play_again_message
    puts ""
    puts "Let's play again! Press Enter to continue."
    gets

    # puts "Let's play again!"
    # 2.times { pause }
  end

  def display_goodbye_message
    puts "Thank you for playing #{TwentyOne::MAX_ALLOWED_VALUE}. Goodbye!"
  end
end

module TwentyOnePrompt
  private

  def joinor(array)
    case array.size
    when 0..2 then  array.join(' or ')
    else            "#{array[0..-2].join(', ')}, or #{array.last}"
    end
  end

  def obtain_valid_alphabet_input(message, valid_choices_array)
    loop do
      puts message
      input = gets.chomp.delete('^A-Za-z').downcase
      return input if valid_alphabet_choice?(input, valid_choices_array)
      puts "Please enter a valid response: #{joinor(valid_choices_array)}."
    end
  end

  def valid_alphabet_choice?(input, valid_choices_array)
    valid_choices_array.any? { |choice| choice == input }
  end

  def obtain_hit_or_stay_choice
    message = "(h)it or (s)tay?"
    valid_choices_array = %w(h s hit stay)
    obtain_valid_alphabet_input(message, valid_choices_array)
  end

  def play_again?
    message = "Would you like to play again? (y/n)"
    valid_choices_array = %w(y n yes no)
    answer = obtain_valid_alphabet_input(message, valid_choices_array)
    answer.start_with?('y')
  end
end

module ParticipantHandDisplay
  def show_hand
    cards = hand
    number_of_cards = cards.size
    print_horizontal_borders(number_of_cards)
    print_card_numbers(cards, justification: 'ljust')
    puts ""
    print_card_symbols(cards)
    puts ""
    print_card_numbers(cards, justification: 'rjust')
    puts ""
    print_horizontal_borders(number_of_cards)
  end

  private

  def print_horizontal_borders(number_of_cards)
    puts "+-----+ " * number_of_cards
  end

  def print_card_numbers(cards, justification: nil)
    cards.each { |card| print "|#{card.rank.send(justification, 5)}| " }
  end

  def print_card_symbols(cards)
    cards.each { |card| print "|#{Card::SUIT_UNICODES[card.suit].center(5)}| " }
  end
end

class Card
  attr_reader :suit, :rank

  SUIT_UNICODES = {
    clubs: "\u2663",
    diamonds: "\u2666",
    hearts: "\u2665",
    spades: "\u2660"
  }
  SUITS = SUIT_UNICODES.keys
  NUMBERS = ("2".."10").to_a
  LETTERS = %w(J Q K A)
  RANKS = NUMBERS + LETTERS

  def initialize(suit, rank)
    @suit = suit # Symbol object
    @rank = rank  # String object
  end

  def number_card?
    NUMBERS.include?(rank)
  end

  def ace?
    rank == "A"
  end
end

class Deck
  attr_reader :cards

  def initialize
    @cards = new_shuffled_deck
  end

  def deal_one_card
    cards.pop
  end

  private

  def new_shuffled_deck
    deck = []
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        deck << Card.new(suit, rank)
      end
    end
    deck.shuffle
  end
end

class Participant
  include ParticipantHandDisplay
  attr_reader :hand, :hand_total, :score

  def initialize
    @name = obtain_valid_name
    @hand = []
    @hand_total = 0
    @score = 0
  end

  def reset_hand
    self.hand = []
    self.hand_total = 0
  end

  def reset_score
    self.score = 0
  end

  def increment_score
    self.score += 1
  end

  def busted?
    hand_total > TwentyOne::MAX_ALLOWED_VALUE
  end

  def add_cards_to_hand(cards_to_add)
    hand.concat(cards_to_add)
    self.hand_total = calculate_hand_total
  end

  private

  attr_reader :name
  attr_writer :hand, :hand_total, :score

  def calculate_hand_total
    aces, non_aces = hand.partition(&:ace?)
    total = non_aces.sum do |card|
      card.number_card? ? card.rank.to_i : 10
    end

    aces.size.times do
      total += 11
      total -= 10 if total > 21
    end

    total
  end

  def to_s
    name
  end
end

class Player < Participant
  private

  def obtain_valid_name
    loop do
      puts "What's your name? (alphabets only)"
      input = gets.chomp.delete('^A-Za-z')
      return input.capitalize unless input.empty?
      puts "Please enter a valid name."
    end
  end
end

class Dealer < Participant
  def show_only_one_card_from_hand
    first_card = hand[0]
    puts "+-----+ +-----+"
    print "|#{first_card.rank.ljust(5)}| |     |"
    puts ""
    print "|#{Card::SUIT_UNICODES[first_card.suit].center(5)}| |  ?  |"
    puts ""
    print "|#{first_card.rank.rjust(5)}| |     |"
    puts ""
    puts "+-----+ +-----+"
  end

  private

  def obtain_valid_name
    self.class.to_s
  end
end

class TwentyOne
  include TwentyOneDisplay
  include TwentyOnePrompt

  DEALER_STAY_MIN = 17
  MAX_ALLOWED_VALUE = 21
  GRAND_WINNING_SCORE = 5

  def initialize
    display_intro_screen
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def play
    loop do
      play_until_grand_winner
      break unless play_again?
      display_play_again_message
      reset_deck_and_participant_hands
      reset_scores
    end
    display_goodbye_message
  end

  private

  attr_reader :player, :dealer
  attr_accessor :deck

  def play_until_grand_winner
    loop do
      play_one_round
      grand_winner = determine_grand_winner
      break display_grand_winner(grand_winner) if grand_winner
      reset_deck_and_participant_hands
      display_next_round_prompt
    end
  end

  def play_one_round
    deal_initial_cards
    play_player_turn
    play_dealer_turn unless player.busted?
    winner = determine_round_winner
    winner&.increment_score
    clear_screen_and_display_game_screen
    long_pause
    display_result(winner)
    long_pause
  end

  def deal_initial_cards
    deal_cards_and_add_to_hand(player, 2)
    deal_cards_and_add_to_hand(dealer, 2)
  end

  def deal_cards_and_add_to_hand(participant, number_of_cards)
    cards_dealt = []
    number_of_cards.times { cards_dealt << deck.deal_one_card }
    participant.add_cards_to_hand(cards_dealt)
  end

  def play_player_turn
    loop do
      clear_screen_and_display_game_screen(dealer_card_reveal: false)
      short_pause

      if player.busted?
        puts "You busted!"
        long_pause
        break
      elsif player.hand_total == MAX_ALLOWED_VALUE
        puts "Your hand total is at max value #{MAX_ALLOWED_VALUE}!"
        break
      elsif obtain_hit_or_stay_choice.start_with?('s')
        puts "You chose to stay!"
        break
      else
        puts "You chose to hit!"
        long_pause
        deal_cards_and_add_to_hand(player, 1)
      end
    end
  end

  def play_dealer_turn
    long_pause
    puts "Dealer's turn now!"

    loop do
      clear_screen_and_display_game_screen

      if dealer.busted?
        puts "Dealer busted!"
        break
      elsif dealer.hand_total >= DEALER_STAY_MIN
        puts "Dealer stays at #{dealer.hand_total}!"
        break
      else
        puts "Dealer hits!"
        long_pause
        deal_cards_and_add_to_hand(dealer, 1)
      end
    end
  end

  def determine_round_winner
    return dealer if player.busted?
    return player if dealer.busted?

    if dealer.hand_total > player.hand_total
      dealer
    elsif player.hand_total > dealer.hand_total
      player
    end
  end

  def determine_grand_winner
    if player.score == GRAND_WINNING_SCORE
      player
    elsif dealer.score == GRAND_WINNING_SCORE
      dealer
    end
  end

  def reset_deck_and_participant_hands
    self.deck = Deck.new
    player.reset_hand
    dealer.reset_hand
  end

  def reset_scores
    player.reset_score
    dealer.reset_score
  end
end

game = TwentyOne.new
game.play
