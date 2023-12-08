# Modify the word_sizes method from the previous exercise to exclude non-letters when determining word size. For instance, the length of "it's" is 3, not 4.

def word_sizes(string)
  result = Hash.new(0)
  string.delete('^A-za-z ').split.map(&:size).each do |size|
    result[size] += 1
  end
  result
end

# def word_sizes(string)
#   sizes_array = string.delete('^A-za-z ').split.map(&:size)
#   sizes_array.map do |size|
#     [size, sizes_array.count(size)]
#   end.to_h
# end

p word_sizes('Four score and seven.') == { 3 => 1, 4 => 1, 5 => 2 }
p word_sizes('Hey diddle diddle, the cat and the fiddle!') == { 3 => 5, 6 => 3 }
p word_sizes("What's up doc?") == { 5 => 1, 2 => 1, 3 => 1 }
p word_sizes('') == {}