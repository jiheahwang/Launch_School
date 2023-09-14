# Alyssa was asked to write an implementation of a rolling buffer.
# Elements are added to the rolling buffer and if the buffer becomes full, then new elements that are added will displace the oldest elements in the buffer.

# She wrote two implementations saying, "Take your pick. Do you like << or + for modifying the buffer?".
# Is there a difference between the two, other than what operator she chose to use to concatenate an element to the buffer?
  # yes, the first one mutates the argument 'buffer' and the argument buffer and return 'buffer' reference the same object
  # the second one does not mutate the input_array but instead creates and returns a new variable 'buffer' that points to a new object
  
def rolling_buffer1(buffer, max_buffer_size, new_element) #has a side effect of mutating the argument
  buffer << new_element
  buffer.shift if buffer.size > max_buffer_size
  buffer
end

def rolling_buffer2(input_array, max_buffer_size, new_element) #better solution
  buffer = input_array + [new_element]
  buffer.shift if buffer.size > max_buffer_size
  buffer
end