#include <cs50.h>
#include <stdio.h>

int main(void)
{
    int years = 0;
    int inc;
    int dec;

    int pop = get_int("Population size: ");
    
    while (pop < 9)
    {
        printf("\nPlease enter a larger number.\n");
        pop = get_int("Population size: ");
    }

    int end = get_int("End pop. size: ");
    
    while (end < pop)
    {
        printf("\nPlease enter a number larger than current population.\n");
        end = get_int("End pop. size: ");
    }

    while (pop < end)
    {
        inc = pop / 3;
        dec = pop / 4;

        pop += inc - dec;

        years++;
    }

    printf("Years: %i\n", years);
}