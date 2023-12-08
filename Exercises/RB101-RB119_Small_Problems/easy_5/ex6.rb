# Write a method that takes a string with one or more space separated words and returns a hash that shows the number of words of different sizes.

# Words consist of any string of characters that do not include a space.

# def word_sizes(string)
#   result = Hash.new(0)
#   string.split.map(&:size).each do |size|
#     result[size] += 1
#   end
#   result
# end

def word_sizes(string)
  sizes_array = string.split.map(&:size)
  sizes_array.map do |size|
    [size, sizes_array.count(size)]
  end.to_h
end


p word_sizes('Four score and seven.') == { 3 => 1, 4 => 1, 5 => 1, 6 => 1 }
p word_sizes('Hey diddle diddle, the cat and the fiddle!') == { 3 => 5, 6 => 1, 7 => 2 }
p word_sizes("What's up doc?") == { 6 => 1, 2 => 1, 4 => 1 }
p word_sizes('') == {}