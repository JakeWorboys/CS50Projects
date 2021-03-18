# Imports get_int from cs50 library.
from cs50 import get_int

# Prompts user for height, rejects if not within required parameters.
height = get_int("Height: ")
if height < 1:
    height = get_int("Height: ")
if height > 8:
    height = get_int("Height: ")

# Sets variable for spaces to be added before #.
space = height - 1

# Creates pyramid based on parameters given by user.
for i in range(height):
    print(" " * (space-i), end="")
    print("#" * (i+1), end="")
    print("  ", end="")
    print("#" * (i+1), end="")
    print()