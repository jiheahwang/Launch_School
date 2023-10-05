SUITS = {
  clubs: { unicode: "\u2663" },
  diamonds: { unicode: "\u2666" },
  hearts: { unicode: "\u2665" },
  spades: { unicode: "\u2660" }
}

NUMBER_CARDS = ("2".."10").to_a
LETTER_CARDS = {
  "J" => { value: 10 },
  "Q" => { value: 10 },
  "K" => { value: 10 },
  "A" => { value: 11, alternate_value: 1 }
}

DEALER_STAY_MIN = 17
MAX_ALLOWED_VALUE = 21

PLAYER_CHOICES = {
  hit_or_stay: { 1 => "Hit", 2 => "Stay" },
  play_again: { 1 => true, 2 => false }
}

GRAND_WINNING_SCORE = 5

# display related
def prompt(message)
  puts "=> #{message}"
end

def screen_clear
  system 'clear'
end

def display_game_explanation
  screen_clear
  puts <<-RULES
Let's play #{MAX_ALLOWED_VALUE}!

Here are the rules:
- Your goal is to try to get as close to #{MAX_ALLOWED_VALUE} as possible without going over.
  If you go over #{MAX_ALLOWED_VALUE}, it's a 'bust' and you lose!

- Jack, queen, and king are each worth 10.
  Ace can be worth 1 or 11 depending on your hand total.

- You can 'hit'(get another card) or 'stay'. You can keep hitting as
  many times as you want. Once you choose 'stay', it's dealer's turn.

- Dealer will hit until the total is at least #{DEALER_STAY_MIN}.

- Keep playing until either you or the dealer reaches #{GRAND_WINNING_SCORE} wins.

Press Enter to play.
  RULES
  gets
end

def display_game_screen(player, dealer)
  if player_turn_ended?(player)
    display_cards(dealer[:cards])
  else
    display_only_one_dealer_card(dealer[:cards][0])
  end

  dealer_total = player_turn_ended?(player) ? dealer[:total] : "?"

  puts <<-STATUS_DISPLAY
