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

    -- variable for boss explosion
    self.explosionX = 0
    self.explosionY = 0
    self.explosionWarning = false
    self.warningBeginTimer = 0
    self.radius = 0
    -- has the circleOrigin been set?
    self.circleOriginSet = false
    self.bombX = 0
    self.bombY = 0
    self.explosionAim = false

    -- division of distance between self.bombX and player
    self.distanceDivisionX = 10
    self.distanceDivisionY = 10
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
                    self.player:damage(2)
                    self.player:goInvulnerable(2)
                end
            else
                -- collision with space-ship fire
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
        type = ENTITY_DEFS['creature_'..creature_type].type,
        
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
    ---- update the fireTimer and timer
    self.fireTimer = self.fireTimer + dt
    self.timer = self.timer + dt

    if self.score > 200 and not self.boss then
        gSounds['music']:stop()
        gSounds['battle']:setLooping(true)
        gSounds['battle']:play()
        self.boss = Boss {
            animations = ENTITY_DEFS['boss'].animations,
            moveSpeed = 50,
            type = ENTITY_DEFS['boss'].type,

            x = VIRTUAL_WIDTH - 256,
            y = math.random(0, VIRTUAL_HEIGHT - 256),

            width = 256,
            height = 256,
    
            health = 200,
        }

        table.insert(self.entities, self.boss)

        self.boss.stateMachine = StateMachine{
            ['move'] = function() return BossMoveState(self.boss) end,
            ['idle'] = function() return BossIdleState(self.boss) end,
            ['charge'] = function() return BossChargeState(self.boss) end
        }
        self.boss:changeState('move')

        self.bossHealthBar = ProgressBar {
            x = self.boss.x + 24,
            y = self.boss.y - 16,
            width = 152,
            height = 6,
            color = {r = 255/255, g = 0/255, b = 102/255},
            value = self.boss.health,
            max = 200
        }
    end

    -- if boss touches the player then player dies
    if self.boss and self.boss:collides(self.player) then
        self.player:damage(6)
    end
        
    -- randomly init asteroids at random location and random speed
    local maxDifficultyLevel = 4
    -- increase difficulty after 15 seconds
    local difficultyDelay = 25
    
    local difficultyLevel = math.min(math.floor(self.timer / difficultyDelay) + 1, maxDifficultyLevel)
    
    -- score points after alien kill
    -- change the scorepoints according to the level
    local scorePoints = 100 * difficultyLevel

    if not self.boss then
        for i = 1, difficultyLevel do
            local enemySpawnProbability = (i + 9) / 2200
            if math.random(1 / enemySpawnProbability) == 1 then
                self:generateAsteroids()
            end
    
            if math.random(1 / enemySpawnProbability) == 1 then
                self:generateCreatures()
            end
        end
    end    

    ---- update the player -----
    self.player:update(dt)

    -- if player is dead then game-over
    if self.player.health < 1 and not self.player.remove then
        -- after 2 sec change to gameover state
        gSounds['dead']:play()
        self.player.remove = true
        self.player:changeAnimation('destroy')
        self.player.deathTime = self.timer
    end
    
    if self.timer - self.player.deathTime > 3 and self.player.remove then
        gStateMachine:change('game-over')
    end

    -- if boss is dead then victory
    if self.boss and self.boss.health < 1 and not self.boss.remove then
        print('run')
        self.boss.remove = true
        self.boss:changeAnimation('destroy')
        self.boss.deathTime = self.timer
    end

    if self.boss and self.timer - self.boss.deathTime > 3 and self.boss.remove then
        gStateMachine:change('game-over')
    end

    ----- update the spaceship fires ------
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
                gSounds['boss-death']:play()
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

    ----- update the entities ---------
    -- table to keep updating the object and remove the ones needed to remove
    local newEntities = {}

    for k, entity in pairs(self.entities) do
        if entity.health <= 0 then
            entity.dead = true
            gSounds['explosion2']:play()
            if entity == self.boss then
                self.bossHealthBar.remove = true
            end
            self.score = self.score + scorePoints
            -- generate a score object to show score increase
            table.insert(self.scoreObjects, Score(scorePoints, entity.x - 48, entity.y + entity.height / 2))
            -- generate a heart randomly after entity death
            self:generateHeart(entity)
        elseif not entity.dead then
            entity:processAI({level = self}, dt)
            entity:update(dt)

            if entity.fireTimer > 0.25 and math.abs(self.player.y - entity.y) < 64 then
                local fire = CreatureFire(entity.x, entity.y + entity.height / 2)
                table.insert(self.creatureFires, fire)
                entity.fireTimer = 0
            end
        end
        entity.prevHealth = entity.health

        if self.player:collides(entity) and not entity == self.boss then
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

    ----- if it is boss then do the explosion and charge by timer
    if self.boss and self.boss.explosionTimer > 10 then
        -- first make the area reddish
        self.explosionAim = true
        self.warningBeginTimer = self.timer
        self.boss.explosionTimer = 0
    end

    -- table to keep updating the object and remove the ones needed to remove
    local newObjects = {}

    for k, object in pairs(self.objects) do
        object:update(dt)

        -- if there is explosion then run it only once
        if object.type == 'explosion' then
            if object.state == 'explode' and object.currentAnimation.timesPlayed > 0 then
                object:changeState('smoke')
            elseif object.state == 'smoke' and object.currentAnimation.timesPlayed > 0 then
                object.remove = true
            end
        end
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

    if self.bossHealthBar and not self.bossHealthBar.remove then
        self.bossHealthBar:update(self.boss, dt)
    end
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

    -- render the bosshealthbar if available
    if self.bossHealthBar and not self.bossHealthBar.remove then
        self.bossHealthBar:render()
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

    if self.explosionAim and not self.explosionWarning then
        self:explosionAiming()
    end
    
    if self.explosionWarning then
        self:explosionWarn()
    end
