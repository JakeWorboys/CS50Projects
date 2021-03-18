# Imports get_string function from the cs50 library
from cs50 import get_string

# Asks for the user's name and prints customised greeting.
name = get_string("What is your name? ")
print("hello, " + name)