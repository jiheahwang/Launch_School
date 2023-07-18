process_the_loop = [true, false].sample

if process_the_loop == true
  loop do
    print "The loop was processed"
    break
  end
else
  print "The loop wasn't processed!"
end