#a method that takes an array of strings, and returns a string that is all those strings concatenated together

#casual
take an array of strings
start with first string in the array
iterate through each string in the array and add each string to the first string
output the resultant single string

#formal
START

SET array_of_strings
GET array_of_strings
SET concat_string = empty string

SET iterator = 0

WHILE iterator < length of array_of_strings
  concat_string << string at the iterator index inside array_of_strings
  iterator += 1
RETURN concat_string

END