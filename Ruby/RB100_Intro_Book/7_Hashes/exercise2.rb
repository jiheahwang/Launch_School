details1 = {name: 'bob', height: '6 ft', weight: '160 lbs', hair: 'brown'}
details1copy = {name: 'bob', height: '6 ft', weight: '160 lbs', hair: 'brown'}
details2 = {age: 62, city: "New York City"}

puts details1.merge(details2)
puts details1copy.merge!(details2)

puts details1
puts details1copy