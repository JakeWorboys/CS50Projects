#include <stdio.h>
#include <cs50.h>

int main(void)
{
    string Name = get_string("What is your name?\n"); // Asks user to provide their name.
    printf("Hello, %s.\n", Name); // Uses name input to greet the user.
}