--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ENTITY_DEFS = {
    ['player'] = {
        moveSpeed = SPACESHIP_SPEED,
        animations = {
            ['move-left'] = {
                frames = {1},
                texture = 'spaceship-move-left'
            },
            ['move-right'] = {
                frames = {1, 2, 3, 4, 5},
                interval = 0.15,
                texture = 'spaceship-move-right'
            },
            ['turn-down'] = {
                frames = {2},
                interval = 0.15,
                texture = 'spaceship-turn-down'
            },
            ['turn-up'] = {
                frames = {2},
                interval = 0.15,
                texture = 'spaceship-turn-up'
            },
            ['idle'] = {
                frames = {1},
                texture = 'spaceship-move-left'
            },
        --     ['sword-left'] = {
        --         frames = {13, 14, 15, 16},
        --         interval = 0.05,
        --         looping = false,
        --         texture = 'character-swing-sword'
        --     },
        }
    },
    -- ['skeleton'] = {
    --     texture = 'entities',
    --     animations = {
    --         ['walk-left'] = {
    --             frames = {22, 23, 24, 23},
    --             interval = 0.2
    --         },
    --         ['walk-right'] = {
    --             frames = {34, 35, 36, 35},
    --             interval = 0.2
    --         },
    --         ['walk-down'] = {
    --             frames = {10, 11, 12, 11},
    --             interval = 0.2
    --         },
    --         ['walk-up'] = {
    --             frames = {46, 47, 48, 47},
    --             interval = 0.2
    --         },
    --         ['idle-left'] = {
    --             frames = {23}
    --         },
    --     }
    -- },
}