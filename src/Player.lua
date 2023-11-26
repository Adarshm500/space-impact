Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    -- self.canChangeRoom = true
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local yOffset = 60
    local xOffset = 50
 
    local selfY, selfHeight = self.y + yOffset, self.height - 2 * yOffset

    local selfX, selfWidth = self.x + xOffset, self.width - 2 * xOffset
    
    return not (selfX + selfWidth < target.x or
                selfX > target.x + target.width or
                selfY + selfHeight < target.y or
                selfY > target.y + target.height)  
end

function Player:render()
    Entity.render(self)
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end