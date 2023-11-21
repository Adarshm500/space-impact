--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

EntityMoveState = Class{__includes = BaseState}

-- function EntityMoveState:init(entity, dungeon)
function EntityMoveState:init(entity)
    self.entity = entity
    self.entity:changeAnimation('idle')

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

    -- keeps track of whether we just hit a wall
    -- self.bumped = false
end

function EntityMoveState:update(dt)
    
    -- -- assume we didn't hit a wall
    -- self.bumped = false

    -- -- boundary checking on all sides, allowing us to avoid collision detection on tiles
    -- if self.entity.direction == 'left' then
    --     self.entity.x = self.entity.x - self.entity.moveSpeed * dt
        
    --     if self.entity.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then 
    --         self.entity.x = MAP_RENDER_OFFSET_X + TILE_SIZE
    --         self.bumped = true
    --     end
    -- elseif self.entity.direction == 'right' then
    --     self.entity.x = self.entity.x + self.entity.moveSpeed * dt

    --     if self.entity.x + self.entity.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
    --         self.entity.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.entity.width
    --         self.bumped = true
    --     end
    -- elseif self.entity.direction == 'up' then
    --     self.entity.y = self.entity.y - self.entity.moveSpeed * dt

    --     if self.entity.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.entity.height / 2 then 
    --         self.entity.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.entity.height / 2
    --         self.bumped = true
    --     end
    -- elseif self.entity.direction == 'down' then
    --     self.entity.y = self.entity.y + self.entity.moveSpeed * dt

    --     local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
    --         + MAP_RENDER_OFFSET_Y - TILE_SIZE

    --     if self.entity.y + self.entity.height >= bottomEdge then
    --         self.entity.y = bottomEdge - self.entity.height
    --         self.bumped = true
    --     end
    -- end

    if love.keyboard.isDown('w') then
        self.entity.dy = -self.entity.moveSpeed
    elseif love.keyboard.isDown('s') then
        self.entity.dy = self.entity.moveSpeed
    elseif love.keyboard.isDown('a') then
        self.entity.dx = -self.entity.moveSpeed
    elseif love.keyboard.isDown('d') then
        self.entity.dx = self.entity.moveSpeed
    else
        self.entity.dy = 0
        self.entity.dx = 0
    end

    if self.entity.dy < 0 then
        self.entity.y = math.max(0, self.entity.y + self.entity.dy * dt)
    
    else
        self.entity.y = math.min(VIRTUAL_HEIGHT - self.entity.height, self.entity.y + self.entity.dy * dt)
    end

    if self.entity.dx < 0 then
        self.entity.x = math.max(0, self.entity.x + self.entity.dx * dt)
    
    else
        self.entity.x = math.min(VIRTUAL_WIDTH - self.entity.width, self.entity.x + self.entity.dx * dt)
    end
end

-- function EntityMoveState:processAI(params, dt)
--     local room = params.room
--     local directions = {'left', 'right', 'up', 'down'}

--     if self.moveDuration == 0 or self.bumped then
        
--         -- set an initial move duration and direction
--         self.moveDuration = math.random(5)
--         self.entity.direction = directions[math.random(#directions)]
--         self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
--     elseif self.movementTimer > self.moveDuration then
--         self.movementTimer = 0

--         -- chance to go idle
--         if math.random(3) == 1 then
--             self.entity:changeState('idle')
--         else
--             self.moveDuration = math.random(5)
--             self.entity.direction = directions[math.random(#directions)]
--             self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
--         end
--     end

--     self.movementTimer = self.movementTimer + dt
-- end

function EntityMoveState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY),
    0,
    96 / 192, 96 / 192)
    
    -- debug code
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end