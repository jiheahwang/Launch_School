# Given the hash below, create an array containing only two elements: Barney's name and Barney's number.
flintstones = { "Fred" => 0, "Wilma" => 1, "Barney" => 2, "Betty" => 3, "BamBam" => 4, "Pebbles" => 5 }

array = flintstones.assoc("Barney")

p array