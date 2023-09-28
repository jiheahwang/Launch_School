def cleanup(string)
  string.chars.map do |char|
    ('A'..'z').include?(char) ? char : ' '
  end.join.squeeze(' ')
end

p cleanup("---what's my +*& line?") == ' what s my line '
p cleanup("---whatt's my +*& line?") == ' whatt s my line '