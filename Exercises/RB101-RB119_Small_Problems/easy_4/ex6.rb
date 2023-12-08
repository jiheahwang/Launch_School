# Write a method that takes an Array of numbers, and returns an Array with the same number of elements, and each element has the running total from the original Array.
# A running total is the sum of all values in a list up to and including the current element. Thus, the running total when looking at index 2 of the array [14, 11, 7, 15, 20] is 32 (14 + 11 + 7), while the running total at index 3 is 47 (14 + 11 + 7 + 15).

def running_total(array) 
  array.map.with_index { |_, index| array[0..index].sum }
end

def running_total(array)
  sum = 0
  array.each_with_object([]) { |num, obj| obj << sum += num }
end

def running_total(array)
  sum = 0
  array.reduce([]) { |arr, num| arr << sum += num }
end

p running_total([2, 5, 13]) # [2, 7, 20]
p running_total([14, 11, 7, 15, 20]) # [14, 25, 32, 47, 67]
p running_total([3]) == [3]
p running_total([]) == []
