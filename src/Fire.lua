Fire = Class{}

function Fire:init(playerX, playerY)
    self.x = playerX + 72
    self.y = playerY + 36
    self.width = 28
    self.height = 28
    self.dx = 200
    self.remove = false
    gSounds['shoot']:stop()
    gSounds['shoot']:setVolume(0.25)
    gSounds['shoot']:play()
end

function Fire:update(dt)
    if self.x > VIRTUAL_WIDTH then
        self.remove = true
    end
    self.x = self.x + self.dx * dt
end

function Fire:collides(target)
    local yOffset = 20
    local xOffset = 20
 
    local selfY, selfHeight = self.y + yOffset, self.height - 2 * yOffset

    local selfX, selfWidth = self.x + xOffset, self.width - 2 * xOffset
    
    return not (selfX + selfWidth < target.x or
                selfX > target.x + target.width or
                selfY + selfHeight < target.y or
                selfY > target.y + target.height)     
end

function Fire:render()
    love.graphics.draw(gTextures['fire-1'],
    self.x, self.y,
    0,
    16 / 24, 16 / 24)
end