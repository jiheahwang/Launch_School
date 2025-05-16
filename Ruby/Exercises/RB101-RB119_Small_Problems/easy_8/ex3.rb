# Write a method that returns a list of all substrings of a string. The returned list should be ordered by where in the string the substring begins. This means that all substrings that start at position 0 should come first, then all substrings that start at position 1, and so on. Since multiple substrings will occur at each position, the substrings at a given position should be returned in order from shortest to longest.

# You may (and should) use the leading_substrings method you wrote in the previous exercise:

def leading_substrings(string)
  array = []
  string.each_char.with_index do |_, index|
    array << string[0..index]
  end
  array
end

# def substrings(string)
#   array = []
#   string.chars.each_index do |index|
#     index.upto(string.size-1) do |endpoint|
#       array << string[index..endpoint]
#     end
#   end
#   array
# end

def substrings(string)
  arr = []
  0.upto(string.size-1) do |index|
    arr += leading_substrings(string[index..string.size-1])
  end
  arr
end

p substrings('abcde') == ['a', 'ab', 'abc', 'abcd', 'abcde','b', 'bc', 'bcd', 'bcde','c', 'cd', 'cde','d', 'de', 'e']