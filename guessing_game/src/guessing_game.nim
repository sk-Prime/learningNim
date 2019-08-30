import rdstdin
import random
import strutils
import strformat


echo "Guessing Game in Nim\n------------------------"

randomize()
let number = random.rand(1..10)
var cont = true
var count = 5
proc input(): int =
    try:
        result = parseInt(rdstdin.readLineFromStdin(
                fmt "\nguess the number ({count} chances left) :"))
    except ValueError:
        echo "wrong input"
        result = -1
    count -= 1

proc flow(): void =
    var guessed = input()
    if guessed == -1:
        echo "Moron"
    elif guessed < number:
        echo fmt "{guessed} is too small"
    elif guessed > number:
        echo fmt "{guessed} is too big"
    else:
        echo "you guessed it correctly"
        cont = false

while cont and count > 0:
    flow()
if count == 0 and cont == false:
    echo fmt "\nfailed: you have used all your chances\nThe number is {number}"


