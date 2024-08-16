

local editioncard = {
    object_type = "ConsumableType",
    key = "Editioncard",
    primary_colour = HEX("5A6997"),
    secondary_colour = HEX("654B76"),
    collection_rows = {10,10}, -- 4 pages for all code cards
    loc_txt = {
        collection = "Edition Cards",
        name = "Edition",
        label = "Edition"
    },
    shop_rate = 0.0,
    default = 'c_cry_foiledition',
    can_stack = true,
    can_divide = true
}
local editioncard_atlas = {
    object_type = "Atlas",
    key = "edition",
    path = "atlaseditions.png",
    px = 71,
    py = 95
}

local foiledition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Foiledition",
    key = "foiledition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Foil Edition',
        text = {
			"Gives {C:dark_edition}Foil{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            foil = true
            	})
    end
}
local holoedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Holoedition",
    key = "holoedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Holographic Edition',
        text = {
			"Gives {C:dark_edition}Holographic{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            holo = true
            	})
    end
}
local polychromeedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Polychromeedition",
    key = "polychromeedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Polychrome Edition',
        text = {
			"Gives {C:dark_edition}Polychrome{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            polychrome = true
            	})
    end
}
local negativeedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Negativeedition",
    key = "negativeedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Negative Edition',
        text = {
			"Gives {C:dark_edition}Negative{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            negative = true
            	})
    end
}
local phantomedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Phantomedition",
    key = "phantomedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Phantom Edition',
        text = {
			"Gives {C:dark_edition}Phantom{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            phantom = true
            	})
    end
}
local tentacleedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Tentacleedition",
    key = "tentacleedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Tentacle Edition',
        text = {
			"Gives {C:dark_edition}Tentacle{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            tentacle = true
            	})
    end
}
local krakenedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Krakenedition",
    key = "krakenedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Kraken Edition',
        text = {
			"Gives {C:dark_edition}Kraken{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            kraken = true
            	})
    end
}
local cthulhuedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Cthulhuedition",
    key = "cthulhuedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Cthulhu Edition',
        text = {
			"Gives {C:dark_edition}Cthulhu{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cthulhu = true
            	})
    end
}
local glitteredition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Glitteredition",
    key = "glitteredition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Glitter Edition',
        text = {
			"Gives {C:dark_edition}Glitter{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            bunc_glitter = true
            	})
    end
}
local balavirussquareedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Balavirussquareedition",
    key = "balavirussquare",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Balavirus [Square] Edition',
        text = {
			"Gives {C:dark_edition}Balavirus [Square]{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            bunc_balavirussquare = true
            	})
    end
}
local fluorescentedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Fluorescentedition",
    key = "fluorescentedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Fluorescent Edition',
        text = {
			"Gives {C:dark_edition}Fluorescent{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            bunc_fluorescent = true
            	})
    end
}
local shinygalvanizededition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Shinygalvanizededition",
    key = "shinygalvanizededition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Galvanized (Shiny) Edition',
        text = {
			"Gives {C:dark_edition}Galvanized (Shiny){} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            bunc_shinygalvanized = true
            	})
    end
}
local burntedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Burntedition",
    key = "burntedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Burnt Edition',
        text = {
			"Gives {C:dark_edition}Burnt{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            bunc_burnt = true
            	})
    end
}
local oppositeedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Oppositeedition",
    key = "oppositeedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Opposite Edition',
        text = {
			"Gives {C:dark_edition}Opposite{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_opposite = true
            	})
    end
}
local superoppositeedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Superoppositeedition",
    key = "superoppositeedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Super Opposite Edition',
        text = {
			"Gives {C:dark_edition}Super Opposite{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_superopposite = true
            	})
    end
}
local ultraoppositeedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Ultraoppositeedition",
    key = "ultraoppositeedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Ultra Opposite Edition',
        text = {
			"Gives {C:dark_edition}Ultra Opposite{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_ultraopposite = true
            	})
    end
}
local hyperoppositeedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Hyperoppositeedition",
    key = "hyperoppositeedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Hyper Opposite Edition',
        text = {
			"Gives {C:dark_edition}Hyper Opposite{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_hyperopposite = true
            	})
    end
}
local eraseredition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Eraseredition",
    key = "eraseredition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Eraser Edition',
        text = {
			"Gives {C:dark_edition}Eraser{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_eraser = true
            	})
    end
}
local mosaicedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Mosaicedition",
    key = "mosaicedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Mosaic Edition',
        text = {
			"Gives {C:dark_edition}Mosaic{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_mosaic = true
            	})
    end
}
local sparkleedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Sparkleedition",
    key = "sparkleedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Sparkle Edition',
        text = {
			"Gives {C:dark_edition}Sparkle{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_sparkle = true
            	})
    end
}
local oversatedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Oversatedition",
    key = "oversatedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Oversaturated Edition',
        text = {
			"Gives {C:dark_edition}Oversaturated{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_oversat = true
            	})
    end
}
local glitchededition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Glitchededition",
    key = "glitchededition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Glitched Edition',
        text = {
			"Gives {C:dark_edition}Glitched{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_glitched = true
            	})
    end
}
local glitchoversatedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Glitchoversatedition",
    key = "glitchoversatedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Glitched & Oversaturated Edition',
        text = {
			"Gives {C:dark_edition}Glitched & Oversaturated{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_glitchoversat = true
            	})
    end
}
local ultraglitchedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Ultraglitchedition",
    key = "ultraglitchedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Ultra Glitch Edition',
        text = {
			"Gives {C:dark_edition}Ultra Glitch{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_ultraglitch = true
            	})
    end
}
local absoluteglitchedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Absoluteglitchedition",
    key = "absoluteglitchedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Absolute Glitch Edition',
        text = {
			"Gives {C:dark_edition}Absolute Glitch{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_absoluteglitch = true
            	})
    end
}
local astraledition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Astraledition",
    key = "astraledition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Astral Edition',
        text = {
			"Gives {C:dark_edition}Astral{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_astral = true
            	})
    end
}
local hyperastraledition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Hyperastraledition",
    key = "hyperastraledition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Hyper Astral Edition',
        text = {
			"Gives {C:dark_edition}Hyper Astral{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_hyperastral = true
            	})
    end
}
local bluredition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Bluredition",
    key = "bluredition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Blurred Edition',
        text = {
			"Gives {C:dark_edition}Blurred{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_blur = true
            	})
    end
}
local blindedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Blindedition",
    key = "blindedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Blind Edition',
        text = {
			"Gives {C:dark_edition}Blind{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_blind = true
            	})
    end
}
local eyeslessedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Eyeslessedition",
    key = "eyeslessedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Eyesless Edition',
        text = {
			"Gives {C:dark_edition}Eyesless{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_eyesless = true
            	})
    end
}
local expensiveedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Expensiveedition",
    key = "expensiveedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Expensive Edition',
        text = {
			"Gives {C:dark_edition}Expensive{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_expensive = true
            	})
    end
}
local veryexpensiveedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Veryexpensiveedition",
    key = "veryexpensiveedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Very Expensive Edition',
        text = {
			"Gives {C:dark_edition}Very Expensive{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_veryexpensive = true
            	})
    end
}
local tooexpensiveedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Tooexpensiveedition",
    key = "tooexpensiveedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Too Expensive Edition',
        text = {
			"Gives {C:dark_edition}Too Expensive{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_tooexpensive = true
            	})
    end
}
local unobtainableedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Unobtainableedition",
    key = "unobtainableedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Unobtainable Edition',
        text = {
			"Gives {C:dark_edition}Unobtainable{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_unobtainable = true
            	})
    end
}
local shinyedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Shinyedition",
    key = "shinyedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Shiny Edition',
        text = {
			"Gives {C:dark_edition}Shiny{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_shiny = true
            	})
    end
}
local ultrashinyedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Ultrashinyedition",
    key = "ultrashinyedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Ultra Shiny Edition',
        text = {
			"Gives {C:dark_edition}Ultra Shiny{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_ultrashiny = true
            	})
    end
}
local balavirusedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Balavirusedition",
    key = "balavirusedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Balavirus Edition',
        text = {
			"Gives {C:dark_edition}Balavirus{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_balavirus = true
            	})
    end
}
local cosmicedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Cosmicedition",
    key = "cosmicedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Cosmic Edition',
        text = {
			"Gives {C:dark_edition}Cosmic{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_cosmic = true
            	})
    end
}
local hypercosmicedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Hypercosmicedition",
    key = "hypercosmicedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Hyper Cosmic Edition',
        text = {
			"Gives {C:dark_edition}Hyper Cosmic{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_hypercosmic = true
            	})
    end
}
local darkmatteredition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Darkmatteredition",
    key = "darkmatteredition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Darkmatter Edition',
        text = {
			"Gives {C:dark_edition}Darkmatter{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_darkmatter = true
            	})
    end
}
local darkvoidedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Darkvoidedition",
    key = "darkvoidedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Dark Void Edition',
        text = {
			"Gives {C:dark_edition}Dark Void{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_darkvoid = true
            	})
    end
}
local pocketeditionedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Pocketeditionedition",
    key = "pocketeditionedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Pocket Edition',
        text = {
			"Gives {C:dark_edition}Pocket Edition{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_pocketedition = true
            	})
    end
}
local limitededitionedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Limitededitionedition",
    key = "limitededitionedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Limited Edition',
        text = {
			"Gives {C:dark_edition}Limited Edition{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_limitededition = true
            	})
    end
}
local greedyedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Greedyedition",
    key = "greedyedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Greedy Edition',
        text = {
			"Gives {C:dark_edition}Greedy{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_greedy = true
            	})
    end
}
local bailiffedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Bailiffedition",
    key = "bailiffedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Bailiff Edition',
        text = {
			"Gives {C:dark_edition}Bailiff{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_bailiff = true
            	})
    end
}
local duplicatededition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Duplicatededition",
    key = "duplicatededition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Duplicated Edition',
        text = {
			"Gives {C:dark_edition}Duplicated{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_duplicated = true
            	})
    end
}
local trashedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Trashedition",
    key = "trashedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Trash Edition',
        text = {
			"Gives {C:dark_edition}Trash{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_trash = true
            	})
    end
}
local lefthandededition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Lefthandededition",
    key = "lefthandededition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Left Handed Edition',
        text = {
			"Gives {C:dark_edition}Left Handed{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_lefthanded = true
            	})
    end
}
local righthandededition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Righthandededition",
    key = "righthandededition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Right Handed Edition',
        text = {
			"Gives {C:dark_edition}Right Handed{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_righthanded = true
            	})
    end
}
local pinkstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Pinkstakecurseedition",
    key = "pinkstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Pink Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Pink Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_pinkstakecurse = true
            	})
    end
}
local brownstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Brownstakecurseedition",
    key = "brownstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Brown Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Brown Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_brownstakecurse = true
            	})
    end
}
local yellowstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Yellowstakecurseedition",
    key = "yellowstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Yellow Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Yellow Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_yellowstakecurse = true
            	})
    end
}
local jadestakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Jadestakecurseedition",
    key = "jadestakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Jade Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Jade Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_jadestakecurse = true
            	})
    end
}
local cyanstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Cyanstakecurseedition",
    key = "cyanstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Cyan Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Cyan Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_cyanstakecurse = true
            	})
    end
}
local graystakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Graystakecurseedition",
    key = "graystakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Gray Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Gray Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_graystakecurse = true
            	})
    end
}
local crimsonstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Crimsonstakecurseedition",
    key = "crimsonstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Crimson Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Crimson Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_crimsonstakecurse = true
            	})
    end
}
local diamondstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Diamondstakecurseedition",
    key = "diamondstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Diamond Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Diamond Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_diamondstakecurse = true
            	})
    end
}
local amberstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Amberstakecurseedition",
    key = "amberstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Amber Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Amber Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_amberstakecurse = true
            	})
    end
}
local bronzestakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Bronzestakecurseedition",
    key = "bronzestakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Bronze Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Bronze Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_bronzestakecurse = true
            	})
    end
}
local quartzstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Quartzstakecurseedition",
    key = "quartzstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Quartz Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Quartz Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_quartzstakecurse = true
            	})
    end
}
local rubystakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Rubystakecurseedition",
    key = "rubystakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Ruby Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Ruby Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_rubystakecurse = true
            	})
    end
}
local glassstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Glassstakecurseedition",
    key = "glassstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Glass Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Glass Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_glassstakecurse = true
            	})
    end
}
local sapphirestakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Sapphirestakecurseedition",
    key = "sapphirestakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Sapphire Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Sapphire Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_sapphirestakecurse = true
            	})
    end
}
local emeraldstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Emeraldstakecurseedition",
    key = "emeraldstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Emerald Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Emerald Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_emeraldstakecurse = true
            	})
    end
}
local platinumstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Platinumstakecurseedition",
    key = "platinumstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Platinum Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Platinum Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_platinumstakecurse = true
            	})
    end
}
local verdantstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Verdantstakecurseedition",
    key = "verdantstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Verdant Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Verdant Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_verdantstakecurse = true
            	})
    end
}
local emberstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Emberstakecurseedition",
    key = "emberstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Ember Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Ember Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_emberstakecurse = true
            	})
    end
}
local dawnstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Dawnstakecurseedition",
    key = "dawnstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Dawn Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Dawn Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_dawnstakecurse = true
            	})
    end
}
local horizonstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Horizonstakecurseedition",
    key = "horizonstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Horizon Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Horizon Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_horizonstakecurse = true
            	})
    end
}
local blossomstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Blossomstakecurseedition",
    key = "blossomstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Blossom Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Blossom Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_blossomstakecurse = true
            	})
    end
}
local azurestakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Azurestakecurseedition",
    key = "azurestakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Azure Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Azure Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_azurestakecurse = true
            	})
    end
}
local ascendantstakecurseedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Ascendantstakecurseedition",
    key = "ascendantstakecurseedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Ascendant Stake Curse Edition',
        text = {
			"Gives {C:dark_edition}Ascendant Stake Curse{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_ascendantstakecurse = true
            	})
    end
}
local brilliantedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Brilliantedition",
    key = "brilliantedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Brilliant Edition',
        text = {
			"Gives {C:dark_edition}Brilliant{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_brilliant = true
            	})
    end
}
local blisteredition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Blisteredition",
    key = "blisteredition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Blister Edition',
        text = {
			"Gives {C:dark_edition}Blister{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_blister = true
            	})
    end
}
local galvanizededition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Galvanizededition",
    key = "galvanizededition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Galvanized Edition',
        text = {
			"Gives {C:dark_edition}Galvanized{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_galvanized = true
            	})
    end
}
local chromaticplatinumedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Chromaticplatinumedition",
    key = "chromaticplatinumedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Chromatic Platinum Edition',
        text = {
			"Gives {C:dark_edition}Chromatic Platinum{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_chromaticplatinum = true
            	})
    end
}
local metallicedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Metallicedition",
    key = "metallicedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Metallic Edition',
        text = {
			"Gives {C:dark_edition}Metallic{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_metallic = true
            	})
    end
}
local titaniumedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Titaniumedition",
    key = "titaniumedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Titanium Edition',
        text = {
			"Gives {C:dark_edition}Titanium{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_titanium = true
            	})
    end
}
local omnichromaticedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Omnichromaticedition",
    key = "omnichromaticedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Omnichromatic Edition',
        text = {
			"Gives {C:dark_edition}Omnichromatic{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_omnichromatic = true
            	})
    end
}
local chromaticastraledition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Chromaticastraledition",
    key = "chromaticastraledition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Chromatic Astral Edition',
        text = {
			"Gives {C:dark_edition}Chromatic Astral{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_chromaticastral = true
            	})
    end
}
local tvghostedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Tvghostedition",
    key = "tvghostedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'TV Ghost Edition',
        text = {
			"Gives {C:dark_edition}TV Ghost{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_tvghost = true
            	})
    end
}
local noisyedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Noisyedition",
    key = "noisyedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Noisy Edition',
        text = {
			"Gives {C:dark_edition}Noisy{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_noisy = true
            	})
    end
}
local rainbowedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Rainbowedition",
    key = "rainbowedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Rainbow Edition',
        text = {
			"Gives {C:dark_edition}Rainbow{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_rainbow = true
            	})
    end
}
local hyperchromeedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Hyperchromeedition",
    key = "hyperchromeedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Hyperchrome Edition',
        text = {
			"Gives {C:dark_edition}Hyperchrome{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_hyperchrome = true
            	})
    end
}
local shadowingedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Shadowingedition",
    key = "shadowingedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Shadowing Edition',
        text = {
			"Gives {C:dark_edition}Shadowing{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_shadowing = true
            	})
    end
}
local graymatteredition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Graymatteredition",
    key = "graymatteredition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Graymatter Edition',
        text = {
			"Gives {C:dark_edition}Graymatter{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_graymatter = true
            	})
    end
}
local hardstoneedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Hardstoneedition",
    key = "hardstoneedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Hardstone Edition',
        text = {
			"Gives {C:dark_edition}Hardstone{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_hardstone = true
            	})
    end
}
local impulsionedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Impulsionedition",
    key = "impulsionedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Impulsion Edition',
        text = {
			"Gives {C:dark_edition}Impulsion{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_impulsion = true
            	})
    end
}
local chromaticimpulsionedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Chromaticimpulsionedition",
    key = "chromaticimpulsionedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Chromatic Impulsion Edition',
        text = {
			"Gives {C:dark_edition}Chromatic Impulsion{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_chromaticimpulsion = true
            	})
    end
}
local psychedelicedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Psychedelicedition",
    key = "psychedelicedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Psychedelic Edition',
        text = {
			"Gives {C:dark_edition}Psychedelic{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_psychedelic = true
            	})
    end
}
local bedrockedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Bedrockedition",
    key = "bedrockedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Bedrock Edition',
        text = {
			"Gives {C:dark_edition}Bedrock{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_bedrock = true
            	})
    end
}
local goldenedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Goldenedition",
    key = "goldenedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Golden Edition',
        text = {
			"Gives {C:dark_edition}Golden{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_golden = true
            	})
    end
}
local ultragoldenedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Ultragoldenedition",
    key = "ultragoldenedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Ultra Golden Edition',
        text = {
			"Gives {C:dark_edition}Ultra Golden{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_ultragolden = true
            	})
    end
}
local rootedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Rootedition",
    key = "rootedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Root Edition',
        text = {
			"Gives {C:dark_edition}Root{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_root = true
            	})
    end
}
local catalystedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Catalystedition",
    key = "catalystedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Catalyst Edition',
        text = {
			"Gives {C:dark_edition}Catalyst{} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_catalyst = true
            	})
    end
}
local eyesless_balavirusedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Eyesless_balavirusedition",
    key = "eyesless_balavirusedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Eyesless (Balavirus) Edition',
        text = {
			"Gives {C:dark_edition}Eyesless (Balavirus){} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_eyesless_balavirus = true
            	})
    end
}
local absoluteglitch_balavirusedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Absoluteglitch_balavirusedition",
    key = "absoluteglitch_balavirusedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Absolute Glitch (Balavirus) Edition',
        text = {
			"Gives {C:dark_edition}Absolute Glitch (Balavirus){} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_absoluteglitch_balavirus = true
            	})
    end
}
local darkvoid_balavirusedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Darkvoid_balavirusedition",
    key = "darkvoid_balavirusedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Dark Void (Balavirus) Edition',
        text = {
			"Gives {C:dark_edition}Dark Void (Balavirus){} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_darkvoid_balavirus = true
            	})
    end
}
local psychedelic_balavirusedition = {
    object_type = "Consumable",
    set = "Editioncard",
    name = "cry-Psychedelic_balavirusedition",
    key = "psychedelic_balavirusedition",
    pos = {x=0,y=0},
    soul_pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Psychedelic (Balavirus) Edition',
        text = {
			"Gives {C:dark_edition}Psychedelic (Balavirus){} to a selected {C:dark_edition}joker{}.",
        }
    },
    cost = 4,
    atlas = "edition",
    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1]:set_edition({
            cry_psychedelic_balavirus = true
            	})
    end
}


