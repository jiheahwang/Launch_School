# Write a method which takes a grocery list (array) of fruits with quantities and converts it into an array of the correct number of each fruit.

def convert_array(array)
  new_array = []
  array[1].times do |i|
    new_array << array[0]
  end
  new_array
end

def buy_fruit(array)
  array.map do |subarray|
    convert_array(subarray)
  end.flatten
end

p buy_fruit([["apples", 3], ["orange", 1], ["bananas", 2]]) ==
  ["apples", "apples", "apples", "orange", "bananas","bananas"]