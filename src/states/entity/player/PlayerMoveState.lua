--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerMoveState = Class{__includes = EntityMoveState}

-- function PlayerMoveState:init(player, dungeon)
function PlayerMoveState:init(player)
    self.entity = player

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 0
    self.entity.offsetX = 0
end

function PlayerMoveState:update(dt)
    if love.keyboard.isDown('a') then
        self.entity:changeAnimation('move-left')
        self.entity.dx = -self.entity.moveSpeed
    elseif love.keyboard.isDown('d') then
        self.entity:changeAnimation('move-right')
        self.entity.dx = self.entity.moveSpeed
    elseif love.keyboard.isDown('w') then
        self.entity:changeAnimation('turn-up')
        self.entity.dy = -self.entity.moveSpeed
    elseif love.keyboard.isDown('s') then
        self.entity:changeAnimation('turn-down')
        self.entity.dy = self.entity.moveSpeed
    else
        self.entity:changeState('idle')
        self.entity.dy = 0
        self.entity.dx = 0
    end
    
    -- perform base collision detection against walls
    EntityMoveState.update(self, dt)
    
    if self.entity.dy < 0 then
        self.entity.y = math.max(-self.entity.offsetY, self.entity.y + self.entity.dy * dt)
    
    else
        self.entity.y = math.min(VIRTUAL_HEIGHT - self.entity.height + self.entity.offsetY, self.entity.y + self.entity.dy * dt)
    end

    if self.entity.dx < 0 then
        self.entity.x = math.max(-self.entity.offsetX, self.entity.x + self.entity.dx * dt)
    
    else
        self.entity.x = math.min(VIRTUAL_WIDTH - self.entity.width + self.entity.offsetX, self.entity.x + self.entity.dx * dt)
    end


    -- for k, object in pairs(self.dungeon.currentRoom.objects) do
    --     -- if we collide with a solid object then stop
    --     if self.entity:collides(object) and object.solid then
    --         -- if collision with pot then player can lift it
    --         if object.type == 'pot' and object.state == 'ground' then
    --             if love.keyboard.wasPressed('return') then
    --                 self.entity:changeState('pot-lift', object)
    --             end
    --         end
    --         if self.entity.direction == 'left' then
    --             self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
    --         elseif self.entity.direction == 'right' then
    --             self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
    --         elseif self.entity.direction == 'up' then
    --             self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
    --         elseif self.entity.direction == 'down' then
    --             self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
    --         end
    --     end
    -- end

    -- if we bumped something when checking collision, check any object collisions
    -- if self.bumped then
    --     if self.entity.direction == 'left' then
            
    --         -- temporarily adjust position into the wall, since bumping pushes outward
    --         self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
            
    --         -- check for colliding into doorway to transition
    --         for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
    --             if self.entity:collides(doorway) and doorway.open and self.entity.canChangeRoom then

    --                 -- shift entity to center of door to avoid phasing through wall
    --                 self.entity.y = doorway.y + 4
    --                 Event.dispatch('shift-left')
    --             end
    --         end

    --         -- readjust
    --         self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
    --     elseif self.entity.direction == 'right' then
            
    --         -- temporarily adjust position
    --         self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
            
    --         -- check for colliding into doorway to transition
    --         for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
    --             if self.entity:collides(doorway) and doorway.open  and self.entity.canChangeRoom then

    --                 -- shift entity to center of door to avoid phasing through wall
    --                 self.entity.y = doorway.y + 4
    --                 Event.dispatch('shift-right')
    --             end
    --         end

    --         -- readjust
    --         self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
    --     elseif self.entity.direction == 'up' then
            
    --         -- temporarily adjust position
    --         self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
            
    --         -- check for colliding into doorway to transition
    --         for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
    --             if self.entity:collides(doorway) and doorway.open  and self.entity.canChangeRoom then

    --                 -- shift entity to center of door to avoid phasing through wall
    --                 self.entity.x = doorway.x + 8
    --                 Event.dispatch('shift-up')
    --             end
    --         end

    --         -- readjust
    --         self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
    --     else
            
    --         -- temporarily adjust position
    --         self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
            
    --         -- check for colliding into doorway to transition
    --         for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
    --             if self.entity:collides(doorway) and doorway.open  and self.entity.canChangeRoom then

    --                 -- shift entity to center of door to avoid phasing through wall
    --                 self.entity.x = doorway.x + 8
    --                 Event.dispatch('shift-down')
    --             end
    --         end

    --         -- readjust
    --         self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
    --     end
    -- end
end

function PlayerMoveState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY),
    0,
    96 / 192, 96 / 192)
end
