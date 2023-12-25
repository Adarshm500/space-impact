BossIdleState = Class{__includes = EntityIdleState}

function BossIdleState:enter(params)
    self.waitDuration = 0
    self.waitTimer = 0
    self.entity.charging = false
end

function BossIdleState:update(dt)
end

function BossIdleState:processAI(params, dt)
    if self.waitDuration == 0 then
        self.waitDuration = math.random(5)
    else
        self.waitTimer = self.waitTimer + dt

        if self.waitTimer > self.waitDuration then
            self.entity:changeState('move')
        end
    end
end

function BossIdleState:render(dt)
    -- print(self.entity)
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end