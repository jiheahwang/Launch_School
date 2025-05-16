# Create a hash that expresses the frequency with which each letter occurs in this string:
# ex: { "F"=>1, "R"=>1, "T"=>1, "c"=>1, "e"=>2, ... }

statement = "The Flintstones Rock"
frequency_hash = Hash.new(0)

statement.each_char do |char|
  frequency_hash[char] += 1
end

p frequency_hash