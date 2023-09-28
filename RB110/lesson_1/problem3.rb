# remove people with age 100 and greater.

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }

ages.select! do |_, value|
  value < 100
end

p ages