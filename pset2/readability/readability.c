#include <stdio.h>
#include <cs50.h>
#include <math.h>



int main(void)
{
    int lettercount = 0; // Initialises important variables at program start.
    int wordcount = 1;
    int sentencecount = 0;
    float l;
    float s;
    int index;

    string passage[0]; // Initialises string array to store excerpt to be graded.

    passage[0] = get_string("Enter the passage you would like to grade:\n"); // Prompts user input.

    for (int i = 0; passage[0][i] != '\0'; i++) // ensures counting runs until the very end of the array.
    {
        if (((passage[0][i] >= 65) && (passage[0][i] <= 90)) || ((passage[0][i] >= 97) && (passage[0][i] <= 122)))
            // Triggers block if the ASCII code of the input is between A and Z, both upper and lower case.

        {
            lettercount++;
        }

        if (passage[0][i] == ' ') // Triggers block if a space is detected.
        {
            wordcount++;
        }

        if (passage[0][i] == '.' || passage[0][i] == '!' || passage[0][i] == '?') // Triggers block if ending punctuation is used.
        {
            sentencecount++;
        }
    }

    l = (lettercount / (float)wordcount) * 100;

    s = (sentencecount / (float) wordcount) * 100;

    index = round(0.0588 * l - 0.296 * s - 15.8); // Feeds averages l and s into Coleman-Liau index.

    if (index > 0 && index < 17) // Prints grade number between 1 and 16.
    {
        printf("Grade %i\n", index);
    }
    else if (index > 16)
    {
        printf("Grade 16+\n");
    }
    else
    {
        printf("Before Grade 1\n");
    }
}