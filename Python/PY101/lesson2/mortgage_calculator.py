import os

def prompt(message):
    print(f'==> {message}')

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

#TODO: validation - 2 decimal places; only positive numbers (can't be 0 or lower); handle comma and $ (REGEX opportunity!)
def get_loan_amount() -> float:
    prompt('What is the loan amount? ex) $50,000.00 | 50000 | 50,000.55')
    return 50000.00

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
    monthly_rate = apr_percent / 100 / 12
    loan_months = get_loan_duration_months()

    # do calculations
    monthly_payment = calculate_monthly_payment(monthly_rate, loan_amount, loan_months)
    total_amount = monthly_payment * loan_months
    total_interest = total_amount - loan_amount

    # output result
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

# Finally, don't forget to run your code through Pylint.