SQMETERS_TO_SQFEET = 10.7639

puts "Enter the length of the room in meters:"
length_meters = gets.chomp.to_f

puts "Enter the width of the room in meters:"
width_meters = gets.chomp.to_f

area_square_meter = length_meters * width_meters

area_square_feet = (SQMETERS_TO_SQFEET * area_square_meter).round(2)

puts "The area of the room is #{area_square_meter} square meters (#{area_square_feet} square feet)."

SQFEET_TO_SQINCHES = 144
SQFEET_TO_SQCENTIMETERS = 929.0304

#ask for the input measurements in feet, and display the results in square feet, square inches, and square centimeters.
puts "Enter the length of the room in feet:"
length_feet = gets.chomp.to_f

puts "Enter the width of the room in feet:"
width_feet = gets.chomp.to_f

square_feet = length_feet * width_feet
square_inches = (SQFEET_TO_SQINCHES * square_feet).round(2)
square_centimeters = (SQFEET_TO_SQCENTIMETERS * square_feet).round(2)

puts "The area of the room is #{square_feet} square feet (#{square_inches} square inches or #{square_centimeters} square centimeters)."