Fire = Class{}

function Fire:init(playerX, playerY)
    self.x = playerX + 72
    self.y = playerY + 36
    self.dx = 200
    self.removed = false
    gSounds['shoot']:stop()
    gSounds['shoot']:setVolume(0.2)
    gSounds['shoot']:play()
end

function Fire:update(dt)
    if self.x > VIRTUAL_WIDTH then
        self.removed = true
    end
    self.x = self.x + self.dx * dt
end

function Fire:render()
    love.graphics.draw(gTextures['fire-1'],
    self.x, self.y,
    0,
    16 / 24, 16 / 24)
end