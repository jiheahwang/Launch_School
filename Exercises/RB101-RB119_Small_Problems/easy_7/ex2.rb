# Write a method that takes a string, and then returns a hash that contains 3 entries: one represents the number of characters in the string that are lowercase letters, one represents the number of characters that are uppercase letters, and one represents the number of characters that are neither.

LOWERCASE = ("a".."z").to_a
UPPERCASE = ("A".."Z").to_a

def letter_case_count(string)
  hash = { lowercase: 0, uppercase: 0, neither: 0 }
  
  string.each_char do |char|
    if LOWERCASE.include?(char)
      hash[:lowercase] += 1
    elsif UPPERCASE.include?(char)
      hash[:uppercase] += 1
    else 
      hash[:neither] += 1
    end
  end
  
  hash
end

p letter_case_count('abCdef 123') == { lowercase: 5, uppercase: 1, neither: 4 }
p letter_case_count('AbCd +Ef') == { lowercase: 3, uppercase: 3, neither: 2 }
p letter_case_count('123') == { lowercase: 0, uppercase: 0, neither: 3 }
p letter_case_count('') == { lowercase: 0, uppercase: 0, neither: 0 }