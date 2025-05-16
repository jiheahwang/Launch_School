def prompt(message)
  Kernel.puts(">> #{message}")
end

def get_answer
  Kernel.gets().chomp()
end

def invalid_number?(num)
  num.strip.empty?() || num.to_f() <= 0
end

def get_valid_answer
  loop do
    input = get_answer
    if invalid_number?(input)
      prompt('Invalid amount. Please enter an amount greater than 0.')
    else
      return input
    end
  end
end

def calculate_again?
  loop do
    prompt("Do another calculation? (yes/no)")
    again = get_answer
    if again.downcase().start_with?('y')
      return true
    elsif again.downcase().start_with?('n')
      return false
    else
      prompt("Please answer yes or no")
      next
    end
  end
end

prompt('Welcome to the mortgage calculator!')

loop do
  prompt('What is the loan amount? Enter numbers only (ex. 50000 for $50000)')
  amount = get_valid_answer

  prompt('What is the APR? Enter numbers only (ex. 5 for 5%, 3.5 for 3.5%)')
  apr = get_valid_answer

  prompt('What is the loan duration in years?
        Enter numbers only (ex. 5 for 5 years)')
  duration_years = get_valid_answer

  monthly_rate = apr.to_f() / 12 / 100
  duration_months = duration_years.to_f() * 12
  monthly_payment = amount.to_f() * (monthly_rate /
                    (1 - ((1 + monthly_rate)**(-duration_months))))
  total_amount = monthly_payment * duration_months
  total_interest = total_amount - amount.to_f()

  prompt("For a $#{amount}, #{apr}% APR, #{duration_years} year loan,")
  prompt("Monthly payment: $#{format('%.2f', monthly_payment)}
    Number of payments: #{duration_months}
    Total amount repaid: $#{format('%.2f', total_amount)}
    Total interest: $#{format('%.2f', total_interest)}")

  break unless calculate_again?
end

prompt('Thank you for using the mortgage calculator! Goodbye :)')
