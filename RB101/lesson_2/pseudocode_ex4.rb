#a method that determines the index of the 3rd occurrence of a given character in a string.
# For instance, if the given character is 'x' and the string is 'axbxcdxex', the method should return 6 (the index of the 3rd 'x').
# If the given character does not occur at least 3 times, return nil.

#casual
given a string and given a character
create a counter variable and set to 0
iterate through each character in the string ( and whenever it matches the given character, raise the counter by 1
when the counter hits 3, return the index of the character at which the counter hit 3
if the counter does not hit 3 and it finished iterating through the string, return nil

#formal
START

GET given_string
GET given_character
SET counter = 0
SET index = 0
WHILE index < string.length
  IF character == current character being iterated
    THEN counter += 1
  ELSE next
  
  IF counter == 3
    RETURN index
  IF counter < 3 by the time the end of string is reached (index == string.length-1)
    RETURN nil
  
END