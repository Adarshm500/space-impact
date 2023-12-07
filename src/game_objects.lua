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
    -- ['creature_1'] = {
    --     type = 'creature',
    --     moveSpeed = OBJECT_MOVE_SPEED,
    --     defaultState = 'move',
    --     states = {
    --         ['idle'] = {
    --             frames = {1, 2},
    --             interval = 0.15,
    --             texture = 'creatures'
    --         },
    --         ['move'] = {
    --             frames = {1, 2},
    --             interval = 0.15,
    --             texture = 'creatures'
    --         }
    --     }
    -- }
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
    }
}