=begin
a method that takes two arrays of numbers and returns the result of merging the arrays.
The elements of the first array should become the elements at the even indexes of the returned array,
while the elements of the second array should become the elements at the odd indexes.
For instance:
merge([1, 2, 3], [4, 5, 6]) # => [1, 4, 2, 5, 3, 6]
You may assume that both array arguments have the same number of elements.
=end

#casual
given array1 and array2, both with the same number of elements
set up a new array
push first elements of array1 and array2, taking turns, while deleting the first element when pushed
return new array

#formal
START

GET array1
GET array2
SET new_array
SET iterator = 0

WHILE iterator < size of either given array
  new_array << first element of array1 (and also delete that element)
  new_array << first element of array2 (and also delete that element)

RETURN new_array

END
