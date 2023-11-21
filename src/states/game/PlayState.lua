PlayState = Class{__includes = BaseState}

local backgroundScroll = 0
function PlayState:init()
    print('PlayState-init')
    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        moveSpeed = ENTITY_DEFS['player'].moveSpeed,
        
        x = 0,
        y = VIRTUAL_HEIGHT / 2 - 48,
        
        width = 96,
        height = 96,

        -- health = 6,

        -- rendering and collision offset for spaced sprites
        offsetY = -48
    }
    
    self.player.stateMachine = StateMachine {
        ['move'] = function() return PlayerMoveState(self.player) end,
        ['idle'] = function() return PlayerIdleState(self.player) end,
    }
    self.player:changeState('idle')

    -- spaceship = Spaceship()
    gSounds['music']:setLooping(true)
    -- gSounds['music']:setVolume(0.5)
    gSounds['music']:play()
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        gSounds['music']:stop()
        gStateMachine:change('start')
    end

    -- scroll our background and ground, looping back to 0 after a certain amount
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    -- spaceship:update(dt)
    self.player:update(dt)

end

function PlayState:render()
    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()
    
    love.graphics.draw(gTextures['background'], 
        -- draw at coordinates 0, 0
        -backgroundScroll, 0, 
        -- no rotation
        0)

    -- for k, entity in pairs(self.entities) do
    --     if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    -- end

    self.player:render()
        
    -- spaceship:render()
end