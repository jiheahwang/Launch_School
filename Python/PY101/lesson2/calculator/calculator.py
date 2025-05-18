import os
import operator

OPERATORS = {
    "+": operator.add,
    "-": operator.sub,
    "*": operator.mul,
    "/": operator.truediv,
}

def prompt(message):
    print(f'==> {message}')

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def get_valid_number(message):
    while True:
        prompt(message)
        try:
            number = float(input().strip())
        except ValueError:
            prompt("Invalid input. Please enter a valid number.\n")
        else:
            return number

def perform_one_calculation():
    number1 = get_valid_number("What's the first number?")
    number2 = get_valid_number("What's the second number?")

    while True:
        prompt('What operation would you like to perform?\n'
            'Enter +, -, *, or /')
        operation = input().strip()

        # check for zero division
        if operation == '/' and number2 == 0.0:
            prompt('Cannot divide by 0. Please choose another operation.\n')
            continue

        if operation in OPERATORS:
            output = OPERATORS[operation](number1, number2)
            break # break out of this loop if everything is good

        prompt('You must choose +, -, *, or /\n')

    # format specifier g removes unnecessary decimal points
    prompt(f'{number1:g} {operation} {number2:g} is {output:g}\n')

# main
clear_screen()
prompt('Welcome to Calculator!')

while True:
    perform_one_calculation()
    prompt('Would you like to perform another calculation? y/n')
    answer = input().strip()
    if answer.lower().startswith('y'):
        clear_screen()
    else:
        break

prompt('Thanks for using the calculator. Goodbye!')
