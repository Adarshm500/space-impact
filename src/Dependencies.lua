--[[
    CS50x Final Project
    Author: Adarsh Maurya

    -- Dependencies --

    A file to organize all of the global dependencies for our project, as
    well as the assets for our game, rather than pollute our main.lua file.
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
require 'src/Hitbox'

-- world
require 'src/world/Level'

require 'src/states/BaseState'

-- entity states
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityMoveState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerMoveState'

-- game states
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
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
    ['asteroid'] = love.graphics.newImage('graphics/asteroid/asteroid.png'),
    ['explosion'] = love.graphics.newImage('graphics/Explosion.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png')
}

gFrames = {
    ['spaceship-idle'] = GenerateQuads(gTextures['spaceship-idle'], 192, 192),
    ['spaceship-turn-up'] = GenerateQuads(gTextures['spaceship-turn-up'], 192, 192),
    ['spaceship-turn-down'] = GenerateQuads(gTextures['spaceship-turn-down'], 192, 192),
    ['spaceship-move-left'] = GenerateQuads(gTextures['spaceship-move-left'], 192, 192),
    ['spaceship-move-right'] = GenerateQuads(gTextures['spaceship-move-right'], 192, 192),
    ['fire-1'] = GenerateQuads(gTextures['fire-1'], 28, 28),
    ['asteroid'] = GenerateQuads(gTextures['asteroid'], 96, 96),
    ['explosion'] = GenerateQuads(gTextures['explosion'], 32, 32),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16)
}
gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    -- ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
    ['title'] = love.graphics.newFont('fonts/SpaceFont.otf', 32),
}