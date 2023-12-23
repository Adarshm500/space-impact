Boss = Class{__includes = Entity}

function Boss:init(def)
    Entity.init(self, def)
    self.explosionTimer = 0
    self.chargeTimer = 0
    self.fireTimer = 0
    self.chargeSpeed = 1000
    self.deathTime = 0
    self.remove = false
end

function Boss:update(dt)
    self.fireTimer = self.fireTimer + dt
    self.explosionTimer = self.explosionTimer + dt
    self.chargeTimer = self.chargeTimer + dt
    Entity.update(self, dt)
end

function Boss:collides(target)
    local yOffset = 40
    local xOffset = 40
 
    local selfY, selfHeight = self.y + yOffset, self.height - 2 * yOffset

    local selfX, selfWidth = self.x + xOffset, self.width - 2 * xOffset
    
    return not (selfX + selfWidth < target.x or
                selfX > target.x + target.width or
                selfY + selfHeight < target.y or
                selfY > target.y + target.height)
end

function Boss:render()
    Entity.render(self)
end