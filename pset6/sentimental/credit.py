from cs50 import get_int
from sys import exit

card = get_int("Card number: ")

c1 = round(card % 10000000000000000 / 1000000000000000)
c2 = round(card % 1000000000000000 / 10000000000000)
c3 = round(card % 100000000000000 / 10000000000000)
c4 = round(card % 10000000000000 / 1000000000000)

rem = 100
divi = 10
store = 0
fd = 0
sd = 0
total = 0

if (c1 == 5 and c2 < 1) or (c1 == 5 and c2 > 5):
    print("INVALID")
    exit
elif c1 == 0 and c2 == 3:
    if c3 != 4 and c3 != 7:
        print("INVALID")
        exit
elif (c1 == 0 and c4 != 4) and (c1 == 0 and c3 != 4) and (c1 == 0 and c2 != 4):
    print("INVALID")
    exit

for i in range(8):
    if card % rem / divi * 2 > 9:
        store = round(card % rem / divi * 2)
        fd = store / 10
        sd = store % 10
        total += round(fd + sd)
    else:
        total += round(card % rem / divi * 2)
    rem = rem * 100
    divi = divi * 100

print(total)

rem = 10
divi = 1

for i in range(8):
    total += round(card % rem / divi)
    rem = rem * 100
    divi = divi * 100

print(total)

if total % 10 == 0:
    print("VALID")
    if card / (10 ** 15) > 5:
        print("MASTERCARD")
    elif card / (10 ** 14) > 4:
        print("VISA")
    elif card / (10 ** 14) > 3:
        print("AMEX")
    elif (card / (10 ** 12) > 4) or (card / (10 ** 13) > 4) or (card / (10 ** 15) > 4):
        print("VISA")
else:
    print("INVALID")