CreatureIdleState = Class{__includes = EntityIdleState}

function CreatureIdleState:enter(params)
    self.waitDuration = 0
    self.waitTimer = 0
end

function CreatureIdleState:update(dt)
    -- self.entity:changeState('move')
    self.entity.x = self.entity.x - self.entity.moveSpeed * dt
end

function CreatureIdleState:processAI(params, dt)
    if self.waitDuration == 0 then
        self.waitDuration = math.random(5)
    else
        self.waitTimer = self.waitTimer + dt

        if self.waitTimer > self.waitDuration then
            self.entity:changeState('move')
        end
    end
end

function CreatureIdleState:render(dt)
    -- print(self.entity)
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end