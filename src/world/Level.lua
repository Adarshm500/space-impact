Level = Class{}

function Level:init(player)
    self.width = VIRTUAL_WIDTH
    self.height = VIRTUAL_HEIGHT

    -- entities in the Level
    self.entities = {}
    self:generateEntities()

    -- game objects in the level
    self.objects = {}
    self:generateObjects()

    self.player = player
    self.fires = {}

    self.background = Background()
    
    self.fireTimer = 0
    for i = 1, 2 do
        self.fire = Fire(self.player.x , self.player.y + (i - 1) * 4)
        self.fireTimer = 0
        -- inititate the lasers
        table.insert(self.fires, self.fire)
    end

    -- timer for animation before removing objects and entities
    self.delayTimer = 0
end

function Level:generateEntities()
end

function Level:generateObjects()
    -- init at random height
    local asteroidY = math.random(0, VIRTUAL_HEIGHT - 96)
    local asteroid = GameObject {
        animations = GAME_OBJECT_DEFS['asteroid'].states,
        moveSpeed = GAME_OBJECT_DEFS['asteroid'].moveSpeed,

        type = GAME_OBJECT_DEFS['asteroid'].type,
        x = VIRTUAL_WIDTH - 96 ,
        y = asteroidY,

        width = 96,
        height = 96,

        health = 10,
    }

    asteroid:changeState('move')

    asteroid.onCollide = function()
        if asteroid.state == 'move' then
            asteroid:changeState('destroy')
            -- shift the asteroid to ahead of itself because destroy is smaller than asteroid
            asteroid.y = asteroid.y + 30
            asteroid.x = asteroid.x + 20

            asteroid.moveSpeed = 0

            gSounds['explosion']:play()

            -- asteroid:damage(1)

            -- if asteroid.health == 0 then
                asteroid.remove = true
            -- end

        end
    end

    table.insert(self.objects, asteroid)
end

function Level:update(dt)
    self.fireTimer = self.fireTimer + dt

    self.player:update(dt)

    -- after every 0.2 seconds init a fire
    if self.fireTimer > 0.2 then
        for i = 1,2 do
            self.fire = Fire(self.player.x, self.player.y + (i - 1) * 4)
            table.insert(self.fires, self.fire)
            self.fireTimer = 0
        end
    end

    -- randomly init asteroids at random location and random speed
    if math.random(20) == 1 then
        local asteroidY = math.random(0, VIRTUAL_HEIGHT - 96)
        local asteroidSpeed = math.random(100, 300)
        local asteroid = GameObject {
            animations = GAME_OBJECT_DEFS['asteroid'].states,
            moveSpeed = asteroidSpeed,
    
            type = GAME_OBJECT_DEFS['asteroid'].type,
            x = VIRTUAL_WIDTH + 96 ,
            y = asteroidY,
    
            width = 96,
            height = 96,
    
            health = 8,
        }
    
        asteroid:changeState('move')
        
        asteroid.onCollide = function()
            if asteroid.state == 'move' then
                asteroid:changeState('destroy')
                -- shift the asteroid to ahead of itself because destroy is smaller than asteroid
                asteroid.y = asteroid.y + 30
                asteroid.x = asteroid.x + 20

                asteroid.moveSpeed = 0

                gSounds['explosion']:play()

                asteroid.remove = true

            end
        end

        table.insert(self.objects, asteroid)
    end

    -- update the lasers
    for k, fire in pairs(self.fires) do
        fire:update(dt)

        -- remove the fires crossing the right boundary
        if fire.x > VIRTUAL_WIDTH then
            table.remove(self.fires, k)
        end
    end

    -- table to keep updating the object and remove the ones needed to remove
    local newObjects = {}

    for k, object in pairs(self.objects) do
        object:update(dt)
        -- check collision with player
        if self.player:collides(object) then
            object:onCollide()
        end
        
        -- check collision with lasers
        for k, fire in pairs(self.fires) do
            if object.type == 'asteroid' and object.state == 'destroy' then
                break
            end
            if fire:collides(object) then
                object:onCollide()
                table.remove(self.fires, k)
            end
        end

        -- add destruction effect to the asteroid
        if (object.remove) or (object.removing) then
            -- include a shatter effect before disappearance for pot
            if object.type == 'asteroid' then
                object.remove = false
                object.removing = true
                -- wait for some time before setting the object to remove
                object.timer = object.timer + dt
                object.onCollide()
                if object.timer > 0.7 then
                    -- removingPot = false
                    object.removing = false
                    object.remove = true
                end
            end
        end

        -- remove the flagged to remove objects
        if not object.remove then
            table.insert(newObjects, object)
        end
    end

    self.objects = newObjects

    self.background:update(dt)
end

function Level:render()
    self.background:render()

    self.player:render()

    -- render the lasers
    for k, fire in pairs(self.fires) do
        fire:render()
    end

    -- render entities

    -- render objects
    for k, object in pairs(self.objects) do
        object:render()
    end
end