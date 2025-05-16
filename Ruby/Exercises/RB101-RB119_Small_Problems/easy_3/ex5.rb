def multiply(num1, num2)
  num1 * num2
end

def square(num)
  multiply(num, num)
end

def power_to_the_n(num, power)
  product = 1
  power.times do |i|
    product = multiply(product, num)
  end
  product
end


p square(5) == 25
p square(-8) == 64

p power_to_the_n(5, 6)