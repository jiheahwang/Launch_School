# Consider this nested Hash. Determine the total age of just the male members of the family.

munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

# male_hash = munsters.select do |_, value|
#   value["gender"] == "male"
# end

# p (male_hash.values.map do |hash|
#   hash["age"]
# end.sum)

age_total = 0

munsters.each_value do |details|
  age_total += details["age"] if details["gender"] == "male"
end

p age_total