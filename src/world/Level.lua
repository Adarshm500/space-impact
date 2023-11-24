Level = Class{}

function Level:init(player)
    self.width = VIRTUAL_WIDTH
    self.height = VIRTUAL_HEIGHT

    -- entities in the Level
    self.entities = {}
    self:generateEntities()

    -- game objects in the level
    self.objects = {}
    self.generateObjects()

    self.player = player

    self.delayTimer = 0
end

function Level:generateEntities()
end

function Level:generateObjects()
    
end