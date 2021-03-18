// Implements a dictionary's functionality
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <strings.h>
#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 26;

// Hash table
node *table[N];

int words = 0;

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    // TODO
    int hn = hash(word);

    node *srch = table[hn];
    
    while (srch != NULL)
    {
        if (strcasecmp(srch->word, word) != 0)
        {
            srch = srch->next;
            if (srch == NULL)
            {
                return false;
            }
        }
        if (strcasecmp(srch->word, word) == 0)
        {
            return true;
        }
    }
    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // TODO
    int total = 0;

    if (isupper(word[0]) != 0)
    {
        total += word[0] - 65;
    }
    else
    {
        total += word[0] - 97;
    }
    
    return total;
}

// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{
    // TODO
    FILE *dict = fopen(dictionary, "r");
    if (dict == NULL)
    {
        return false;
    }

    char wrd[LENGTH+1];

    while (fscanf(dict, "%s", wrd) != EOF)
    {
        node *entry = malloc(sizeof(node));
        if (entry == NULL)
        {
            return false;
        }

        strcpy(entry->word, wrd);

        int hn = hash(wrd);
        
        entry->next = table[hn];            
        table[hn] = entry;

        words++;
    }
    
    fclose(dict);

    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    // TODO
    return words;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    // TODO
    node *crsr = table[0];
    node *del = table[0];

    for (int i = 0; i < N; i++)
    {
        crsr = table[i];
        del = table[i];
        
        while (crsr != NULL)
        {
            crsr = crsr->next;
            free(del);
            del = crsr;
        }
    }    
    return true;
}
