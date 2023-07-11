contact_data = [["joe@email.com", "123 Main st.", "555-123-4567"],
            ["sally@email.com", "404 Not Found Dr.", "123-234-3454"]]

contacts = {"Joe Smith" => {}, "Sally Johnson" => {}}
fields = [:email, :address, :phone]

# Expected output:
#  {
#    "Joe Smith"=>{:email=>"joe@email.com", :address=>"123 Main st.", :phone=>"555-123-4567"},
#    "Sally Johnson"=>{:email=>"sally@email.com", :address=>"404 Not Found Dr.",  :phone=>"123-234-3454"}
#  }

contact_details = Hash.new 

n = 0
fields.each do |field|
  contact_details[field] = contact_data.first[n]
  n+=1
end


contact_names = contacts.keys #array version of contacts (names)
contact_names.each do |name|
  contacts[name] = contact_details
  contact_data.shift #unable to figure out how to get this to work
end
  
p contacts

