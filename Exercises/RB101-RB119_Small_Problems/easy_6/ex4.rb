# Write a method that takes an Array as an argument, and reverses its elements in place; that is, mutate the Array passed into this method. The return value should be the same Array object.

# You may not use Array#reverse or Array#reverse!.

# Note: for the test case list = ['abc'], we want to reverse the elements in the array. The array only has one element, a String, but we're not reversing the String itself, so the reverse! method call should return ['abc'].

def reverse!(array)
  index = 0
  
  until index > (array.size - 1) / 2
    array[index], array[-index - 1] = array[-index - 1], array[index]
    index += 1
  end
  
  array
end

list = [1,2,3,4]
result = reverse!(list)
p result == [4, 3, 2, 1] # true
p list == [4, 3, 2, 1] # true
p list.object_id == result.object_id # true

list = %w(a b e d c)
p reverse!(list) == ["c", "d", "e", "b", "a"] # true
p list == ["c", "d", "e", "b", "a"] # true

list = ['abc']
p reverse!(list) == ["abc"] # true
p list == ["abc"] # true

list = []
p reverse!(list) == [] # true
p list == [] # true
