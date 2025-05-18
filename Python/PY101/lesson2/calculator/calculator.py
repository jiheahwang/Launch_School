def prompt(message):
    print(f'==> {message}')

def invalid_number(number_str):
    try:
        float(number_str)
    except ValueError:
        return True

    return False


prompt('Welcome to Calculator!')

prompt("What's the first number?")
number_str1 = input()

while invalid_number(number_str1):
    prompt("Hmm... that doesn't look like a valid number.")
    number_str1 = input()

prompt("What's the second number?")
number_str2 = input()

while invalid_number(number_str2):
    prompt("Hmm... that doesn't look like a valid number.")
    number_str2 = input()

prompt('What operation would you like to perform?\n'
      '1) Add 2) Subtract 3) Multiply 4) Divide')
operation = input()

while operation not in ["1", "2", "3", "4"]:
    prompt('You must choose 1, 2, 3, or 4')
    operation = input()

# match/case for operation
match operation:
    case "1":
        output = float(number_str1) + float(number_str2)
    case "2":
        output = float(number_str1) - float(number_str2)
    case "3":
        output = float(number_str1) * float(number_str2)
    case "4":
        output = float(number_str1) / float(number_str2)

prompt(f'The result is: {output}')