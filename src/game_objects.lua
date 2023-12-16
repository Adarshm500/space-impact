GAME_OBJECT_DEFS = {
    ['asteroid'] = {
        type = 'asteroid',
        moveSpeed = OBJECT_MOVE_SPEED,
        defaultState = 'move',
        states = {
            ['move'] = {
                frames = {1},
                texture = 'asteroid'
            },
            ['destroy'] = {
                frames = {1, 2, 3, 4, 5, 6, 7},
                interval = 0.15,
                texture = 'explosion'
            }
        },

    },
    ['heart'] = {
        type = 'heart',
        moveSpeed = OBJECT_MOVE_SPEED,
        defaultState = 'move',
        states = {
            ['move'] = {
                frames = {5},
                texture = 'hearts'
            }
        }
    },
    ['boss-explosion'] = {
        type = 'explosion',
        moveSpeed = 0,
        defaultState = 'explode',
        states = {
            ['explode'] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9},
                interval = 0.2,
                texture = 'boss-explosion'
            }
        }
    }
}