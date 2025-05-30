import os       # for screen clearing
import time     # for sleep
import random

# typing
from typing import TypedDict

Board = dict[str, str]

class GameState(TypedDict):
    player_marker: str
    computer_marker: str
    first_move_marker: str
    current_marker: str
    numpad_mode: bool
    minimax_mode: bool
    current_round: int
    total_rounds: int
    player_score: int
    computer_score: int

# constants
WINNING_LINES = (
    ("1", "2", "3"), ("4", "5", "6"), ("7", "8", "9"),  # rows
    ("1", "4", "7"), ("2", "5", "8"), ("3", "6", "9"),  # columns
    ("1", "5", "9"), ("3", "5", "7")                   # diagonals
)

CORNER_SQUARES = ("1", "3", "7", "9")
CENTER_SQUARE = "5"
TOTAL_NUMBER_OF_SQUARES = 9

INITIAL_MARKER = " "
MARKERS = ("x", "o")
ROUND_LIMIT = 5

PLAYER = 'player'
COMPUTER = 'computer'

NEGAMAX_MIN = -1000 # arbitrarily chosen initial value

# constants for game state dict keys
PLAYER_MARKER = 'player_marker'
COMPUTER_MARKER = 'computer_marker'
MINIMAX_MODE = 'minimax_mode'
PLAYER_SCORE = 'player_score'
COMPUTER_SCORE = 'computer_score'
CURRENT_ROUND = 'current_round'
TOTAL_ROUNDS = 'total_rounds'
FIRST_MOVE_MARKER = 'first_move_marker'
CURRENT_MARKER = 'current_marker'
NUMPAD_MODE = 'numpad_mode'

# display related functions
def clear_screen() -> None:
    os.system('cls' if os.name == 'nt' else 'clear')

def pause(duration: float = 0.5) -> None:
    time.sleep(duration)

def display_intro_screen() -> None:
    clear_screen()
    print("""
Let's play Tic Tac Toe! After this screen, you'll choose the following:
        
1. Your marker
2. Board layout
3. Game difficulty
4. How many rounds you want to play

* Who gets to go first is randomly decided, then rotated in subsequent rounds.
        
Press Enter to continue.
          """)

    input()

def display_game_screen(board: Board, game_state: GameState) -> None:
    def square_number(position: str) -> str:
        return position if board[position] == INITIAL_MARKER else " "

    def display_row(sq1: str, sq2: str, sq3: str) -> None:
        print('     |     |')
        print(f"  {board[sq1]}  |  {board[sq2]}  |  {board[sq3]}")
        print(f"    {square_number(sq1)}|    {square_number(sq2)}|    {square_number(sq3)}")

    numpad_mode = game_state[NUMPAD_MODE]
    if game_state[CURRENT_ROUND] <= game_state[TOTAL_ROUNDS]:
        extra_str = " "
    else:
        extra_str = "(EXTRA ROUND!)"

    clear_screen()
    print(f"""
***||  Let's Play TIC TAC TOE  ||***
====================================
| MARKERS |  You: {game_state[PLAYER_MARKER]}  |  Computer: {game_state[COMPUTER_MARKER]}
------------------------------------
| SCORES  |  You: {game_state[PLAYER_SCORE]}  |  Computer: {game_state[COMPUTER_SCORE]}
====================================
        ROUND {game_state[CURRENT_ROUND]} of {game_state[TOTAL_ROUNDS]} {extra_str}
====================================""")

    print('')
    display_row('7','8','9') if numpad_mode else display_row('1','2','3')
    print('-----+-----+-----')
    display_row('4','5','6')
    print('-----+-----+-----')
    display_row('1','2','3') if numpad_mode else display_row('7','8','9')
    print('')

def display_next_round_countdown() -> None:
    pause()
    print("Get ready for next round!")

    # countdown
    for num in range(3, 0, -1):
        print(f'{num}..')
        pause()

