#include <stdio.h>
#include <cs50.h>
#include <math.h>

int main(void)
{
    float change = 0; // Introduces user-set variable.
    int coins = 0; // Introduces end result variable.

    while (change <= 0)
    {
        change = get_float("How much change is due? $"); // Prompts user to give change value.
    }

    printf("\n");

    int cents = round(change * 100); // Alters the float variable into rounded whole numbers.

    while (cents > 24) // Checks if 25 cent can be taken from total value and adds 1 to coin total.
    {
        coins++;
        cents -= 25;
    }

    while (cents > 9 && cents < 25) // Checks if 10 cent can be taken from total value and adds 1 to coin total.
    {
        coins++;
        cents -= 10;
    }

    while (cents > 4 && cents < 10) // Checks if 5 cent can be taken from total value and adds 1 to coin total.
    {
        coins++;
        cents -= 5;
    }

    while (cents > 0 && cents < 5) // Checks if 1 cent can be taken from total value and adds 1 to coin total.
    {
        coins++;
        cents -= 1;
    }
    
    printf("%i\n", coins); // Provides answer to smallest nummber of coins possible.
}
