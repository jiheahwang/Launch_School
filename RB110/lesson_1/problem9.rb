# Write your own version of the rails titleize implementation.
# Turn this: words = "the flintstones rock"
# Into this: words = "The Flintstones Rock"

def titleize(sentence)
  sentence.split.map(&:capitalize).join(" ")
end

p titleize("the flintstones rock")