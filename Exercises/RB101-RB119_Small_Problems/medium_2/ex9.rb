def bubble_sort!(array, passes = 0)
  swapped = false
  max_index = array.size - 2 - passes
  
  0.upto(max_index) do |index|
    first = array[index]
    second = array[index + 1]
    
    if first > second
      array[index], array[index + 1] = second, first
      swapped = true
    end
  end
  
  return unless swapped
  
  bubble_sort!(array, passes + 1)
end

array = [5, 3]
bubble_sort!(array)
p array == [3, 5]

array = [6, 2, 7, 1, 4]
bubble_sort!(array)
p array == [1, 2, 4, 6, 7]

array = %w(Sue Pete Alice Tyler Rachel Kim Bonnie)
bubble_sort!(array)
p array == %w(Alice Bonnie Kim Pete Rachel Sue Tyler)