def display_round_result(winning_marker: str | None, game_state: GameState) -> None:
    if winning_marker == game_state[PLAYER_MARKER]:
        print('You won!')
    elif winning_marker == game_state[COMPUTER_MARKER]:
        print('Computer won!')
    else:
        print("It's a tie!")

def display_grand_winner(grand_winner: str) -> None:
    if grand_winner == PLAYER:
        print('Yay! You are the grand winner!')
    elif grand_winner == COMPUTER:
        print('Computer is the grand winner.')

# functions relating to getting user input
def join_or(available_options: tuple[str, ...]) -> str:
    if len(available_options) <= 2:
        return " or ".join(available_options)

    return f'{", ".join(available_options[:-1])}, or {available_options[-1]}'

def get_valid_user_input(message: str, valid_options: tuple[str, ...], screen_clearing: bool = True) -> str:
    user_input = ""
    valid_options_str = join_or(valid_options)

    if screen_clearing: clear_screen()

    while user_input not in valid_options:
        print(message)
        user_input = input(f'Enter {valid_options_str}: ').strip().lower()

        if user_input in valid_options:
            return user_input

        if screen_clearing: clear_screen()
        print(f'Invalid input. Please enter {valid_options_str}.\n')

    raise RuntimeError("unreachable") # to satisfy the type checker

def get_player_marker() -> str:
    message = "Choose your marker."
    return get_valid_user_input(message, MARKERS)

def ask_use_minimax() -> bool:
    USE_NORMAL_AI = '1'
    USE_MINIMAX = '2'

    message = '''
Which difficulty mode do you want to play?
1. Normal
2. Impossible (you cannot beat the computer in this mode)
    '''
    valid_options = (USE_NORMAL_AI, USE_MINIMAX)
    user_input = get_valid_user_input(message, valid_options)

    return user_input == USE_MINIMAX

def get_round_count_choice() -> int:
    message = f'How many rounds do you want to play? Max {ROUND_LIMIT} rounds.'
    valid_options = tuple(str(num) for num in range(1, ROUND_LIMIT + 1))
    user_input = get_valid_user_input(message, valid_options)

    return int(user_input)

def ask_use_numpad_layout() -> bool:
    message = '''
Which layout do you want to use when choosing your squares?

(d)efault layout          (n)umpad layout
    1 | 2 | 3                 7 | 8 | 9
    4 | 5 | 6                 4 | 5 | 6
    7 | 8 | 9                 1 | 2 | 3
'''
    valid_options = ('default', 'd', 'numpad', 'n')
    user_input = get_valid_user_input(message, valid_options)

    return user_input in ('n', 'numpad')

def get_user_square_choice(board: Board) -> str:
    message = "Choose a square to mark."
    valid_options = get_available_squares(board)
    return get_valid_user_input(message, valid_options, screen_clearing=False)

def ask_play_again(message: str = "Play again?") -> bool:
    valid_options = ('y', 'yes', 'n', 'no')
    user_input = get_valid_user_input(message, valid_options, screen_clearing=False)
    return user_input in ('y', 'yes')

# game setup, states, and management
def initialize_game_state() -> GameState:
    player_marker = get_player_marker()
    computer_marker = get_other_marker(player_marker)
    first_move_marker = random.choice(MARKERS)
    numpad_mode = ask_use_numpad_layout()
    minimax_mode = ask_use_minimax()
    round_count = get_round_count_choice()

    return {
        PLAYER_MARKER: player_marker,
        COMPUTER_MARKER: computer_marker,
        FIRST_MOVE_MARKER: first_move_marker,
        CURRENT_MARKER: first_move_marker,
        NUMPAD_MODE: numpad_mode,
        MINIMAX_MODE: minimax_mode,
        CURRENT_ROUND: 0,
        TOTAL_ROUNDS: round_count,
        PLAYER_SCORE: 0,
        COMPUTER_SCORE: 0,
    }

def initialize_board() -> Board:
    return {str(square_num): INITIAL_MARKER for square_num in range(1,10)}

