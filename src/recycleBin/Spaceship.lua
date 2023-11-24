--[[
    Spaceship Class
    Author: Adarsh Maurya
]]

Spaceship = Class{}

function Spaceship:init()
    self.x = VIRTUAL_WIDTH / 2 - 96
    self.y = VIRTUAL_HEIGHT / 2 - 96

    -- self.width = self.image:getWidth()
    -- self.height = self.image:getHeight()

    self.width = 96
    self.height = 96

    self.dx = 0
    self.dy = 0
end

-- --[[
--     AABB collision that expects a pipe, which will have an X and Y and reference
--     global pipe width and height values.
-- ]]
-- function Spaceship:collides(pipe)
--     -- the 2's are left and top offsets
--     -- the 4's are right and bottom offsets
--     -- both offsets are used to shrink the bounding box to give the player
--     -- a little bit of leeway with the collision
--     if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
--         if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
--             return true
--         end
--     end

--     return false
-- end

function Spaceship:update(dt)
    -- keyboard input
    -- if love.keyboard.isDown('left') then
    --     self.x = self.x - PLAYER_MOVE_SPEED * dt
        
    --     if self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then 
    --         self.x = MAP_RENDER_OFFSET_X + TILE_SIZE
    --         self.bumped = true
    --     end
    -- elseif love.keyboard.isDown('right') then
    --     self.x = self.x + PLAYER_MOVE_SPEED * dt

    --     if self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
    --         self.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.width
    --         self.bumped = true
    --     end
    -- elseif love.keyboard.isDown('up') then
    --     self.y = self.y - PLAYER_MOVE_SPEED * dt

    --     if self.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2 then 
    --         self.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2
    --         self.bumped = true
    --     end
    -- elseif love.keyboard.isDown('down') then
    --     self.y = self.y + PLAYER_MOVE_SPEED * dt

    --     local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
    --         + MAP_RENDER_OFFSET_Y - TILE_SIZE

    --     if self.y + self.height >= bottomEdge then
    --         self.y = bottomEdge - self.height
    --         self.bumped = true
    --     end
    -- end
    if love.keyboard.isDown('w') then
        self.dy = -SPACESHIP_SPEED
    elseif love.keyboard.isDown('s') then
        self.dy = SPACESHIP_SPEED
    elseif love.keyboard.isDown('a') then
        self.dx = -SPACESHIP_SPEED
    elseif love.keyboard.isDown('d') then
        self.dx = SPACESHIP_SPEED
    else
        self.dy = 0
        self.dx = 0
    end

    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Spaceship:render()
    love.graphics.draw(gTextures['spaceship'],
        self.x, self.y,
    0,
    96 / 192, 96 / 192
    )
end