end

function Level:explosionAiming()
    gSounds['bomb']:play()
    love.graphics.setColor(214/255, 5/255, 14/255, 1)
    -- loop over the entities to find boss
    if self.boss then
        -- set the self.bombX and self.bombY only once
        if not self.circleOriginSet then
            local bombX = self.boss.x
            local bombY = self.boss.y + self.boss.height / 2
            
            self.bomb = GameObject {
                animations = GAME_OBJECT_DEFS['bomb'].states,
                moveSpeed = GAME_OBJECT_DEFS['bomb'].moveSpeed,
                type = GAME_OBJECT_DEFS['bomb'].type,

                x = bombX,
                y = bombY,

                width = 32,
                height = 32,

                health = 50
            }
            self.bomb:changeState('idle')
            table.insert(self.objects, self.bomb)
            self.circleOriginSet = true
        end
    end

    -- player location
    local playerX = self.player.x + self.player.width / 2
    local playerY = self.player.y + self.player.height / 2
    
    -- use the distance formula to get the distance from circle to player
    local distanceCircleToPlayerX
    local distanceCircleToPlayerY
    local speedX
    local speedY

    
    distanceCircleToPlayerX = self.bomb.x - playerX
    distanceCircleToPlayerY = self.bomb.y - playerY
    print('distanceCircleToPlayerX:  '..distanceCircleToPlayerX)
    print('distanceCircleToPlayerY:  '..distanceCircleToPlayerY)
    -- if not self.circleSpeedSet then
    speedX = distanceCircleToPlayerX / self.distanceDivisionX
    speedY = distanceCircleToPlayerY / self.distanceDivisionY
    -- if the abs(speed) is greater than the distance itself then just sutract the difference or just stop at all
        -- to code
    if math.abs(speedX) < 1 then
        -- self.distanceDivisionX = self.distanceDivisionX / 2
        self.distanceDivisionX = 10
        
    end
    if math.abs(speedY) < 1 then
        -- self.distanceDivisionY = self.distanceDivisionY / 2
        self.distanceDivisionY = 10
    end
    -- self.circleSpeedSet = true
    print('speedX:  '..speedX)
    print('speedY:  '..speedY)
    -- end
    
    self.bomb.x = math.floor(self.bomb.x - speedX)
    self.bomb.y = math.floor(self.bomb.y - speedY)
    -- love.graphics.circle('fill', self.bombX, self.bombY, 10)
    
    local distanceCircleToPlayer = math.sqrt(distanceCircleToPlayerX ^ 2 + distanceCircleToPlayerY ^ 2)
    print('distanceCircleToPlayer:  '..distanceCircleToPlayer)
    
    if distanceCircleToPlayer < 10 then
        -- reset all the values
        self.distanceDivisionX = 10
        self.distanceDivisionY = 10
        self.circleOriginSet = false
        self.explosionAim = false
        self.warningBeginTimer = self.timer
        self.explosionX = playerX
        self.explosionY = playerY
        self.explosionWarning = true
        self.bomb.remove = true
    end
end

function  Level:explosionWarn()
    -- implement dot from the boss to space-ship
    if self.radius < 10 then
        love.graphics.circle('fill', self.explosionX, self.explosionY, self.radius)
    else
        love.graphics.circle('line', self.explosionX, self.explosionY, self.radius)
    end

    -- keep incrementing the size of the circle until 256px
    if self.radius < 80 then
        self.radius = math.floor(self.radius + (self.timer - self.warningBeginTimer) * 7)
    elseif self.radius < 100 then
        self.radius = math.floor(self.radius + (self.timer - self.warningBeginTimer) * 3)
    else
        love.graphics.setColor(1, 1, 1, 1)
        self.explosionWarning = false
        self:generateExplosion(self.explosionX - self.player.width, self.explosionY - self.player.height)
    end
end

function Level:generateExplosion(x, y)
    local bossExplosion = GameObject {
        animations = GAME_OBJECT_DEFS['boss-explosion'].states,
        moveSpeed = 0,
        type = GAME_OBJECT_DEFS['boss-explosion'].type,

        x = x,
        y = y,

        width = 160,
        height = 184,

        health = 50
    }
    bossExplosion:changeState('explode')

    bossExplosion.onCollide = function()
        if bossExplosion.state == 'explode' then
            local explosionRange = 100
    
            -- Calculate the distance between the player and the explosion center
            local distanceToPlayer = math.sqrt((self.player.x - bossExplosion.x)^2 + (self.player.y - bossExplosion.y)^2)
    
            -- Check if the player is within the explosion range
            if distanceToPlayer < explosionRange then
                self.player:damage(2)
            end

            if self.boss:collides(bossExplosion) then
                self.boss:damage(10)
            end
        end
    end
    gSounds['boss_explosion']:play()

    table.insert(self.objects, bossExplosion)
    self.radius = 0
end

function Level:generateHeart(entity) 
    -- chance to generate a heart
    if math.random(4) == 1 and entity.prevHealth > 0 then
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
                gSounds['health']:play()
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