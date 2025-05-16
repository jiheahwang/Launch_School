require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

LANGUAGE = 'en' # May change language to 'en' or 'kr'

def messages(message, lang = LANGUAGE)
  MESSAGES[lang][message]
end

def prompt(key)
  message = messages(key, LANGUAGE)
  Kernel.puts("=> #{message}")
end

def valid_number?(num)
  num.to_i().to_s() == num
end

def get_number
  loop do
    num = Kernel.gets().chomp()

    if valid_number?(num)
      break num
    else
      prompt('invalid_number')
    end
  end
end

prompt('welcome')

name = ''
loop do
  name = Kernel.gets().chomp()

  if name.strip.empty?()
    prompt('valid_name')
  else
    break
  end
end

Kernel.puts("=> #{format(messages('greeting'), name: name)}")

loop do # main loop
  prompt('first_number')
  number1 = get_number

  prompt('second_number')
  number2 = get_number

  prompt('operator_prompt')

  operator = ''
  loop do
    operator = Kernel.gets().chomp()

    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt('choose1234')
    end
  end

  prompt(operator)

  result = case operator
           when '1'
             number1.to_i() + number2.to_i()
           when '2'
             number1.to_i() - number2.to_i()
           when '3'
             number1.to_i() * number2.to_i()
           when '4'
             number1.to_f() / number2.to_f()
           end

  Kernel.puts("=> #{format(messages('result'), result: result)}")

  prompt('calculate_again')
  answer = Kernel.gets().chomp()
  break unless answer.downcase().start_with?('y')
end

prompt('goodbye')
