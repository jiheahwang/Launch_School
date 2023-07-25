# a method that takes an array of integers, and returns a new array with every other element from the original array, starting with the first element. For instance:
# every_other([1,4,7,2,5]) # => [1,7,5]

#casual
take an array of integers
start with first element of the array
get subsequent values of elements whose index is +2 from current one, starting with the first element
continue until the index number is greater than the array size
get these values into a new array
return the new array

#formal
START

GET array_of_integers
SET new_array = empty array
SET index = 0
WHILE index < size of array_of_integers
  new_array << element of array_of_integers at index
  index += 2
RETURN new_array

END