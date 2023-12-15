EntityMoveState = Class{__includes = BaseState}

function EntityMoveState:init(entity)
    self.entity = entity
    self.entity:changeAnimation('move-left')
end

function EntityMoveState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end