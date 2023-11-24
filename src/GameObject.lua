--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def)
    self.animations = self:createAnimations(def.animations)
    -- string identifying this object type
    self.type = def.type
    
    -- whether it acts as an obstacle or not
    self.solid = def.solid
    
    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states
    
    -- dimensions
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    self.moveSpeed = def.moveSpeed

    self.health = def.health

    -- default empty collision callback
    self.onCollide = function() end

    self.destroyed = false
end

function GameObject:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture,
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

function GameObject:update(dt)
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
    self.x = self.x - self.moveSpeed * dt
end

function GameObject:damage(dmg)
    self.health = self.health - dmg
end

function GameObject:changeState(name)
    self.state = name
    self.currentAnimation = self.animations[name]
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    local anim = self.currentAnimation

    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.x), math.floor(self.y))
end