Dealer Cards (Current Hand Total: #{dealer_total})
# of Wins: #{dealer[:score]}


# of Wins: #{player[:score]}
Your Cards (Current Hand Total: #{player[:total]})
  STATUS_DISPLAY
  display_cards(player[:cards])
  puts ""
end

def display_only_one_dealer_card(card)
  puts "+-----+ +-----+"
  print "|#{card[:rank].ljust(5)}| |     |"
  puts ""
  print "|#{SUITS[card[:suit]][:unicode].center(5)}| |  ?  |"
  puts ""
  print "|#{card[:rank].rjust(5)}| |     |"
  puts ""
  puts "+-----+ +-----+"
end

# rubocop:disable Metrics/AbcSize
def display_cards(cards)
  puts "+-----+ " * cards.size
  cards.each { |card| print "|#{card[:rank].ljust(5)}| " }
  puts ""
  cards.each { |card| print "|#{SUITS[card[:suit]][:unicode].center(5)}| " }
  puts ""
  cards.each { |card| print "|#{card[:rank].rjust(5)}| " }
  puts ""
  puts "+-----+ " * cards.size
end
# rubocop:enable Metrics/AbcSize

def display_result_message(winner)
  case winner
  when "Player" then prompt "You win!"
  when "Dealer" then prompt "Dealer wins!"
  when nil      then prompt "It's a tie!"
  end
end

def display_winning_message(grand_winner)
  winner_phrase = grand_winner == "Player" ? "You are" : "Dealer is"
  prompt "#{winner_phrase} the grand winner!"
  puts ""
end

def display_next_round_prompt
  puts ""
  prompt "Press Enter to continue to the next round!"
  gets
end

def display_goodbye_message
  prompt "Thank you for playing #{MAX_ALLOWED_VALUE}. Goodbye!"
end

# getting user input
def get_valid_player_choice(question_category)
  loop do
    player_choice = gets.chomp
    if valid_input?(player_choice)
      return PLAYER_CHOICES[question_category][player_choice.to_i]
    end
    prompt "Sorry, invalid answer. Please choose 1 or 2."
  end
end

def hit_or_stay_choice
  puts <<-HIT_OR_STAY
=> Hit or Stay? (Enter 1 or 2)
   1. Hit
   2. Stay
    HIT_OR_STAY

  get_valid_player_choice(:hit_or_stay)
end

# checks returning booleans
def valid_input?(input)
  input == input.to_i.to_s && (1..2).include?(input.to_i)
end

def busted?(total)
  total > MAX_ALLOWED_VALUE
end

def player_turn_ended?(player)
  player[:busted] || player[:stay]
end

def play_again?
  puts <<-ASK_PLAY_AGAIN
=> Play Again? (Enter 1 or 2)
   1. Yes
   2. No
  ASK_PLAY_AGAIN

  get_valid_player_choice(:play_again)
end

def grand_winner?(player_score, dealer_score)
  !!detect_grand_winner(player_score, dealer_score)
end

# winning, scores, and calculations
def calculate_hand_total(cards)
  card_ranks = cards.map { |card| card[:rank] }
  total_value = (card_ranks.map do |card|
    ("2".."10").include?(card) ? card.to_i : LETTER_CARDS[card][:value]
  end.sum)

  card_ranks.count("A").times do
    if total_value > 21
      total_value -= LETTER_CARDS["A"][:value]
      total_value += LETTER_CARDS["A"][:alternate_value]
    end
  end

  total_value
end

def update_total!(person)
  person[:total] = calculate_hand_total(person[:cards])
end

def update_score!(winner, player, dealer)
  player[:score] += 1 if winner == "Player"
  dealer[:score] += 1 if winner == "Dealer"
end

def detect_round_winner(player_total, dealer_total)
  return "Dealer" if busted?(player_total)
  return "Player" if busted?(dealer_total)

  if dealer_total > player_total
    "Dealer"
  elsif player_total > dealer_total
    "Player"
  end
end

def detect_grand_winner(player_score, dealer_score)
  if player_score == GRAND_WINNING_SCORE
    return "Player"
  elsif dealer_score == GRAND_WINNING_SCORE
    return "Dealer"
  end
  nil
end

# gameplay - initializing and dealing
def initialize_deck
  cards = SUITS.keys.product(NUMBER_CARDS + LETTER_CARDS.keys).shuffle
  cards.map { |suit, rank| { suit: suit, rank: rank } }
end

def setup_beginning(deck, player, dealer)
  player[:cards] = []
  player[:total] = 0
  player[:stay] = false
  player[:busted] = false
  dealer[:cards] = []
  dealer[:total] = 0
  dealer[:busted] = false
  deal_cards!(deck, player[:cards], 2)
  deal_cards!(deck, dealer[:cards], 2)
  update_total!(player)
  update_total!(dealer)
end

def deal_cards!(deck, cards, number_of_cards_to_deal)
  number_of_cards_to_deal.times do
    cards << deck.pop
  end
end

# gameplay - performing actions according to game state
def perform_after_bust_actions(person)
  person[:busted] = true
  prompt(person[:name] == "Player" ? "You busted!" : "Dealer busted!")
  sleep 1
end

def perform_after_hit_actions(deck, person)
  prompt(person[:name] == "Player" ? "You chose to hit!" : "Dealer hits!")
  sleep 1
  deal_cards!(deck, person[:cards], 1)
  update_total!(person)
end

def perform_after_player_stay_actions(player)
  if player[:total] == MAX_ALLOWED_VALUE
    prompt "Your hand total is at max value #{MAX_ALLOWED_VALUE}!"
  else
    prompt "You chose to stay!"
  end
  player[:stay] = true
  sleep 1
  prompt "Dealer's turn now!"
end

def perform_end_of_round_actions(player, dealer)
  winner = detect_round_winner(player[:total], dealer[:total])
  update_score!(winner, player, dealer)
  screen_clear
  display_game_screen(player, dealer)
  display_result_message(winner)
  sleep 1
end

# gameplay - turns
def play_player_turn(deck, player, dealer)
  loop do
    screen_clear
    display_game_screen(player, dealer)
    sleep 0.5

    if busted?(player[:total])
      perform_after_bust_actions(player)
      break
    elsif player[:total] == MAX_ALLOWED_VALUE || hit_or_stay_choice == "Stay"
      perform_after_player_stay_actions(player)
      break
    else
      perform_after_hit_actions(deck, player)
    end
  end
end

def play_dealer_turn(deck, player, dealer)
  loop do
    screen_clear
    display_game_screen(player, dealer)
    sleep 1

    if busted?(dealer[:total])
      perform_after_bust_actions(dealer)
      break
    elsif dealer[:total] >= DEALER_STAY_MIN
      prompt "Dealer stays at #{dealer[:total]}!"
      sleep 1
      break
    else
      perform_after_hit_actions(deck, dealer)
    end
  end
end

# main
display_game_explanation

loop do
  player = { name: "Player", score: 0 }
  dealer = { name: "Dealer", score: 0 }

  loop do
    deck = initialize_deck
    setup_beginning(deck, player, dealer)

    play_player_turn(deck, player, dealer)
    play_dealer_turn(deck, player, dealer) unless player[:busted]
    perform_end_of_round_actions(player, dealer)

    if grand_winner?(player[:score], dealer[:score])
      grand_winner = detect_grand_winner(player[:score], dealer[:score])
      break display_winning_message(grand_winner)
    end

    display_next_round_prompt
  end

  break unless play_again?
end

display_goodbye_message
