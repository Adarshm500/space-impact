PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 0
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)   
    if not self.entity.remove then 
        if love.keyboard.isDown('a') or love.keyboard.isDown('d') or
            love.keyboard.isDown('w') or love.keyboard.isDown('s') or love.keyboard.isDown('left') or love.keyboard.isDown('right') or
            love.keyboard.isDown('up') or love.keyboard.isDown('down') then
            self.entity:changeState('move')
        end
    end
end

function PlayerIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY),
        0,
        96 / 192, 96 / 192)
end