#include <stdio.h>
#include <cs50.h>

int main(void)
{
    int Height = 0; // Introduces height variable.

    while (Height < 1 || Height > 8)
    {
        Height = get_int("Height: "); // Asks the user to determine the height of the pyramid.
    }

    for (int h = 0; h < Height; h++) // Initial loop, using height variable to determine full loop length.
    {
        for (int s = Height - 1; s > h; s--) // Nested loop to create white space preceding hash "blocks". Set as height - 1 to offset beginning from 0.
        {
            printf(" ");
        }

        for (int l = 0; l <= h; l++) // Nested loop to create the necessary number of hash "blocks" per line.
        {
            printf("#");
        }

        printf("  ");

        for (int l = 0; l <= h; l++) // Nested loop to create the necessary number of hash "blocks" per line.
        {
            printf("#");
        }

        printf("\n");
    }
}