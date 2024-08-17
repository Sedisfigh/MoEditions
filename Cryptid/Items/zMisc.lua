--Edition code based on Bunco's Glitter Edition
local opposite_shader = {
    object_type = "Shader",
    key = 'opposite', 
    path = 'opposite.fs'
}
local opposite = {
    object_type = "Edition",
    key = "opposite",
    weight = 4, --slightly rarer than Polychrome
    shader = "opposite",
    in_shop = true,
    extra_cost = 6,
    config = {Xjokers = 0.2},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xjokers}}
    end,
    loc_txt = {
        name = "Opposite",
        label = "Opposite",
        text = {
            "{C:blue} +#1# {}joker slot when scored"
        }
    }
}

local superopposite_shader = {
    object_type = "Shader",
    key = 'superopposite', 
    path = 'superopposite.fs'
}
local superopposite = {
    object_type = "Edition",
    key = "superopposite",
    weight = 0.2, --slightly rarer than Polychrome
    shader = "superopposite",
    in_shop = true,
    extra_cost = 16,
    config = {Xjokers = 1.5},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xjokers}}
    end,
    loc_txt = {
        name = "Super Opposite",
        label = "Super Opposite",
        text = {
            "{C:blue} +#1# {}joker slot when scored"
        }
    }
}

local ultraopposite_shader = {
    object_type = "Shader",
    key = 'ultraopposite', 
    path = 'ultraopposite.fs'
}
local ultraopposite = {
    object_type = "Edition",
    key = "ultraopposite",
    weight = 0.02, --slightly rarer than Polychrome
    shader = "ultraopposite",
    in_shop = true,
    extra_cost = 26,
    config = {Xjokers = 3},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xjokers}}
    end,
    loc_txt = {
        name = "Ultra Opposite",
        label = "Ultra Opposite",
        text = {
            "{C:blue} +#1# {}joker slot when scored"
        }
    }
}

local hyperopposite_shader = {
    object_type = "Shader",
    key = 'hyperopposite', 
    path = 'hyperopposite.fs'
}
local hyperopposite = {
    object_type = "Edition",
    key = "hyperopposite",
    weight = 0.0005, --slightly rarer than Polychrome
    shader = "hyperopposite",
    in_shop = true,
    extra_cost = 46,
    config = {Xjokers = 9},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xjokers}}
    end,
    loc_txt = {
        name = "Hyper Opposite",
        label = "Hyper Opposite",
        text = {
            "{C:blue} +#1# {}joker slot when scored"
        }
    }
}

local eraser_shader = {
    object_type = "Shader",
    key = 'eraser', 
    path = 'eraser.fs'
}
local eraser = {
    object_type = "Edition",
    key = "eraser",
    weight = 3, --slightly rarer than Polychrome
    shader = "eraser",
    in_shop = true,
    extra_cost = -8,
    config = {Xjokers = 0.25},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xjokers}}
    end,
    loc_txt = {
        name = "Eraser",
        label = "Eraser",
        text = {
            "{C:red} -#1# {}joker slot when scored"
        }
    }
}
local mosaic_shader = {
    object_type = "Shader",
    key = 'mosaic', 
    path = 'mosaic.fs'
}
local mosaic = {
    object_type = "Edition",
    key = "mosaic",
    weight = 0.8, --slightly rarer than Polychrome
    shader = "mosaic",
    in_shop = true,
    extra_cost = 6,
    config = {Xchips = 2.5},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xchips}}
    end,
    loc_txt = {
        name = "Mosaic",
        label = "Mosaic",
        text = {
            "{X:chips,C:white} X#1# {} Chips"
        }
    }
}
local sparkle_shader = {
    object_type = "Shader",
    key = 'sparkle', 
    path = 'sparkle.fs'
}
local sparkle = {
    object_type = "Edition",
    key = "sparkle",
    weight = 0.2, --slightly rarer than Polychrome
    shader = "sparkle",
    in_shop = true,
    extra_cost = 16,
    config = {Xchips = 25},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xchips}}
    end,
    loc_txt = {
        name = "Sparkle",
        label = "Sparkle",
        text = {
            "{X:chips,C:white} X#1# {} Chips"
        }
    }
}
local oversat_shader = {
    object_type = "Shader",
    key = 'oversat', 
    path = 'oversat.fs'
}
local oversat = {
    object_type = "Edition",
    key = "oversat",
    weight = 3,
    shader = "oversat",
    in_shop = true,
    extra_cost = 5,
    sound = {
        sound = 'cry_e_oversaturated',
        per = 1,
        vol = 0.25
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Oversaturated",
        label = "Oversaturated",
        text = {
            "All values are {C:attention}doubled{},", "if possible"
        }
    }
}
local glitched_shader = {
    object_type = "Shader",
    key = 'glitched', 
    path = 'glitched.fs'
}
local glitched = {
    object_type = "Edition",
    key = "glitched",
    weight = 15,
    shader = "glitched",
    in_shop = true,
    extra_cost = 3,
    sound = {
        sound = 'cry_e_glitched',
        per = 1,
        vol = 0.25
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Glitched",
        label = "Glitched",
        text = {
            'All values are {C:dark_edition}randomized{}',
            'between {C:blue}X0.1{} and {C:red}X10{},',
            ' if possible',
        }
    }
}
local glitchoversat_shader = {
    object_type = "Shader",
    key = 'glitchoversat', 
    path = 'glitchoversat.fs'
}
local glitchoversat = {
    object_type = "Edition",
    key = "glitchoversat",
    weight = 10,
    shader = "glitchoversat",
    in_shop = true,
    extra_cost = 9,
    sound = {
        sound = 'cry_e_glitched',
        per = 1,
        vol = 0.25
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Glitched & Oversaturated",
        label = "Glitched & Oversaturated",
        text = {
            'All values are {C:dark_edition}randomized{}',
            'between {C:blue}X0.1{} and {C:red}X100{},',
            ' if possible',
        }
    }
}
local ultraglitch_shader = {
    object_type = "Shader",
    key = 'ultraglitch', 
    path = 'ultraglitch.fs'
}
local ultraglitch = {
    object_type = "Edition",
    key = "ultraglitch",
    weight = 5,
    shader = "ultraglitch",
    in_shop = true,
    extra_cost = 17,
    sound = {
        sound = 'cry_e_glitched',
        per = 1,
        vol = 0.25
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Ultra glitch",
        label = "Ultra glitch",
        text = {
            'All values are {C:dark_edition}randomized{}',
            'between {C:blue}X0.1{} and {C:red}X1000{},',
            ' if possible',
        }
    }
}
local absoluteglitch_shader = {
    object_type = "Shader",
    key = 'absoluteglitch', 
    path = 'absoluteglitch.fs'
}
local absoluteglitch = {
    object_type = "Edition",
    key = "absoluteglitch",
    weight = 0.5,
    shader = "absoluteglitch",
    in_shop = true,
    extra_cost = 29,
    sound = {
        sound = 'cry_e_glitched',
        per = 1,
        vol = 0.25
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Absolute glitch",
        label = "Absolute glitch",
        text = {
            'All values are {C:dark_edition}randomized{}',
            'between {C:blue}X0.01{} and {C:red}X100000{},',
            ' if possible',
        }
    }
}
local astral_shader = {
    object_type = "Shader",
    key = 'astral', 
    path = 'astral.fs'
}
local astral = {
    object_type = "Edition",
    key = "astral",
    weight = 0.3, --very rare
    shader = "astral",
    in_shop = true,
    extra_cost = 3,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Astral",
        label = "Astral",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult"
        }
    },
    config = {pow_mult = 1.1},
    loc_vars = function(self, info_queue)
        return {vars = {self.config.pow_mult}}
    end
}
local hyperastral_shader = {
    object_type = "Shader",
    key = 'hyperastral', 
    path = 'hyperastral.fs'
}
local hyperastral = {
    object_type = "Edition",
    key = "hyperastral",
    weight = 0.05, --very rare
    shader = "hyperastral",
    in_shop = true,
    extra_cost = 20,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Hyper Astral",
        label = "Hyper Astral",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult"
        }
    },
    config = {pow_mult = 2},
    loc_vars = function(self, info_queue)
        return {vars = {self.config.pow_mult}}
    end
}
local blurred_shader = {
    object_type = "Shader",
    key = 'blur', 
    path = 'blur.fs'
}
local blurred = {
    object_type = "Edition",
    key = "blur",
    weight = 0.5, --very rare
    shader = "blur",
    in_shop = true,
    extra_cost = 3,
    sound = {
        sound = 'cry_e_blur',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Blurred",
        label = "Blurred",
        text = {
            "{C:attention}Retrigger{} card",
            "{C:green}#1# in #2#{} chance", "to retrigger {C:attention}#3#{}", "additional time"
        }
    },
    config = {retrigger_chance = 2, retriggers = 1},
    loc_vars = function(self, info_queue, center)
        local chance = center and center.edition.retrigger_chance or self.config.retrigger_chance
        local retriggers = center and center.edition.retriggers or self.config.retriggers

        return {vars = {G.GAME.probabilities.normal, chance, retriggers}}
    end
}
local blind_shader = {
    object_type = "Shader",
    key = 'blind', 
    path = 'blind.fs'
}
local blind = {
    object_type = "Edition",
    key = "blind",
    weight = 0.05, --very rare
    shader = "blind",
    in_shop = true,
    extra_cost = 15,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Blind",
        label = "Blind",
        text = {
            "{C:attention}Retrigger{} this card", "{C:attention}#3#{} additional times"
        }
    },
    config = {retrigger_chance = 1, retriggers = 8},
    loc_vars = function(self, info_queue, center)
        local chance = center and center.edition.retrigger_chance or self.config.retrigger_chance
        local retriggers = center and center.edition.retriggers or self.config.retriggers

        return {vars = {G.GAME.probabilities.normal, chance, retriggers}}
    end
}

