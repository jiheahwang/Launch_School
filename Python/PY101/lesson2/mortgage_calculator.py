import os
import re

def prompt(message):
    print(f'==> {message}')

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def get_loan_amount() -> float:
    def is_valid_money_format(user_input):
        pattern = re.compile(r"""
        \$?                         # allow a single optional $ sign
        (
            (                       # cases 1 and 2 inside this parenthesis
                (                   # case 1 - for comma separated inputs:
                    [1-9]           # check that the number doesn't have leading 0s
                    \d{0,2}         # possible remaining 0-2 digits before the...
                    (,\d{3})*       # possible comma separated groups of 3 digits
                    |[1-9]\d*       # or case 2: plain numbers without commas
                )
                (\.\d{0,2})?        # then optional decimal point with 0-2 digits
            )|                      # or:
            (0\.(0[1-9]|[1-9]\d))   # case 3 - allow 0.01-0.99
        )
        """, re.VERBOSE)

        return pattern.fullmatch(user_input)

    while True:
        prompt('What is the loan amount? ex) $50,000.00 | 50000 | 50,000.55')
        user_input = input().strip()

        if is_valid_money_format(user_input):
            loan_amount = float(user_input.replace(',','').replace('$',''))
            if loan_amount < 1:
                prompt("I hope you didn't take out a loan for mere cents!")
            return loan_amount
        else:
            prompt('Invalid input. Please enter a valid amount.\n' \
            '\tvalid  : $50,000.00 | 50000 | 50,000.55 | $0.99\n' \
            '\tinvalid: $0 | -5000 | $040 | 40,00,00 | $.99')

#TODO: validation - handle percent sign
def get_apr() -> float:
    prompt('What is the Annual Percentage Rate (APR)? ex) 4 | 5.75 | 5%')
    return 3.3

#TODO: convert y and m to just m; only positive number (total months can't be 0 or lower); disallow floats
def get_loan_duration_months() -> int:
    prompt('What is the loan duration? ex) 4y 2m | 10y | 60m')
    return 5

def calculate_monthly_payment(monthly_rate: float, loan_amount: float, loan_months: int) -> float:
    if monthly_rate == 0:
        return loan_amount / loan_months

    return loan_amount * (monthly_rate / (1 - (1 + monthly_rate)**(-loan_months)))

def run_mortgage_calculator_once():
    # collect info from user
    loan_amount = get_loan_amount()
    apr_percent = get_apr()
    loan_months = get_loan_duration_months()

    # do calculations
    monthly_rate = apr_percent / 100 / 12
    monthly_payment = calculate_monthly_payment(monthly_rate, loan_amount, loan_months)
    total_amount = monthly_payment * loan_months
    total_interest = total_amount - loan_amount

    # output result
    clear_screen()
    prompt(f'''For a ${loan_amount:,.2f}, {apr_percent}% APR, {loan_months} month loan:
        Monthly payment     : ${monthly_payment:,.2f}
        Number of payments  : {loan_months}
        Total amount paid   : ${total_amount:,.2f}
        Total interest      : ${total_interest:,.2f}
        ''')

def ask_to_repeat() -> bool:
    prompt('Would you like to perform another calculation? y/n')

    while True:
        answer = input().strip().lower()
        if answer in ('y', 'yes'):
            return True
        if answer in ('n', 'no'):
            return False
        prompt('Please answer (y)es or (n)o')


# main
prompt('Welcome to Mortgage Calculator!')

while True:
    run_mortgage_calculator_once()
    should_repeat = ask_to_repeat()
    if should_repeat:
        clear_screen()
    else:
        break

prompt('Thank you for using the Mortgage Calculator. Goodbye!')

# TODO: pylint