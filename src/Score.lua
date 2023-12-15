Score = Class{}

function Score:init(points,x, y)
    self.x = x
    self.y = y
    self.points = points
    self.color = points > 0 and 'green' or 'red'
    self.timer = 0
    self.remove = false
end

function Score:update(dt)
    self.timer = self.timer + dt
    if self.timer > 0.5 then
        self.remove = true
    end
end

function Score:render()
    if self.color == 'green' then
        love.graphics.setColor(162/255, 229/255, 112/255, 1)
    else
        love.graphics.setColor(178/255, 76/255, 76/255, 1)
    end
    love.graphics.setFont(gFonts['score'])
    love.graphics.printf(tostring(self.points), self.x, self.y, 192, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['small'])
end