#include "helpers.h"
#include <string.h>
#include <stdio.h>
#include <math.h>

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    int avg;

    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            avg = round((image[h][w].rgbtBlue + image[h][w].rgbtGreen + image[h][w].rgbtRed) / 3.0); // Collects average of RGB values.
            
            // Sets output RGB values to average.
            image[h][w].rgbtBlue = avg;
            image[h][w].rgbtGreen = avg;
            image[h][w].rgbtRed = avg;
        }
    }
    
    

    return;
}

// Convert image to sepia
void sepia(int height, int width, RGBTRIPLE image[height][width])
{
    int sb;
    int sg;
    int sr;

    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            // Uses sepia algorithm to set RGB values into placeholder variables.
            sb = round(.272 * image[h][w].rgbtRed + .534 * image[h][w].rgbtGreen + .131 * image[h][w].rgbtBlue);
            sg = round(.349 * image[h][w].rgbtRed + .686 * image[h][w].rgbtGreen + .168 * image[h][w].rgbtBlue);
            sr = round(.393 * image[h][w].rgbtRed + .769 * image[h][w].rgbtGreen + .189 * image[h][w].rgbtBlue);

            // Resolves any visual bugs that might come about as a result of values being greather than max colour value.
            if (sb > 255)
            {
                sb = 255;
            }
            if (sg > 255)
            {
                sg = 255;
            }
            if (sr > 255)
            {
                sr = 255;
            }

            image[h][w].rgbtBlue = sb;
            image[h][w].rgbtGreen = sg;
            image[h][w].rgbtRed = sr;
        }
    }

    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE reflect[width];

    for (int h = 0; h <= height; h++)
    {
        int b = 0;

        for (int w = 0; w <= width; w++)
        {
            reflect[w] = image[h][w]; // Fills reflect array with all the RGB values for h's row.
        }
        for (int r = width - 1; r >= 0; r--)
        {
            image[h][b] = reflect[r]; // Reverses image row by moving back down the row as the reflect array replaces values from the beginning.
            b++;
        }
    }

    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    // Creates container for new colour values.
    RGBTRIPLE blur[height][width];


    // Averages the colour values for the ~3x3 grid of pixels around the chosen pixel.
    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            if (h == 0) // Checks if dealing with top image row.
            {
                if (w == 0) // Checks if dealing with leftmost column.
                {
                    blur[h][w].rgbtRed = round((image[h][w].rgbtRed + image[h][w + 1].rgbtRed + image[h + 1][w].rgbtRed + image[h + 1][w + 1].rgbtRed) 
                                                / 4.0);
                    blur[h][w].rgbtGreen = round((image[h][w].rgbtGreen + image[h][w + 1].rgbtGreen + image[h + 1][w].rgbtGreen + image[h + 1][w + 1].rgbtGreen)
                                                / 4.0);
                    blur[h][w].rgbtBlue = round((image[h][w].rgbtBlue + image[h][w + 1].rgbtBlue + image[h + 1][w].rgbtBlue + image[h + 1][w + 1].rgbtBlue) 
                                                / 4.0);
                }
                else if (w == width-1) // Checks if dealing with rightmost column.
                {
                    blur[h][w].rgbtRed = round((image[h][w - 1].rgbtRed + image[h][w].rgbtRed + image[h + 1][w - 1].rgbtRed + image[h + 1][w].rgbtRed)
                                                / 4.0);
                    blur[h][w].rgbtGreen = round((image[h][w - 1].rgbtGreen + image[h][w].rgbtGreen + image[h + 1][w - 1].rgbtGreen + image[h + 1][w].rgbtGreen) 
                                                / 4.0);
                    blur[h][w].rgbtBlue = round((image[h][w - 1].rgbtBlue + image[h][w].rgbtBlue + image[h + 1][w - 1].rgbtBlue + image[h + 1][w].rgbtBlue) 
                                                / 4.0);
                }
                else
                {
                    blur[h][w].rgbtRed = round((image[h][w - 1].rgbtRed + image[h][w].rgbtRed + image[h][w + 1].rgbtRed + image[h + 1][w - 1].rgbtRed + image[h + 1][w].rgbtRed 
                                                + image[h + 1][w + 1].rgbtRed) / 6.0);
                    blur[h][w].rgbtGreen = round((image[h][w - 1].rgbtGreen + image[h][w].rgbtGreen + image[h][w + 1].rgbtGreen + image[h + 1][w - 1].rgbtGreen + image[h + 1][w].rgbtGreen
                                                + image[h + 1][w + 1].rgbtGreen) / 6.0);
                    blur[h][w].rgbtBlue = round((image[h][w - 1].rgbtBlue + image[h][w].rgbtBlue + image[h][w + 1].rgbtBlue + image[h + 1][w - 1].rgbtBlue + image[h + 1][w].rgbtBlue
                                                + image[h+1][w+1].rgbtBlue) / 6.0);
                }
            }
            else if (h == height-1) // Checks if dealing with bottom image row.
            {
                if (w == 0)
                {
                    blur[h][w].rgbtRed = round((image[h - 1][w].rgbtRed + image[h - 1][w + 1].rgbtRed + image[h][w].rgbtRed + image[h][w + 1].rgbtRed)
                                                / 4.0);
                    blur[h][w].rgbtGreen = round((image[h - 1][w].rgbtGreen + image[h - 1][w + 1].rgbtGreen + image[h][w].rgbtGreen + image[h][w + 1].rgbtGreen)
                                                / 4.0);
                    blur[h][w].rgbtBlue = round((image[h - 1][w].rgbtBlue + image[h - 1][w + 1].rgbtBlue + image[h][w].rgbtBlue + image[h][w + 1].rgbtBlue)
                                                / 4.0);
                }
                else if (w == width - 1)
                {
                    blur[h][w].rgbtRed = round((image[h - 1][w - 1].rgbtRed + image[h - 1][w].rgbtRed + image[h][w - 1].rgbtRed + image[h][w].rgbtRed)
                                                / 4.0);
                    blur[h][w].rgbtGreen = round((image[h - 1][w - 1].rgbtGreen + image[h - 1][w].rgbtGreen + image[h][w - 1].rgbtGreen + image[h][w].rgbtGreen)
                                                / 4.0);
                    blur[h][w].rgbtBlue = round((image[h - 1][w - 1].rgbtBlue + image[h - 1][w].rgbtBlue + image[h][w - 1].rgbtBlue + image[h][w].rgbtBlue)
                                                / 4.0);
                }
                else
                {
                    blur[h][w].rgbtRed = round((image[h - 1][w - 1].rgbtRed + image[h - 1][w].rgbtRed + image[h - 1][w + 1].rgbtRed + image[h][w - 1].rgbtRed 
                                                + image[h][w].rgbtRed + image[h][w + 1].rgbtRed) / 6.0);
                    blur[h][w].rgbtGreen = round((image[h - 1][w - 1].rgbtGreen + image[h - 1][w].rgbtGreen + image[h - 1][w + 1].rgbtGreen + image[h][w - 1].rgbtGreen
                                                + image[h][w].rgbtGreen + image[h][w + 1].rgbtGreen) / 6.0);
                    blur[h][w].rgbtBlue = round((image[h - 1][w - 1].rgbtBlue + image[h - 1][w].rgbtBlue + image[h - 1][w + 1].rgbtBlue + image[h][w - 1].rgbtBlue 
                                                + image[h][w].rgbtBlue + image[h][w + 1].rgbtBlue) / 6.0);
                }
            }
            else if (w == 0)
            {
                blur[h][w].rgbtRed = round((image[h - 1][w].rgbtRed + image[h - 1][w + 1].rgbtRed + image[h][w].rgbtRed + image[h][w + 1].rgbtRed + image[h + 1][w].rgbtRed
                                            + image[h + 1][w + 1].rgbtRed) / 6.0);
                blur[h][w].rgbtGreen = round((image[h - 1][w].rgbtGreen + image[h - 1][w + 1].rgbtGreen + image[h][w].rgbtGreen + image[h][w + 1].rgbtGreen
                                            + image[h + 1][w].rgbtGreen + image[h + 1][w + 1].rgbtGreen) / 6.0);
                blur[h][w].rgbtBlue = round((image[h - 1][w].rgbtBlue + image[h - 1][w + 1].rgbtBlue + image[h][w].rgbtBlue + image[h][w + 1].rgbtBlue
                                            + image[h + 1][w].rgbtBlue + image[h + 1][w + 1].rgbtBlue) / 6.0);   
            }
            else if (w == width - 1)
            {
                blur[h][w].rgbtRed = round((image[h - 1][w - 1].rgbtRed + image[h - 1][w].rgbtRed + image[h][w - 1].rgbtRed + image[h][w].rgbtRed + image[h + 1][w - 1].rgbtRed
                                            + image[h + 1][w].rgbtRed) / 6.0);
                blur[h][w].rgbtGreen = round((image[h - 1][w - 1].rgbtGreen + image[h - 1][w].rgbtGreen + image[h][w - 1].rgbtGreen + image[h][w].rgbtGreen
                                            + image[h + 1][w - 1].rgbtGreen + image[h + 1][w].rgbtGreen) / 6.0);
                blur[h][w].rgbtBlue = round((image[h - 1][w - 1].rgbtBlue + image[h - 1][w].rgbtBlue + image[h][w - 1].rgbtBlue + image[h][w].rgbtBlue
                                            + image[h + 1][w - 1].rgbtBlue + image[h + 1][w].rgbtBlue) / 6.0);
            }
            else
            {
                blur[h][w].rgbtRed = round((image[h - 1][w - 1].rgbtRed + image[h - 1][w].rgbtRed + image[h - 1][w + 1].rgbtRed + image[h][w - 1].rgbtRed
                                            + image[h][w].rgbtRed + image[h][w + 1].rgbtRed + image[h + 1][w - 1].rgbtRed + image[h + 1][w].rgbtRed
                                                + image[h + 1][w + 1].rgbtRed) / 9.0);
                blur[h][w].rgbtGreen = round((image[h - 1][w - 1].rgbtGreen + image[h - 1][w].rgbtGreen + image[h - 1][w + 1].rgbtGreen + image[h][w - 1].rgbtGreen
                                            + image[h][w].rgbtGreen + image[h][w + 1].rgbtGreen + image[h + 1][w - 1].rgbtGreen + image[h + 1][w].rgbtGreen
                                                + image[h + 1][w + 1].rgbtGreen) / 9.0);
                blur[h][w].rgbtBlue = round((image[h - 1][w - 1].rgbtBlue + image[h - 1][w].rgbtBlue + image[h - 1][w + 1].rgbtBlue + image[h][w - 1].rgbtBlue
                                            + image[h][w].rgbtBlue + image[h][w + 1].rgbtBlue + image[h + 1][w - 1].rgbtBlue + image[h + 1][w].rgbtBlue
                                                + image[h + 1][w + 1].rgbtBlue) / 9.0);
            }
        }
    }

    // Returns altered values from blur array back into image array.
    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            image[h][w] = blur[h][w];
        }
    }

    return;
}

















