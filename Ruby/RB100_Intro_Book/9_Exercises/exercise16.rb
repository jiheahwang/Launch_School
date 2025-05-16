# Expected output:
#  {
#    "Joe Smith"=>{:email=>"joe@email.com", :address=>"123 Main st.", :phone=>"555-123-4567"},
#    "Sally Johnson"=>{:email=>"sally@email.com", :address=>"404 Not Found Dr.",  :phone=>"123-234-3454"}
#  }

def contact_hash_with_fields(field_array, data)
  contact_details = {}
  n = 0

  field_array.each do |field|
    contact_details[field] = data[n]
    n+=1
  end
  return contact_details
end

contact_data = [["joe@email.com", "123 Main st.", "555-123-4567"],
            ["sally@email.com", "404 Not Found Dr.", "123-234-3454"]]
contacts = {"Joe Smith" => {}, "Sally Johnson" => {}}
fields = [:email, :address, :phone]

contacts.each_key do |key|
  contacts[key] = contact_hash_with_fields(fields, contact_data.first)
  contact_data.shift
end

p contacts