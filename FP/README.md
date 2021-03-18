# Bumper!
#### Video Demo:  https://youtu.be/R5NNNL4q2Lc
#### Description:
For my final project I wanted to recreate my intro project from scratch in a real coding environment. I decided to use LOVE2d as I have a small amount of prior experience working with the engine.

The game is a basic pong/breakout clone in which the player collects tokens to increase their score and progress through three stages. When the player collects all 15 tokens, or loses all three lives, the game ends with a win or loss screen.

In order to fulfill the basic conditions for the game to be playable, it was necessary to find ways to code three different fundamental gameplay concepts:
- Collision detection & reaction
- Paddle & game controls
- Engine draw conditions

Additional features were added on top to make the game a little more interesting, such as a basic, easily understandable UI, soundtracking and sfx, and pause functionality.

There is also a short list of features I would like to add into the game in my spare time down the line, for example a difficulty modifier and a time-attack mode with a scoreboard.

Collision detection is handled with a basic axis-aligned bounding box (AABB) collision system. The game is continuously checking that the ball is not within certain areas as defined by the code, for instance the player's paddle or the walls in stage 3. When the function detects a collision with one of these, a code statement tells the ball to alter the dynamic x or y variable to its inverse dependent on which axis the ball has collided with, creating a 'bounce'.

Separately to this, the ball rebounds from the top, left, and right side of the window using a simpler system that checks only if the left, upper, or right side of the ball is equal to the window boundaries.

The same system is used whenever the ball hits a score token, but this time instead of rebounding the ball, the resulting statement alters a variable causing the engine to no longer draw the token. This variable also changes the collision detection function in such a way that if the ball passes the same token space again, the game will not count it as a hit and as such will not increase the score unnecessarily.

The graphics are very basic at the moment as I am very unfamiliar with shader, texture, and mesh systems, particularly within the LOVE engine. While I would eventully like to change the basic polygon sprites out for something more intricate in order to improve the visual appeal of the game, I also think that the basic approach to aesthetics suits the older style of the game, hearkening back to the earlier days of video games when games like this were more popular.

Overall I am pleased with the current build of the game. There are some minor issues to work out, such as a few dodgy corner cases with the collision detection, and I plan to continue to tweak these as I progress with my ability as a side project.