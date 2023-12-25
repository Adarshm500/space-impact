VictoryState = Class{__includes = BaseState}
function VictoryState:init()
    gSounds['battle']:stop()
    gSounds['victory-music']:setLooping(true)
    gSounds['victory-music']:play()
end

function VictoryState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['victory-music']:stop()
        gStateMachine:change('start')
    end
end

function VictoryState:render()
    love.graphics.draw(gTextures['victory-background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['victory-background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['victory-background']:getHeight())

    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(34/255, 34/255, 34/255, 1)
    love.graphics.printf('You have won', 2, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(175/255, 53/255, 42/255, 1)
    love.graphics.printf('You have won', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to Play Again', 0, VIRTUAL_HEIGHT / 2 + 64, VIRTUAL_WIDTH, 'center')
end