local eyesless_shader = {
    object_type = "Shader",
    key = 'eyesless', 
    path = 'eyesless.fs'
}
local eyesless = {
    object_type = "Edition",
    key = "eyesless",
    weight = 0.009, --very rare
    shader = "eyesless",
    in_shop = true,
    extra_cost = 85,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Eyesless",
        label = "Eyesless",
        text = {
            "{C:attention}Retrigger{} this card", "{C:attention}#3#{} additional times"
        }
    },
    config = {retrigger_chance = 1, retriggers = 64},
    loc_vars = function(self, info_queue, center)
        local chance = center and center.edition.retrigger_chance or self.config.retrigger_chance
        local retriggers = center and center.edition.retriggers or self.config.retriggers

        return {vars = {G.GAME.probabilities.normal, chance, retriggers}}
    end
}

local expensive_shader = {
    object_type = "Shader",
    key = 'expensive', 
    path = 'expensive.fs'
}
local expensive = {
    object_type = "Edition",
    key = "expensive",
    weight = 10,
    shader = "expensive",
    in_shop = true,
    extra_cost = 75,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Expensive",
        label = "Expensive",
        text = {
            "This card is ridiculously expensive."
        }
    },
}

local veryexpensive_shader = {
    object_type = "Shader",
    key = 'veryexpensive', 
    path = 'veryexpensive.fs'
}
local veryexpensive = {
    object_type = "Edition",
    key = "veryexpensive",
    weight = 1,
    shader = "veryexpensive",
    in_shop = true,
    extra_cost = 750,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Very expensive",
        label = "Very expensive",
        text = {
            "WTF is this price ? - Random Balatro Enjoyer, 2024."
        }
    },
}

local tooexpensive_shader = {
    object_type = "Shader",
    key = 'tooexpensive', 
    path = 'tooexpensive.fs'
}
local tooexpensive = {
    object_type = "Edition",
    key = "tooexpensive",
    weight = 0.1,
    shader = "tooexpensive",
    in_shop = true,
    extra_cost = 7500,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Too expensive",
        label = "Too expensive",
        text = {
            "I want to die... - Random Balatro Enjoyer, 2024."
        }
    },
}

local unobtainable_shader = {
    object_type = "Shader",
    key = 'unobtainable', 
    path = 'unobtainable.fs'
}
local unobtainable = {
    object_type = "Edition",
    key = "unobtainable",
    weight = 0.01,
    shader = "unobtainable",
    in_shop = true,
    extra_cost = 750000000000,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Unobtainable",
        label = "Unobtainable",
        text = {
            "Who wants to buy it ?"
        }
    },
}

local shiny_shader = {
    object_type = "Shader",
    key = 'shiny', 
    path = 'shiny.fs'
}
local shiny = {
    object_type = "Edition",
    key = "shiny",
    weight = 0.1,
    shader = "shiny",
    in_shop = true,
    extra_cost = 30,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Shiny",
        label = "Shiny",
        text = {
            "It's a rare card."
        }
    },
}
local ultrashiny_shader = {
    object_type = "Shader",
    key = 'ultrashiny', 
    path = 'ultrashiny.fs'
}
local ultrashiny = {
    object_type = "Edition",
    key = "ultrashiny",
    weight = 0.001,
    shader = "ultrashiny",
    in_shop = true,
    extra_cost = 30,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Ultra Shiny",
        label = "Ultra Shiny",
        text = {
            "It's an extremely rare card."
        }
    },
}
local balavirus_shader = {
    object_type = "Shader",
    key = 'balavirus', 
    path = 'balavirus.fs'
}
local balavirus = {
    object_type = "Edition",
    key = "balavirus",
    weight = 0.00001,
    shader = "balavirus",
    in_shop = true,
    extra_cost = 50,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Balavirus",
        label = "Balavirus",
        text = {
            "The rarest edition ever !"
        }
    },
}

local cosmic_shader = {
    object_type = "Shader",
    key = 'cosmic', 
    path = 'cosmic.fs'
}
local cosmic = {
    object_type = "Edition",
    key = "cosmic",
    weight = 0.005, --very rare
    shader = "cosmic",
    in_shop = true,
    extra_cost = 500,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Cosmic",
        label = "Cosmic",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult"
        }
    },
    config = {pow_mult = 20},
    loc_vars = function(self, info_queue)
        return {vars = {self.config.pow_mult}}
    end
}

local hypercosmic_shader = {
    object_type = "Shader",
    key = 'hypercosmic', 
    path = 'hypercosmic.fs'
}
local hypercosmic = {
    object_type = "Edition",
    key = "hypercosmic",
    weight = 0.001, --very rare
    shader = "hypercosmic",
    in_shop = true,
    extra_cost = 2000,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Hyper Cosmic",
        label = "Hyper Cosmic",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult"
        }
    },
    config = {pow_mult = 200},
    loc_vars = function(self, info_queue)
        return {vars = {self.config.pow_mult}}
    end
}
local darkmatter_shader = {
    object_type = "Shader",
    key = 'darkmatter', 
    path = 'darkmatter.fs'
}
local darkmatter = {
    object_type = "Edition",
    key = "darkmatter",
    weight = 0.0001, --very rare
    shader = "darkmatter",
    in_shop = true,
    extra_cost = 1e+10,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Dark Matter",
        label = "Dark Matter",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult"
        }
    },
    config = {pow_mult = 1000000},
    loc_vars = function(self, info_queue)
        return {vars = {self.config.pow_mult}}
    end
}
local darkvoid_shader = {
    object_type = "Shader",
    key = 'darkvoid', 
    path = 'darkvoid.fs'
}
local darkvoid = {
    object_type = "Edition",
    key = "darkvoid",
    weight = 0.00001,
    shader = "darkvoid",
    in_shop = true,
    extra_cost = 1e+50,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Dark Void",
        label = "Dark Void",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult"
        }
    },
    config = {pow_mult = 1e+100},
    loc_vars = function(self, info_queue)
        return {vars = {self.config.pow_mult}}
    end
}

local pocketedition_shader = {
    object_type = "Shader",
    key = 'pocketedition', 
    path = 'pocketedition.fs'
}
local pocketedition = {
    object_type = "Edition",
    key = "pocketedition",
    weight = 3, --slightly rarer than Polychrome
    shader = "pocketedition",
    in_shop = true,
    extra_cost = 7,
    config = {Xconsumable = 0.5},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xconsumable}}
    end,
    loc_txt = {
        name = "Pocket Edition",
        label = "Pocket Edition",
        text = {
            "{C:blue}+ #1# {}consumeable slots when scored"
        }
    }
}

local limitededition_shader = {
    object_type = "Shader",
    key = 'limitededition', 
    path = 'limitededition.fs'
}
local limitededition = {
    object_type = "Edition",
    key = "limitededition",
    weight = 1, --slightly rarer than Polychrome
    shader = "limitededition",
    in_shop = true,
    extra_cost = 15,
    config = {Xconsumable = 2},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xconsumable}}
    end,
    loc_txt = {
        name = "Limited Edition",
        label = "Limited Edition",
        text = {
            "{C:blue}+ #1# {}consumeable slots when scored"
        }
    }
}

local greedy_shader = {
    object_type = "Shader",
    key = 'greedy', 
    path = 'greedy.fs'
}
local greedy = {
    object_type = "Edition",
    key = "greedy",
    weight = 5, --slightly rarer than Polychrome
    shader = "greedy",
    in_shop = true,
    extra_cost = -50,
    config = {Xchips = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xchips}}
    end,
    loc_txt = {
        name = "Greedy",
        label = "Greedy",
        text = {
            "Set the {X:chips,C:white}Chips{} value to {C:red}1{}"
        }
    }
}

local bailiff_shader = {
    object_type = "Shader",
    key = 'bailiff', 
    path = 'bailiff.fs'
}
local bailiff = {
    object_type = "Edition",
    key = "bailiff",
    weight = 5, --slightly rarer than Polychrome
    shader = "bailiff",
    in_shop = true,
    extra_cost = -50,
    config = {Xmult = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xmult}}
    end,
    loc_txt = {
        name = "Bailiff",
        label = "Bailiff",
        text = {
            "Set the {X:mult,C:white}Mult{} value to {C:red}1{}"
        }
    }
}