local edition_cards = {editioncard, editioncard_atlas, foiledition, holoedition, polychromeedition, negativeedition, phantomedition, tentacleedition, krakenedition, cthulhuedition, glitteredition, balavirussquareedition, fluorescentedition, shinygalvanizededition, burntedition, oppositeedition, superoppositeedition, ultraoppositeedition, hyperoppositeedition, eraseredition, mosaicedition, sparkleedition, oversatedition, glitchededition, glitchoversatedition, ultraglitchedition, absoluteglitchedition, astraledition, hyperastraledition, bluredition, blindedition, eyeslessedition, expensiveedition, veryexpensiveedition, tooexpensiveedition, unobtainableedition, shinyedition, ultrashinyedition, balavirusedition, cosmicedition, hypercosmicedition, darkmatteredition, darkvoidedition, pocketeditionedition, limitededitionedition, greedyedition, bailiffedition, duplicatededition, trashedition, lefthandededition, righthandededition, pinkstakecurseedition, brownstakecurseedition, yellowstakecurseedition, jadestakecurseedition, cyanstakecurseedition, graystakecurseedition, crimsonstakecurseedition, diamondstakecurseedition, amberstakecurseedition, bronzestakecurseedition, quartzstakecurseedition, rubystakecurseedition, glassstakecurseedition, sapphirestakecurseedition, emeraldstakecurseedition, platinumstakecurseedition, verdantstakecurseedition, emberstakecurseedition, dawnstakecurseedition, horizonstakecurseedition, blossomstakecurseedition, azurestakecurseedition, ascendantstakecurseedition, brilliantedition, blisteredition, galvanizededition, chromaticplatinumedition, metallicedition, titaniumedition, omnichromaticedition, chromaticastraledition, tvghostedition, noisyedition, rainbowedition, hyperchromeedition, shadowingedition, graymatteredition, hardstoneedition, impulsionedition, chromaticimpulsionedition, psychedelicedition, bedrockedition, goldenedition, ultragoldenedition, rootedition, catalystedition, eyesless_balavirusedition, absoluteglitch_balavirusedition, darkvoid_balavirusedition, psychedelic_balavirusedition}
return {name = "Edition Cards",
        items = edition_cards}
