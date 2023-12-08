# Write a method that displays a 4-pointed diamond in an n x n grid, where n is an odd integer that is supplied as an argument to the method. You may assume that the argument will always be an odd integer.

# Examples

# diamond(1)

# *

# diamond(3)

#  *
# ***
#  *

# diamond(9)

#     *
#    ***
#   *****
#  *******
# *********
#  ******* 
#   ***** 
#    *** 
#     * 

def diamond(n)
  star_numbers_in_each_row = (1..n).map do |row|
    (row <= (n + 1) / 2) ? row * 2 - 1 : (n - row) * 2 + 1
  end
  
  star_numbers_in_each_row.each do |num|
    puts ("*" * num).center(n)
  end
end

def hollow_diamond(n)
  star_numbers_in_each_row = (1..n).map do |row|
    (row <= (n + 1) / 2) ? row * 2 - 1 : (n - row) * 2 + 1
  end
  
  star_numbers_in_each_row.each do |num|
    puts num == 1 ? "*".center(n) : "*#{(" " * (num-2))}*".center(n)
  end
end

diamond(1)
diamond(3)
diamond(9)

hollow_diamond(1)
hollow_diamond(3)
hollow_diamond(9)