local duplicated_shader = {
    object_type = "Shader",
    key = 'duplicated', 
    path = 'duplicated.fs'
}
local duplicated = {
    object_type = "Edition",
    key = "duplicated",
    weight = 1, --slightly rarer than Polychrome
    shader = "duplicated",
    in_shop = true,
    extra_cost = 10,
    config = {Xscore = 2},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xscore}}
    end,
    loc_txt = {
        name = "Duplicated",
        label = "Duplicated",
        text = {
            "{X:chips,C:white}X#1#{} to {X:chips,C:white}Chips{} and {X:mult,C:white}X2{} to {X:mult,C:white}Mult{}"
        }
    }
}
local trash_shader = {
    object_type = "Shader",
    key = 'trash', 
    path = 'trash.fs'
}
local trash = {
    object_type = "Edition",
    key = "trash",
    weight = 2, --slightly rarer than Polychrome
    shader = "trash",
    in_shop = true,
    extra_cost = -50,
    config = {Xconsumable = -0.2},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xconsumable}}
    end,
    loc_txt = {
        name = "Trash",
        label = "Trash",
        text = {
            "{C:red} #1# {}consumeable slots when scored"
        }
    }
}
local lefthanded_shader = {
    object_type = "Shader",
    key = 'lefthanded', 
    path = 'lefthanded.fs'
}
local lefthanded = {
    object_type = "Edition",
    key = "lefthanded",
    weight = 0.3, --slightly rarer than Polychrome
    shader = "lefthanded",
    in_shop = true,
    extra_cost = 10,
    config = {Xhand = 0.15},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xhand}}
    end,
    loc_txt = {
        name = "Left Handed",
        label = "Left Handed",
        text = {
            "{C:blue}+#1# {}hand when triggered"
        }
    }
}
local righthanded_shader = {
    object_type = "Shader",
    key = 'righthanded', 
    path = 'righthanded.fs'
}
local righthanded = {
    object_type = "Edition",
    key = "righthanded",
    weight = 0.3, --slightly rarer than Polychrome
    shader = "righthanded",
    in_shop = true,
    extra_cost = 10,
    config = {Xdiscard = 0.15},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xdiscard}}
    end,
    loc_txt = {
        name = "Right Handed",
        label = "Right Handed",
        text = {
            "{C:red}+#1# {}discard when triggered"
        }
    }
}
local pinkstakecurse_shader = {
    object_type = "Shader",
    key = 'pinkstakecurse', 
    path = 'pinkstakecurse.fs'
}
local pinkstakecurse = {
    object_type = "Edition",
    key = "pinkstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "pinkstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xpinkstakecurse = 0.5},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xpinkstakecurse}}
    end,
    loc_txt = {
        name = "Pink Stake Curse",
        label = "Pink Stake Curse",
        text = {
            "{C:red}Negative effect :{} When triggered, increase the {C:red}Blinds Chips Amount{} by {C:red}50%{}",
            "{C:green}Positive effect :{} {C:blue}+1{} jokers slot when triggered"
        }
    }
}
local brownstakecurse_shader = {
    object_type = "Shader",
    key = 'brownstakecurse', 
    path = 'brownstakecurse.fs'
}
local brownstakecurse = {
    object_type = "Edition",
    key = "brownstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "brownstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xbrownstakecurse = 0.5},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xbrownstakecurse}}
    end,
    loc_txt = {
        name = "Brown Stake Curse",
        label = "Brown Stake Curse",
        text = {
            "{C:red}Negative effect :{} Makes all {C:attention}stickers{} compatible when triggered",
            "{C:green}Positive effect :{} {C:blue}+0.1{} consumeables slot when triggered"
        }
    }
}
local yellowstakecurse_shader = {
    object_type = "Shader",
    key = 'yellowstakecurse', 
    path = 'yellowstakecurse.fs'
}
local yellowstakecurse = {
    object_type = "Edition",
    key = "yellowstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "yellowstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xyellowstakecurse = 0.5},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xyellowstakecurse}}
    end,
    loc_txt = {
        name = "Yellow Stake Curse",
        label = "Yellow Stake Curse",
        text = {
            "{C:red}Negative effect :{} Makes {C:attention}stickers{} appear on all purchasable items",
            "{C:green}Positive effect :{} {C:gold}+4${} when triggered"
        }
    }
}
local jadestakecurse_shader = {
    object_type = "Shader",
    key = 'jadestakecurse', 
    path = 'jadestakecurse.fs'
}
local jadestakecurse = {
    object_type = "Edition",
    key = "jadestakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "jadestakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xjadestakecurse = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xjadestakecurse}}
    end,
    loc_txt = {
        name = "Jade Stake Curse",
        label = "Jade Stake Curse",
        text = {
            "{C:red}Negative effect :{} Increase {C:attention}face down{} card chance by {C:red}5%{}",
            "{C:green}Positive effect :{} Increase {C:blue}hands{} left and {C:red}discards{} left by {C:blue}0.5{}"
        }
    }
}
local cyanstakecurse_shader = {
    object_type = "Shader",
    key = 'cyanstakecurse', 
    path = 'cyanstakecurse.fs'
}
local cyanstakecurse = {
    object_type = "Edition",
    key = "cyanstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "cyanstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xcyanstakecurse = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xcyanstakecurse}}
    end,
    loc_txt = {
        name = "Cyan Stake Curse",
        label = "Cyan Stake Curse",
        text = {
            "{C:red}Negative effect :{} Decrease {C:attention}jokers{} rate in shop by {C:red}1%{}",
            "{C:green}Positive effect :{} Increase {C:attention}editions{} rate in shop by {C:blue}2%{}"
        }
    }
}
local graystakecurse_shader = {
    object_type = "Shader",
    key = 'graystakecurse', 
    path = 'graystakecurse.fs'
}
local graystakecurse = {
    object_type = "Edition",
    key = "graystakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "graystakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xgraystakecurse = 2},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xgraystakecurse}}
    end,
    loc_txt = {
        name = "Gray Stake Curse",
        label = "Gray Stake Curse",
        text = {
            "{C:red}Negative effect :{} Increase {C:attention}cards cost{} by {C:red}2{}",
            "{C:green}Positive effect :{} Increase {C:gold}money{} by {C:blue}20%{}"
        }
    }
}
local crimsonstakecurse_shader = {
    object_type = "Shader",
    key = 'crimsonstakecurse', 
    path = 'crimsonstakecurse.fs'
}
local crimsonstakecurse = {
    object_type = "Edition",
    key = "crimsonstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "crimsonstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xcrimsonstakecurse = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xcrimsonstakecurse}}
    end,
    loc_txt = {
        name = "Crimson Stake Curse",
        label = "Crimson Stake Curse",
        text = {
            "{C:red}Negative effect :{} Increase shop prizes by current {C:gold}money{}",
            "{C:green}Positive effect :{} Decrease shop values by {C:blue}75%{}"
        }
    }
}
local diamondstakecurse_shader = {
    object_type = "Shader",
    key = 'diamondstakecurse', 
    path = 'diamondstakecurse.fs'
}
local diamondstakecurse = {
    object_type = "Edition",
    key = "diamondstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "diamondstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xdiamondstakecurse = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xdiamondstakecurse}}
    end,
    loc_txt = {
        name = "Diamond Stake Curse",
        label = "Diamond Stake Curse",
        text = {
            "{C:red}Negative effect :{} Increase ante win goal by {C:red}1{}",
            "{C:green}Positive effect :{} Increase interest amount by {C:blue}1{}"
        }
    }
}
local amberstakecurse_shader = {
    object_type = "Shader",
    key = 'amberstakecurse', 
    path = 'amberstakecurse.fs'
}
local amberstakecurse = {
    object_type = "Edition",
    key = "amberstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "amberstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xamberstakecurse = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xamberstakecurse}}
    end,
    loc_txt = {
        name = "Amber Stake Curse",
        label = "Amber Stake Curse",
        text = {
            "{C:red}Negative effect :{} Decrease booster packs amount in shop by {C:red}1{}",
            "{C:green}Positive effect :{} Set jokers in shop at {C:blue}3{}"
        }
    }
}
local bronzestakecurse_shader = {
    object_type = "Shader",
    key = 'bronzestakecurse', 
    path = 'bronzestakecurse.fs'
}
local bronzestakecurse = {
    object_type = "Edition",
    key = "bronzestakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "bronzestakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xbronzestakecurse = 25},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xbronzestakecurse}}
    end,
    loc_txt = {
        name = "Bronze Stake Curse",
        label = "Bronze Stake Curse",
        text = {
            "{C:red}Negative effect :{} Increase cards price in shop by {C:red}5${}",
            "{C:green}Positive effect :{} Gain {C:gold}money{} equals to",
            "{C:red}current discards left{}"
        }
    }
}
local quartzstakecurse_shader = {
    object_type = "Shader",
    key = 'quartzstakecurse', 
    path = 'quartzstakecurse.fs'
}
local quartzstakecurse = {
    object_type = "Edition",
    key = "quartzstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "quartzstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xquartzstakecurse = 0.25},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xquartzstakecurse}}
    end,
    loc_txt = {
        name = "Quartz Stake Curse",
        label = "Quartz Stake Curse",
        text = {
            "{C:red}Negative effect :{} Jokers can be {C:attention}pinned{}",
            "{C:green}Positive effect :{} Increase {C:red}mult{} by {C:blue}50%{}",
        }
    }
}
local rubystakecurse_shader = {
    object_type = "Shader",
    key = 'rubystakecurse', 
    path = 'rubystakecurse.fs'
}
local rubystakecurse = {
    object_type = "Edition",
    key = "rubystakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "rubystakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xrubystakecurse = 0.1},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xrubystakecurse}}
    end,
    loc_txt = {
        name = "Ruby Stake Curse",
        label = "Ruby Stake Curse",
        text = {
            "{C:red}Negative effect :{} Increase boss rate in random rounds by {C:red}10%{}",
            "{C:green}Positive effect :{} Increase {C:dark_edition}spectral{} rate by {C:blue}5%{}",
        }
    }
}
local glassstakecurse_shader = {
    object_type = "Shader",
    key = 'glassstakecurse', 
    path = 'glassstakecurse.fs'
}
local glassstakecurse = {
    object_type = "Edition",
    key = "glassstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "glassstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xglassstakecurse = 10},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xglassstakecurse}}
    end,
    loc_txt = {
        name = "Glass Stake Curse",
        label = "Glass Stake Curse",
        text = {
            "{C:red}Negative effect :{} Increase broken glass card chance by {C:red}10%{}",
            "{C:green}Positive effect :{} Multiplies the {C:blue}current hand chips{} by",
            "{C:blue}25%{} of current {C:gold}money{}"
        }
    }
}
local sapphirestakecurse_shader = {
    object_type = "Shader",
    key = 'sapphirestakecurse', 
    path = 'sapphirestakecurse.fs'
}
local sapphirestakecurse = {
    object_type = "Edition",
    key = "sapphirestakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "sapphirestakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xsapphirestakecurse = 10},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xsapphirestakecurse}}
    end,
    loc_txt = {
        name = "Sapphire Stake Curse",
        label = "Sapphire Stake Curse",
        text = {
            "{C:red}Negative effect :{} Lose {C:red}25%{} of {C:gold}money{} when finishing an ante",
            "The cap increases by {C:red}10${} when triggered",
            "{C:green}Positive effect :{} Multiplies the {C:blue}current hand chips{} by",
            "the cap"
        }
    }
}
local emeraldstakecurse_shader = {
    object_type = "Shader",
    key = 'emeraldstakecurse', 
    path = 'emeraldstakecurse.fs'
}
local emeraldstakecurse = {
    object_type = "Edition",
    key = "emeraldstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "emeraldstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xemeraldstakecurse = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xemeraldstakecurse}}
    end,
    loc_txt = {
        name = "Emerald Stake Curse",
        label = "Emerald Stake Curse",
        text = {
            "{C:red}Negative effect :{} Cards can be {C:attention}flipped{} in shop",
            "{C:green}Positive effect :{} Adds {C:blue}10%{} of current {C:gold}money{} to {C:red}mult{}"
        }
    }
}
local platinumstakecurse_shader = {
    object_type = "Shader",
    key = 'platinumstakecurse', 
    path = 'platinumstakecurse.fs'
}
local platinumstakecurse = {
    object_type = "Edition",
    key = "platinumstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "platinumstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xplatinumstakecurse = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xplatinumstakecurse}}
    end,
    loc_txt = {
        name = "Platinum Stake Curse",
        label = "Platinum Stake Curse",
        text = {
            "{C:red}Negative effect :{} Small blind {C:attention}disappears{}",
            "{C:green}Positive effect :{} Multiplies {C:red}mult{} by the number",
            "of {C:blue}current hands played +1{}"
        }
    }
}
local verdantstakecurse_shader = {
    object_type = "Shader",
    key = 'verdantstakecurse', 
    path = 'verdantstakecurse.fs'
}
local verdantstakecurse = {
    object_type = "Edition",
    key = "verdantstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "verdantstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xverdantstakecurse = 3},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xverdantstakecurse}}
    end,
    loc_txt = {
        name = "Verdant Stake Curse",
        label = "Verdant Stake Curse",
        text = {
            "{C:red}Negative effect :{} Increase ante scaling by {C:red}400%{}",
            "{C:green}Positive effect :{} Increase {C:red}discards{} by {C:blue}2{}"
        }
    }
}
local emberstakecurse_shader = {
    object_type = "Shader",
    key = 'emberstakecurse', 
    path = 'emberstakecurse.fs'
}
local emberstakecurse = {
    object_type = "Edition",
    key = "emberstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "emberstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xemberstakecurse = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xemberstakecurse}}
    end,
    loc_txt = {
        name = "Ember Stake Curse",
        label = "Ember Stake Curse",
        text = {
            "{C:red}Negative effect :{} Cards have {C:red}no sell value{}",
            "{C:green}Positive effect :{} Set interest cap at {C:gold}80${}"
        }
    }
}
local dawnstakecurse_shader = {
    object_type = "Shader",
    key = 'dawnstakecurse', 
    path = 'dawnstakecurse.fs'
}
local dawnstakecurse = {
    object_type = "Edition",
    key = "dawnstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "dawnstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xdawnstakecurse = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xdawnstakecurse}}
    end,
    loc_txt = {
        name = "Dawn Stake Curse",
        label = "Dawn Stake Curse",
        text = {
            "{C:red}Negative effect :{} Set consumeable slot to {C:red}1{}",
            "{C:green}Positive effect :{} Set {C:attention}tarots{} rate to {C:blue}90%{}",
            " and {C:dark_edition}spectrals{} rate to {C:blue}20%{}"
        }
    }
}
local horizonstakecurse_shader = {
    object_type = "Shader",
    key = 'horizonstakecurse', 
    path = 'horizonstakecurse.fs'
}
local horizonstakecurse = {
    object_type = "Edition",
    key = "horizonstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "horizonstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xhorizonstakecurse = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xhorizonstakecurse}}
    end,
    loc_txt = {
        name = "Horizon Stake Curse",
        label = "Horizon Stake Curse",
        text = {
            "{C:red}Negative effect :{} Decrease {C:red}mult{} by {C:red}25%{}",
            "{C:green}Positive effect :{} Set playing card rate in shop at {C:blue}25%{}"
        }
    }
}
local blossomstakecurse_shader = {
    object_type = "Shader",
    key = 'blossomstakecurse', 
    path = 'blossomstakecurse.fs'
}
local blossomstakecurse = {
    object_type = "Edition",
    key = "blossomstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "blossomstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xblossomstakecurse = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xblossomstakecurse}}
    end,
    loc_txt = {
        name = "Blossom Stake Curse",
        label = "Blossom Stake Curse",
        text = {
            "{C:red}Negative effect :{} Boss blinds can appear in {C:attention}any ante{}",
            "{C:green}Positive effect :{} When triggered, add {C:blue}2{} times",
            "{C:blue}current hands left{} to {C:gold}money{}"
        }
    }
}
local azurestakecurse_shader = {
    object_type = "Shader",
    key = 'azurestakecurse', 
    path = 'azurestakecurse.fs'
}
local azurestakecurse = {
    object_type = "Edition",
    key = "azurestakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "azurestakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xazurestakecurse = 0.05},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xazurestakecurse}}
    end,
    loc_txt = {
        name = "Azure Stake Curse",
        label = "Azure Stake Curse",
        text = {
            "{C:red}Negative effect :{} Decrease jokers values by {C:red}50%{}",
            "{C:green}Positive effect :{} Add {X:dark_edition,C:white}^ 2{} to {C:red}mult{}"
        }
    }
}
local ascendantstakecurse_shader = {
    object_type = "Shader",
    key = 'ascendantstakecurse', 
    path = 'ascendantstakecurse.fs'
}
local ascendantstakecurse = {
    object_type = "Edition",
    key = "ascendantstakecurse",
    weight = 3, --slightly rarer than Polychrome
    shader = "ascendantstakecurse",
    in_shop = true,
    extra_cost = 4,
    config = {Xascendantstakecurse = 0},
    sound = {
        sound = 'cry_e_mosaic',
        per = 1,
        vol = 0.2
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xascendantstakecurse}}
    end,
    loc_txt = {
        name = "Ascendant Stake Curse",
        label = "Ascendant Stake Curse",
        text = {
            "{C:red}Negative effect :{} Set jokers in shop at {C:red}1{}",
            "{C:green}Positive effect :{} Set jokers values at {C:blue}150%{}"
        }
    }
}

