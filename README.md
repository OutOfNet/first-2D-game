# first-2D-game
Pretty self explanatory, made using godot 4.4 and some free to use assets, i don't really plan on publishing it for now, this is mostly to learn, however i could compile the game and publish it here if anyone is curious to try it out.

## Latest changes
### Stamina consumption rework
Reworked the way stamina consumption works, instead of consuming 1 every 0.3 second, it consumes 0.1 every 0.03 second, which is less ressource-efficient, however it allows for a proper way to implement sprint interruption without needing too precise of a timing to interrupt it.
### Stamina recovery rework
Reworked the way stamina recovery works, instead of checking every frame whether or not the player is sprinting, recovering stamina, the game is paused etc, it's instead become a function that gets called upon the end of a sprint to save up some resources and compensate a bit for the more resource hungry stamina consumption system.
### Bug fix
Fixed a bug where the cursor would display a pointing cursor when hovering over the "resume" and "exit" buttons even though the game isn't paused
