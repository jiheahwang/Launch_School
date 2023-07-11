bobprofile = {height: '6 ft', weight: '160 lbs', hair: 'brown', age: 62, city: "New York City"}

puts bobprofile.keys
puts bobprofile.values

bobprofile.each {|key, value| puts "Bob's #{key} is #{value}"}