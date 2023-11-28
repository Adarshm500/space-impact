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
                frames = {1, 2, 3, 4},
                interval = 0.1,
                texture = 'spaceship-idle'
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
                frames = {1, 2, 3, 4},
                interval = 0.05,
                texture = 'spaceship-idle'
            },
        --     ['sword-left'] = {
        --         frames = {13, 14, 15, 16},
        --         interval = 0.05,
        --         looping = false,
        --         texture = 'character-swing-sword'
        --     },
        }
    },
    ['creature_1'] = {
        animations = {
            ['move'] = {
                frames = {1, 2},
                interval = 0.2,
                texture = 'creatures'
            },
            ['idle'] = {
                frames = {1, 2},
                interval = 0.2,
                texture = 'creatures'
            }
        }
    },
    ['creature_2'] = {
        animations = {
            ['move'] = {
                frames = {3, 4},
                interval = 0.2,
                texture = 'creatures'
            },
            ['idle'] = {
                frames = {3, 4},
                interval = 0.2,
                texture = 'creatures'
            }
        }
    },    
    ['creature_3'] = {
        animations = {
            ['move'] = {
                frames = {7, 8},
                interval = 0.2,
                texture = 'creatures'
            },
            ['idle'] = {
                frames = {7, 8},
                interval = 0.2,
                texture = 'creatures'
            }
        }
    },    
    ['creature_4'] = {
        animations = {
            ['move'] = {
                frames = {11, 12},
                interval = 0.2,
                texture = 'creatures'
            },
            ['idle'] = {
                frames = {11, 12},
                interval = 0.2,
                texture = 'creatures'
            }
        }
    },    
    ['creature_5'] = {
        animations = {
            ['move'] = {
                frames = {19, 20},
                interval = 0.2,
                texture = 'creatures'
            },
            ['idle'] = {
                frames = {19, 20},
                interval = 0.2,
                texture = 'creatures'
            }
        }
    },    
    ['creature_6'] = {
        animations = {
            ['move'] = {
                frames = {23, 24},
                interval = 0.2,
                texture = 'creatures'
            },
            ['idle'] = {
                frames = {23, 24},
                interval = 0.2,
                texture = 'creatures'
            }
        }
    },    
    ['creature_7'] = {
        animations = {
            ['move'] = {
                frames = {25, 26},
                interval = 0.2,
                texture = 'creatures'
            },
            ['idle'] = {
                frames = {25, 26},
                interval = 0.2,
                texture = 'creatures'
            }
        }
    },    
    ['creature_8'] = {
        animations = {
            ['move'] = {
                frames = {33, 34},
                interval = 0.2,
                texture = 'creatures'
            },
            ['idle'] = {
                frames = {33, 34},
                interval = 0.2,
                texture = 'creatures'
            }
        }
    },    
    ['creature_9'] = {
        animations = {
            ['move'] = {
                frames = {51, 52},
                interval = 0.2,
                texture = 'creatures'
            },
            ['idle'] = {
                frames = {17, 18},
                interval = 0.2,
                texture = 'creatures'
            }
        }
    },    
    ['creature_10'] = {
        animations = {
            ['move'] = {
                frames = {61, 62},
                interval = 0.2,
                texture = 'creatures'
            },
            ['idle'] = {
                frames = {61, 62},
                interval = 0.2,
                texture = 'creatures'
            }
        }
    },
}