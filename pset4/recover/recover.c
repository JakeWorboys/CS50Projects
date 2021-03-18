#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <cs50.h>

typedef uint8_t BYTE;

int main(int argc, char *argv[])
{
    if (argc != 2) // Checks if cla used properly.
    {
        printf("Usage: ./recover image");
        return 1;
    }

    FILE *input = fopen(argv[1], "r"); // Opens forensic image.
    if (input == NULL)
    {
        return 2;
    }

    int fr = 0; // Keeps track of number of images discovered.

    char filename[8];
    sprintf(filename, "%03i.jpg", fr); // Sets filename to have buffer 0's.

    BYTE block[512]; // Creates array to store blocks of memory from forensic image.

    FILE *output = fopen(filename, "w"); // Opens initial file to write output to.

    while (fread(&block, sizeof(BYTE), 512, input)) // Reads through blocks of data until none remain.
    {
        // Checks if block is beginning of new jpeg file.
        if (block[0] == 0xff && block[1] == 0xd8 && block[2] == 0xff && (block[3] & 0xf0) == 0xe0)
        {
            if (fr > 0) // Checks if jpeg is first in chain.
            {
                fclose(output);

                sprintf(filename, "%03i.jpg", fr); // Resets filename with new count number.

                output = fopen(filename, "w"); // Opens fresh output file.
                if (output == NULL)
                {
                    return 2;
                }
            }
            fr++;
            fwrite(&block, sizeof(BYTE), 512, output);
        }
        else if (fr > 0) // Ensures program doesn't write garbage data to output file.
        {
            fwrite(&block, sizeof(BYTE), 512, output);
        }
    }

    // Closes remaining documents.
    fclose(input);
    fclose(output);
}










