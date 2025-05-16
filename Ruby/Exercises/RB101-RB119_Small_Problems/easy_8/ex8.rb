# Write a method that takes one argument, a string, and returns a new string with the words in reverse order.

def reverse_sentence(string)
  string.split.reverse.join(' ')
end

p reverse_sentence('Hello World') == 'World Hello'
p reverse_sentence('Reverse these words') == 'words these Reverse'
p reverse_sentence('') == ''
p reverse_sentence('    ') == '' # Any number of spaces results in ''