local brilliant_shader = {
    object_type = "Shader",
    key = 'brilliant', 
    path = 'brilliant1.fs'
}
local brilliant = {
    object_type = "Edition",
    key = "brilliant",
    weight = 0.2,
    shader = "brilliant",
    in_shop = true,
    extra_cost = 20,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Brilliant",
        label = "Brilliant",
        text = {
            "{X:chips,C:white}X2{} to {X:chips,C:white}Chips{} and {X:mult,C:white}X2{} to {X:mult,C:white}Mult{}",
            "{C:blue}+1{} temporary {C:red}discard{} when triggered"
        }
    },
}
local blister_shader = {
    object_type = "Shader",
    key = 'blister', 
    path = 'blister.fs'
}
local blister = {
    object_type = "Edition",
    key = "blister",
    weight = 0.5,
    shader = "blister",
    in_shop = true,
    extra_cost = 10,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Blister",
        label = "Blister",
        text = {
            "{C:blue}+500{} chips",
        }
    },
}
local galvanized_shader = {
    object_type = "Shader",
    key = 'galvanized', 
    path = 'galvanized.fs'
}
local galvanized = {
    object_type = "Edition",
    key = "galvanized",
    weight = 0,
    shader = "galvanized",
    in_shop = true,
    extra_cost = 10,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Galvanized",
        label = "Galvanized",
        text = {
            "{C:blue}+1000{} chips, {X:mult,C:white}X3{} mult",
        }
    },
}
local chromaticplatinum_shader = {
    object_type = "Shader",
    key = 'chromaticplatinum', 
    path = 'chromaticplatinum.fs'
}
local chromaticplatinum = {
    object_type = "Edition",
    key = "chromaticplatinum",
    weight = 0,
    shader = "chromaticplatinum",
    in_shop = true,
    extra_cost = 30,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Chromatic Platinum",
        label = "Chromatic Platinum",
        text = {
            "{X:dark_edition,C:white}^12{} chips, {X:dark_edition,C:white}^12{} mult",
            "{C:blue}+2{} temporary {C:red}discards{} when triggered"
        }
    },
}
local metallic_shader = {
    object_type = "Shader",
    key = 'metallic', 
    path = 'metallic.fs'
}
local metallic = {
    object_type = "Edition",
    key = "metallic",
    weight = 0,
    shader = "metallic",
    in_shop = true,
    extra_cost = 60,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Metallic",
        label = "Metallic",
        text = {
            "{C:gold}+10${} when triggered",
        }
    },
}
local titanium_shader = {
    object_type = "Shader",
    key = 'titanium', 
    path = 'titanium.fs'
}
local titanium = {
    object_type = "Edition",
    key = "titanium",
    weight = 0,
    shader = "titanium",
    in_shop = true,
    extra_cost = 70,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Titanium",
        label = "Titanium",
        text = {
            "{C:gold}+15${} when triggered, {C:red}+20{} mult",
        }
    },
}
local omnichromatic_shader = {
    object_type = "Shader",
    key = 'omnichromatic', 
    path = 'omnichromatic.fs'
}
local omnichromatic = {
    object_type = "Edition",
    key = "omnichromatic",
    weight = 0,
    shader = "omnichromatic",
    in_shop = true,
    extra_cost = 70,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Omnichromatic",
        label = "Omnichromatic",
        text = {
            "{X:dark_edition,C:white}^12{} chips, {X:dark_edition,C:white}^12{} mult",
            "{C:blue}+2{} temporary {C:red}discards{} when triggered",
            "{X:gold,C:white}X2{} {C:gold}money{}"
        }
    },
}
local chromaticastral_shader = {
    object_type = "Shader",
    key = 'chromaticastral', 
    path = 'chromaticastral.fs'
}
local chromaticastral = {
    object_type = "Edition",
    key = "chromaticastral",
    weight = 0,
    shader = "chromaticastral",
    in_shop = true,
    extra_cost = 10,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Chromatic Astral",
        label = "Chromatic Astral",
        text = {
            "{X:dark_edition,C:white}^1.5{} chips, {X:dark_edition,C:white}^1.5{} mult",
        }
    },
}
local tvghost_shader = {
    object_type = "Shader",
    key = 'tvghost', 
    path = 'tvghost.fs'
}
local tvghost = {
    object_type = "Edition",
    key = "tvghost",
    weight = 5,
    shader = "tvghost",
    in_shop = true,
    extra_cost = 5,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "TV Ghost",
        label = "TV Ghost",
        text = {
            "{C:blue}+60{} chips, {X:gold,C:white}X1.25{} {C:gold}money{}",
        }
    },
}
local noisy_shader = {
    object_type = "Shader",
    key = 'noisy', 
    path = 'noisy.fs'
}
local noisy = {
    object_type = "Edition",
    key = "noisy",
    weight = 0,
    shader = "noisy",
    in_shop = true,
    extra_cost = 5,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Noisy",
        label = "Noisy",
        text = {
            "{X:blue,C:white}X50{} chips, {X:gold,C:white}X1.25{} {C:gold}money{}",
        }
    },
}
local rainbow_shader = {
    object_type = "Shader",
    key = 'rainbow', 
    path = 'rainbow.fs'
}
local rainbow = {
    object_type = "Edition",
    key = "rainbow",
    weight = 0,
    shader = "rainbow",
    in_shop = true,
    extra_cost = 5,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Rainbow",
        label = "Rainbow",
        text = {
            "{X:red,C:white}X15{} mult",
        }
    },
}
local hyperchrome_shader = {
    object_type = "Shader",
    key = 'hyperchrome', 
    path = 'hyperchrome.fs'
}
local hyperchrome = {
    object_type = "Edition",
    key = "hyperchrome",
    weight = 0,
    shader = "hyperchrome",
    in_shop = true,
    extra_cost = 5,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Hyperchrome",
        label = "Hyperchrome",
        text = {
            "{X:red,C:white}X512{} mult",
        }
    },
}
local shadowing_shader = {
    object_type = "Shader",
    key = 'shadowing', 
    path = 'shadowing.fs'
}
local shadowing = {
    object_type = "Edition",
    key = "shadowing",
    weight = 1,
    shader = "shadowing",
    in_shop = true,
    extra_cost = 11,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Shadowing",
        label = "Shadowing",
        text = {
            "{X:dark_edition,C:white}^3{} chips, {X:dark_edition,C:white}^0.5{} mult",
        }
    },
}
local hardstone_shader = {
    object_type = "Shader",
    key = 'hardstone', 
    path = 'hardstone.fs'
}
local hardstone = {
    object_type = "Edition",
    key = "hardstone",
    weight = 3,
    shader = "hardstone",
    in_shop = true,
    extra_cost = 5,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Hardstone",
        label = "Hardstone",
        text = {
            "Fix {C:blue}chips{} and {C:red}mult{} at {C:attention}100{}",
        }
    },
}
local graymatter_shader = {
    object_type = "Shader",
    key = 'graymatter', 
    path = 'graymatter.fs'
}
local graymatter = {
    object_type = "Edition",
    key = "graymatter",
    weight = 0.01,
    shader = "graymatter",
    in_shop = true,
    extra_cost = 18,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Graymatter",
        label = "Graymatter",
        text = {
            "{X:dark_edition,C:white}^6{} chips, {X:dark_edition,C:white}^0.75{} mult",
        }
    },
}
local impulsion_shader = {
    object_type = "Shader",
    key = 'impulsion', 
    path = 'impulsion.fs'
}
local impulsion = {
    object_type = "Edition",
    key = "impulsion",
    weight = 0,
    shader = "impulsion",
    in_shop = true,
    extra_cost = 40,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Impulsion",
        label = "Impulsion",
        text = {
            "{X:dark_edition,C:white}^1.1{} {C:gold}money{}",
        }
    },
}
local chromaticimpulsion_shader = {
    object_type = "Shader",
    key = 'chromaticimpulsion', 
    path = 'chromaticimpulsion.fs'
}
local chromaticimpulsion = {
    object_type = "Edition",
    key = "chromaticimpulsion",
    weight = 0,
    shader = "chromaticimpulsion",
    in_shop = true,
    extra_cost = 80,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Chromatic Impulsion",
        label = "Chromatic Impulsion",
        text = {
            "{X:dark_edition,C:white}^1.5{} {C:gold}money{}, {X:dark_edition,C:white}^1.5{} chips, {X:dark_edition,C:white}^1.5{} mult",
        }
    },
}
local psychedelic_shader = {
    object_type = "Shader",
    key = 'psychedelic', 
    path = 'psychedelic.fs'
}
local psychedelic = {
    object_type = "Edition",
    key = "psychedelic",
    weight = 0,
    shader = "psychedelic",
    in_shop = true,
    extra_cost = 8000,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Psychedelic",
        label = "Psychedelic",
        text = {
            "{X:dark_edition,C:white}^40{} {C:gold}money{}, {X:dark_edition,C:white}^40{} chips, {X:dark_edition,C:white}^40{} mult",
            "{X:dark_edition,C:white}^2{} temporary hands, {X:dark_edition,C:white}^2{} temporary discards"
        }
    },
}
local bedrock_shader = {
    object_type = "Shader",
    key = 'bedrock', 
    path = 'bedrock.fs'
}
local bedrock = {
    object_type = "Edition",
    key = "bedrock",
    weight = 0.5,
    shader = "bedrock",
    in_shop = true,
    extra_cost = 12,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Bedrock",
        label = "Bedrock",
        text = {
            "Fix {C:blue}chips{} and {C:red}mult{} at {C:attention}1000{}",
        }
    },
}
local golden_shader = {
    object_type = "Shader",
    key = 'golden', 
    path = 'golden.fs'
}
local golden = {
    object_type = "Edition",
    key = "golden",
    weight = 0,
    shader = "golden",
    in_shop = true,
    extra_cost = 15,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Golden",
        label = "Golden",
        text = {
            "{C:gold}+30${}",
        }
    },
}
local ultragolden_shader = {
    object_type = "Shader",
    key = 'ultragolden', 
    path = 'ultragolden.fs'
}
local ultragolden = {
    object_type = "Edition",
    key = "ultragolden",
    weight = 0,
    shader = "ultragolden",
    in_shop = true,
    extra_cost = 30,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Ultra Golden",
        label = "Ultra Golden",
        text = {
            "{C:gold}+90${}",
        }
    },
}
local root_shader = {
    object_type = "Shader",
    key = 'root', 
    path = 'root.fs'
}
local root = {
    object_type = "Edition",
    key = "root",
    weight = 15,
    shader = "root",
    in_shop = true,
    extra_cost = 0,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Root",
        label = "Root",
        text = {
            "{X:dark_edition,C:white}^0.5{} mult",
        }
    },
}
local catalyst_shader = {
    object_type = "Shader",
    key = 'catalyst', 
    path = 'catalyst.fs'
}
local catalyst = {
    object_type = "Edition",
    key = "catalyst",
    weight = 8,
    shader = "catalyst",
    in_shop = true,
    extra_cost = 5,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Catalyst",
        label = "Catalyst",
        text = {
            "{X:blue,C:white}X3{} chips, {C:gold}+1${}",
            "Upgrades the shiny editions tier"
        }
    },
}

