#include <stdio.h>
#include <cs50.h>
#include <math.h>

int main(void)
{
    long card = 0; // List initialises all variable in one place at the beginning of the program.
    long rem = 100;
    long divi = 10;
    int store = 0;
    int fd = 0;
    int sd = 0;
    int total = 0;

    card = get_long("Please enter your card number;"); // Prompts user to input main variable data.
    printf("\n");

    int c1 = card % 10000000000000000 / 1000000000000000;
    int c2 = card % 1000000000000000 / 100000000000000;
    int c3 = card % 100000000000000 / 10000000000000;
    int c4 = card % 10000000000000 / 1000000000000;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (card / pow(10, 12) <= 1)
    {
        printf("INVALID\n");

        return 0;
    }

    if ((c1 == 5 && c2 < 1) || (c1 == 5 && c2 > 5))
    {
        printf("INVALID\n");

        return 0;
    }
    else if (c1 == 0 && c2 == 3)
    {
        if (c3 < 4 || (c4 > 4 && c3 < 7) || c3 > 7)
        {
            printf("INVALID\n");

            return 0;
        }
    }

    else if ((c1 == 0 && c4 != 4) && (c1 == 0 && c3 != 4) && (c1 == 0 && c2 != 4))
    {
        printf("INVALID3");

        return 0;
    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    for (int a = 0; a < 8; a++) // Set to run 8 times, max number needed for 16 digit card number.
    {
        if (card % rem / divi * 2 > 9) // Checks if the algorithm would output a 2 digit number.
        {
            store = card % rem / divi * 2;
            fd = store / 10; // Stores the first digit.
            sd = store % 10; // Stores the second digit.

            total += fd + sd;
        }
        else
        {
            total += card % rem / divi * 2; // Finds the next number for the algorithm and multiplies by two.
        }

        rem = rem * 100; // rem and divi variables set to multiply by 100
        divi = divi * 100; // at the end of the loop to skip two numbers in the chain.
    }
    
    printf("%i\n", total);

    rem = 10; // Variables reset to lowest numbers necessary to beging from last card digit.
    divi = 1;

    for (int a = 0; a < 8; a++)
    {
        total += card % rem / divi;

        rem = rem * 100;
        divi = divi * 100;
    }
    
    printf("%i\n", total);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (total % 10 == 0)
    {
        printf("VALID\n");

        if (card / pow(10, 15) > 5) // Used pow() to clean up code but gives inaccurate response [5.55556], hence > 5 and not 5.
        {
            printf("MASTERCARD\n");
        }
        else if (card / pow(10, 14) > 4)
        {
            printf("VISA\n");
        }
        else if (card / pow(10, 14) > 3)
        {
            printf("AMEX\n");
        }
        else if (card / pow(10, 12) > 4 || card / pow(10, 13) > 4 || card / pow(10, 15) > 4) // Used multiple or operands due to fluctuating card number length.
        {
            printf("VISA\n");
        }

    }
    else
    {
        printf("INVALID\n");
    }
}





