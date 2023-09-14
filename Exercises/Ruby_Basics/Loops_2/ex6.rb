names = ['Sally', 'Joe', 'Lisa', 'Henry']

loop do
  puts names.shift #names.pop to print the names from last to first
  break if names.empty?
end