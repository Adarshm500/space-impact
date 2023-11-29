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
    self.creatureFires = {}
    self.creatureFireTimer = 0

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
    self:generateCreatures()
end

function Level:generateObjects()
    -- init an asteroid at random height
    self:generateAsteroids()
end

-- generate Asteroids
function Level:generateAsteroids()
    -- random speed and y
    local asteroidSpeed = math.random(100, 200)
    local asteroidY = math.random(0, VIRTUAL_HEIGHT - 96)
    local asteroid = GameObject {
        animations = GAME_OBJECT_DEFS['asteroid'].states,
        moveSpeed = asteroidSpeed,

        type = GAME_OBJECT_DEFS['asteroid'].type,
        x = VIRTUAL_WIDTH + 96 ,
        y = asteroidY,

        width = 96,
        height = 96,

        health = 4,
    }

    asteroid:changeState('move')

    asteroid.onCollide = function()
        if asteroid.state == 'move' then
            if self.player:collides(asteroid) then
                asteroid.health = 0
            else
                asteroid:damage(1)
            end
            if asteroid.health == 0 then
                gSounds['explosion']:play()
                asteroid:changeState('destroy')
                asteroid.remove = true
            end
        end
    end

    table.insert(self.objects, asteroid)
end

-- generateCreatures
function Level:generateCreatures()
    --randomly select a creature
    creature_type = tostring(math.random(1, 10))
    local creature = Creature {
        animations = ENTITY_DEFS['creature_'..creature_type].animations,
        moveSpeed = math.random(50, 80),
        
        x = VIRTUAL_WIDTH + 48,
        y = math.random(0, VIRTUAL_HEIGHT - 48),

        width = 48,
        height = 48,

        health = 8,

        -- rendering and collision offset for spaced sprites
        -- offsetY = -48
    }

    table.insert(self.entities, creature)

    creature.stateMachine = StateMachine{
        ['move'] = function() return CreatureMoveState(creature) end,
        ['idle'] = function() return CreatureIdleState(creature) end
    }
    creature:changeState('move')
end

function Level:update(dt)
    self.fireTimer = self.fireTimer + dt

    -- randomly init asteroids at random location and random speed
    if math.random(200) == 1 then
        self:generateAsteroids()
    end

    if math.random(200) == 1 then
        self:generateCreatures()
    end

    self.player:update(dt)

    if self.player.health < 1 then
        gStateMachine:change('game-over')  
    end

    -- table to remove the non-active fires
    local newFires = {}
    -- update the lasers
    for k, fire in pairs(self.fires) do
        fire:update(dt)

        -- check collision with the entities
        for k, entity in pairs(self.entities) do
            -- collision effect of player fires with entities
            if fire:collides(entity) then
                entity:damage(2)
                fire.remove = true
            end
        end

        -- check collision with the creatureFires
        for k, creatureFire in pairs(self.creatureFires) do
            if fire:collides(creatureFire) then
                creatureFire.remove = true
                fire.remove = true
            end
        end

        if not fire.remove then
            table.insert(newFires, fire)
        end
    end

    self.fires = newFires

    -- after every 0.2 seconds init a fire
    if self.fireTimer > 0.2 then
        for i = 1,2 do
            self.fire = Fire(self.player.x, self.player.y + (i - 1) * 4)
            table.insert(self.fires, self.fire)
            self.fireTimer = 0
        end
    end

    -- table to keep updating the object and remove the ones needed to remove
    local newEntities = {}

    for k, entity in pairs(self.entities) do
        if entity.health <= 0 then
            entity.dead = true
        elseif not entity.dead then
            entity:processAI({level = self}, dt)
            entity:update(dt)
            if entity.fireTimer > 0.2 then
                local fire = CreatureFire(entity.x, entity.y)
                table.insert(self.creatureFires, fire)
                entity.fireTimer = 0
            end
        end

        if self.player:collides(entity) then
            entity.dead = true
            self.player:damage(2)
        end
        
        -- remove the flagged to remove objects
        if not entity.dead then
            table.insert(newEntities, entity)
        end
    end

    -- update the entities table to only include the non-dead entities
    self.entities = newEntities

    -- table to keep updating the object and remove the ones needed to remove
    local newObjects = {}

    for k, object in pairs(self.objects) do
        object:update(dt)
        -- check collision with player
        -- if asteroid then only collides when in move state
        if self.player:collides(object) then
            if object.type == 'asteroid' then
                if object.state == 'move' then
                    object:onCollide()
                    self.player:damage(2)
                end
            else
                object:onCollide()
            end
        end
        
        -- check collision with lasers
        for k, fire in pairs(self.fires) do
            if object.type == 'asteroid' and object.state == 'destroy' then
                break
            end
            if fire:collides(object) then
                object:onCollide()
                fire.remove = true
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

    -- update the objects table with only non-destroyed objects
    self.objects = newObjects

    -- table to keep updating the object and remove the ones needed to remove
    local newCreatureFires = {}
    -- update the fires of creature
    for k, creatureFire in pairs(self.creatureFires) do
        creatureFire:update(dt)

        -- collision 
        if self.player:collides(creatureFire) then
            creatureFire.remove = true
            self.player:damage(1)
            -- table.remove(self.fires, k)
        end
        if not creatureFire.remove then
            table.insert(newCreatureFires, creatureFire)
        end
    end

    -- update the Fires table to only include the active fires
    self.creatureFires = newCreatureFires

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
    for k, entity in pairs(self.entities) do
        if not entity.dead then
            entity:render()
        end
    end
    -- render creatureFire
    for k, fire in pairs(self.creatureFires) do
        fire:render()
    end

    -- render objects
    for k, object in pairs(self.objects) do
        object:render()
    end
end