local eyesless_balavirus_shader = {
    object_type = "Shader",
    key = 'eyesless_balavirus', 
    path = 'eyesless_balavirus.fs'
}
local eyesless_balavirus = {
    object_type = "Edition",
    key = "eyesless_balavirus",
    weight = 0, --very rare
    shader = "eyesless_balavirus",
    in_shop = true,
    extra_cost = 500,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Eyesless (Balavirus)",
        label = "Eyesless (Balavirus)",
        text = {
            "{C:green}#1# in #2#{} chance to", "{C:attention}retrigger{} this card", "{C:attention}#3#{} additional times"
        }
    },
    config = {retrigger_chance = 1, retriggers = 512},
    loc_vars = function(self, info_queue, center)
        local chance = center and center.edition.retrigger_chance or self.config.retrigger_chance
        local retriggers = center and center.edition.retriggers or self.config.retriggers

        return {vars = {G.GAME.probabilities.normal, chance, retriggers}}
    end
}

local absoluteglitch_balavirus_shader = {
    object_type = "Shader",
    key = 'absoluteglitch_balavirus', 
    path = 'absoluteglitch_balavirus.fs'
}
local absoluteglitch_balavirus = {
    object_type = "Edition",
    key = "absoluteglitch_balavirus",
    weight = 0,
    shader = "absoluteglitch_balavirus",
    in_shop = true,
    extra_cost = 500,
    sound = {
        sound = 'cry_e_glitched',
        per = 1,
        vol = 0.25
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Absolute glitch (Balavirus)",
        label = "Absolute glitch (Balavirus)",
        text = {
            'All values are {C:dark_edition}randomized{}',
            'between {C:blue}X1{} and {C:red}X100000000{},',
            ' if possible',
        }
    }
}

