Describe the difference between ! and ? in Ruby. And explain what would happen in the following scenarios:
# ! negates whatever immediately follows it.
# ? is used in ternary expression and will evaluate the expression before it
#   and if true, will return the value before ':' and if false, return the value after ':'

    what is != and where should you use it? it means # 'is not equal to' and you use it when you create boolean expressions
    put ! before something, like !user_name 
    put ! after something, like words.uniq! #usually denotes a method that mutates the caller
    put ? before something
    put ? after something
    put !! before something, like !!user_name
