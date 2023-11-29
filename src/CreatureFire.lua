CreatureFire = Class{}

function CreatureFire:init(creatureX, creatureY)
    self.x = creatureX
    self.y = creatureY + 20
    self.width = 28
    self.height = 28
    self.dx = -150
    self.remove = false
end

function CreatureFire:update(dt)
    if self.x + self.width < 0 then 
        self.remove = true
    end
    self.x = self.x + self.dx * dt
end

function CreatureFire:collides(target)
    local yOffset = 27
    local xOffset = 27
 
    local selfY, selfHeight = self.y + yOffset, self.height - 2 * yOffset

    local selfX, selfWidth = self.x + xOffset, self.width - 2 * xOffset
    
    return not (selfX + selfWidth < target.x or
                selfX > target.x + target.width or
                selfY + selfHeight < target.y or
                selfY > target.y + target.height)     
end

function CreatureFire:render()
    love.graphics.draw(gTextures['creature-fire'], self.x, self.y, 
    0, 
    16 / 24, 16 / 24)
end