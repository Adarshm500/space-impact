Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.deathTime = 0
    self.remove = false
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local yOffset = 40
    local xOffset = 40
 
    local selfY, selfHeight = self.y + yOffset, self.height - 2 * yOffset

    local selfX, selfWidth = self.x + xOffset, self.width - 2 * xOffset
    
    return not (selfX + selfWidth < target.x or
                selfX > target.x + target.width or
                selfY + selfHeight < target.y or
                selfY > target.y + target.height)  
end

function Player:render()
    Entity.render(self)
end