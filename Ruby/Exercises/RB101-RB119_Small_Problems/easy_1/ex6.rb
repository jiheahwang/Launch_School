def triangle(integer, location = "br") # location possibilities: tl, tr, bl, br
  case location
  when "br"
    stars = 1
    while stars <= integer
      puts ("*" * stars).rjust(integer)
      stars += 1
    end
  
  when "bl"
    stars = 1
    while stars <= integer
      puts ("*" * stars).ljust(integer)
      stars += 1
    end
  
  when "tl"
    stars = integer
    while stars >= 1
      puts ("*" * stars).ljust(integer)
      stars -= 1
    end
    
  when "tr"
    stars = integer
    while stars >= 1
      puts ("*" * stars).rjust(integer)
      stars -= 1
    end
  end
end

triangle(5, "br")
triangle(5, "bl")
triangle(5, "tl")
triangle(5, "tr")