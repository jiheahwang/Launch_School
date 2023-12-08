# Write a method that rotates an array by moving the first element to the end of the array. The original array should not be modified.

# Do not use the method Array#rotate or Array#rotate! for your implementation.

def rotate_array(array)
  (array.size-1).downto(0).map { |index| array[-index] }
end

p rotate_array([7, 3, 5, 2, 9, 1]) == [3, 5, 2, 9, 1, 7]
p rotate_array(['a', 'b', 'c']) == ['b', 'c', 'a']
p rotate_array(['a']) == ['a']
p rotate_array([]) == []

x = [1, 2, 3, 4]
p rotate_array(x) == [2, 3, 4, 1]   # => true
p x == [1, 2, 3, 4]                 # => true

# Write a method that rotates a string instead of an array. Do the same thing for integers. You may use rotate_array from inside your new method.

def rotate_string(string)
  rotate_array(string.chars).join
end

p rotate_string("Hello")

def rotate_integer(integer)
  rotate_array(integer.to_s.chars).join.to_i
end

p rotate_integer(12345)