local darkvoid_balavirus_shader = {
    object_type = "Shader",
    key = 'darkvoid_balavirus', 
    path = 'darkvoid_balavirus.fs'
}
local darkvoid_balavirus = {
    object_type = "Edition",
    key = "darkvoid_balavirus",
    weight = 0,
    shader = "darkvoid_balavirus",
    in_shop = true,
    extra_cost = 1e+90,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Dark Void (Balavirus)",
        label = "Dark Void (Balavirus)",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult, {X:dark_edition,C:white}^#1#{} Chips"
        }
    },
    config = {pow_mult = 1e+100},
    loc_vars = function(self, info_queue)
        return {vars = {self.config.pow_mult}}
    end
}

local psychedelic_balavirus_shader = {
    object_type = "Shader",
    key = 'psychedelic_balavirus', 
    path = 'psychedelic_balavirus.fs'
}
local psychedelic_balavirus = {
    object_type = "Edition",
    key = "psychedelic_balavirus",
    weight = 0,
    shader = "psychedelic_balavirus",
    in_shop = true,
    extra_cost = 1e+10,
    sound = {
        sound = 'cry_^Mult',
        per = 1,
        vol = 0.5
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    loc_txt = {
        name = "Psychedelic (Balavirus)",
        label = "Psychedelic (Balavirus)",
        text = {
            "{X:dark_edition,C:white}^1e+10{} {C:gold}money{}, {X:dark_edition,C:white}^1e+10{} chips, {X:dark_edition,C:white}^1e+10{} mult",
            "{X:dark_edition,C:white}^10{} temporary hands, {X:dark_edition,C:white}^10{} temporary discards"
        }
    },
}

local echo_atlas = {
    object_type = 'Atlas',
    key = 'echo_atlas',
    path = 'm_cry_echo.png',
    px = 71,
    py = 95,
}

local echo = {
    object_type = 'Enhancement',
    key = 'echo',
    loc_txt = {
        name = 'Echo Card',
        text = {'{C:green}#2# in #3#{} chance to',
        '{C:attention}retrigger{} #1# additional',
    'times when scored'}
    },
    atlas = 'echo_atlas',
    config = {retriggers = 2, extra = 2},
    loc_vars = function(self, info_queue)
        return {vars = {self.config.retriggers,G.GAME.probabilities.normal, self.config.extra}}
    end,
}

local lastcoin_atlas = {
    object_type = 'Atlas',
    key = 'lastcoin_atlas',
    path = 'm_cry_lastcoin.png',
    px = 71,
    py = 95,
}

local lastcoin = {
    object_type = 'Enhancement',
    key = 'lastcoin',
    loc_txt = {
        name = 'Last Coin Card',
        text = {'{C:red}-2${}, {C:blue}+1{} temporary {C:blue}hand{}',
        'Triggers only if you have',
    'more than {C:gold}2${}'}
    },
    atlas = 'lastcoin_atlas',
    config = {},
    loc_vars = function(self, info_queue)
        return {vars = {}}
    end,
}

local eclipse_atlas = {
    object_type = 'Atlas',
    key = 'eclipse_atlas',
    path = 'c_cry_eclipse.png',
    px = 71,
    py = 95,
}

local eclipse = {
    object_type = "Consumable",
    set = "Tarot",
    name = "cry-Eclipse",
    key = "eclipse",
    pos = {x=0,y=0},
    config = {mod_conv = 'm_cry_echo', max_highlighted = 1},
    loc_txt = {
        name = 'The Eclipse',
        text = {
            "Enhances {C:attention}#1#{} selected card",
            "into an {C:attention}Echo Card"
        }
    },
    atlas = "eclipse_atlas",
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS.m_cry_echo

        return {vars = {self.config.max_highlighted}}
    end,
}

local holder_atlas = {
    object_type = 'Atlas',
    key = 'holder_atlas',
    path = 'c_cry_holder.png',
    px = 71,
    py = 95,
}

local holder = {
    object_type = "Consumable",
    set = "Tarot",
    name = "cry-Holder",
    key = "holder",
    pos = {x=0,y=0},
    config = {mod_conv = 'm_cry_lastcoin', max_highlighted = 1},
    loc_txt = {
        name = 'The Holder',
        text = {
            "Enhances {C:attention}#1#{} selected card",
            "into an {C:attention}Last Coin Card"
        }
    },
    atlas = "holder_atlas",
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS.m_cry_lastcoin

        return {vars = {self.config.max_highlighted}}
    end,
}
--note: seal colors are also used in lovely.toml for spectral descriptions
-- and must be modified in both places
local azure_seal = {
    object_type = "Seal",
    name = "cry-Azure-Seal",
    key = "azure",
    badge_colour = HEX("1d4fd7"),
	config = { planets_amount = 3 },
    loc_txt = {
        -- Badge name
        label = 'Azure Seal',
        -- Tooltip description
        description = {
            name = 'Azure Seal',
            text = {
                'Create {C:attention}#1#{} {C:dark_edition}Negative{}',
                '{C:planet}Planets{} for played',
                '{C:attention}poker hand{}, then',
                '{C:red}destroy{} this card'
            }
        },
    },
    loc_vars = function(self, info_queue)
        return { vars = {self.config.planets_amount} }
    end,
    atlas = "azure_atlas",
    pos = {x=0, y=0},

    -- Requires latest Steamodded version (as of 7/9/24)
    calculate = function(self, card, context)        
        if context.destroying_card then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card_type = 'Planet'
                    local _planet = nil
                    if G.GAME.last_hand_played then
                        for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                            if v.config.hand_type == G.GAME.last_hand_played then
                                _planet = v.key
                                break
                            end
                        end
                    end

                    for i = 1, self.config.planets_amount do
                        local card = create_card(card_type, G.consumeables, nil, nil, nil, nil, _planet, 'cry_azure')

                        card:set_edition({negative = true}, true)
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                    end
                    return true
                end)
            }))

            return true
        end
    end,
}

local hyperazure_seal = {
    object_type = "Seal",
    name = "cry-Hyperazure-Seal",
    key = "hyperazure",
    badge_colour = HEX("1d4fd7"),
	config = { planets_amount = 15 },
    loc_txt = {
        -- Badge name
        label = 'Hyper Azure Seal',
        -- Tooltip description
        description = {
            name = 'Hyper Azure Seal',
            text = {
                'Create {C:attention}#1#{} {C:dark_edition}Negative{}',
                '{C:planet}Planets{} for played',
                '{C:attention}poker hand{}, then',
                '{C:red}destroy{} this card'
            }
        },
    },
    loc_vars = function(self, info_queue)
        return { vars = {self.config.planets_amount} }
    end,
    atlas = "hyperazure_atlas",
    pos = {x=0, y=0},

    -- Requires latest Steamodded version (as of 7/9/24)
    calculate = function(self, card, context)        
        if context.destroying_card then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card_type = 'Planet'
                    local _planet = nil
                    if G.GAME.last_hand_played then
                        for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                            if v.config.hand_type == G.GAME.last_hand_played then
                                _planet = v.key
                                break
                            end
                        end
                    end

                    for i = 1, self.config.planets_amount do
                        local card = create_card(card_type, G.consumeables, nil, nil, nil, nil, _planet, 'cry_hyperazure')

                        card:set_edition({negative = true}, true)
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                    end
                    return true
                end)
            }))

            return true
        end
    end,
}

local azure_seal_sprite = {
    object_type = "Atlas",
    key = "azure_atlas",
    path = "s_cry_azure_seal.png",
    px = 71,
    py = 95
}

local hyperazure_seal_sprite = {
    object_type = "Atlas",
    key = "hyperazure_atlas",
    path = "s_cry_hyperazure_seal.png",
    px = 71,
    py = 95
}


local typhoon = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Typhoon",
    key = "typhoon",
	config = { 
        -- This will add a tooltip.
        mod_conv = 's_cry_azure_seal',
        -- Tooltip args
        seal = { planets_amount = 3 },
        max_highlighted = 1,
    },
    loc_vars = function(self, info_queue, center)
        -- Handle creating a tooltip with set args.
        info_queue[#info_queue+1] = { set = 'Other', key = 's_cry_azure_seal', specific_vars = { self.config.seal.planets_amount } }
        return {vars = {center.ability.max_highlighted}}
    end,
    loc_txt = {
        name = 'Typhoon',
        text = {
            "Add an {C:cry_azure}Azure Seal{}",
            "to {C:attention}1{} selected",
            "card in your hand"
        }
    },
    cost = 4,
    atlas = "typhoon_atlas",
    pos = {x=0, y=0},
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                for i = 1, card.ability.max_highlighted do
                    local highlighted = G.hand.highlighted[i]

                    if highlighted then
                        highlighted:set_seal('s_cry_azure')
                    else
                        break
                    end
                end
                return true
            end
        }))
    end
}

local typhoon_sprite = {
    object_type = "Atlas",
    key = "typhoon_atlas",
    
    path = "s_cry_typhoon.png",
    px = 71,
    py = 95
}
local typhoonii = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Typhoonii",
    key = "typhoonii",
	config = { 
        -- This will add a tooltip.
        mod_conv = 's_cry_hyperazure_seal',
        -- Tooltip args
        seal = { planets_amount = 15 },
        max_highlighted = 1,
    },
    loc_vars = function(self, info_queue, center)
        -- Handle creating a tooltip with set args.
        info_queue[#info_queue+1] = { set = 'Other', key = 's_cry_hyperazure_seal', specific_vars = { self.config.seal.planets_amount } }
        return {vars = {center.ability.max_highlighted}}
    end,
    loc_txt = {
        name = 'Typhoon II',
        text = {
            "Add an {C:cry_azure}Hyper Azure Seal{}",
            "to {C:attention}1{} selected",
            "card in your hand"
        }
    },
    cost = 12,
    atlas = "typhoonii_atlas",
    pos = {x=0, y=0},
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                for i = 1, card.ability.max_highlighted do
                    local highlighted = G.hand.highlighted[i]

                    if highlighted then
                        highlighted:set_seal('s_cry_hyperazure')
                    else
                        break
                    end
                end
                return true
            end
        }))
    end
}

