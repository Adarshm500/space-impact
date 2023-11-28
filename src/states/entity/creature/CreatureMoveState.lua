CreatureMoveState = Class{__includes = EntityMoveState}

function CreatureMoveState:init(creature)
    self.entity = creature
    if math.random(2) == 1 then
        self.entity.direction = 'up'
    else
        self.entity.direction = 'down'
    end
    self.entity:changeAnimation('move')

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

    -- keeps track of whether we just hit a wall
    self.bumped = false
end

function CreatureMoveState:update(dt)
    self.bumped = false

    if self.entity.direction == 'up' then
        self.entity.y = self.entity.y - self.entity.moveSpeed * dt

        if self.entity.y <= 0 then
            self.bumped = true
        end
    elseif self.entity.direction == 'down' then
        self.entity.y = self.entity.y + self.entity.moveSpeed * dt

        if self.entity.y >= VIRTUAL_HEIGHT - self.entity.height then
            self.bumped = true
        end       
    end

    self.entity.x = self.entity.x - self.entity.moveSpeed * dt
    
    -- EntityMoveState.update(self, dt)
end

function CreatureMoveState:processAI(params, dt)
    local directions = {'up', 'down'}
    
    if self.moveDuration == 0 or self.bumped then
        
        -- set an initial move duration and direction
        self.moveDuration = math.random(5)
        self.entity.direction = directions[math.random(#directions)]
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0

        -- chance to go idle
        if math.random(3) == 1 then
            self.entity:changeState('idle')
        else
            self.moveDuration = math.random(5)
            self.entity.direction = directions[math.random(#directions)]
        end
    end

    self.movementTimer = self.movementTimer + dt
end

function CreatureMoveState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end