# What do you expect to happen when the greeting variable is referenced in the last line of the code below?

if false
  greeting = "hello world"
end

greeting # nil; not error because variable is initialized in the if clause even though it doesn't get executed