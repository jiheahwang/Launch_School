# Write a method that counts the number of occurrences of each element in a given array.
# The words in the array are case-sensitive: 'suv' != 'SUV'. Once counted, print each element alongside the number of occurrences.

vehicles = [
  'car', 'car', 'truck', 'car', 'SUV', 'truck',
  'motorcycle', 'motorcycle', 'car', 'truck'
]

# should print:
# car => 4
# truck => 3
# SUV => 1
# motorcycle => 2

def count_occurrences(array)
  hash = Hash.new(0)
  array.each do |element|
    hash[element] += 1
  end
  puts hash
end

count_occurrences(vehicles)
