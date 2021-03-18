#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <strings.h>
#include <cs50.h>

int main(void)
{
    char *word = get_string("Word; ");
    int hash = 0;

    
    for (int i = 0; i < 3; i++)
    {
        int score = 0;
        
        if (word[i] == '\0')
        {
            break;
        }
        
        if (isupper(word[i]) != 0)
        {
            score = word[i] - 65;
        }
        else
        {
            score = word[i] - 97;
        }
        
        if (i == 1)
        {
            score *= 10;
        }
        if (i == 0)
        {
            score *= 100;
        }
        
        hash += score;
    }
    
    printf("Hash number; %i\n", hash);
}