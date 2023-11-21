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
require 'src/constants'
require 'src/Entity'
require 'src/entity_defs'
require 'src/Player'
require 'src/StateMachine'
require 'src/Util'

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
    ['music'] = love.audio.newSource('sounds/music.mp3', 'static'),
    ['intro-music'] = love.audio.newSource('sounds/menu.wav', 'static')
}

gTextures = {
    ['start-background'] = love.graphics.newImage('graphics/start-background.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['spaceship-idle'] = love.graphics.newImage('graphics/Bomber/Idle.png'),
    ['spaceship-turn-up'] = love.graphics.newImage('graphics/Bomber/Turn_up.png'),
    ['spaceship-turn-down'] = love.graphics.newImage('graphics/Bomber/Turn_down.png'),
    ['spaceship-move-left'] =  love.graphics.newImage('graphics/Bomber/Move.png'),
    ['spaceship-move-right'] =  love.graphics.newImage('graphics/Bomber/Boost.png'),
}

gFrames = {
    ['spaceship-idle'] = GenerateQuads(gTextures['spaceship-idle'], 192, 192),
    ['spaceship-turn-up'] = GenerateQuads(gTextures['spaceship-turn-up'], 192, 192),
    ['spaceship-turn-down'] = GenerateQuads(gTextures['spaceship-turn-down'], 192, 192),
    ['spaceship-move-left'] = GenerateQuads(gTextures['spaceship-move-left'], 192, 192),
    ['spaceship-move-right'] = GenerateQuads(gTextures['spaceship-move-right'], 192, 192),
}
gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}