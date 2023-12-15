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
        self.fire = Fire(self.player.x , self.player.y + (i - 1) * 4, 'primary')
        self.fireTimer = 0
        -- inititate the lasers
        table.insert(self.fires, self.fire)
    end

    self.score = 0

    self.scoreObjects = {}

    -- timer for animation before removing objects and entities
    self.delayTimer = 0

    -- timer to gradually increase the difficulty with time
    self.timer = 0
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
                if not self.player.invulnerable then
                    self.player:damage(5)
                    self.player:goInvulnerable(2)
                end
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
    self.timer = self.timer + dt
    
    -- randomly init asteroids at random location and random speed
    local maxDifficultyLevel = 4
    -- increase difficulty after 15 seconds
    local difficultyDelay = 25
    
    local difficultyLevel = math.min(math.floor(self.timer / difficultyDelay) + 1, maxDifficultyLevel)
    
    -- score points after alien kill
    -- change the scorepoints according to the level
    local scorePoints = 100 * difficultyLevel
    
    for i = 1, difficultyLevel do
        local enemySpawnProbability = (i + 9) / 2200
        if math.random(1 / enemySpawnProbability) == 1 then
            self:generateAsteroids()
        end

        if math.random(1 / enemySpawnProbability) == 1 then
            self:generateCreatures()
        end
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
    if self.fireTimer > 0.17 then
        for i = 1, math.min(difficultyLevel + 1, 4) do
            local fire
            if i <= 2 then
                fire = Fire(self.player.x, self.player.y + (i - 1) * 4, 'primary')
            else
                fire = Fire(self.player.x, self.player.y + (i - 3) * 10, 'secondary')
            end
            self.fireTimer = 0
            table.insert(self.fires, fire)
        end
    end    

    -- table to keep updating the object and remove the ones needed to remove
    local newEntities = {}

    for k, entity in pairs(self.entities) do
        if entity.health <= 0 then
            entity.dead = true
            self.score = self.score + scorePoints
            -- generate a score object to show score increase
            table.insert(self.scoreObjects, Score(scorePoints, entity.x - 48, entity.y + entity.height / 2))
            -- generate a heart randomly after entity death
            self:generateHeart(entity)
        elseif not entity.dead then
            entity:processAI({level = self}, dt)
            entity:update(dt)
            if entity.fireTimer > 0.25 and math.abs(self.player.y - entity.y) < 64 then
                local fire = CreatureFire(entity.x, entity.y)
                table.insert(self.creatureFires, fire)
                entity.fireTimer = 0
            end
        end
        entity.prevHealth = entity.health

        if self.player:collides(entity) then
            entity.dead = true
            if not self.player.invulnerable then
                self.player:damage(2)
                self.player:goInvulnerable(2)
            end
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
                if object.type == 'asteroid' and object.state == 'move' then
                    fire.remove = true
                end
            end
        end

        -- add destruction effect to the asteroid
        if (object.remove) or (object.removing) then
            -- include a destruction effect before disappearance for asteroid
            if object.type == 'asteroid' then
                object.remove = false
                object.removing = true
                -- wait for some time before setting the object to remove
                object.timer = object.timer + dt
                object.onCollide()
                if object.timer > 0.7 then
                    self.score = self.score + 50
                    -- generate a score object to show score increase
                    -- local score = 
                    table.insert(self.scoreObjects, Score(50, object.x - 48, object.y + object.height / 2))

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
            if not self.player.invulnerable then
                self.player:damage(1)
                self.player:goInvulnerable(2)
            end
        end
        if not creatureFire.remove then
            table.insert(newCreatureFires, creatureFire)
        end
    end

    -- update the Fires table to only include the active fires
    self.creatureFires = newCreatureFires

    -- remove the score after two seconds
    local newScores = {}

    for k, score in pairs(self.scoreObjects) do
        score:update(dt)

        if not score.remove then
            table.insert(newScores, score)
        end
    end

    self.scoreObjects = newScores

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

    for k, score in pairs(self.scoreObjects) do
        score:render()
    end
end

function Level:generateHeart(entity) 
    -- chance to generate a heart
    if math.random(3) == 1 and entity.prevHealth > 0 then
        local heart = GameObject{
            animations = GAME_OBJECT_DEFS['heart'].states,
            moveSpeed = GAME_OBJECT_DEFS['heart'].moveSpeed,
            type = GAME_OBJECT_DEFS['heart'].type,

            x = entity.x + 24,
            y = entity.y + 24,

            width = 16,
            height = 16
        }
        heart:changeState('move')

        -- onCollide the heart should disappear and the health should increase
        heart.onCollide = function(obj)
            -- ensure that the health should increase and to the extent that it isn't beyond the 3 hearts
            if self.player:collides(heart) then
                if self.player.health < 5 then
                    self.player:damage(-2)
                elseif self.player.health == 5 then
                    self.player:damage(-1)
                end
                heart.remove = true
            end
        end
        table.insert(self.objects, heart)
    end
end