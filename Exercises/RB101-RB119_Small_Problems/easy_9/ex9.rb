# Given the array...

# Write a program that prints out groups of words that are anagrams. Anagrams are words that have the same exact letters in them but in a different order. Your output should look something like this:
# ["demo", "dome", "mode"]
# ["neon", "none"]
#(etc)

def print_anagrams(words_array)
  unique_character_sets = words_array.map do |word|
    word.chars.sort.join
  end.uniq
  
  anagrams = {}
  unique_character_sets.each do |set|
    anagrams[set] = []
  end
  
  words_array.each do |word|
    anagrams[word.chars.sort.join] << word
  end
  
  anagrams.values.each do |anagram_set|
    p anagram_set
  end
end

words =  ['demo', 'none', 'tied', 'evil', 'dome', 'mode', 'live',
          'fowl', 'veil', 'wolf', 'diet', 'vile', 'edit', 'tide',
          'flow', 'neon']

print_anagrams(words)
