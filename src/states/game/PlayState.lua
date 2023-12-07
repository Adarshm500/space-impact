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
end