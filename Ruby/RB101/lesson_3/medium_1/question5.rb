# Alyssa asked Ben to write up a basic implementation of a Fibonacci calculator.
# A user passes in two numbers, and the calculator will keep computing the sequence until some limit is reached.

# Ben coded up this implementation but complained that as soon as he ran it, he got an error.
# Something about the limit variable. What's wrong with the code?
  # methods are self containing so the fib method cannot access local variable 'limit'
# How would you fix this so that it works?

def fib(first_num, second_num, limit)
  while first_num + second_num < limit
    sum = first_num + second_num
    first_num = second_num
    second_num = sum
  end
  sum
end

result = fib(0, 1, 15)
puts "result is #{result}"

