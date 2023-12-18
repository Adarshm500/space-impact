PlayerMoveState = Class{__includes = EntityMoveState}

function PlayerMoveState:init(player)
    self.entity = player

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 0
    self.entity.offsetX = 0
    self.entity:changeAnimation('move-left')
end

function PlayerMoveState:update(dt)
    if not self.entity.remove then
        if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
            self.entity:changeAnimation('move-left')
            self.entity.dx = -self.entity.moveSpeed
        elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
            self.entity:changeAnimation('move-right')
            self.entity.dx = self.entity.moveSpeed
        elseif love.keyboard.isDown('w') or love.keyboard.isDown('up') then
            self.entity:changeAnimation('turn-up')
            self.entity.dy = -self.entity.moveSpeed
        elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
            self.entity:changeAnimation('turn-down')
            self.entity.dy = self.entity.moveSpeed
        else
            self.entity:changeState('idle')
            self.entity.dy = 0
            self.entity.dx = 0
        end 
    else
        self.entity.dy = 0
        self.entity.dx = 0
    end

    -- perform base collision detection against walls
    EntityMoveState.update(self, dt)
    
    if self.entity.dy < 0 then
        self.entity.y = math.max(-self.entity.offsetY, self.entity.y + self.entity.dy * dt)
    
    else
        self.entity.y = math.min(VIRTUAL_HEIGHT - self.entity.height + self.entity.offsetY, self.entity.y + self.entity.dy * dt)
    end

    if self.entity.dx < 0 then
        self.entity.x = math.max(-self.entity.offsetX, self.entity.x + self.entity.dx * dt)
    
    else
        self.entity.x = math.min(VIRTUAL_WIDTH - self.entity.width + self.entity.offsetX, self.entity.x + self.entity.dx * dt)
    end

    -- if self.entity.remove then
    --     self.entity:changeAnimation('destroy')
    -- end
end

function PlayerMoveState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY),
    0,
    96 / 192, 96 / 192)
end
