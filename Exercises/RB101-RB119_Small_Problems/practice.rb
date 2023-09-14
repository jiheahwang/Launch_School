def find_children(string)
  chars = string.chars
    chars.sort! do |a, b|
      a.downcase <=> b.downcase
    end

    # char.sort! do |a, b|
      
    # end

  # chars.join
end


p find_children("abBA") #== "AaBb"
p find_children("AaaaaZazzz") #== "AaaaaaZzzz"
p find_children("CbcBcbaA") #== "AaBbbCcc"
p find_children("xXfuUuuF") #== "FfUuuuXx"
p find_children("") #== ""