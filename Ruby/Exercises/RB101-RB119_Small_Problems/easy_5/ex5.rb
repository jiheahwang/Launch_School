# Given a string that consists of some words (all lowercased) and an assortment of non-alphabetic characters, write a method that returns that string with all of the non-alphabetic characters replaced by spaces. If one or more non-alphabetic characters occur in a row, you should only have one space in the result (the result should never have consecutive spaces).

# def cleanup(string)
#   string.chars.map do |char|
#     ('A'..'z').include?(char) ? char : ' '
#   end.join.squeeze(' ')
# end

def cleanup(string)
  string.tr_s('^a-z', ' ')
end

p cleanup("---what's my +*& line?") == ' what s my line '
p cleanup("---whatt's my +*& line?") == ' whatt s my line '