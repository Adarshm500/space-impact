BossChargeState = Class{__includes = EntityMoveState}

function BossChargeState:init(boss)
    self.entity = boss
    self.entity:changeAnimation('idle')

    self.entity.dx = self.entity.chargeSpeed
    self.bumped = false
    self.warning = true
    -- before charging there should be a warning
    -- need to draw a pentagon
    self.drawSpeed = 700
    self.pentagonAX = self.entity.x + 40
    self.pentagonAY = self.entity.y + self.entity.height / 2 - 50

    self.pentagonBX = self.entity.x + 40
    self.pentagonBY = self.entity.y + self.entity.height / 2 - 50

    self.pentagonCX = self.entity.x + 40
    self.pentagonCY = self.entity.y + self.entity.height / 2 + 50

    self.pentagonDX = self.entity.x + 40
    self.pentagonDY = self.entity.y + self.entity.height / 2 + 50

    self.pentagonEX = self.entity.x - 40
    self.pentagonEY = self.entity.y + self.entity.height / 2
end

function BossChargeState:update(dt)
    if self.warning then
        self.pentagonAX = self.pentagonAX - self.drawSpeed * dt
        self.pentagonDX = self.pentagonDX - self.drawSpeed * dt
        self.pentagonEX = self.pentagonEX - self.drawSpeed * dt
        if self.pentagonEX < 64 then
            self.warning = false
        end
    else
        self.bumped = false

        if self.entity.dx > 0 and self.entity.x < 0 then
            self.bumped = true
        end
    
        self.entity.x = self.entity.x - self.entity.dx * dt
    end
end

function BossChargeState:processAI(params, dt)
    if not self.warning then
        if self.bumped then
            self.entity.dx = -self.entity.chargeSpeed
        end
    
        if self.entity.dx < 0 and self.entity.x + self.entity.width > VIRTUAL_WIDTH then
            self.entity.dx = 0
            self.entity.chargeTimer = 0
            self.entity:changeState('idle')
        end
    end
end

function BossChargeState:render()
    if self.warning then
        love.graphics.setColor(214/255, 5/255, 14/255, 1)
        love.graphics.polygon("fill", 
        self.pentagonAX, self.pentagonAY, 
        self.pentagonBX, self.pentagonBY, 
        self.pentagonCX, self.pentagonCY, 
        self.pentagonDX, self.pentagonDY, 
        self.pentagonEX, self.pentagonEY)
        love.graphics.setColor(1, 1, 1, 1)
    end
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end