local typhoonii_sprite = {
    object_type = "Atlas",
    key = "typhoonii_atlas",
    
    path = "s_cry_typhoonii.png",
    px = 71,
    py = 95
}
local typhooniii = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Typhooniii",
    key = "typhooniii",
	config = { 
        -- This will add a tooltip.
        mod_conv = 's_cry_razure_seal',
        -- Tooltip args
        seal = { planets_amount = 3 },
        max_highlighted = 3,
    },
    loc_vars = function(self, info_queue, center)
        -- Handle creating a tooltip with set args.
        info_queue[#info_queue+1] = { set = 'Other', key = 's_cry_azure_seal', specific_vars = { self.config.seal.planets_amount } }
        return {vars = {center.ability.max_highlighted}}
    end,
    loc_txt = {
        name = 'Typhoon III',
        text = {
            "Add an {C:cry_azure}Azure Seal{}",
            "to {C:attention}3{} selected",
            "cards in your hand"
        }
    },
    cost = 20,
    atlas = "typhooniii_atlas",
    pos = {x=0, y=0},
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                for i = 1, card.ability.max_highlighted do
                    local highlighted = G.hand.highlighted[i]

                    if highlighted then
                        highlighted:set_seal('s_cry_azure')
                    else
                        break
                    end
                end
                return true
            end
        }))
    end
}

local typhooniii_sprite = {
    object_type = "Atlas",
    key = "typhooniii_atlas",
    
    path = "s_cry_typhooniii.png",
    px = 71,
    py = 95
}
local typhooniv = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Typhooniv",
    key = "typhooniv",
	config = { 
        -- This will add a tooltip.
        mod_conv = 's_cry_hyperazure_seal',
        -- Tooltip args
        seal = { planets_amount = 15 },
        max_highlighted = 3,
    },
    loc_vars = function(self, info_queue, center)
        -- Handle creating a tooltip with set args.
        info_queue[#info_queue+1] = { set = 'Other', key = 's_cry_hyperazure_seal', specific_vars = { self.config.seal.planets_amount } }
        return {vars = {center.ability.max_highlighted}}
    end,
    loc_txt = {
        name = 'Typhoon IV',
        text = {
            "Add an {C:cry_azure}Hyper Azure Seal{}",
            "to {C:attention}3{} selected",
            "cards in your hand"
        }
    },
    cost = 30,
    atlas = "typhooniv_atlas",
    pos = {x=0, y=0},
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                for i = 1, card.ability.max_highlighted do
                    local highlighted = G.hand.highlighted[i]

                    if highlighted then
                        highlighted:set_seal('s_cry_hyperazure')
                    else
                        break
                    end
                end
                return true
            end
        }))
    end
}

