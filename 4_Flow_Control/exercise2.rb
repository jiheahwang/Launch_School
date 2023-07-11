def all_caps(string)
  if string.length > 10
    string.upcase
  else
    string
  end
end

puts all_caps("Hello")
puts all_caps("Good evening! How are you?!?")