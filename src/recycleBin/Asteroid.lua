Asteroid = Class{__includes = Entity}

function Asteroid:init(def)
    Entity.init(self, def)
end

function Asteroid:update(dt)
    Entity.update(self, dt)
end

function Asteroid:render()
    Entity.render(self)
end