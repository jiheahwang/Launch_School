import os
import random

MOVE_RULES: dict[str, tuple[str, str]] = {
    'rock': ('lizard', 'scissors'),     # winning_move: (losing moves)
    'paper': ('rock', 'spock'),
    'scissors': ('lizard', 'paper'),
    'lizard': ('paper', 'spock'),
    'spock': ('rock', 'scissors'),
}

FULL_MOVE_NAMES = tuple(MOVE_RULES.keys())

ABBREVIATIONS: dict[str, str] = {
    'r': 'rock',
    'p': 'paper',
    'sc': 'scissors',
    'l': 'lizard',
    'sp': 'spock',
}

GRAND_WINNING_SCORE = 3

# for displaying the rules table
RULES_TABLE_WIDTH = 39
WINNING_MOVE_FIELD_WIDTH = 8
LOSING_MOVES_FIELD_WIDTH = 16

def generate_move_names_with_shortcut_hints() -> str:
    move_names = []
    for abbr, full_move_name in ABBREVIATIONS.items():
        move_names.append(f'({abbr}){full_move_name[len(abbr):]}')
    return ', '.join(move_names)

MOVE_NAMES_WITH_SHORTCUT_HINTS = generate_move_names_with_shortcut_hints()

def prompt(message: str) -> None:
    print(f'==> {message}')

def clear_screen() -> None:
    os.system('cls' if os.name == 'nt' else 'clear')

def draw_horizontal_border(width=RULES_TABLE_WIDTH) -> None:
    print('-' * width)

def display_rules() -> None:
    prompt("Here are the rules.")
    draw_horizontal_border()
    for winning_move, losing_moves in MOVE_RULES.items():
        print(f'| {winning_move.center(WINNING_MOVE_FIELD_WIDTH)} | beats | '
              f'{', '.join(losing_moves).center(LOSING_MOVES_FIELD_WIDTH)} |')
    draw_horizontal_border()

def get_user_move() -> str:


    while True:
        prompt(f"Choose your move: {MOVE_NAMES_WITH_SHORTCUT_HINTS}")
        user_input = input().strip().lower()

        if user_input in ABBREVIATIONS:
            return ABBREVIATIONS[user_input] # return full move name
        if user_input in FULL_MOVE_NAMES:
            return user_input

        prompt('Please enter a valid move.')
        prompt(f'''You can either:
        - Enter the full move name (choose from: {', '.join(FULL_MOVE_NAMES)})
        - Or enter an abbreviation (choose from: {', '.join(ABBREVIATIONS)})
        ''')

def get_round_winner(user_move: str, computer_move: str) -> str | None:
    if computer_move in MOVE_RULES[user_move]:
        return 'user'
    if user_move in MOVE_RULES[computer_move]:
        return 'computer'
    return None # for tie

def get_score_str(scores: dict[str, int]) -> str:
    return f"You: {scores['user']}, Computer: {scores['computer']}"

def get_grand_winner(scores: dict[str, int]) -> str:
    return 'user' if scores['user'] > scores['computer'] else 'computer'

def display_final_result(scores: dict[str, int], grand_winner: str) -> None:
    prompt(f"Final score: {get_score_str(scores)}")

    if grand_winner == 'user':
        prompt('You are the grand winner!!')
    else:
        prompt('Computer is the grand winner!!')

def run_game_until_grand_winner() -> None:
    scores = { 'user': 0, 'computer': 0 }

    # 1 loop is 1 round; play rounds until someone gets to GRAND_WINNING_SCORE
    while max(scores.values()) < GRAND_WINNING_SCORE:
        prompt(f"Current score - {get_score_str(scores)}")

        user_move = get_user_move()
        computer_move = random.choice(FULL_MOVE_NAMES)
        prompt(f"You chose: {user_move}, computer chose: {computer_move}.")
        winner = get_round_winner(user_move, computer_move)

        if winner:
            prompt(f"{'You' if winner == 'user' else 'Computer'} won!\n")
            scores[winner] += 1
        else:
            prompt("It's a tie!\n")

    grand_winner = get_grand_winner(scores)
    display_final_result(scores, grand_winner)

def ask_to_repeat() -> bool:
    prompt('Would you like to play again? y/n')

    while True:
        answer = input().strip().lower()
        if answer in ('y', 'yes'):
            return True
        if answer in ('n', 'no'):
            return False
        prompt('Please answer (y)es or (n)o')

# main
clear_screen()
prompt("Welcome to Rock, Paper, Scissors, Lizard, Spock!")
prompt("First to 3 wins is the grand winner!")
display_rules()

while True:
    run_game_until_grand_winner()

    if ask_to_repeat():
        clear_screen()
    else:
        break

prompt("Thank you for playing RPSLS! Goodbye!")
