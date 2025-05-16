# Write a method that returns an Array that contains every other element of an Array that is passed in as an argument. The values in the returned list should be those values that are in the 1st, 3rd, 5th, and so on elements of the argument Array.

def oddities(array)
  array.select.with_index do |_, index|
    index.even?
  end
end

def oddities(array)
  new_array = []
  array.size.times do |index|
    new_array << array[index] if index.even?
  end
  new_array
end

def oddities(array)
  switch_on = true
  new_array = []
  array.each do |element|
    new_array << element if switch_on
    switch_on = !switch_on
  end
  new_array
end

p oddities([2, 3, 4, 5, 6]) == [2, 4, 6]
p oddities([1, 2, 3, 4, 5, 6]) == [1, 3, 5]
p oddities(['abc', 'def']) == ['abc']
p oddities([123]) == [123]
p oddities([]) == []
p oddities([1, 2, 3, 4, 1]) == [1, 3, 1]