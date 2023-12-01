Interface using PS2 Keyboard for W,A,S,D,Up,Down,Left,Right,Esc,Space
Esc-restart/go to start screen
Space-start game
WASD-Player 1
Up,down,left,right-Player 2

Scans keyboard codes and converts to usuable hex number. 

Current Implementation does not handle 'break' keys to acknowledge a keyboard key is not being depressed. LED output was used
for testing to verify correct keys were being entered and decoded by circuit. Pressing keys other than specified will result
in no movement/no function unless added hex condition is added.

Will handle inputs from 2 players for air hockey game, ECE 3710 - F2023 : University of Utah
