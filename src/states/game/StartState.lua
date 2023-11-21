StartState = Class{__includes = BaseState}

function StartState:init()
    gSounds['intro-music']:setLooping(true)
    -- gSounds['music']:setVolume(0.5)
    gSounds['intro-music']:play()
end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['intro-music']:stop()
        gStateMachine:change('play')
    end
end

function StartState:render()
    love.graphics.draw(gTextures['start-background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['start-background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['start-background']:getHeight())

    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(34/255, 34/255, 34/255, 1)
    love.graphics.printf('Space 50', 2, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(175/255, 53/255, 42/255, 1)
    love.graphics.printf('Space 50', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 64, VIRTUAL_WIDTH, 'center')
end