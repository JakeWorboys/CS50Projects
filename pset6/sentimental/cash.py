# Imports get_float from cs50 library.
from cs50 import get_float

# Prompts user for amount of change owed.
change = get_float("Change owed: ")
if change < 0.01:
    change = get_float("Change owed: ")

# Sets coin count to 0.
count = 0

# Increases change variable by *100 to negate floating point math imprecision.
owed = (change * 100)

# Loops through change owed with greedy algorithm.
while owed >= 25:
    owed -= 25
    count += 1
while owed >= 10:
    owed -= 10
    count += 1
while owed >= 5:
    owed -= 5
    count += 1
while owed > 0:
    owed -= 1
    count += 1

# Prints smallest coin count.
print(count)