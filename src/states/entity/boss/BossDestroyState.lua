BossDestroyState = Class{__includes = EntityMoveState}

function BossDestroyState:init(boss)
    self.entity = boss
    self.entity:changeAnimation('destroy')

    self.entity.dx = 0
    self.timer = 0
    self.entity.charging = false
end

function BossDestroyState:update(dt)
    self.timer = self.timer + dt
    if self.timer > 3 then
        self.entity.death = true
    end
end

function BossDestroyState:processAI(params,dt)
    
end

function BossDestroyState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end