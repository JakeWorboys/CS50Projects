#include <stdio.h>
#include <stdlib.h>
#include <cs50.h>
#include <ctype.h>
#include <string.h>

int main(int argc, string arg[])
{
    if (argc > 2 || argc == 1 || atoi(arg[1]) < 1) // Checks the command line argument (CLA) to see if the user has given what was required.
    {
        printf("Usage: ./caesar key");
        return 1;
    }

    int k = atoi(arg[1]); // Converts CLA for key into int value.
    int key = k; // Ensures key data is saved, atoi seems to have incredibly limited range and soon returns k to 0.

    for (int cmd = 0; cmd < strlen(arg[1]); cmd++)
    {
        if (isdigit(arg[1][cmd]) == 0) // Checks each character in the CLA to see if numerical data is present.
        {
            printf("Usage: ./caesar key");
            return 1;
        }
    }

    string message[0];
    message[0] = get_string("Message to be encrypted; "); // Retrieves user input for plaintext message.

    for (int i = 0; message[0][i] != '\0'; i++) // Works sequentially through the characters of the user-defined message.
    {
        if (isupper(message[0][i]) && isalpha(message[0][i])) // Checks for letter and case.
        {
            for (int a = 0; a < key; a++)
            {
                message[0][i] += 1;

                if (message[0][i] > 90) // Ensures cipher does not traverse out of alphabet or case, because I'm bad at maths.
                {
                    message[0][i] -= 26; // Creates basic wraparound in the basest way.
                }
            }
        }

        if (isalpha(message[0][i]) && islower(message[0][i]))
        {
            for (int b = 0; b < key; b++)
            {
                message[0][i] += 1;

                if (message[0][i] > 122)
                {
                    message[0][i] -= 26;
                }
            }
        }
    }

    printf("ciphertext: %s\n", message[0]); // Prints user defined plaintext as ciphertext.

    return 0;

}