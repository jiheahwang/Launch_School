# Study the following code and state what will be displayed...and why:

def tricky_method(string_param_one, string_param_two)
  string_param_one += "rutabaga"
  string_param_two << "rutabaga"
end

string_arg_one = "pumpkins"
string_arg_two = "pumpkins"
tricky_method(string_arg_one, string_arg_two)

puts "String_arg_one looks like this now: #{string_arg_one}" # "pumpkins"
puts "String_arg_two looks like this now: #{string_arg_two}" # "pumpkinsrutabaga"

#because string_param_one inside the method reassigns string_param_one to a new object
#but string_param_two mutates the object referenced by the argument