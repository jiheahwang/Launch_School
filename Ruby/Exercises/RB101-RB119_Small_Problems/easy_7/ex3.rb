# Write a method that takes a single String argument and returns a new string that contains the original value of the argument with the first character of every word capitalized and all other letters lowercase.

# You may assume that words are any sequence of non-blank characters.

# def word_cap(string)
#   string.split.map(&:capitalize).join(' ')
# end

# def word_cap(string)
#   string.split.map do |word|
#     word = word.downcase
#     word[0] = word[0].upcase
#     word
#   end.join(' ')
# end

def word_cap(string)
  string.split.map do |word|
    word.chars.map.with_index do |char, index|
      index == 0 ? char.upcase : char.downcase
    end.join
  end.join(' ')
end

p word_cap('four score and seven') == 'Four Score And Seven'
p word_cap('the javaScript language') == 'The Javascript Language'
p word_cap('this is a "quoted" word') == 'This Is A "quoted" Word'