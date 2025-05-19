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
                    \d{0,2}         # possible remaining 0-2 digits, then
                    (,\d{3})*       # possible comma separated groups of 3 digits
                    |[1-9]\d*       # or case 2: plain numbers without commas
                )
                (\.\d{0,2})?        # then optional decimal point with 0-2 digits
            )|                      # or:
            (0\.(0[1-9]|[1-9]\d))   # case 3 - allow 0.01-0.99
        )
        """, re.VERBOSE)

        return pattern.fullmatch(user_input) is not None

    while True:
        prompt('What is the loan amount? ex) $50,000.00 | 50000 | 50,000.55')
        user_input = input().strip()

        if is_valid_money_format(user_input):
            loan_amount = float(user_input.replace(',','').replace('$',''))
            if loan_amount < 1:
                prompt("I hope you didn't take out a loan for mere cents!")
            return loan_amount

        prompt('Invalid input. Please enter a valid amount.\n' \
        '\tvalid  : $50,000.00 | 50000 | 50,000.55 | $0.99\n' \
        '\tinvalid: $0 | -5000 | $040 | 40,00,00 | $.99')

def get_apr() -> float:
    def is_valid_apr_format(user_input):
        pattern = re.compile(r"""
                (
                    0|          # allow zero
                    [1-9]\d*    # disallow leading zero for numbers >= 1 
                )
                (\.\d*)?        # then optional decimal parts
                %?              # and option percent sign
        """, re.VERBOSE)

        return pattern.fullmatch(user_input) is not None

    while True:
        prompt('What is the Annual Percentage Rate (APR)? ex) 8 | 5.75 | 6%')
        user_input = input().strip()

        if is_valid_apr_format(user_input):
            apr = float(user_input.replace('%',''))
            if apr > 30:
                prompt("I hope you didn't borrow from a loan shark! Good luck")
            elif apr == 0:
                prompt("I wish I could borrow money for free too!")
            return apr

        prompt('Invalid input. Please enter a valid amount.\n' \
        '\tvalid  : 8 | 5.75 | 6%\n' \
        '\tinvalid: -5% | 4.4.4 | 02')

def get_loan_duration_months() -> int:
    def get_whole_number(message):
        while True:
            prompt(message)
            user_input = input().strip()

            if user_input.isdigit():
                if len(user_input) > 1 and user_input.startswith('0'):
                    prompt('Leading zeros are not allowed.')
                    continue

                return int(user_input)

            prompt('Only nonnegative whole numbers allowed.\n' \
            '\tvalid: 0, 3, 10\tinvalid: 3.5, -4, 0.0')

    prompt("Now let's enter the duration of your loan.\n" \
    "\t-First I'll ask you the loan term years, then months.\n" \
    "\t-It's ok to enter more than 12 months - they'll be added to the total.")

    while True:
        loan_years = get_whole_number("Enter number of years (whole number)")
        loan_months = get_whole_number("Enter number of months (whole number)")
        total_months = loan_years * 12 + loan_months

        if total_months == 0:
            prompt("Loan duration cannot be 0. Try again!")
            continue

        return total_months

def calculate_monthly_payment(monthly_rate, loan_amount, loan_months):
    if monthly_rate == 0:
        return loan_amount / loan_months

    numerator = loan_amount * monthly_rate
    denominator = 1 - (1 + monthly_rate)**(-loan_months)

    return numerator / denominator

def run_mortgage_calculator_once():
    # collect info from user
    loan_amount = get_loan_amount()
    apr_percent = get_apr()
    loan_months = get_loan_duration_months()

    # do calculations
    monthly_rate = apr_percent / 100 / 12
    monthly_payment = calculate_monthly_payment(
        monthly_rate,
        loan_amount,
        loan_months)
    total_amount = monthly_payment * loan_months
    total_interest = total_amount - loan_amount
    years, months = divmod(loan_months, 12)

    # output result
    clear_screen()
    prompt(f"For a ${loan_amount:,.2f}, {apr_percent}% APR, "
           f"{years} year {months} month loan:\n"
           f"""
        Monthly payment     : ${monthly_payment:,.2f}
        Number of payments  : {loan_months}
        Total amount paid   : ${total_amount:,.2f}
        Total interest      : ${total_interest:,.2f}
        """)

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

    if ask_to_repeat():
        clear_screen()
    else:
        break

prompt('Thank you for using the Mortgage Calculator. Goodbye!')