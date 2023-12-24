--[[
    GD50

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
ProgressBar = Class{}

function ProgressBar:init(def)
    self.x = def.x
    self.y = def.y
    
    self.width = def.width
    self.height = def.height
    
    self.color = def.color

    self.value = def.value
    self.max = def.max
    self.remove = false
end

function ProgressBar:setMax(max)
    self.max = max
end

function ProgressBar:setValue(value)
    self.value = value
end

function ProgressBar:update(entity, dt)
    self.x = entity.x
    self.y = entity.y
    self.value = entity.health
end

function ProgressBar:render()
    -- multiplier on width based on progress
    local renderWidth = (self.value / self.max) * self.width

    -- draw main bar, with calculated width based on value / max
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
    
    if self.value > 0 then
        love.graphics.rectangle('fill', self.x, self.y, renderWidth, self.height, 3)
    end

    -- draw outline around actual bar
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height, 3)
    love.graphics.setColor(1, 1, 1, 1)
end