Creature = Class{__includes = Entity}

function Creature:init(def)
    Entity.init(self, def)
    self.fireTimer = 0
end

function Creature:update(dt)
    self.fireTimer = self.fireTimer + dt
    Entity.update(self, dt)
end

function Creature:collides(target)
    local yOffset = 0
    local xOffset = 0
 
    local selfY, selfHeight = self.y + yOffset, self.height - 2 * yOffset

    local selfX, selfWidth = self.x + xOffset, self.width - 2 * xOffset
    
    return not (selfX + selfWidth < target.x or
                selfX > target.x + target.width or
                selfY + selfHeight < target.y or
                selfY > target.y + target.height)  
end

function Creature:render()
    Entity.render(self)
end