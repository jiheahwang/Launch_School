def compare_by_length(str1, str2):
    if len(str1) < len(str2):
        return -1
    elif len(str1) == len(str2):
        return 0
    else:
        return 1

print(compare_by_length('patience', 'perseverance')) # -1
print(compare_by_length('strength', 'dignity'))      #  1
print(compare_by_length('humor', 'grace'))           #  0