def get_other_marker(marker: str) -> str:
    x, o = MARKERS
    return x if marker == o else o

def get_available_squares(board: Board) -> tuple[str, ...]:
    return tuple(square_num for square_num in board if board[square_num] == INITIAL_MARKER)

def find_critical_square(board: Board, square_nums: tuple[str, str, str], marker: str) -> str | None:
    mapped_line = tuple(board[square_num] for square_num in square_nums)

    # if there's no empty square, no critical square exists
    if INITIAL_MARKER not in mapped_line:
        return None

    # the critical square number returned is the winning move for the marker
    if mapped_line.count(marker) == 2:
        target_index = mapped_line.index(INITIAL_MARKER)
        return square_nums[target_index]

def get_computer_move_normal(board: Board, game_state: GameState) -> str:
    computer_marker = game_state[COMPUTER_MARKER]
    player_marker = game_state[PLAYER_MARKER]
    available_squares = get_available_squares(board)

    # choose center square for first move if available
    if (len(available_squares) >= TOTAL_NUMBER_OF_SQUARES - 1) and CENTER_SQUARE in available_squares:
        return CENTER_SQUARE

    loss_preventing_square = None
    random_square = random.choice(available_squares)

    for square_nums in WINNING_LINES:
        winning_square = find_critical_square(board, square_nums, computer_marker)
        if winning_square: # return winning square immediately if found
            return winning_square

        # save loss preventing square in case no winning square is found
        loss_preventing_square = find_critical_square(board, square_nums, player_marker)

    return loss_preventing_square or random_square

def get_negamax_value(board: Board, game_state: GameState, moves_remaining: int, is_computer_turn: bool) -> int:
    computer_marker = game_state[COMPUTER_MARKER]
    player_marker = game_state[PLAYER_MARKER]
    available_squares = get_available_squares(board)
    winner_marker = get_winning_marker(board)

    multiplier = 1 if is_computer_turn else -1

    if winner_marker or moves_remaining == 0:
        if winner_marker == computer_marker:
            return multiplier * (1 + moves_remaining)
        elif winner_marker == player_marker:
            return multiplier * (-1 * (1 + moves_remaining))
        else:
            return 0

    best_value = NEGAMAX_MIN # arbitrarily chosen initial negative value

    for square in available_squares:
        current_marker = computer_marker if is_computer_turn else player_marker
        board[square] = current_marker

        current_value = -get_negamax_value(board, game_state, moves_remaining - 1, not is_computer_turn)

        if current_value > best_value:
            best_value = current_value

        board[square] = INITIAL_MARKER

    return best_value

def get_computer_move_minimax(board: Board, game_state: GameState) -> str:
    available_squares = get_available_squares(board)
    moves_remaining = len(available_squares)

    best_value = NEGAMAX_MIN # arbitrarily chosen initial negative value
    best_square = available_squares[0] # arbitrary initial value

    for square in available_squares:
        board[square] = game_state[COMPUTER_MARKER]

        current_value = -get_negamax_value(board, game_state, moves_remaining - 1, is_computer_turn=False)
        
        if current_value > best_value:
            best_value = current_value
            best_square = square

        board[square] = INITIAL_MARKER
    
    return best_square

def get_computer_square_choice(board: Board, game_state: GameState) -> str:
    if game_state[MINIMAX_MODE]:
        return get_computer_move_minimax(board, game_state)

    return get_computer_move_normal(board, game_state)

def get_winning_marker(board: Board) -> str | None:
    for square_numbers in WINNING_LINES:
        square_values = set(board[square_num] for square_num in square_numbers)
        if len(square_values) == 1 and INITIAL_MARKER not in square_values:
            return square_values.pop()
    return None

def get_grand_winner(game_state: GameState) -> str | None:
    if game_state[PLAYER_SCORE] > game_state[COMPUTER_SCORE]:
        return PLAYER
    elif game_state[PLAYER_SCORE] < game_state[COMPUTER_SCORE]:
        return COMPUTER
    else:
        return None

