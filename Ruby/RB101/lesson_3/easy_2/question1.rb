# In this hash of people and their age, see if "Spot" is present.

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }

p ages.assoc("Spot")
p ages.any? {|key, _value| key == "Spot"}
p ages.key?("Spot")
p ages.include?("Spot")