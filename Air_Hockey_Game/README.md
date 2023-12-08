Air Hockey Game
----------------------------------
Inputs:
Player 1 - W A S D
Player 2 - Arrow Keys
'Esc' - Restart Game

Instructions:
-Press the 'ESC' key to start/restart the game: In this mode, the hockey puck will remain still until a player moves their paddle.
-Hockey Puck will bounce around the edge and against paddles.
-Player pad movement does not incorporate simultaneous input, if a pad is not moving verify only one input key is being pressed.
-Goal of Game: Hit hockey puck into opponent goal indicated by the RED area on each side
-The player that wins will show a 'WIN' text on their side of the screen



File Description
--------------------------
*top_level.v --------> Top Level file for game inputs and outputs
*ps2.v      ---------> Convert PS/2 keyboard inputs into usable output
*bitGenTop.v --------> VGA bit generation control
*bitGen.v    --------> VGA graphics pattern and collision logic
*VGA_Controller.v  --> VGA graphics generation for 640x480 @ 60Hz



