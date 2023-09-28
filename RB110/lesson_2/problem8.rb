# Using the each method, write some code to output all of the vowels from the strings.

hsh = {first: ['the', 'quick'], second: ['brown', 'fox'], third: ['jumped'], fourth: ['over', 'the', 'lazy', 'dog']}

hsh.each do |_, value|
  value.each do |str|
    str.each_char do |char|
      puts char if 'aeiou'.include?(char)
    end
  end
end