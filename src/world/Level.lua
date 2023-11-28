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
        moveSpeed = math.random(60, 100),
        
        x = VIRTUAL_WIDTH + 48,
        y = math.random(0, VIRTUAL_HEIGHT - 48),

        width = 48,
        height = 48,

        health = 6,

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

    self.player:update(dt)

    if self.player.health < 1 then
        gStateMachine:change('game-over')  
    end

    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]

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
    end

    -- after every 0.2 seconds init a fire
    if self.fireTimer > 0.2 then
        for i = 1,2 do
            self.fire = Fire(self.player.x, self.player.y + (i - 1) * 4)
            table.insert(self.fires, self.fire)
            self.fireTimer = 0
        end
    end

    -- randomly init asteroids at random location and random speed
    if math.random(200) == 1 then
        self:generateAsteroids()
    end

    if math.random(200) == 1 then
        self:generateCreatures()
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