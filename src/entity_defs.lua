ENTITY_DEFS = {
    ['player'] = {
        type = 'player',
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
            ['destroy'] = {
                frames = {5, 6, 7, 8, 9, 10, 11, 12},
                interval = 0.15,
                texture = 'spaceship-destroy'
            }
        }
    },
    ['creature_1'] = {
        type = 'creature',
        animations = {
            ['idle'] = {
                frames = {1, 2},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },
    ['creature_2'] = {
        type = 'creature',
        animations = {
            ['idle'] = {
                frames = {3, 4},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_3'] = {
        type = 'creature',
        animations = {
            ['idle'] = {
                frames = {7, 8},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_4'] = {
        type = 'creature',
        animations = {
            ['idle'] = {
                frames = {11, 12},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_5'] = {
        type = 'creature',
        animations = {
            ['idle'] = {
                frames = {19, 20},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_6'] = {
        type = 'creature',
        animations = {
            ['idle'] = {
                frames = {23, 24},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_7'] = {
        type = 'creature',
        animations = {
            ['idle'] = {
                frames = {25, 26},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_8'] = {
        type = 'creature',
        animations = {
            ['idle'] = {
                frames = {33, 34},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_9'] = {
        type = 'creature',
        animations = {
            ['idle'] = {
                frames = {51, 52},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },    
    ['creature_10'] = {
        type = 'creature',
        animations = {
            ['idle'] = {
                frames = {61, 62},
                interval = 0.2,
                texture = 'creatures'
            },
        }
    },
    ['boss'] = {
        type = 'boss',
        animations = {
            ['idle'] = {
                frames = {1},
                texture = 'boss'
            },
            ['destroy'] = {
                frames = {6, 7, 8, 9},
                interval = 0.15,
                texture = 'boss-destroy'
            }
        }
    }
}