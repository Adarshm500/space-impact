--[[
    CS50x Final Project
    Author: Adarsh Maurya

    -- Dependencies --
]]

--
-- libraries
--
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/Background'
require 'src/constants'
require 'src/Entity'
require 'src/entity_defs'
require 'src/Fire'
require 'src/Player'
require 'src/StateMachine'
require 'src/Util'
require 'src/GameObject'
require 'src/game_objects'
require 'src/Creature'
require 'src/CreatureFire'
require 'src/Score'
require 'src/Boss'

-- world
require 'src/world/Level'

require 'src/states/BaseState'

-- entity states
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityMoveState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerMoveState'

require 'src/states/entity/creature/CreatureIdleState'
require 'src/states/entity/creature/CreatureMoveState'

require 'src/states/entity/boss/BossIdleState'
require 'src/states/entity/boss/BossMoveState'

-- game states
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
require 'src/states/game/GameOverState'
gSounds = {
    ['shoot'] = love.audio.newSource('sounds/shoot4.wav', 'static'),
    ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
    ['music'] = love.audio.newSource('sounds/music.mp3', 'static'),
    ['intro-music'] = love.audio.newSource('sounds/menu.wav', 'static'),
}

gTextures = {
    ['start-background'] = love.graphics.newImage('graphics/start_background.png'),
    ['starfield-1'] = love.graphics.newImage('graphics/starfield_1.png'),
    ['starfield-2'] = love.graphics.newImage('graphics/starfield_2.png'),
    ['starfield-3'] = love.graphics.newImage('graphics/starfield_3.png'),
    ['spaceship-idle'] = love.graphics.newImage('graphics/Fighter/Attack_1.png'),
    ['spaceship-turn-up'] = love.graphics.newImage('graphics/Fighter/Turn_up.png'),
    ['spaceship-turn-down'] = love.graphics.newImage('graphics/Fighter/Turn_down.png'),
    ['spaceship-move-left'] =  love.graphics.newImage('graphics/Fighter/Move.png'),
    ['spaceship-move-right'] =  love.graphics.newImage('graphics/Fighter/Boost.png'),
    ['fire-1'] = love.graphics.newImage('graphics/Fighter/Charge_1.png'),
    ['fire-2'] = love.graphics.newImage('graphics/Fighter/Charge_2.png'),
    ['asteroid'] = love.graphics.newImage('graphics/asteroid/asteroid.png'),
    ['explosion'] = love.graphics.newImage('graphics/asteroid/explosion.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['creatures'] = love.graphics.newImage('graphics/Creatures.png'),
    ['creature-fire'] = love.graphics.newImage('graphics/creature_fire.png'),
    ['boss'] = love.graphics.newImage('graphics/Boss.png')
}

gFrames = {
    ['spaceship-idle'] = GenerateQuads(gTextures['spaceship-idle'], 192, 192),
    ['spaceship-turn-up'] = GenerateQuads(gTextures['spaceship-turn-up'], 192, 192),
    ['spaceship-turn-down'] = GenerateQuads(gTextures['spaceship-turn-down'], 192, 192),
    ['spaceship-move-left'] = GenerateQuads(gTextures['spaceship-move-left'], 192, 192),
    ['spaceship-move-right'] = GenerateQuads(gTextures['spaceship-move-right'], 192, 192),
    ['fire-1'] = GenerateQuads(gTextures['fire-1'], 28, 28),
    ['fire-2'] = GenerateQuads(gTextures['fire-2'], 12, 12),
    ['asteroid'] = GenerateQuads(gTextures['asteroid'], 96, 96),
    ['explosion'] = GenerateQuads(gTextures['explosion'], 96, 96),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16),
    ['creatures'] = GenerateQuads(gTextures['creatures'], 48, 48),
    ['creature-fire'] = GenerateQuads(gTextures['creature-fire'], 28, 28),
    ['boss'] = GenerateQuads(gTextures['boss'], 256, 256)
}
gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    -- ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
    ['title'] = love.graphics.newFont('fonts/SpaceFont.otf', 32),
    ['score'] = love.graphics.newFont('fonts/fipps.otf'),
    ['points'] = love.graphics.newFont('fonts/Debug.otf')
}