# Space-Impact 50
### Video Demo:  [Watch Demo](https://youtu.be/raEgKaq4vzk)
### Description:
This project is a remake of the classic Space Impact game, where players control a spaceship to navigate through space, shoot enemies, and avoid obstacles.
### Files and their purpose:

#### General files
- Animation: controls animation of sprites
- Background: background of the game
- constants : global constants used in the game
- Entity : behaviour and attributes of entities in the game
- entity_defs : entity definition- data about entities
- Fire : fire of player
- Player : space-ship to control
- StateMachine : control the state of game and entities
- Util : creates usable quads, frames from spritesheets
- GameObject : Object in the game
- game_objects : definition of objects
- Creature : Alien Creature Entities
- CreatureFire : creature fires at enemies
- Score : shows score at when enemies are killed or objects are destroyd
- Boss : boss to fight in the end
- ProgressBar : progress bar to show the health of boss

#### world
- Level : All of the events and level generation

#### states
- BaseState: Base for all states
- EntityIdleState: Entity when moving only towards player(x-axis)
- EntityMoveState: Entity when moving in both x and y axis
- PlayerIdleState: Player when no button is clicked moved only in x axis with no acceleration
- PlayerMoveState: Player when it is being controlled and moved in both x and y axis according to the control
- CreatureIdleState: alien creature moving in only one direction 
- CreatureMoveState: alien creatures moving in both x and y axis
- BossIdleState: Boss when being in just one place
- BossMoveState: Boss when moving up and down randomly
- BossChargeState: Boss warns to charge into the player and then charges into the player direction
- BossDestroyState: Boss is destroyed and about to die
- PlayState: All the game-play happens here from space-ship generation to boss fight
- StartState: The first page when enters the game
- GameOverState: The player is dead and the game is over
- VictoryState: The boss is killed and the player has won
#### Technologies Used
- Lua
- Love2d
#### Controls
- Move Left: ← or 'a'
- Move Right: → or 'd'
- Move Up: ↑ or 'w'
- Move Down: ↓ or 's'
#### Features
- Player-controlled spaceship
- Asteroid Obstacles
- Alien Creatures with laser
- Score tracking
- Difficulty increases with time
- Bullet count increases with increase in difficulty
- Health spawn 
- CheckPoint
- Boss Battle
#### Acknowledgements
- Special thanks to [CS50x](https://cs50.harvard.edu/x/) for the amazing course!
#### Contact
For inquiries, please contact [adarshmaurya500@gmail.com](mailto:adarshmaurya500@gmail.com).
