PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        moveSpeed = ENTITY_DEFS['player'].moveSpeed,
        
        x = 0,
        y = VIRTUAL_HEIGHT / 2 - 48,
        
        width = 96,
        height = 96,

        health = 6,

        -- rendering and collision offset for spaced sprites
        offsetY = -48
    }

    self.level = Level(self.player)
    
    self.player.stateMachine = StateMachine {
        ['move'] = function() return PlayerMoveState(self.player) end,
        ['idle'] = function() return PlayerIdleState(self.player) end,
    }
    self.player:changeState('idle')

    gSounds['music']:setLooping(true)
    gSounds['music']:setVolume(0.5)
    gSounds['music']:play()
end

function PlayState:update(dt)
    -- self.timer = self.timer + dt
    if love.keyboard.wasPressed('escape') then
        gSounds['music']:stop()
        gStateMachine:change('start')
    end

    self.level:update(dt)
    
end

function PlayState:render()

    -- render the level
    love.graphics.push()
    self.level:render()
    love.graphics.pop()

    -- following code snippet is adapted from gd50
    -- draw player hearts, top of screen
    local healthLeft = self.player.health
    local heartFrame = 1

    for i = 1, 3 do
        if healthLeft > 1 then
            heartFrame = 5
        elseif healthLeft == 1 then
            heartFrame = 3
        else
            heartFrame = 1
        end

        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][heartFrame],
            (i) * 20, 2)
        
        healthLeft = healthLeft - 2
    end

    love.graphics.setColor(244/255, 255/255, 113/255, 1)
    love.graphics.setFont(gFonts['score'])
    love.graphics.printf("Score ", 0, 8, VIRTUAL_WIDTH - 96, 'right')
    love.graphics.printf(self.level.score, 0, 8, VIRTUAL_WIDTH - 16, 'right')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['small'])

end