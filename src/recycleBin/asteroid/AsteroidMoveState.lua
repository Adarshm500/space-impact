AsteroidMoveState = Class{__includes = EntityMoveState}

function AsteroidMoveState:enter(params)
    self.entity.dx = -self.entity.moveSpeed
    self.entity.dy = 0

    self.entity.angularVelocity = math.rad(5) -- in radians
    self.entity.angle = 0
    print(self.entity.width)
    print(self.entity.height)
    print(self.entity.x)
    print(self.entity.y)
end

function AsteroidMoveState:update(dt)
    self.entity:changeAnimation('move-left')

    self.entity.x = self.entity.x + self.entity.dx * dt

    EntityMoveState.update(self, dt)
    self.entity.angle = self.entity.angle + self.entity.angularVelocity
end

function AsteroidMoveState:render()
    -- set the rotation point to middle of the asteroid
    -- local rotationPoint = { x = self.entity.x + self.entity.width / 2, y = self.entity.y + self.entity.height / 2}

    -- -- translate the rotaion point
    -- love.graphics.translate(rotationPoint.x, rotationPoint.y)

    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        self.entity.x, self.entity.y,
        self.entity.angle, 
         1, 1,
        self.entity.width / 2 , self.entity.height / 2)

    -- -- reset the rotation point
    -- love.graphics.translate(-rotationPoint.x, -rotationPoint.y)
end