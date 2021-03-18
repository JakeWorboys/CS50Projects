# Imports necessary code from libraries.
import sys
import csv

# Checks for correct number of cmd-line arguments.
if len(sys.argv) != 3:
    print("Incorrect cmd-line use. \nUsage: python dna.py STR.csv DNA.txt")
    sys.exit()

# Sets up memory for csv and dna sequence files.
STR = []
DNA = ""

# Opens specified csv and txt files and saves them to predefined variables.
with open(sys.argv[1], "r") as counts:
    reader = csv.DictReader(counts)
    for row in reader:
        STR.append(row)
with open(sys.argv[2], "r") as sequence:
    reader = sequence.readlines()
    DNA = str(reader)

# Creates list of strings that program is searching for.
seq = ["AGATC", "TTTTTTCT", "AATG", "TCTAG", "GATA", "TATC", "GAAA", "TCTG"]

# Keeps track of max consecutive STR repeats.
repeats = {
    "AGATC": 0,
    "TTTTTTCT": 0,
    "AATG": 0,
    "TCTAG": 0,
    "GATA": 0,
    "TATC": 0,
    "GAAA": 0,
    "TCTG": 0
}

# Variables to keep track of number of repeats, current repeating STR, and sequence character.
cc = ""
rpt = 1
i = 1

# Combs through DNA sequence and checks that it might be the start of any STR.
while i < (len(DNA)-4):
    found = False
    for j in range(8):
        if DNA[i] == seq[j][0]:
            counter = ""
            counter += DNA[i]
            found = True

# Retrieves following 3 characters in sequence.
    if found == True:        
        for k in range(1, 4):
            counter += DNA[i+k]

# Checks if the 4 letter combination is an STR.
        if counter in seq:
            if counter == cc:  # Checks if already looking at combination as repeat and increases if true.
                rpt += 1
            elif counter != cc:
                if cc != "":  # Checks combination is not the first in sequence. If not, saves previous STR stats. 
                    if repeats[cc] < rpt:
                        repeats[cc] = rpt
                    rpt = 1
            cc = counter
            i += len(cc)  # Ensures repeat chain isnt broken needlessly.
            
# Checks if the combination including the next letter in the sequence is an STR.
        elif (counter + DNA[i+4]) in seq:
            if counter + DNA[i+4] == cc:
                rpt += 1
            elif counter + DNA[i+4] != cc:
                if cc != "":
                    if repeats[cc] < rpt:
                        repeats[cc] = rpt
                    rpt = 1
            cc = counter + DNA[i+4]
            i += len(cc)

# Checks if four letter combo is beginning of longest STR.
        elif counter == "TTTT":
            seq2 = ""
            for l in range(1, 5):
                seq2 += DNA[i+3+l]
            if seq2 == "TTCT":  # Checks if full STR is in sequence.
                if counter + seq2 == cc:
                    rpt += 1
                elif counter + seq2 != cc:
                    if cc != "":
                        if repeats[cc] < rpt:
                            repeats[cc] = rpt
                        rpt = 1
                cc = counter + seq2
                i += len(cc)
            else:
                i += 1
                cc = ""
        else:
            if cc != "":
                if counter != cc:
                    i -= 3  # Minor bug fix.
            if rpt > 1:
                if cc != "":
                    if repeats[cc] < rpt:
                        repeats[cc] = rpt
                    rpt = 1
            i += 1
            cc = ""
    else:
        i += 1

MATCH = ""

# Checks STR repeats against person database for match.
for i in range(len(STR)):
    if STR[i]["AGATC"] == str(repeats["AGATC"]):
        if STR[i]["AATG"] == str(repeats["AATG"]):
            if STR[i]["TATC"] == str(repeats["TATC"]):
                if len(STR) < 4:
                    MATCH = STR[i]["name"]
                if len(STR) > 3:
                    if STR[i]["TTTTTTCT"] == str(repeats["TTTTTTCT"]):
                        if STR[i]["TCTAG"] == str(repeats["TCTAG"]):
                            if STR[i]["GATA"] == str(repeats["GATA"]):
                                if STR[i]["GAAA"] == str(repeats["GAAA"]):
                                    if STR[i]["TCTG"] == str(repeats["TCTG"]):
                                        MATCH = STR[i]["name"]
                                        break
    elif MATCH == "":
        MATCH = "No match"

print(MATCH)