def is_board_full(board: Board) -> bool:
    return not bool(get_available_squares(board))

def update_scores(winning_marker: str | None, game_state: GameState) -> None:
    if not winning_marker: return

    if winning_marker == game_state[PLAYER_MARKER]:
        game_state[PLAYER_SCORE] += 1
    elif winning_marker == game_state[COMPUTER_MARKER]:
        game_state[COMPUTER_SCORE] += 1

def switch_first_move_player(game_state: GameState) -> None:
    game_state[FIRST_MOVE_MARKER] = get_other_marker(game_state[FIRST_MOVE_MARKER])
    game_state[CURRENT_MARKER] = game_state[FIRST_MOVE_MARKER]

def reset_game(game_state: GameState) -> GameState:
    KEEP_SETTINGS = "1"
    CHANGE_DIFFICULTY = "2"
    CHANGE_ALL = "3"

    message = """
For the new game, what would you like to do?
1. Keep the current settings
2. Change the difficulty setting
3. Change all settings
    (marker, board layout, difficulty setting, number of rounds)
    """
    valid_options = (KEEP_SETTINGS, CHANGE_DIFFICULTY, CHANGE_ALL)
    user_input = get_valid_user_input(message, valid_options)

    if user_input == CHANGE_ALL:
        return initialize_game_state()

    game_state[CURRENT_ROUND] = 0
    game_state[PLAYER_SCORE] = 0
    game_state[COMPUTER_SCORE] = 0
    game_state[FIRST_MOVE_MARKER] = random.choice(MARKERS)
    game_state[CURRENT_MARKER] = game_state[FIRST_MOVE_MARKER]

    if user_input == CHANGE_DIFFICULTY:
        game_state[MINIMAX_MODE] = ask_use_minimax()
    
    return game_state

# game rounds and loops
def play_one_round(game_state: GameState) -> None:
    board = initialize_board()
    player_marker = game_state[PLAYER_MARKER]
    game_state[CURRENT_ROUND] += 1

    # each loop is a turn
    while True:
        display_game_screen(board, game_state)

        current_marker = game_state[CURRENT_MARKER]
        if current_marker == player_marker:
            square_choice = get_user_square_choice(board)
        else:
            pause()
            square_choice = get_computer_square_choice(board, game_state)

        # mark square and switch current marker
        board[square_choice] = current_marker
        game_state[CURRENT_MARKER] = get_other_marker(current_marker)

        # check for winner
        winning_marker = get_winning_marker(board)
        board_full = is_board_full(board)

        if winning_marker or board_full:
            update_scores(winning_marker, game_state)
            display_game_screen(board, game_state)
            display_round_result(winning_marker, game_state)
            break

def play_all_rounds(game_state: GameState) -> None:
    for round in range(1, game_state[TOTAL_ROUNDS] + 1):
        play_one_round(game_state)

        # if round is not the final round
        if round != game_state[TOTAL_ROUNDS]:
            display_next_round_countdown()
            switch_first_move_player(game_state)

def play_until_grand_winner(game_state: GameState) -> None:
    while True:
        grand_winner = get_grand_winner(game_state)
        if grand_winner:
            display_grand_winner(grand_winner)
            return
        
        print("No grand winner yet.")
        message = "Play more rounds until a grand winner can be determined?"
        if ask_play_again(message):
            play_one_round(game_state)
        else:
            print('No grand winner for this game...\n')
            return

def play_ttt():
    display_intro_screen()
    clear_screen()
    game_state = initialize_game_state()

    while True:
        play_all_rounds(game_state)
        play_until_grand_winner(game_state) # optional extra rounds in case of no grand winner
        if ask_play_again():
            print("Let's play again!")
            pause(1)
            game_state = reset_game(game_state)
            continue
        break

    print("Thanks for playing Tic Tac Toe! Goodbye!")


play_ttt()