local typhooniv_sprite = {
    object_type = "Atlas",
    key = "typhooniv_atlas",
    
    path = "s_cry_typhooniv.png",
    px = 71,
    py = 95
}
local cat = {
    object_type = "Tag",
    atlas = "tag_cry",
    pos = {x=0, y=2},
    key = "cat",
    loc_txt = {
        name = "Cat Tag",
        text = {"Meow."}
    }
}
local epic_tag = {
    object_type = "Tag",
    atlas = "tag_cry",
    pos = {x=3, y=0},
    config = {type = 'store_joker_create'},
    key = "epic",
    loc_txt = {
        name = "Epic Tag",
        text = {
            "Shop has a half-price",
            "{C:cry_epic}Epic Joker"
        }
    },
    apply = function(tag, context)
        if context.type == 'store_joker_create' then
            local rares_in_posession = {0}
                for k, v in ipairs(G.jokers.cards) do
                    if v.config.center.rarity == "cry_epic" and not rares_in_posession[v.config.center.key] then
                        rares_in_posession[1] = rares_in_posession[1] + 1 
                        rares_in_posession[v.config.center.key] = true
                    end
                end

                if #G.P_JOKER_RARITY_POOLS.cry_epic > rares_in_posession[1] then 
                    local card = create_card('Joker', context.area, nil, 1, nil, nil, nil, 'cry_eta')
                    create_shop_card_ui(card, 'Joker', context.area)
                    card.states.visible = false
                    tag:yep('+', G.C.RARITY.cry_epic,function() 
                        card:start_materialize()
                        card.misprint_cost_fac = 0.5
                        card:set_cost()
                        return true
                    end)
                else
                    tag:nope()
                end
                tag.triggered = true
                return card
        end
    end
}
--Bug: this still doesn't trigger immediately
local empowered = {
    object_type = "Tag",
    atlas = "tag_cry",
    pos = {x=1, y=0},
    config = {type = 'immediate'},
    key = "empowered",
    loc_txt = {
        name = "Empowered Tag",
        text = {
            "Gives a free {C:spectral}Spectral Pack",
            "with {C:legendary,E:1}The Soul{} and {C:cry_exotic,E:1}Gateway{}"
        }
    },
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS.p_spectral_normal_1
        info_queue[#info_queue+1] = {set = "Spectral", key = "c_soul"}
        if G.P_CENTERS.c_cry_gateway then
            info_queue[#info_queue+1] = {set = "Spectral", key = "c_cry_gateway"}
        end
        return {vars = {}}
    end,
    apply = function(tag, context)
        if context.type == 'immediate' then
            tag:yep('+', G.C.SECONDARY_SET.Spectral,function() 
                local key = 'p_spectral_normal_1'
                local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[key], {bypass_discovery_center = true, bypass_discovery_ui = true})
                card.cost = 0
                card.from_tag = true
                card.from_empowered = true
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                return true
            end)
            tag.triggered = true
            return true
        end
    end,
    in_pool = function()
        return false
    end
}
local gambler = {
    object_type = "Tag",
    atlas = "tag_cry",
    pos = {x=2, y=0},
    config = {type = 'immediate', odds = 4},
    key = "gambler",
    loc_txt = {
        name = "Gambler's Tag",
        text = {
            "{C:green}#1# in #2#{} chance to create",
            "an {C:cry_exotic,E:1}Empowered Tag"
        }
    },
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = {set = "Tag", key = "tag_cry_empowered"}
        return {vars = {G.GAME.probabilities.normal or 1, self.config.odds}}
    end,
    apply = function(tag, context)
        if context.type == 'immediate' then
            if pseudorandom('cry_gambler_tag') < G.GAME.probabilities.normal/tag.config.odds then
                local lock = tag.ID
                G.CONTROLLER.locks[lock] = true
                tag:yep('+', G.C.RARITY.cry_exotic,function()
                    add_tag(Tag("tag_cry_empowered"))
                    G.GAME.tags[#G.GAME.tags]:apply_to_run({type = 'immediate'})
                    G.CONTROLLER.locks[lock] = nil
                    return true
                end)
            else
                tag:nope()
            end
            tag.triggered = true
            return true
        end
    end
}
local bundle = {
    object_type = "Tag",
    atlas = "tag_cry",
    pos = {x=0, y=0},
    config = {type = 'immediate'},
    key = "bundle",
    min_ante = 2,
    loc_txt = {
        name = "Bundle Tag",
        text = {
            "Create a {C:attention}Standard Tag{}, {C:tarot}Charm Tag{},",
            "{C:attention}Buffoon Tag{}, and {C:planet}Meteor Tag"
        }
    },
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = {set = "Tag", key = "tag_standard"}
        info_queue[#info_queue+1] = {set = "Tag", key = "tag_charm"}
        info_queue[#info_queue+1] = {set = "Tag", key = "tag_meteor"}
        info_queue[#info_queue+1] = {set = "Tag", key = "tag_buffoon"}
        return {vars = {}}
    end,
    apply = function(tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.ATTENTION,function()
                add_tag(Tag("tag_standard"))
                add_tag(Tag("tag_charm"))
                add_tag(Tag("tag_meteor"))
                add_tag(Tag("tag_buffoon"))
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}
local memory = {
    object_type = "Tag",
    atlas = "tag_cry",
    pos = {x=3, y=1},
    name = "cry-Memory Tag",
    config = {type = 'immediate', num = 2},
    key = "memory",
    loc_txt = {
        name = "Memory Tag",
        text = {
            "Create {C:attention}#1#{} copies of",
            "the last {C:attention}Tag{} used",
            "during this run",
            "{s:0.8,C:inactive}Copying Tags excluded",
            "{s:0.8,C:inactive}Currently: {s:0.8,C:attention}#2#"
        }
    },
    loc_vars = function(self, info_queue)
        if G.GAME.cry_last_tag_used then
            _c = G.P_TAGS[G.GAME.cry_last_tag_used]
        end
        local loc_tag = _c and localize{type = 'name_text', key = G.GAME.cry_last_tag_used, set = _c.set} or localize('k_none')
        return {vars = {self.config.num, loc_tag}}
    end,
    apply = function(tag, context)
        if context.type == 'immediate' and G.GAME.cry_last_tag_used then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.ATTENTION,function()
                add_tag(Tag(G.GAME.cry_last_tag_used))
                add_tag(Tag(G.GAME.cry_last_tag_used))
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
        end
        return true
    end,
    in_pool = function()
        return G.GAME.cry_last_tag_used and true
    end
}

local miscitems = {opposite_shader, opposite, superopposite_shader, superopposite, ultraopposite_shader, ultraopposite, hyperopposite_shader, hyperopposite, eraser_shader, eraser, mosaic_shader, mosaic, sparkle_shader, sparkle, oversat_shader, oversat, glitched_shader, glitched, glitchoversat_shader, glitchoversat, ultraglitch_shader, ultraglitch, absoluteglitch_shader, absoluteglitch, astral_shader, astral, hyperastral_shader, hyperastral, blurred_shader, blurred, blind_shader, blind, eyesless_shader, eyesless, expensive_shader, expensive, veryexpensive_shader, veryexpensive, tooexpensive_shader, tooexpensive, unobtainable_shader, unobtainable, shiny_shader, shiny, ultrashiny_shader, ultrashiny, balavirus_shader, balavirus, cosmic_shader, cosmic, hypercosmic_shader, hypercosmic, darkmatter_shader, darkmatter, darkvoid_shader, darkvoid, pocketedition_shader, pocketedition, limitededition_shader, limitededition, greedy_shader, greedy, bailiff_shader, bailiff, duplicated_shader, duplicated, trash_shader, trash, lefthanded_shader, lefthanded, righthanded_shader, righthanded, pinkstakecurse_shader, pinkstakecurse, brownstakecurse_shader, brownstakecurse, yellowstakecurse_shader, yellowstakecurse, jadestakecurse_shader, jadestakecurse, cyanstakecurse_shader, cyanstakecurse, graystakecurse_shader, graystakecurse, crimsonstakecurse_shader, crimsonstakecurse, diamondstakecurse_shader, diamondstakecurse, amberstakecurse_shader, amberstakecurse, bronzestakecurse_shader, bronzestakecurse, quartzstakecurse_shader, quartzstakecurse, rubystakecurse_shader, rubystakecurse, glassstakecurse_shader, glassstakecurse, sapphirestakecurse_shader, sapphirestakecurse, emeraldstakecurse_shader, emeraldstakecurse, platinumstakecurse_shader, platinumstakecurse, verdantstakecurse_shader, verdantstakecurse, emberstakecurse_shader, emberstakecurse, dawnstakecurse_shader, dawnstakecurse, horizonstakecurse_shader, horizonstakecurse, blossomstakecurse_shader, blossomstakecurse, azurestakecurse_shader, azurestakecurse, ascendantstakecurse_shader, ascendantstakecurse, brilliant_shader, brilliant, blister_shader, blister, galvanized_shader, galvanized, chromaticplatinum_shader, chromaticplatinum, metallic_shader, metallic, titanium_shader, titanium, omnichromatic_shader, omnichromatic, chromaticastral_shader, chromaticastral, tvghost_shader, tvghost, noisy_shader, noisy, rainbow_shader, rainbow, hyperchrome_shader, hyperchrome, shadowing_shader, shadowing, graymatter_shader, graymatter, hardstone_shader, hardstone, impulsion_shader, impulsion, chromaticimpulsion_shader, chromaticimpulsion, psychedelic_shader, psychedelic, bedrock_shader, bedrock, golden_shader, golden, ultragolden_shader, ultragolden, root_shader, root, catalyst_shader, catalyst, eyesless_balavirus_shader, eyesless_balavirus, absoluteglitch_balavirus_shader, absoluteglitch_balavirus, darkvoid_balavirus_shader, darkvoid_balavirus, psychedelic_balavirus_shader, psychedelic_balavirus,
echo_atlas, echo, lastcoin_atlas, lastcoin, eclipse_atlas, eclipse, holder_atlas, holder,
typhoon_sprite, typhoonii_sprite, typhooniii_sprite, typhooniv_sprite, azure_seal_sprite, typhoon, typhoonii, typhooniii, typhooniv, azure_seal, hyperazure_seal_sprite, hyperazure_seal, black_seal_sprite, black_seal,
cat, empowered, gambler, bundle, memory}
--[[if cry_enable_epics then
    miscitems[#miscitems+1] = epic_tag
end--]] --disabled due to bug
return {name = "Misc.", 
        init = function()

function calculate_blurred(card)
    local retriggers = 1

    if card.edition.retrigger_chance then
        local chance = card.edition.retrigger_chance
        chance = G.GAME.probabilities.normal / chance

        if pseudorandom("blurred") <= chance then
            retriggers = retriggers + card.edition.retriggers
        end
    end
    
    return {
        message = 'Again?',
        repetitions = retriggers,
        card = card
    }
end

function calculate_blind(card)
    local retriggers = 8

    if card.edition.retrigger_chance then
        local chance = card.edition.retrigger_chance
        chance = G.GAME.probabilities.normal / chance

        if pseudorandom("blind") <= chance then
            retriggers = retriggers + card.edition.retriggers
        end
    end
    
    return {
        message = 'Again?',
        repetitions = retriggers,
        card = card
    }
end

function calculate_eyesless(card)
    local retriggers = 64

    if card.edition.retrigger_chance then
        local chance = card.edition.retrigger_chance
        chance = G.GAME.probabilities.normal / chance

        if pseudorandom("eyesless") <= chance then
            retriggers = retriggers + card.edition.retriggers
        end
    end
    
    return {
        message = 'Again?',
        repetitions = retriggers,
        card = card
    }
end

function calculate_eyesless_balavirus(card)
    local retriggers = 512

    if card.edition.retrigger_chance then
        local chance = card.edition.retrigger_chance
        chance = G.GAME.probabilities.normal / chance

        if pseudorandom("eyesless") <= chance then
            retriggers = retriggers + card.edition.retriggers
        end
    end
    
    return {
        message = 'Again?',
        repetitions = retriggers,
        card = card
    }
end

se = Card.set_edition
function Card:set_edition(x,y,z)
    local was_oversat = self.edition and (self.edition.cry_oversat or self.edition.cry_glitched or self.edition.cry_glitchoversat or self.edition.cry_ultraglitch or self.edition.cry_absoluteglitch or self.edition.cry_absoluteglitch_balavirus)
    se(self,x,y,z)
    if was_oversat then
        cry_misprintize(self,nil,true)
    end
    if self.edition and self.edition.cry_oversat then
        cry_misprintize(self, {min=2*(G.GAME.modifiers.cry_misprint_min or 1),max=2*(G.GAME.modifiers.cry_misprint_max or 1)})
    end
    if self.edition and self.edition.cry_glitched then
        cry_misprintize(self, {min=0.1*(G.GAME.modifiers.cry_misprint_min or 1),max=10*(G.GAME.modifiers.cry_misprint_max or 1)})
    end
    if self.edition and self.edition.cry_glitchoversat then
        cry_misprintize(self, {min=0.1*(G.GAME.modifiers.cry_misprint_min or 1),max=100*(G.GAME.modifiers.cry_misprint_max or 1)})
    end
    if self.edition and self.edition.cry_ultraglitch then
        cry_misprintize(self, {min=0.1*(G.GAME.modifiers.cry_misprint_min or 1),max=1000*(G.GAME.modifiers.cry_misprint_max or 1)})
    end
    if self.edition and self.edition.cry_absoluteglitch then
        cry_misprintize(self, {min=0.01*(G.GAME.modifiers.cry_misprint_min or 1),max=100000*(G.GAME.modifiers.cry_misprint_max or 1)})
    end
    if self.edition and self.edition.cry_absoluteglitch_balavirus then
        cry_misprintize(self, {min=1*(G.GAME.modifiers.cry_misprint_min or 1),max=100000000*(G.GAME.modifiers.cry_misprint_max or 1)})
    end
end
--echo card
cs = Card.calculate_seal
function Card:calculate_seal(context)
    local ret = cs(self,context)
    if context.repetition then
        local total_repetitions = ret and ret.repetitions or 0

        if self.config.center == G.P_CENTERS.m_cry_echo then
            if pseudorandom('echo') < G.GAME.probabilities.normal/self.ability.extra then
                total_repetitions = total_repetitions + self.ability.retriggers
                sendDebugMessage("echo retrigger, total " .. tostring(total_repetitions))
            end
        end
        if self.config.center == G.P_CENTERS.m_cry_lastcoin and G.GAME.dollars > 2 then
            G.GAME.dollars = G.GAME.dollars - 2
            G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1
        end
        if self.edition and (self.edition.cry_blur or self.edition.cry_blind or self.edition.cry_eyesless or self.edition.cry_eyesless_balavirus) and not context.other_card then
            local check = calculate_blurred(self)
            
            if check and check.repetitions then
                total_repetitions = total_repetitions + check.repetitions
                sendDebugMessage("blur retrigger, total " .. tostring(total_repetitions) .. "rank: " .. (self.base.value or 'nil') .. " suit: " .. (self.base.suit or 'nil'))
            end
        end

        if total_repetitions > 0 then
            return {
                message = localize('k_again_ex'),
                repetitions = total_repetitions,
                card = self
            }
        end
    end
    return ret
end
--Memory Tag Patches - store last tag used
local tapr = Tag.apply_to_run
function Tag:apply_to_run(x)
    local ret = tapr(self,x)
    if self.triggered and self.key ~= "tag_double" and self.key ~= "tag_cry_memory" and 
    self.key ~= "tag_cry_triple" and self.key ~= "tag_cry_quadruple" and self.key ~= "tag_cry_quintuple" then
        G.GAME.cry_last_tag_used = self.key
    end
    return ret
end

function Card:calculate_banana()
    if not self.ability.extinct then
        if self.ability.banana and (pseudorandom('banana') < G.GAME.probabilities.normal/10) then 
            self.ability.extinct = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    self.T.r = -0.2
                    self:juice_up(0.3, 0.4)
                    self.states.drag.is = true
                    self.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                        func = function()
                                self.area:remove_card(self)
                                self:remove()
                                self = nil
                            return true; end})) 
                    return true
                end
            }))
            card_eval_status_text(self, 'jokers', nil, nil, nil, {message = localize('k_extinct_ex'), delay = 0.1})
            return true
        elseif self.ability.banana then
            card_eval_status_text(self, 'jokers', nil, nil, nil, {message = localize('k_safe_ex'), delay = 0.1})
            return false
        end
    end
    return false
end
        end,
        items = miscitems}

