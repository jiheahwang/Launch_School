# print_in_box('To boldly go where no one has gone before.')
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+

def print_in_box(text)
  length = text.size
  if length <= 76
    puts "+-" + ("-" * length) + "-+"
    puts "| " + (" " * length) + " |"
    puts "| " + text + " |"
    puts "| " + (" " * length) + " |"
    puts "+-" + ("-" * length) + "-+"
  elsif length > 76
    puts "+-" + ("-" * 76) + "-+"
    puts "| " + (" " * 76) + " |"
    while text.size > 0
      puts "| " + text.slice!(0..75).ljust(76) + " |"
    end
    puts "| " + (" " * 76) + " |"
    puts "+-" + ("-" * 76) + "-+"
  end
end

print_in_box('To boldly go where no one has gone before..')
print_in_box("Two episodes made notably deep impressions in Vaughan Williams's personal life. The First World War, in which he served in the army, had a lasting emotional effect. Twenty years later, though in his sixties and devotedly married, he was reinvigorated by a love affair with a much younger woman, who later became his second wife. He went on composing through his seventies and eighties, producing his last symphony months before his death at the age of eighty-five. His works have continued to be a staple of the British concert repertoire, and all his major compositions and many of the minor ones have been recorded.")