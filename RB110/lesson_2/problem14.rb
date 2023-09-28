# Given this data structure write some code to return an array containing the colors of the fruits, and the sizes of the vegetables. The sizes should be uppercase and the colors should be capitalized.
# The return value should look like this:
# [["Red", "Green"], "MEDIUM", ["Red", "Green"], ["Orange"], "LARGE"]

hsh = {
  'grape' => {type: 'fruit', colors: ['red', 'green'], size: 'small'},
  'carrot' => {type: 'vegetable', colors: ['orange'], size: 'medium'},
  'apple' => {type: 'fruit', colors: ['red', 'green'], size: 'medium'},
  'apricot' => {type: 'fruit', colors: ['orange'], size: 'medium'},
  'marrow' => {type: 'vegetable', colors: ['green'], size: 'large'},
}

arr = []
hsh.each_value do |value|
  arr << value[:colors].map(&:capitalize) if value[:type] == "fruit"
  arr << value[:size].upcase if value[:type] == "vegetable"
end

p arr