BACKGROUND_TYPES = {
    'starfield-1', 'starfield-2', 'starfield-3'
}

Background = Class{}

function Background:init() 
    self.scroll = 0
    self.background = BACKGROUND_TYPES[math.random(#BACKGROUND_TYPES)]
end

function Background:update(dt)
    -- scroll our background and ground, looping back to 0 after a certain amount
    self.scroll = (self.scroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
end

function Background:render()
    love.graphics.draw(gTextures[self.background],         
    -- draw at coordinates -backgroundScroll, 0
    -self.scroll, 0, 
    -- no rotation
    0)
end