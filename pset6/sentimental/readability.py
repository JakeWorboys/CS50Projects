# Imports get_string from cs50 library.
from cs50 import get_string

# Sets variables at top to save irregularity.
lettercount = 0
wordcount = 1
sentencecount = 0
l = 0
s = 0
index = 0

# Prompts user for passage.
passage = get_string("Enter the passage you would like to grade: ")

# Loops through passage increasing relevant character variables.
for i in range(len(passage)):
    if passage[i].isalpha() == True:
        lettercount += 1
    elif passage[i] == " ":
        wordcount += 1
    elif (passage[i] == ".") or (passage[i] == "!") or (passage[i] == "?"):
        sentencecount += 1

# Sets variables used in Luhn's algorithm and then performs it.
l = (lettercount / wordcount) * 100
s = (sentencecount / wordcount) * 100
index = round(0.0588 * l - 0.296 * s - 15.8)

# Sorts grading response into relevant outcome.
if index in range(1, 17):
    print("Grade " + str(index))
elif index > 16:
    print("Grade 16+")
else:
    print("Before Grade 1")