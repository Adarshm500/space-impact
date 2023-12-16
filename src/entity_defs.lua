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
        }
    },
    ['creature_1'] = {
        animations = {
            ['idle'] = {
                frames = {1, 2},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },
    ['creature_2'] = {
        animations = {
            ['idle'] = {
                frames = {3, 4},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_3'] = {
        animations = {
            ['idle'] = {
                frames = {7, 8},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_4'] = {
        animations = {
            ['idle'] = {
                frames = {11, 12},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_5'] = {
        animations = {
            ['idle'] = {
                frames = {19, 20},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_6'] = {
        animations = {
            ['idle'] = {
                frames = {23, 24},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_7'] = {
        animations = {
            ['idle'] = {
                frames = {25, 26},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_8'] = {
        animations = {
            ['idle'] = {
                frames = {33, 34},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_9'] = {
        animations = {
            ['idle'] = {
                frames = {51, 52},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_10'] = {
        animations = {
            ['idle'] = {
                frames = {61, 62},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },
    ['boss'] = {
        animations = {
            ['idle'] = {
                frames = {1},
                texture = 'boss'
            },
        }
    }
}