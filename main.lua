--[[
    CS50x Final Project
    Space Impact Remake

    Author: Adarsh Maurya
    adarshmaurya500@gmail.com
    
    A classic space shooter game using free art packs.

    Art pack:
    spaceship
    https://craftpix.net/freebies/free-spaceship-pixel-art-sprite-sheets/

    creatures:
    https://www.gamedevmarket.net/asset/deep-sea-creatures
    by pixel_emm

    Boss:
    https://www.gamedevmarket.net/asset/free-2d-space-shooter-pack

    asteroid:
    https://foozlecc.itch.io/void-environment-pack
    Void - Environment Pack (1.0)
    License: (Creative Commons Zero, CC0)

    background:
    https://opengameart.org/content/seamless-space-backgrounds

    Music:
    https://opengameart.org/content/cyberpunk-moonlight-sonata
]]
require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setFont(gFonts['medium'])
    love.window.setTitle('Space Impact')

    math.randomseed(os.time())
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true,
        canvas = false
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end
    }
    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end