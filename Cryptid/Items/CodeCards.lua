local code = {
    object_type = "ConsumableType",
    key = "Code",
    primary_colour = HEX("14b341"),
    secondary_colour = HEX("12f254"),
    collection_rows = {4,4}, -- 4 pages for all code cards
    loc_txt = {
        collection = "Code Cards",
        name = "Code",
        label = "Code"
    },
    shop_rate = 0.0,
    default = 'c_cry_crash',
    can_stack = true,
    can_divide = true
}
local code_atlas = {
    object_type = "Atlas",
    key = "code",
    path = "c_cry_code.png",
    px = 71,
    py = 95
}
local pack_atlas = {
    object_type = "Atlas",
    key = "pack",
    path = "pack_cry.png",
    px = 71,
    py = 95
}
local pack1 = {
    object_type = "Booster",
    key = "p_code_normal_1",
    kind = "Code",
    atlas = "pack",
    pos = {x=0,y=0},
    config = {extra = 2, choose = 1},
    cost = 4,
    weight = 1.2,
    create_card = function(self, card)
        return create_card("Code", G.pack_cards, nil, nil, true, true, nil, 'cry_program')
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SET.Code)
        ease_background_colour{new_colour = G.C.SET.Code, special_colour = G.C.BLACK, contrast = 2}
    end,
    loc_vars = function(self, info_queue, card)
		return { vars = {card.config.center.config.choose, card.ability.extra} }
	end,
    loc_txt = {
        name = "Program Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:cry_code} Code{} cards"
        }
    },
    group_key = "k_cry_program_pack"
}
local pack2 = {
    object_type = "Booster",
    key = "p_code_normal_2",
    kind = "Code",
    atlas = "pack",
    pos = {x=1,y=0},
    config = {extra = 2, choose = 1},
    cost = 4,
    weight = 1.2,
    create_card = function(self, card)
        return create_card("Code", G.pack_cards, nil, nil, true, true, nil, 'cry_program')
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SET.Code)
        ease_background_colour{new_colour = G.C.SET.Code, special_colour = G.C.BLACK, contrast = 2}
    end,
    loc_vars = function(self, info_queue, card)
		return { vars = {card.config.center.config.choose, card.ability.extra} }
	end,
    loc_txt = {
        name = "Program Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:cry_code} Code{} cards"
        }
    },
    group_key = "k_cry_program_pack"
}
local packJ = {
    object_type = "Booster",
    key = "p_code_jumbo_1",
    kind = "Code",
    atlas = "pack",
    pos = {x=2,y=0},
    config = {extra = 4, choose = 1},
    cost = 4,
    weight = 0.6,
    create_card = function(self, card)
        return create_card("Code", G.pack_cards, nil, nil, true, true, nil, 'cry_program')
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SET.Code)
        ease_background_colour{new_colour = G.C.SET.Code, special_colour = G.C.BLACK, contrast = 2}
    end,
    loc_vars = function(self, info_queue, card)
		return { vars = {card.config.center.config.choose, card.ability.extra} }
	end,
    loc_txt = {
        name = "Jumbo Program Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:cry_code} Code{} cards"
        }
    },
    group_key = "k_cry_program_pack"
}
local packM = {
    object_type = "Booster",
    key = "p_code_mega_1",
    kind = "Code",
    atlas = "pack",
    pos = {x=3,y=0},
    config = {extra = 4, choose = 2},
    cost = 4,
    weight = 0.15,
    create_card = function(self, card)
        return create_card("Code", G.pack_cards, nil, nil, true, true, nil, 'cry_program')
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.SET.Code)
        ease_background_colour{new_colour = G.C.SET.Code, special_colour = G.C.BLACK, contrast = 2}
    end,
    loc_vars = function(self, info_queue, card)
		return { vars = {card.config.center.config.choose, card.ability.extra} }
	end,
    loc_txt = {
        name = "Mega Program Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:cry_code} Code{} cards"
        }
    },
    group_key = "k_cry_program_pack"
}
local crash = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Crash",
    key = "crash",
    pos = {x=0,y=0},
	config = {},
    loc_txt = {
        name = '://CRASH',
        text = {
			"{C:cry_code,E:1}Don't."
        }
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local f = pseudorandom_element(crash_functions, pseudoseed("cry_crash"))
        f(self, card, area, copier)
    end
}

local payload = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Payload",
    key = "payload",
    pos = {x=1,y=0},
	config = {interest_mult = 3},
    loc_txt = {
        name = '://PAYLOAD',
        text = {
			"Next defeated Blind",
            "gives {C:cry_code}X#1#{} interest"
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {self.config.interest_mult}}
    end,
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return true
    end,
    can_bulk_use = true,
    use = function(self, card, area, copier)
        G.GAME.cry_payload = (G.GAME.cry_payload or 1) * card.ability.interest_mult
    end,
    bulk_use = function(self, card, area, copier, number)
        G.GAME.cry_payload = (G.GAME.cry_payload or 1) * card.ability.interest_mult^number
    end
}
local reboot = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Reboot",
    key = "reboot",
    pos = {x=2,y=0},
	config = {},
    loc_txt = {
        name = '://REBOOT',
        text = {
			"Replenish {C:blue}Hands{} and {C:red}Discards{},",
            "return {C:cry_code}all{} cards to deck",
            "and draw a {C:cry_code}new{} hand"
        }
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND
    end,
    use = function(self, card, area, copier)
        G.FUNCS.draw_from_hand_to_discard()
        G.FUNCS.draw_from_discard_to_deck()
        ease_discard(math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards)-G.GAME.current_round.discards_left)
        ease_hands_played(math.max(1, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands)-G.GAME.current_round.hands_left)
        for k, v in pairs(G.playing_cards) do
            v.ability.wheel_flipped = nil
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                G.STATE = G.STATES.DRAW_TO_HAND
                G.deck:shuffle('cry_reboot'..G.GAME.round_resets.ante)
                G.deck:hard_set_T()
                G.STATE_COMPLETE = false
                return true
            end
        }))

    end
}

local revert = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Revert",
    key = "revert",
    pos = {x=3,y=0},
	config = {},
    loc_txt = {
        name = '://REVERT',
        text = {
			"Set {C:cry_code}game state{} to",
            "start of {C:cry_code}this Ante{}"
        }
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return G.GAME.cry_revert
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 4,
            func = function()
                G:delete_run()
                G:start_run({
                    savetext = STR_UNPACK(G.GAME.cry_revert),
                })
            end
        }),"other")
    end
}

local semicolon = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Semicolon",
    key = "semicolon",
    pos = {
        x = 0,
        y = 1
    },
    config = {},
    loc_txt = {
        name = ';//',
        text = {"Ends current non-Boss {C:cry_code}Blind{},", "Blind gives {C:cry_code}no{} reward money"}
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND and not G.GAME.blind.boss
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                if G.STATE ~= G.STATES.SELECTING_HAND then return false end
                G.GAME.current_round.semicolon = true
                G.STATE = G.STATES.HAND_PLAYED
                G.STATE_COMPLETE = true
                end_round()
                return true
            end
        }), "other")
    end
}

local malware = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Malware",
    key = "malware",
    pos = {
        x = 1,
        y = 1
    },
    config = {},
    loc_txt = {
        name = '://MALWARE',
        text = {"Add {C:dark_edition}Glitched{} to all",
                "cards {C:cry_code}held in hand"}
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        for i=1, #G.hand.cards do
            local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('card1', percent);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.2)
        for i=1, #G.hand.cards do
			local CARD = G.hand.cards[i]
            local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() CARD:flip();
            CARD:set_edition({
            				cry_glitched = true
            			})
                  play_sound('tarot2', percent);CARD:juice_up(0.3, 0.3);return true end }))
        end
    end
}

local seed = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Seed",
    key = "seed",
    pos = {
        x = 2,
        y = 1
    },
    config = {},
    loc_txt = {
        name = '://SEED',
        text = {
            "Select a Joker",
            "or playing card",
            "to become {C:cry_code}Rigged"
        }
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return #G.jokers.highlighted + #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        if G.jokers.highlighted[1] then
            G.jokers.highlighted[1].ability.cry_rigged = true
        end
        if G.hand.highlighted[1] then
            G.hand.highlighted[1].ability.cry_rigged = true
        end
    end
}

local ransomware = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Ransomware",
    key = "ransomware",
    pos = {x=3,y=1},
	config = {},
    loc_txt = {
        name = '://RANSOMWARE',
        text = {
			"Add {C:gold}200${} to current {C:gold}money{}",
                        "{C:red}-1{} to {C:blue}hands{}, {C:red}discards{}, {C:dark_edition}jokers{}",
                        " and {C:attention}consumeables{} slots"
        }
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.dollars = G.GAME.dollars + 200
        G.GAME.round_resets.hands = G.GAME.round_resets.hands -1
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
        G.jokers.config.card_limit = G.jokers.config.card_limit - 1
        G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
    end
}
local hardmode = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Hardmode",
    key = "hardmode",
    pos = {x=4,y=1},
	config = {},
    loc_txt = {
        name = '://HARDMODE',
        text = {
			"There is {C:attention}only vouchers{} in shop",
                        "{X:mult,C:white}X2{} to {C:blue}hands{}, {C:red}discards{}, {C:dark_edition}jokers{}",
                        " and {C:attention}consumeables{} slots"
        }
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.shop.joker_max = 0
         G.GAME.modifiers.cry_booster_packs = 0
        G.GAME.round_resets.hands = G.GAME.round_resets.hands * 2
        G.GAME.round_resets.discards = G.GAME.round_resets.discards * 2
        G.jokers.config.card_limit = G.jokers.config.card_limit * 2
        G.consumeables.config.card_limit = G.consumeables.config.card_limit * 2
    end
}
local ddos = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Ddos",
    key = "ddos",
    pos = {x=5,y=1},
	config = {},
    loc_txt = {
        name = '://DDOS',
        text = {
			"{C:red}+2${} in shop prizes",
                        "{C:gold}+1${} interest"
        }
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.inflation = G.GAME.inflation + 2
        G.GAME.interest_amount = G.GAME.interest_amount + 1
    end
}
local encoding = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Encoding",
    key = "encoding",
    pos = {x=0,y=2},
	config = {},
    loc_txt = {
        name = '://ENCODING',
        text = {
			"Upgrade the tier of an edition on a {C:dark_edition}joker{}.",
                        "Cost {C:gold}40${}, increase by {C:gold]}20${}",
                        "per tier level (increase by {X:gold,C:white}X10{}",
                        "for astral tiers)"
        }
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return #G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition and ((#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_astral and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_hyperastral and G.GAME.dollars >= 400) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_cosmic and G.GAME.dollars >= 4000) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_hypercosmic and G.GAME.dollars >= 40000) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_darkmatter and G.GAME.dollars >= 400000) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_eraser and G.GAME.dollars >= 20) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_opposite and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_superopposite and G.GAME.dollars >= 60) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_ultraopposite and G.GAME.dollars >= 80) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_mosaic and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.polychrome and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_duplicated and G.GAME.dollars >= 60) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_glitched and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_oversat and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_glitchoversat and G.GAME.dollars >= 60) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_ultraglitch and G.GAME.dollars >= 80) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_blur and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_blind and G.GAME.dollars >= 60) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_pocketedition and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_trash and G.GAME.dollars >= 20) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_greedy and G.GAME.dollars >= 20) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_bailiff and G.GAME.dollars >= 20) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.foil and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_metallic and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_rainbow and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_shadowing and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.holo and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_hardstone and G.GAME.dollars >= 60) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_titanium and G.GAME.dollars >= 60) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_root and G.GAME.dollars >= 20) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_golden and G.GAME.dollars >= 80) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.bunc_glitter and G.GAME.dollars >= 20) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.bunc_fluorescent and G.GAME.dollars >= 40) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.phantom and G.GAME.dollars >= 20) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.tentacle and G.GAME.dollars >= 1e+7) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.kraken and G.GAME.dollars >= 1e+20) or (#G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.bunc_burnt and G.GAME.dollars >= 20))
    end,
    use = function(self, card, area, copier)
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_darkmatter then
            if G.GAME.dollars >= 400000 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_darkvoid = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 400000
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_hypercosmic then
            if G.GAME.dollars >= 40000 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_darkmatter = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40000
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_cosmic then
            if G.GAME.dollars >= 4000 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_hypercosmic = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 4000
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_hyperastral then
            if G.GAME.dollars >= 400 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_cosmic = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 400
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_astral then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_hyperastral = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_root then
            if G.GAME.dollars >= 20 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_astral = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 20
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_ultraopposite then
            if G.GAME.dollars >= 80 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_hyperopposite = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 80
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_superopposite then
            if G.GAME.dollars >= 60 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_ultraopposite = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 60
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_opposite then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_superopposite = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_eraser then
            if G.GAME.dollars >= 20 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_opposite = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 20
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_mosaic then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_sparkle = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.bunc_glitter then
            if G.GAME.dollars >= 20 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_mosaic = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 20
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_duplicated then
            if G.GAME.dollars >= 60 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_brilliant = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 60
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.polychrome then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_duplicated = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.bunc_burnt then
            if G.GAME.dollars >= 20 then
                G.jokers.highlighted[1]:set_edition({
            				    polychrome = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 20
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_ultraglitch then
            if G.GAME.dollars >= 80 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_absoluteglitch = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 80
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_glitchoversat then
            if G.GAME.dollars >= 60 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_ultraglitch = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 60
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_oversat then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_glitchoversat = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_glitched then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_glitchoversat = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_blind then
            if G.GAME.dollars >= 60 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_eyesless = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 60
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_blur then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_blind = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_pocketedition then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_limitededition = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_trash then
            if G.GAME.dollars >= 20 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_pocketedition = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 20
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_greedy then
            if G.GAME.dollars >= 20 then
                G.jokers.highlighted[1]:set_edition({
            				    foil = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 20
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_bailiff then
            if G.GAME.dollars >= 20 then
                G.jokers.highlighted[1]:set_edition({
            				    holographic = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 20
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.foil then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_blister = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_golden then
            if G.GAME.dollars >= 80 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_ultragolden = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 80
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_titanium then
            if G.GAME.dollars >= 60 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_golden = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 60
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_metallic then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_titanium = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_rainbow then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_hyperchrome = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_shadowing then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_graymatter = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.cry_hardstone then
            if G.GAME.dollars >= 60 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_bedrock = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 60
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.holo then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    cry_hardstone = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.bunc_fluorescent then
            if G.GAME.dollars >= 40 then
                G.jokers.highlighted[1]:set_edition({
            				    negative = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 40
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.phantom then
            if G.GAME.dollars >= 20 then
                G.jokers.highlighted[1]:set_edition({
            				    negative = true
            			    })
                G.GAME.dollars = G.GAME.dollars - 20
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.kraken then
            if G.GAME.dollars >= 1e+20 then
                G.jokers.highlighted[1]:set_edition({
            				    cthulhu = true
            			    })
                G.GAME.dollars = G.GAME.dollars - (1e+20)
            end
        end
        if G.jokers.highlighted[1] and G.jokers.highlighted[1].edition.tentacle then
            if G.GAME.dollars >= 1e+7 then
                G.jokers.highlighted[1]:set_edition({
            				    kraken = true
            			    })
                G.GAME.dollars = G.GAME.dollars - (1e+7)
            end
        end
    end
}
local encoding_advanced = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Encoding_advanced",
    key = "encoding_advanced",
    pos = {x=1,y=2},
	config = {},
    loc_txt = {
        name = '://ENCODING_ADVANCED',
        text = {
			"Merges editions from the leftmost 2 {C:dark_edition}jokers{}.",
                        "Cost {C:gold}80${}",
        }
    },
    cost = 8,
    atlas = "code",

-- La première parenthèse correspond à la liste des conditions lorsqu'il y a deux éditions sur les deux jokers les plus à gauche.

    can_use = function(self, card)
        return G.GAME.dollars >=80 and G.jokers.cards[1].edition and G.jokers.cards[2].edition and ((G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.polychrome and G.jokers.cards[2].edition.cry_blister) or (G.jokers.cards[1].edition.cry_blister and G.jokers.cards[2].edition.polychrome))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_cosmic and G.jokers.cards[2].edition.cry_brilliant) or (G.jokers.cards[1].edition.cry_brilliant and G.jokers.cards[2].edition.cry_cosmic))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_expensive and G.jokers.cards[2].edition.cry_shiny) or (G.jokers.cards[1].edition.cry_shiny and G.jokers.cards[2].edition.cry_expensive))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_chromaticplatinum) or (G.jokers.cards[1].edition.cry_chromaticplatinum and G.jokers.cards[2].edition.cry_balavirus))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_astral and G.jokers.cards[2].edition.polychrome) or (G.jokers.cards[1].edition.polychrome and G.jokers.cards[2].edition.cry_astral))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_tvghost and G.jokers.cards[2].edition.cry_sparkle) or (G.jokers.cards[1].edition.cry_sparkle and G.jokers.cards[2].edition.cry_tvghost))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.polychrome and G.jokers.cards[2].edition.cry_ultrashiny) or (G.jokers.cards[1].edition.cry_ultrashiny and G.jokers.cards[2].edition.polychrome))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_astral and G.jokers.cards[2].edition.cry_metallic) or (G.jokers.cards[1].edition.cry_metallic and G.jokers.cards[2].edition.cry_astral))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.brilliant and G.jokers.cards[2].edition.cry_impulsion) or (G.jokers.cards[1].edition.cry_impulsion and G.jokers.cards[2].edition.brilliant))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_catalyst and G.jokers.cards[2].edition.cry_shiny) or (G.jokers.cards[1].edition.cry_shiny and G.jokers.cards[2].edition.cry_catalyst))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_catalyst and G.jokers.cards[2].edition.cry_ultrashiny) or (G.jokers.cards[1].edition.cry_ultrashiny and G.jokers.cards[2].edition.cry_catalyst))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_psychedelic) or (G.jokers.cards[1].edition.cry_psychedelic and G.jokers.cards[2].edition.cry_balavirus))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_darkvoid) or (G.jokers.cards[1].edition.cry_darkvoid and G.jokers.cards[2].edition.cry_balavirus))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_eyesless) or (G.jokers.cards[1].edition.cry_eyesless and G.jokers.cards[2].edition.cry_balavirus))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_absoluteglitch) or (G.jokers.cards[1].edition.cry_absoluteglitch and G.jokers.cards[2].edition.cry_balavirus))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_balavirus) or (G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_balavirus))) or (G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_shiny and G.jokers.cards[2].edition.cry_galvanized) or (G.jokers.cards[1].edition.cry_galvanized and G.jokers.cards[2].edition.cry_shiny))))
    end,
    use = function(self, card, area, copier)
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.polychrome and G.jokers.cards[2].edition.cry_blister) or (G.jokers.cards[1].edition.cry_blister and G.jokers.cards[2].edition.polychrome)) then
            G.jokers.cards[1]:set_edition({
             			    cry_galvanized = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_galvanized = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_cosmic and G.jokers.cards[2].edition.cry_brilliant) or (G.jokers.cards[1].edition.cry_brilliant and G.jokers.cards[2].edition.cry_cosmic)) then
            G.jokers.cards[1]:set_edition({
             			    cry_chromaticplatinum = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_chromaticplatinum = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_expensive and G.jokers.cards[2].edition.cry_shiny) or (G.jokers.cards[1].edition.cry_shiny and G.jokers.cards[2].edition.cry_expensive)) then
            G.jokers.cards[1]:set_edition({
             			    cry_metallic = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_metallic = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_chromaticplatinum) or (G.jokers.cards[1].edition.cry_chromaticplatinum and G.jokers.cards[2].edition.cry_balavirus)) then
            G.jokers.cards[1]:set_edition({
             			    cry_omnichromatic = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_omnichromatic = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_astral and G.jokers.cards[2].edition.polychrome) or (G.jokers.cards[1].edition.polychrome and G.jokers.cards[2].edition.cry_astral)) then
            G.jokers.cards[1]:set_edition({
             			    cry_chromaticastral = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_chromaticastral = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_tvghost and G.jokers.cards[2].edition.cry_sparkle) or (G.jokers.cards[1].edition.cry_sparkle and G.jokers.cards[2].edition.cry_tvghost)) then
            G.jokers.cards[1]:set_edition({
             			    cry_noisy = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_noisy = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.polychrome and G.jokers.cards[2].edition.cry_ultrashiny) or (G.jokers.cards[1].edition.cry_ultrashiny and G.jokers.cards[2].edition.polychrome)) then
            G.jokers.cards[1]:set_edition({
             			    cry_rainbow = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_rainbow = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_astral and G.jokers.cards[2].edition.cry_metallic) or (G.jokers.cards[1].edition.cry_metallic and G.jokers.cards[2].edition.cry_astral)) then
            G.jokers.cards[1]:set_edition({
             			    cry_impulsion = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_impulsion = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.brilliant and G.jokers.cards[2].edition.cry_impulsion) or (G.jokers.cards[1].edition.cry_impulsion and G.jokers.cards[2].edition.brilliant)) then
            G.jokers.cards[1]:set_edition({
             			    cry_chromaticimpulsion = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_chromaticimpulsion = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_catalyst and G.jokers.cards[2].edition.cry_shiny) or (G.jokers.cards[1].edition.cry_shiny and G.jokers.cards[2].edition.cry_catalyst)) then
            G.jokers.cards[1]:set_edition({
             			    cry_ultrashiny = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_ultrashiny = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_catalyst and G.jokers.cards[2].edition.cry_ultrashiny) or (G.jokers.cards[1].edition.cry_ultrashiny and G.jokers.cards[2].edition.cry_catalyst)) then
            G.jokers.cards[1]:set_edition({
             			    cry_balavirus = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_balavirus = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_psychedelic) or (G.jokers.cards[1].edition.cry_psychedelic and G.jokers.cards[2].edition.cry_balavirus)) then
            G.jokers.cards[1]:set_edition({
             			    cry_psychedelic_balavirus = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_psychedelic_balavirus = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_darkvoid) or (G.jokers.cards[1].edition.cry_darkvoid and G.jokers.cards[2].edition.cry_balavirus)) then
            G.jokers.cards[1]:set_edition({
             			    cry_darkvoid_balavirus = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_darkvoid_balavirus = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_eyesless) or (G.jokers.cards[1].edition.cry_eyesless and G.jokers.cards[2].edition.cry_balavirus)) then
            G.jokers.cards[1]:set_edition({
             			    cry_eyesless_balavirus = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_eyesless_balavirus = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_absoluteglitch) or (G.jokers.cards[1].edition.cry_absoluteglitch and G.jokers.cards[2].edition.cry_balavirus)) then
            G.jokers.cards[1]:set_edition({
             			    cry_absoluteglitch_balavirus = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_absoluteglitch_balavirus = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_balavirus) or (G.jokers.cards[1].edition.cry_balavirus and G.jokers.cards[2].edition.cry_balavirus)) then
            G.jokers.cards[1]:set_edition({
             			    bunc_balavirussquare = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    bunc_balavirussquare = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
        if G.jokers.cards[1] and G.jokers.cards[2] and ((G.jokers.cards[1].edition.cry_shiny and G.jokers.cards[2].edition.cry_galvanized) or (G.jokers.cards[1].edition.cry_galvanized and G.jokers.cards[2].edition.cry_shiny)) then
            G.jokers.cards[1]:set_edition({
             			    bunc_shinygalvanized = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    bunc_shinygalvanized = true
          	    })
            G.GAME.dollars = G.GAME.dollars - 80
        end
    end
}
local freecard = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Freecard",
    key = "freecard",
    pos = {x=2,y=2},
	config = {},
    loc_txt = {
        name = '://FREECARD',
        text = {
			"Multiplies {C:gold}money{} by {C:red}-1{}",
        }
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return G.GAME.dollars ~= 0
    end,
    use = function(self, card, area, copier)
        G.GAME.dollars = G.GAME.dollars * (-1)
    end
}
local encoding_chromatic = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Encoding_chromatic",
    key = "encoding_chromatic",
    pos = {x=3,y=2},
	config = {},
    loc_txt = {
        name = '://ENCODING_CHROMATIC',
        text = {
			"{C:attention}Merges{} the 6 {C:dark_editions}chromatic editions{}",
                        "Place the 6 editions at the left to use it. Cost {C:gold}200${}",
                        "{C:gray}Joker 1 = Polychrome, Joker 2 = Chromatic Impulsion{}",
                        "{C:gray}Joker 3 = Omnichromatic, Joker 4 = Chromatic Platinum{}",
                        "{C:gray}Joker 5 = Chromatic Astral, Joker 6 = Hyperchrome{}"
        }
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return G.GAME.dollars >= 200 and G.jokers.cards[1] and G.jokers.cards[2] and G.jokers.cards[3] and G.jokers.cards[4] and G.jokers.cards[5] and G.jokers.cards[6] and G.jokers.cards[1].edition and G.jokers.cards[2].edition and G.jokers.cards[3].edition and G.jokers.cards[4].edition and G.jokers.cards[5].edition and G.jokers.cards[6].edition and ((G.jokers.cards[1].edition.polychrome and G.jokers.cards[2].edition.cry_chromaticimpulsion and G.jokers.cards[3].edition.cry_omnichromatic and G.jokers.cards[4].edition.cry_chromaticplatinum and G.jokers.cards[5].edition.cry_chromaticastral and G.jokers.cards[6].edition.cry_hyperchrome))
    end,
    use = function(self, card, area, copier)
        if G.jokers.cards[1].edition.polychrome then
            G.jokers.cards[1]:set_edition({
             			    cry_psychedelic = true
          	    })
            G.jokers.cards[2]:set_edition({
             			    cry_psychedelic = true
          	    })
            G.jokers.cards[3]:set_edition({
             			    cry_psychedelic = true
          	    })
            G.jokers.cards[4]:set_edition({
             			    cry_psychedelic = true
          	    })
            G.jokers.cards[5]:set_edition({
             			    cry_psychedelic = true
          	    })
            G.jokers.cards[6]:set_edition({
             			    cry_psychedelic = true
              	    })
            G.GAME.dollars = G.GAME.dollars - 200
        end
    end
}

local paste = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Paste",
    key = "paste",
    pos = {x=4,y=2},
	config = {},
    loc_txt = {
        name = '://PASTE',
        text = {
			"Place the {C:dark_edition}edition{} of the leftmost {C:attention}playing card{}",
                        "to the leftmost {C:dark_edition}joker{}"
        }
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return #G.hand.cards > 0 and #G.jokers.cards > 0 and (G.hand.cards[1].edition)
    end,
    use = function(self, card, area, copier)
      if G.hand.cards[1].edition then
        if G.hand.cards[1].edition.foil then
            G.jokers.cards[1]:set_edition({
             			    foil = true
          	    })
            G.hand.cards[1]:set_edition({
             			    foil = false
          	    })
	
        elseif G.hand.cards[1].edition.holo then
            G.jokers.cards[1]:set_edition({
             			    holo = true
          	    })
            G.hand.cards[1]:set_edition({
             			    holo = false
          	    })

        elseif G.hand.cards[1].edition.phantom then
            G.jokers.cards[1]:set_edition({
             			    phantom = true
          	    })
            G.hand.cards[1]:set_edition({
             			    phantom = false
          	    })

        elseif G.hand.cards[1].edition.tentacle then
            G.jokers.cards[1]:set_edition({
             			    tentacle = true
          	    })
            G.hand.cards[1]:set_edition({
             			    tentacle = false
          	    })

        elseif G.hand.cards[1].edition.kraken then
            G.jokers.cards[1]:set_edition({
             			    kraken = true
          	    })
            G.hand.cards[1]:set_edition({
             			    kraken = false
          	    })

        elseif G.hand.cards[1].edition.cthulhu then
            G.jokers.cards[1]:set_edition({
             			    cthulhu = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cthulhu = false
          	    })

        elseif G.hand.cards[1].edition.bunc_fluorescent then
            G.jokers.cards[1]:set_edition({
             			    bunc_fluorescent = true
          	    })
            G.hand.cards[1]:set_edition({
             			    bunc_fluorescent = false
          	    })

        elseif G.hand.cards[1].edition.bunc_glitter then
            G.jokers.cards[1]:set_edition({
             			    bunc_glitter = true
          	    })
            G.hand.cards[1]:set_edition({
             			    bunc_glitter = false
          	    })
	
        elseif G.hand.cards[1].edition.polychrome then
            G.jokers.cards[1]:set_edition({
             			    polychrome = true
          	    })
            G.hand.cards[1]:set_edition({
             			    polychrome = false
          	    })
	
        elseif G.hand.cards[1].edition.negative then
            G.jokers.cards[1]:set_edition({
             			    negative = true
          	    })
            G.hand.cards[1]:set_edition({
             			    negative = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_opposite then
            G.jokers.cards[1]:set_edition({
             			    cry_opposite = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_opposite = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_superopposite then
            G.jokers.cards[1]:set_edition({
             			    cry_superopposite = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_superopposite = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_ultraopposite then
            G.jokers.cards[1]:set_edition({
             			    cry_ultraopposite = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_ultraopposite = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_hyperopposite then
            G.jokers.cards[1]:set_edition({
             			    cry_hyperopposite = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_hyperopposite = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_eraser then
            G.jokers.cards[1]:set_edition({
             			    cry_eraser = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_eraser = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_mosaic then
            G.jokers.cards[1]:set_edition({
             			    cry_mosaic = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_mosaic = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_sparkle then
            G.jokers.cards[1]:set_edition({
             			    cry_sparkle = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_sparkle = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_oversat then
            G.jokers.cards[1]:set_edition({
             			    cry_oversat = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_oversat = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_glitched then
            G.jokers.cards[1]:set_edition({
             			    cry_glitched = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_glitched = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_glitchoversat then
            G.jokers.cards[1]:set_edition({
             			    cry_glitchoversat = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_glitchoversat = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_ultraglitch then
            G.jokers.cards[1]:set_edition({
             			    cry_ultraglitch = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_ultraglitch = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_absoluteglitch then
            G.jokers.cards[1]:set_edition({
             			    cry_absoluteglitch = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_absoluteglitch = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_astral then
            G.jokers.cards[1]:set_edition({
             			    cry_astral = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_astral = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_hyperastral then
            G.jokers.cards[1]:set_edition({
             			    cry_hyperastral = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_hyperastral = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_blur then
            G.jokers.cards[1]:set_edition({
             			    cry_blur = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_blur = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_blind then
            G.jokers.cards[1]:set_edition({
             			    cry_blind = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_blind = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_eyesless then
            G.jokers.cards[1]:set_edition({
             			    cry_eyesless = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_eyesless = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_expensive then
            G.jokers.cards[1]:set_edition({
             			    cry_expensive = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_expensive = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_veryexpensive then
            G.jokers.cards[1]:set_edition({
             			    cry_veryexpensive = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_veryexpensive = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_tooexpensive then
            G.jokers.cards[1]:set_edition({
             			    cry_tooexpensive = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_tooexpensive = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_unobtainable then
            G.jokers.cards[1]:set_edition({
             			    cry_unobtainable = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_unobtainable = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_shiny then
            G.jokers.cards[1]:set_edition({
             			    cry_shiny = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_shiny = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_ultrashiny then
            G.jokers.cards[1]:set_edition({
             			    cry_ultrashiny = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_ultrashiny = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_balavirus then
            G.jokers.cards[1]:set_edition({
             			    cry_balavirus = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_balavirus = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_cosmic then
            G.jokers.cards[1]:set_edition({
             			    cry_cosmic = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_cosmic = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_hypercosmic then
            G.jokers.cards[1]:set_edition({
             			    cry_hypercosmic = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_hypercosmic = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_darkmatter then
            G.jokers.cards[1]:set_edition({
             			    cry_darkmatter = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_darkmatter = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_darkvoid then
            G.jokers.cards[1]:set_edition({
             			    cry_darkvoid = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_darkvoid = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_pocketedition then
            G.jokers.cards[1]:set_edition({
             			    cry_pocketedition = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_pocketedition = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_limitededition then
            G.jokers.cards[1]:set_edition({
             			    cry_limitededition = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_limitededition = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_greedy then
            G.jokers.cards[1]:set_edition({
             			    cry_greedy = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_greedy = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_bailiff then
            G.jokers.cards[1]:set_edition({
             			    cry_bailiff = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_bailiff = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_duplicated then
            G.jokers.cards[1]:set_edition({
             			    cry_duplicated = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_duplicated = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_trash then
            G.jokers.cards[1]:set_edition({
             			    cry_trash = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_trash = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_lefthanded then
            G.jokers.cards[1]:set_edition({
             			    cry_lefthanded = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_lefthanded = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_righthanded then
            G.jokers.cards[1]:set_edition({
             			    cry_righthanded = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_righthanded = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_pinkstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_pinkstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_pinkstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_brownstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_brownstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_brownstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_yellowstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_yellowstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_yellowstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_jadestakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_jadestakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_jadestakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_cyanstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_cyanstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_cyanstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_graystakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_graystakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_graystakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_crimsonstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_crimsonstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_crimsonstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_diamondstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_diamondstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_diamondstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_amberstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_amberstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_amberstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_bronzestakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_bronzestakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_bronzestakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_quartzstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_quartzstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_quartzstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_rubystakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_rubystakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_rubystakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_glassstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_glassstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_glassstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_sapphirestakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_sapphirestakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_sapphirestakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_emeraldstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_emeraldstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_emeraldstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_platinumstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_platinumstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_platinumstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_verdantstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_verdantstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_verdantstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_emberstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_emberstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_emberstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_dawnstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_dawnstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_dawnstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_horizonstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_horizonstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_horizonstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_blossomstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_blossomstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_blossomstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_azurestakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_azurestakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_azurestakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_ascendantstakecurse then
            G.jokers.cards[1]:set_edition({
             			    cry_ascendantstakecurse = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_ascendantstakecurse = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_brilliant then
            G.jokers.cards[1]:set_edition({
             			    cry_brilliant = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_brilliant = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_blister then
            G.jokers.cards[1]:set_edition({
             			    cry_blister = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_blister = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_galvanized then
            G.jokers.cards[1]:set_edition({
             			    cry_galvanized = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_galvanized = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_chromaticplatinum then
            G.jokers.cards[1]:set_edition({
             			    cry_chromaticplatinum = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_chromaticplatinum = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_metallic then
            G.jokers.cards[1]:set_edition({
             			    cry_metallic = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_metallic = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_titanium then
            G.jokers.cards[1]:set_edition({
             			    cry_titanium = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_titanium = false
          	    })
        
        elseif G.hand.cards[1].edition.cry_omnichromatic then
            G.jokers.cards[1]:set_edition({
             			    cry_omnichromatic = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_omnichromatic = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_chromaticastral then
            G.jokers.cards[1]:set_edition({
             			    cry_chromaticastral = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_chromaticastral = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_tvghost then
            G.jokers.cards[1]:set_edition({
             			    cry_tvghost = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_tvghost = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_noisy then
            G.jokers.cards[1]:set_edition({
             			    cry_noisy = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_noisy = false
          	    })	
	
        elseif G.hand.cards[1].edition.cry_rainbow then
            G.jokers.cards[1]:set_edition({
             			    cry_rainbow = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_rainbow = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_hyperchrome then
            G.jokers.cards[1]:set_edition({
             			    cry_hyperchrome = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_hyperchrome = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_shadowing then
            G.jokers.cards[1]:set_edition({
             			    cry_shadowing = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_shadowing = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_graymatter then
            G.jokers.cards[1]:set_edition({
             			    cry_graymatter = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_graymatter = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_hardstone then
            G.jokers.cards[1]:set_edition({
             			    cry_hardstone = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_hardstone = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_impulsion then
            G.jokers.cards[1]:set_edition({
             			    cry_impulsion = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_impulsion = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_chromaticimpulsion then
            G.jokers.cards[1]:set_edition({
             			    cry_chromaticimpulsion = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_chromaticimpulsion = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_psychedelic then
            G.jokers.cards[1]:set_edition({
             			    cry_psychedelic = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_psychedelic = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_bedrock then
            G.jokers.cards[1]:set_edition({
             			    cry_bedrock = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_bedrock = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_golden then
            G.jokers.cards[1]:set_edition({
             			    cry_golden = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_golden = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_ultragolden then
            G.jokers.cards[1]:set_edition({
             			    cry_ultragolden = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_ultragolden = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_root then
            G.jokers.cards[1]:set_edition({
             			    cry_root = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_root = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_catalyst then
            G.jokers.cards[1]:set_edition({
             			    cry_catalyst = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_catalyst = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_eyesless_balavirus then
            G.jokers.cards[1]:set_edition({
             			    cry_eyesless_balavirus = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_eyesless_balavirus = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_absoluteglitch_balavirus then
            G.jokers.cards[1]:set_edition({
             			    cry_absoluteglitch_balavirus = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_absoluteglitch_balavirus = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_darkvoid_balavirus then
            G.jokers.cards[1]:set_edition({
             			    cry_darkvoid_balavirus = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_darkvoid_balavirus = false
          	    })
	
        elseif G.hand.cards[1].edition.cry_psychedelic_balavirus then
            G.jokers.cards[1]:set_edition({
             			    cry_psychedelic_balavirus = true
          	    })
            G.hand.cards[1]:set_edition({
             			    cry_psychedelic_balavirus = false
          	    })
        end
      end
    end
}

local cut = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Cut",
    key = "cut",
    pos = {x=5,y=2},
	config = {},
    loc_txt = {
        name = '://CUT',
        text = {
			"Place the {C:dark_edition}edition{} of the leftmost {C:dark_edition}joker{}",
                        "to the leftmost {C:attention}playing card{}"
        }
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return #G.hand.cards > 0 and #G.jokers.cards > 0 and (G.jokers.cards[1].edition)
    end,
    use = function(self, card, area, copier)
      if G.jokers.cards[1].edition then
        if G.jokers.cards[1].edition.foil then
            G.hand.cards[1]:set_edition({
             			    foil = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    foil = false
          	    })
	
        elseif G.jokers.cards[1].edition.holo then
            G.hand.cards[1]:set_edition({
             			    holo = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    holo = false
          	    })

        elseif G.jokers.cards[1].edition.phantom then
            G.hand.cards[1]:set_edition({
             			    phantom = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    phantom = false
          	    })

        elseif G.jokers.cards[1].edition.tentacle then
            G.hand.cards[1]:set_edition({
             			    tentacle = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    tentacle = false
          	    })

        elseif G.jokers.cards[1].edition.kraken then
            G.hand.cards[1]:set_edition({
             			    kraken = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    kraken = false
          	    })

        elseif G.jokers.cards[1].edition.cthulhu then
            G.hand.cards[1]:set_edition({
             			    cthulhu = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cthulhu = false
          	    })

        elseif G.jokers.cards[1].edition.bunc_fluorescent then
            G.hand.cards[1]:set_edition({
             			    bunc_fluorescent = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    bunc_fluorescent = false
          	    })

        elseif G.jokers.cards[1].edition.bunc_glitter then
            G.hand.cards[1]:set_edition({
             			    bunc_glitter = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    bunc_glitter = false
          	    })
	
        elseif G.jokers.cards[1].edition.polychrome then
            G.hand.cards[1]:set_edition({
             			    polychrome = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    polychrome = false
          	    })
	
        elseif G.jokers.cards[1].edition.negative then
            G.hand.cards[1]:set_edition({
             			    negative = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    negative = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_opposite then
            G.hand.cards[1]:set_edition({
             			    cry_opposite = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_opposite = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_superopposite then
            G.hand.cards[1]:set_edition({
             			    cry_superopposite = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_superopposite = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_ultraopposite then
            G.hand.cards[1]:set_edition({
             			    cry_ultraopposite = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_ultraopposite = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_hyperopposite then
            G.hand.cards[1]:set_edition({
             			    cry_hyperopposite = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_hyperopposite = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_eraser then
            G.hand.cards[1]:set_edition({
             			    cry_eraser = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_eraser = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_mosaic then
            G.hand.cards[1]:set_edition({
             			    cry_mosaic = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_mosaic = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_sparkle then
            G.hand.cards[1]:set_edition({
             			    cry_sparkle = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_sparkle = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_oversat then
            G.hand.cards[1]:set_edition({
             			    cry_oversat = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_oversat = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_glitched then
            G.hand.cards[1]:set_edition({
             			    cry_glitched = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_glitched = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_glitchoversat then
            G.hand.cards[1]:set_edition({
             			    cry_glitchoversat = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_glitchoversat = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_ultraglitch then
            G.hand.cards[1]:set_edition({
             			    cry_ultraglitch = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_ultraglitch = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_absoluteglitch then
            G.hand.cards[1]:set_edition({
             			    cry_absoluteglitch = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_absoluteglitch = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_astral then
            G.hand.cards[1]:set_edition({
             			    cry_astral = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_astral = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_hyperastral then
            G.hand.cards[1]:set_edition({
             			    cry_hyperastral = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_hyperastral = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_blur then
            G.hand.cards[1]:set_edition({
             			    cry_blur = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_blur = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_blind then
            G.hand.cards[1]:set_edition({
             			    cry_blind = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_blind = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_eyesless then
            G.hand.cards[1]:set_edition({
             			    cry_eyesless = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_eyesless = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_expensive then
            G.hand.cards[1]:set_edition({
             			    cry_expensive = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_expensive = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_veryexpensive then
            G.hand.cards[1]:set_edition({
             			    cry_veryexpensive = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_veryexpensive = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_tooexpensive then
            G.hand.cards[1]:set_edition({
             			    cry_tooexpensive = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_tooexpensive = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_unobtainable then
            G.hand.cards[1]:set_edition({
             			    cry_unobtainable = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_unobtainable = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_shiny then
            G.hand.cards[1]:set_edition({
             			    cry_shiny = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_shiny = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_ultrashiny then
            G.hand.cards[1]:set_edition({
             			    cry_ultrashiny = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_ultrashiny = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_balavirus then
            G.hand.cards[1]:set_edition({
             			    cry_balavirus = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_balavirus = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_cosmic then
            G.hand.cards[1]:set_edition({
             			    cry_cosmic = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_cosmic = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_hypercosmic then
            G.hand.cards[1]:set_edition({
             			    cry_hypercosmic = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_hypercosmic = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_darkmatter then
            G.hand.cards[1]:set_edition({
             			    cry_darkmatter = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_darkmatter = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_darkvoid then
            G.hand.cards[1]:set_edition({
             			    cry_darkvoid = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_darkvoid = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_pocketedition then
            G.hand.cards[1]:set_edition({
             			    cry_pocketedition = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_pocketedition = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_limitededition then
            G.hand.cards[1]:set_edition({
             			    cry_limitededition = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_limitededition = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_greedy then
            G.hand.cards[1]:set_edition({
             			    cry_greedy = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_greedy = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_bailiff then
            G.hand.cards[1]:set_edition({
             			    cry_bailiff = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_bailiff = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_duplicated then
            G.hand.cards[1]:set_edition({
             			    cry_duplicated = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_duplicated = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_trash then
            G.hand.cards[1]:set_edition({
             			    cry_trash = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_trash = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_lefthanded then
            G.hand.cards[1]:set_edition({
             			    cry_lefthanded = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_lefthanded = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_righthanded then
            G.hand.cards[1]:set_edition({
             			    cry_righthanded = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_righthanded = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_pinkstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_pinkstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_pinkstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_brownstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_brownstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_brownstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_yellowstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_yellowstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_yellowstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_jadestakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_jadestakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_jadestakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_cyanstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_cyanstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_cyanstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_graystakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_graystakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_graystakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_crimsonstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_crimsonstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_crimsonstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_diamondstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_diamondstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_diamondstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_amberstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_amberstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_amberstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_bronzestakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_bronzestakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_bronzestakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_quartzstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_quartzstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_quartzstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_rubystakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_rubystakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_rubystakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_glassstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_glassstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_glassstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_sapphirestakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_sapphirestakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_sapphirestakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_emeraldstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_emeraldstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_emeraldstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_platinumstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_platinumstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_platinumstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_verdantstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_verdantstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_verdantstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_emberstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_emberstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_emberstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_dawnstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_dawnstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_dawnstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_horizonstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_horizonstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_horizonstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_blossomstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_blossomstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_blossomstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_azurestakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_azurestakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_azurestakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_ascendantstakecurse then
            G.hand.cards[1]:set_edition({
             			    cry_ascendantstakecurse = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_ascendantstakecurse = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_brilliant then
            G.hand.cards[1]:set_edition({
             			    cry_brilliant = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_brilliant = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_blister then
            G.hand.cards[1]:set_edition({
             			    cry_blister = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_blister = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_galvanized then
            G.hand.cards[1]:set_edition({
             			    cry_galvanized = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_galvanized = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_chromaticplatinum then
            G.hand.cards[1]:set_edition({
             			    cry_chromaticplatinum = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_chromaticplatinum = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_metallic then
            G.hand.cards[1]:set_edition({
             			    cry_metallic = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_metallic = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_titanium then
            G.hand.cards[1]:set_edition({
             			    cry_titanium = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_titanium = false
          	    })
        
        elseif G.jokers.cards[1].edition.cry_omnichromatic then
            G.hand.cards[1]:set_edition({
             			    cry_omnichromatic = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_omnichromatic = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_chromaticastral then
            G.hand.cards[1]:set_edition({
             			    cry_chromaticastral = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_chromaticastral = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_tvghost then
            G.hand.cards[1]:set_edition({
             			    cry_tvghost = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_tvghost = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_noisy then
            G.hand.cards[1]:set_edition({
             			    cry_noisy = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_noisy = false
          	    })	
	
        elseif G.jokers.cards[1].edition.cry_rainbow then
            G.hand.cards[1]:set_edition({
             			    cry_rainbow = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_rainbow = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_hyperchrome then
            G.hand.cards[1]:set_edition({
             			    cry_hyperchrome = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_hyperchrome = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_shadowing then
            G.hand.cards[1]:set_edition({
             			    cry_shadowing = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_shadowing = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_graymatter then
            G.hand.cards[1]:set_edition({
             			    cry_graymatter = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_graymatter = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_hardstone then
            G.hand.cards[1]:set_edition({
             			    cry_hardstone = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_hardstone = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_impulsion then
            G.hand.cards[1]:set_edition({
             			    cry_impulsion = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_impulsion = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_chromaticimpulsion then
            G.hand.cards[1]:set_edition({
             			    cry_chromaticimpulsion = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_chromaticimpulsion = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_psychedelic then
            G.hand.cards[1]:set_edition({
             			    cry_psychedelic = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_psychedelic = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_bedrock then
            G.hand.cards[1]:set_edition({
             			    cry_bedrock = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_bedrock = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_golden then
            G.hand.cards[1]:set_edition({
             			    cry_golden = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_golden = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_ultragolden then
            G.hand.cards[1]:set_edition({
             			    cry_ultragolden = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_ultragolden = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_root then
            G.hand.cards[1]:set_edition({
             			    cry_root = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_root = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_catalyst then
            G.hand.cards[1]:set_edition({
             			    cry_catalyst = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_catalyst = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_eyesless_balavirus then
            G.hand.cards[1]:set_edition({
             			    cry_eyesless_balavirus = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_eyesless_balavirus = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_absoluteglitch_balavirus then
            G.hand.cards[1]:set_edition({
             			    cry_absoluteglitch_balavirus = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_absoluteglitch_balavirus = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_darkvoid_balavirus then
            G.hand.cards[1]:set_edition({
             			    cry_darkvoid_balavirus = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_darkvoid_balavirus = false
          	    })
	
        elseif G.jokers.cards[1].edition.cry_psychedelic_balavirus then
            G.hand.cards[1]:set_edition({
             			    cry_psychedelic_balavirus = true
          	    })
            G.jokers.cards[1]:set_edition({
             			    cry_psychedelic_balavirus = false
          	    })
        end
      end
    end
}
local warp = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Warp",
    key = "warp",
    pos = {x=0,y=3},
	config = {},
    loc_txt = {
        name = '://WARP',
        text = {
			"Set the current {C:attention}ante{} at the current {C:gold}money{}",
        }
    },
    cost = 4,
    atlas = "code",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.round_resets.ante = G.GAME.dollars
        G.GAME.current_round.ante = G.GAME.dollars
    end
}

crash_functions = {
    function()
        --instantly quit the game, no error log
        function love.errorhandler()
        end
        print(crash.crash.crash)
    end,
    function()
        --removes draw loop, you're frozen and can still weirdly interact with the game a bit
        function love.draw()
        end
    end,
    function()
        --by WilsonTheWolf and MathIsFun_, funky error screen with random funny message
        messages = {"Oops.", "Your cards have been TOASTED, extra crispy for your pleasure.", "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
            "What we have here is a certified whoopsidaisy", "Why don't you buy more jonkers? Are you stupid?", "lmao",
            "How about a game of YOU MUST DIE?",
            "Sorry, I was in the bathroom. What'd I mi'Where'd... Where is everyone?",
            "Peter? What are you doing? Cards. WHAT THE FUCK?", "what if it was called freaklatro", "4",
            "I SAWED THIS GAME IN HALF!", "is this rush hour 4", "You missed a semicolon on line 19742, you buffoon",
            "you are an idiot", "You do not recognise the cards in the deck.", ":( Your P", "Assertion failed",
            "Play ULTRAKILL", "Play Nova Drift", "Play Balatro- wait",
            "what if instead of rush hour it was called kush hour and you just smoked a massive blunt",
            "death.fell.accident.water", "Balatro's innards were made outards", "i am going to club yrou",
            "But the biggest joker of them all, it was you all along!", "fission mailed successfully",
            "table index is nil", "index is nil table", "nil is index table", "nildex is in table", "I AM THE TABLE",
            "I'm never going back this casino agai-", "what did you think would happen?",
            "DO THE EARTHQUAKE! [screams]", "fuck you", "Screaming in the casino prank! AAAAAAAAAAAAAAAAAA",
            "https://www.youtube.com/watch?v=dQw4w9WgXcQ", "You musn't tear or crease it.",
            "Sure, but the point is to do it without making a hole.",
            "The end of all things! As was foretold in the prophecy!", "Do it again. It'd be funny", "", ":3",
            "Looks like a skill issue to me.", "it turns out that card was ligma", "YouJustLostTheCasinoGame",
            "Nah fuck off", "attempt to call global your_mom (value too large)", "Killed by intentional game design",
            "attempt to index field 'attempt to call global to_big (too big)' (a nil value)", "what.avi", "The C",
            "Shoulda kept Chicot", "Maybe next time don't do that?", "[recursion]", "://SHART", "It's converging time.",
            "This is the last error message."}
        function corruptString(str)
            -- replace each character with a random valid ascii character
            local newStr = ""
            local len
            if type(str) == "string" then
                len = #str
            else
                len = str
            end
            for i = 1, len do
                -- newStr = newStr .. string.char(math.random(33, 122))
                local c = math.random(33, 122)
                newStr = newStr .. string.char(c)
                if c == 92 then -- backslash
                    newStr = newStr .. string.char(c)
                end
            end
            return newStr
        end

        function getDebugInfoForCrash()
            local info = "Additional Context:\nBalatro Version: " .. VERSION .. "\nModded Version: " .. MODDED_VERSION
            local major, minor, revision, codename = love.getVersion()
            info = info .. "\nLove2D Version: " .. corruptString(string.format("%d.%d.%d", major, minor, revision))

            local lovely_success, lovely = pcall(require, "lovely")
            if lovely_success then
                info = info .. "\nLovely Version: " .. corruptString(lovely.version)
            end
            if SMODS.mod_list then
                info = info .. "\nSteamodded Mods:"
                local enabled_mods = {}
                for _, v in ipairs(SMODS.mod_list) do
                    if v.can_load then
                        table.insert(enabled_mods, v)
                    end
                end
                for k, v in ipairs(enabled_mods) do
                    info =
                        info .. "\n    " .. k .. ": " .. v.name .. " by " .. table.concat(v.author, ", ") .. " [ID: " .. v.id ..
                            (v.priority ~= 0 and (", Priority: " .. v.priority) or "") ..
                            (v.version and v.version ~= '0.0.0' and (", Version: " .. v.version) or "") .. "]"
                    local debugInfo = v.debug_info
                    if debugInfo then
                        if type(debugInfo) == "string" then
                            if #debugInfo ~= 0 then
                                info = info .. "\n        " .. debugInfo
                            end
                        elseif type(debugInfo) == "table" then
                            for kk, vv in pairs(debugInfo) do
                                if type(vv) ~= 'nil' then
                                    vv = tostring(vv)
                                end
                                if #vv ~= 0 then
                                    info = info .. "\n        " .. kk .. ": " .. vv
                                end
                            end
                        end
                    end
                end
            end
            return info
        end

        VERSION = corruptString(VERSION)
        MODDED_VERSION = corruptString(MODDED_VERSION)

        if SMODS.mod_list then
            for i, mod in ipairs(SMODS.mod_list) do
                mod.can_load = true
                mod.name = corruptString(mod.name)
                mod.id = corruptString(mod.id)
                mod.author = {corruptString(20)}
                mod.version = corruptString(mod.version)
                mod.debug_info = corruptString(math.random(5, 100))
            end
        end

        do
            local utf8 = require("utf8")
            local linesize = 100

            -- Modifed from https://love2d.org/wiki/love.errorhandler
            function love.errorhandler(msg)
                msg = tostring(msg)

                if not love.window or not love.graphics or not love.event then
                    return
                end

                if not love.graphics.isCreated() or not love.window.isOpen() then
                    local success, status = pcall(love.window.setMode, 800, 600)
                    if not success or not status then
                        return
                    end
                end

                -- Reset state.
                if love.mouse then
                    love.mouse.setVisible(true)
                    love.mouse.setGrabbed(false)
                    love.mouse.setRelativeMode(false)
                    if love.mouse.isCursorSupported() then
                        love.mouse.setCursor()
                    end
                end
                if love.joystick then
                    -- Stop all joystick vibrations.
                    for i, v in ipairs(love.joystick.getJoysticks()) do
                        v:setVibration()
                    end
                end
                if love.audio then
                    love.audio.stop()
                end

                love.graphics.reset()
                local font = love.graphics.setNewFont("resources/fonts/m6x11plus.ttf", 20)

                local background = {math.random() * 0.3, math.random() * 0.3, math.random() * 0.3}
                love.graphics.clear(background)
                love.graphics.origin()

                local sanitizedmsg = {}
                for char in msg:gmatch(utf8.charpattern) do
                    table.insert(sanitizedmsg, char)
                end
                sanitizedmsg = table.concat(sanitizedmsg)

                local err = {}

                table.insert(err, "Oops! The game crashed:")
                table.insert(err, sanitizedmsg)

                if #sanitizedmsg ~= #msg then
                    table.insert(err, "Invalid UTF-8 string in error message.")
                end

                local success, msg = pcall(getDebugInfoForCrash)
                if success and msg then
                    table.insert(err, '\n' .. msg)
                else
                    table.insert(err, "\n" .. "Failed to get additional context :/")
                end

                local p = table.concat(err, "\n")

                p = p:gsub("\t", "")
                p = p:gsub("%[string \"(.-)\"%]", "%1")

                local scrollOffset = 0
                local endHeight = 0
                love.keyboard.setKeyRepeat(true)

                local function scrollDown(amt)
                    if amt == nil then
                        amt = 18
                    end
                    scrollOffset = scrollOffset + amt
                    if scrollOffset > endHeight then
                        scrollOffset = endHeight
                    end
                end

                local function scrollUp(amt)
                    if amt == nil then
                        amt = 18
                    end
                    scrollOffset = scrollOffset - amt
                    if scrollOffset < 0 then
                        scrollOffset = 0
                    end
                end

                local pos = 70
                local arrowSize = 20

                local function calcEndHeight()
                    local font = love.graphics.getFont()
                    local rw, lines = font:getWrap(p, love.graphics.getWidth() - pos * 2)
                    local lineHeight = font:getHeight()
                    local atBottom = scrollOffset == endHeight and scrollOffset ~= 0
                    endHeight = #lines * lineHeight - love.graphics.getHeight() + pos * 2
                    if (endHeight < 0) then
                        endHeight = 0
                    end
                    if scrollOffset > endHeight or atBottom then
                        scrollOffset = endHeight
                    end
                end

                local function draw()
                    if not love.graphics.isActive() then
                        return
                    end
                    love.graphics.clear(background)
                    calcEndHeight()
                    local time = love.timer.getTime()
                    if not G.SETTINGS.reduced_motion then
                        background = {math.random() * 0.3, math.random() * 0.3, math.random() * 0.3}
                        p = p .. "\n" .. corruptString(math.random(linesize - linesize / 2, linesize + linesize * 2))
                        linesize = linesize + linesize / 25
                    end
                    love.graphics.printf(p, pos, pos - scrollOffset, love.graphics.getWidth() - pos * 2)
                    if scrollOffset ~= endHeight then
                        love.graphics.polygon("fill", love.graphics.getWidth() - (pos / 2),
                            love.graphics.getHeight() - arrowSize, love.graphics.getWidth() - (pos / 2) + arrowSize,
                            love.graphics.getHeight() - (arrowSize * 2), love.graphics.getWidth() - (pos / 2) - arrowSize,
                            love.graphics.getHeight() - (arrowSize * 2))
                    end
                    if scrollOffset ~= 0 then
                        love.graphics.polygon("fill", love.graphics.getWidth() - (pos / 2), arrowSize,
                            love.graphics.getWidth() - (pos / 2) + arrowSize, arrowSize * 2,
                            love.graphics.getWidth() - (pos / 2) - arrowSize, arrowSize * 2)
                    end
                    love.graphics.present()
                end

                local fullErrorText = p
                local function copyToClipboard()
                    if not love.system then
                        return
                    end
                    love.system.setClipboardText(fullErrorText)
                    p = p .. "\nCopied to clipboard!"
                end

                if G then
                    -- Kill threads (makes restarting possible)
                    if G.SOUND_MANAGER and G.SOUND_MANAGER.channel then
                        G.SOUND_MANAGER.channel:push({
                            type = 'kill'
                        })
                    end
                    if G.SAVE_MANAGER and G.SAVE_MANAGER.channel then
                        G.SAVE_MANAGER.channel:push({
                            type = 'kill'
                        })
                    end
                    if G.HTTP_MANAGER and G.HTTP_MANAGER.channel then
                        G.HTTP_MANAGER.channel:push({
                            type = 'kill'
                        })
                    end
                end

                return function()
                    love.event.pump()

                    for e, a, b, c in love.event.poll() do
                        if e == "quit" then
                            return 1
                        elseif e == "keypressed" and a == "escape" then
                            return 1
                        elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
                            copyToClipboard()
                        elseif e == "keypressed" and a == "r" then
                            return "restart"
                        elseif e == "keypressed" and a == "down" then
                            scrollDown()
                        elseif e == "keypressed" and a == "up" then
                            scrollUp()
                        elseif e == "keypressed" and a == "pagedown" then
                            scrollDown(love.graphics.getHeight())
                        elseif e == "keypressed" and a == "pageup" then
                            scrollUp(love.graphics.getHeight())
                        elseif e == "keypressed" and a == "home" then
                            scrollOffset = 0
                        elseif e == "keypressed" and a == "end" then
                            scrollOffset = endHeight
                        elseif e == "wheelmoved" then
                            scrollUp(b * 20)
                        elseif e == "gamepadpressed" and b == "dpdown" then
                            scrollDown()
                        elseif e == "gamepadpressed" and b == "dpup" then
                            scrollUp()
                        elseif e == "gamepadpressed" and b == "a" then
                            return "restart"
                        elseif e == "gamepadpressed" and b == "x" then
                            copyToClipboard()
                        elseif e == "gamepadpressed" and (b == "b" or b == "back" or b == "start") then
                            return 1
                        elseif e == "touchpressed" then
                            local name = love.window.getTitle()
                            if #name == 0 or name == "Untitled" then
                                name = "Game"
                            end
                            local buttons = {"OK", "Cancel", "Restart"}
                            if love.system then
                                buttons[4] = "Copy to clipboard"
                            end
                            local pressed = love.window.showMessageBox("Quit " .. name .. "?", "", buttons)
                            if pressed == 1 then
                                return 1
                            elseif pressed == 3 then
                                return "restart"
                            elseif pressed == 4 then
                                copyToClipboard()
                            end
                        end
                    end

                    draw()

                    if love.timer then
                        love.timer.sleep(0.1)
                    end
                end

            end
        end

        load('error(messages[math.random(1, #messages)])', corruptString(30), "t")()

    end,
    function()
        --fills screen with Crash cards
        glitched_intensity = 100
        G.SETTINGS.GRAPHICS.crt = 101
        G.E_MANAGER:add_event(Event({trigger = 'immediate', blockable = false, no_delete = true,
        func = function()
            local c = create_card('Code', nil, nil, nil, nil, nil, 'c_cry_crash')
            c.T.x = math.random(-G.CARD_W,G.TILE_W)
            c.T.y = math.random(-G.CARD_H,G.TILE_H)
            return false; end}),"other")
    end,
    function()
        -- Fake lovely panic
        love.window.showMessageBox("lovely-injector", "lovely-injector has crashed:\npanicked at crates/lovely-core/src/lib.rs:420:69:\nFailed to parse patch at \"C:\\\\users\\\\jimbo\\\\AppData\\\\Roaming\\\\Balatro\\\\Mods\\\\Cryptid\\\\lovely.toml\":\nError { inner: TomlError { message: \"expected `.`, `=`\", original: Some(\""
        .."\"According to all known laws of aviation, there is no way a bee should be able to fly.\\nIts wings are too small to get its fat little body off the ground.\\nThe bee, of course, flies anyway because bees don't care what humans think is impossible.\\nYellow, black. Yellow, black. Yellow, black. Yellow, black.\\nOoh, black and yellow!\\nLet's shake it up a little.\\nBarry! Breakfast is ready!\\nComing!\\nHang on a second.\\nHello?\\nBarry?\\nAdam?\\nCan you believe this is happening?\\nI can't.\\nI'll pick you up.\\nLooking sharp.\\nUse the stairs, Your father paid good money for those.\\nSorry. I'm excited.\\nHere's the graduate.\\nWe're very proud of you, son.\\nA perfect report card, all B's.\\nVery proud.\\nMa! I got a thing going here.\\nYou got lint on your fuzz.\\nOw! That's me!\\nWave to us! We'll be in row 118,000.\\nBye!\\nBarry, I told you, stop flying in the house!\\nHey, Adam.\\nHey, Barry.\\nIs that fuzz gel?\\nA little. Special day, graduation.\\nNever thought I'd make it.\\nThree days grade school, three days high school.\\nThose were awkward.\\nThree days college. I'm glad I took a day and hitchhiked around The Hive.\\nYou did come back different.\\nHi, Barry. Artie, growing a mustache? Looks good.\\nHear about Frankie?\\nYeah.\\nYou going to the funeral?\\nNo, I'm not going.\\nEverybody knows, sting someone, you die.\\nDon't waste it on a squirrel.\\nSuch a hothead.\\nI guess he could have just gotten out of the way.\\nI love this incorporating an amusement park into our day.\\nThat's why we don't need vacations.\\nBoy, quite a bit of pomp under the circumstances.\\nWell, Adam, today we are men.\\nWe are!\\nBee-men.\\nAmen!\\nHallelujah!\\nStudents, faculty, distinguished bees,\\nplease welcome Dean Buzzwell.\\nWelcome, New Hive City graduating class of 9:15.\\nThat concludes our ceremonies And begins your career at Honex Industries!\\nWill we pick our job today?\\nI heard it's just orientation.\\nHeads up! Here we go.\\nKeep your hands and antennas inside the tram at all times.\\nWonder what it'll be like?\\nA little scary.\\nWelcome to Honex, a division of Honesco and a part of the Hexagon Group.\\nThis is it!\\nWow.\\nWow.\\nWe know that you, as a bee, have worked your whole life to get to the point where you can work for your whole life.\\nHoney begins when our valiant Pollen Jocks bring the nectar to The Hive.\\nOur top-secret formula is automatically color-corrected, scent-adjusted and bubble-contoured into this soothing sweet syrup with its distinctive golden glow you know as... Honey!\\nThat girl was hot.\\nShe's my cousin!\\nShe is?\\nYes, we're all cousins.\\nRight. You're right.\\nAt Honex, we constantly strive to improve every aspect of bee existence.\\nThese bees are stress-testing a new helmet technology.\\nWhat do you think he makes?\\nNot enough.\\nHere we have our latest advancement, the Krelman.\\nWhat does that do?\\nCatches that little strand of honey that hangs after you pour it.\\nSaves us millions.\\nCan anyone work on the Krelman?\\nOf course. Most bee jobs are small ones.\\nBut bees know that every small job, if it's done well, means a lot.\\nBut choose carefully because you'll stay in the job you pick for the rest of your life.\\nThe same job the rest of your life? I didn't know that.\\nWhat's the difference?\\nYou'll be happy to know that bees, as a species, haven't had one day off in 27 million years.\\nSo you'll just work us to death?\\nWe'll sure try.\\nWow! That blew my mind!\\n\\\"What's the difference?\\\"\\nHow can you say that?\\nOne job forever?\\nThat's an insane choice to have to make.\\nI'm relieved. Now we only have to make one decision in life.\\nBut, Adam, how could they never have told us that?\\nWhy would you question anything? We're bees.\\nWe're the most perfectly functioning society on Earth.\\nYou ever think maybe things work a little too well here?\\nLike what? Give me one example.\\nI don't know. But you know what I'm talking about.\\nPlease clear the gate. Royal Nectar Force on approach.\\nWait a second. Check it out.\\nHey, those are Pollen Jocks!\\nWow.\\nI've never seen them this close.\\nThey know what it's like outside The Hive.\\nYeah, but some don't come back.\\nHey, Jocks!\\nHi, Jocks!\\nYou guys did great!\\nYou're monsters!\\nYou're sky freaks! I love it! I love it!\\nI wonder where they were.\\nI don't know.\\nTheir day's not planned.\\nOutside The Hive, flying who knows where, doing who knows what.\\nYou can't just decide to be a Pollen Jock. You have to be bred for that.\\nRight.\\nLook. That's more pollen than you and I will see in a lifetime.\\nIt's just a status symbol.\\nBees make too much of it.\\nPerhaps. Unless you're wearing it and the ladies see you wearing it.\\nThose ladies?\\nAren't they our cousins too?\\nDistant. Distant.\\nLook at these two.\\nCouple of Hive Harrys.\\nLet's have fun with them.\\nIt must be dangerous being a Pollen Jock.\\nYeah. Once a bear pinned me against a mushroom!\\nHe had a paw on my throat, and with the other, he was slapping me!\\nOh, my!\\nI never thought I'd knock him out.\\nWhat were you doing during this?\\nTrying to alert the authorities.\\nI can autograph that.\\nA little gusty out there today, wasn't it, comrades?\\nYeah. Gusty.\\nWe're hitting a sunflower patch six miles from here tomorrow.\\nSix miles, huh?\\nBarry!\\nA puddle jump for us, but maybe you're not up for it.\\nMaybe I am.\\nYou are not!\\nWe're going 0900 at J-Gate.\\nWhat do you think, buzzy-boy?\\nAre you bee enough?\\nI might be. It all depends on what 0900 means.\\nHey, Honex!\\nDad, you surprised me.\\nYou decide what you're interested in?\\nWell, there's a lot of choices.\\nBut you only get one.\\nDo you ever get bored doing the same job every day?\\nSon, let me tell you about stirring.\\nYou grab that stick, and you just move it around, and you stir it around.\\nYou get yourself into a rhythm.\\nIt's a beautiful thing.\\nYou know, Dad, the more I think about it,\\nmaybe the honey field just isn't right for me.\\nYou were thinking of what, making balloon animals?\\nThat's a bad job for a guy with a stinger.\\nJanet, your son's not sure he wants to go into honey!\\nBarry, you are so funny sometimes.\\nI'm not trying to be funny.\\nYou're not funny! You're going into honey. Our son, the stirrer!\\nYou're gonna be a stirrer?\\nNo one's listening to me!\\nWait till you see the sticks I have.\\nI could say anything right now.\\nI'm gonna get an ant tattoo!\\nLet's open some honey and celebrate!\\nMaybe I'll pierce my thorax. Shave my antennae. Shack up with a grasshopper. Get a gold tooth and call everybody \\\"dawg\\\"!\\nI'm so proud.\\nWe're starting work today!\\nToday's the day.\\nCome on! All the good jobs will be gone.\\nYeah, right.\\nPollen counting, stunt bee, pouring, stirrer, front desk, hair removal...\\nIs it still available?\\nHang on. Two left!\\nOne of them's yours! Congratulations!\\nStep to the side.\\nWhat'd you get?\\nPicking crud out. Stellar!\\nWow!\\nCouple of newbies?\\nYes, sir! Our first day! We are ready!\\nMake your choice.\\nYou want to go first?\\nNo, you go.\\nOh, my. What's available?\\nRestroom attendant's open, not for the reason you think.\\nAny chance of getting the Krelman?\\nSure, you're on.\\nI'm sorry, the Krelman just closed out.\\nWax monkey's always open.\\nThe Krelman opened up again.\\nWhat happened?\\nA bee died. Makes an opening. See? He's dead. Another dead one.\\nDeady. Deadified. Two more dead.\\nDead from the neck up. Dead from the neck down. That's life!\\nOh, this is so hard!\\nHeating, cooling, stunt bee, pourer, stirrer, humming, inspector number seven, lint coordinator, stripe supervisor, mite wrangler.\\nBarry, what do you think I should... Barry?\\nBarry!\\nAll right, we've got the sunflower patch in quadrant nine...\\nWhat happened to you?\\nWhere are you?\\nI'm going out.\\nOut? Out where?\\nOut there.\\nOh, no!\\nI have to, before I go to work for the rest of my life.\\nYou're gonna die! You're crazy! Hello?\\nAnother call coming in.\\nIf anyone's feeling brave, there's a Korean deli on 83rd that gets their roses today.\\nHey, guys.\\nLook at that.\\nIsn't that the kid we saw yesterday?\\nHold it, son, flight deck's restricted.\\nIt's OK, Lou. We're gonna take him up.\\nReally? Feeling lucky, are you?\\nSign here, here. Just initial that.\\nThank you.\\nOK.\\nYou got a rain advisory today, and as you all know, bees cannot fly in rain.\\nSo be careful. As always, watch your brooms, hockey sticks, dogs, birds, bears and bats.\\nAlso, I got a couple of reports of root beer being poured on us.\\nMurphy's in a home because of it, babbling like a cicada!\\nThat's awful.\\nAnd a reminder for you rookies, bee law number one, absolutely no talking to humans!\\n All right, launch positions!\\nBuzz, buzz, buzz, buzz! Buzz, buzz, buzz, buzz! Buzz, buzz, buzz, buzz!\\nBlack and yellow!\\nHello!\\nYou ready for this, hot shot?\\nYeah. Yeah, bring it on.\\nWind, check.\\nAntennae, check.\\nNectar pack, check.\\nWings, check.\\nStinger, check.\\nScared out of my shorts, check.\\nOK, ladies,\\nlet's move it out!\\nPound those petunias, you striped stem-suckers!\\nAll of you, drain those flowers!\\nWow! I'm out!\\nI can't believe I'm out!\\nSo blue.\\nI feel so fast and free!\\nBox kite!\\nWow!\\nFlowers!\\nThis is Blue Leader, We have roses visual.\\nBring it around 30 degrees and hold.\\nRoses!\\n30 degrees, roger. Bringing it around.\\nStand to the side, kid.\\nIt's got a bit of a kick.\\nThat is one nectar collector!\\nEver see pollination up close?\\nNo, sir.\\nI pick up some pollen here, sprinkle it over here. Maybe a dash over there, a pinch on that one.\\nSee that? It's a little bit of magic.\\nThat's amazing. Why do we do that?\\nThat's pollen power. More pollen, more flowers, more nectar, more honey for us.\\nCool.\\nI'm picking up a lot of bright yellow, Could be daisies, Don't we need those?\\nCopy that visual.\\nWait. One of these flowers seems to be on the move.\\nSay again? You're reporting a moving flower?\\nAffirmative.\\nThat was on the line!\\nThis is the coolest. What is it?\\nI don't know, but I'm loving this color.\\nIt smells good.\\nNot like a flower, but I like it.\\nYeah, fuzzy.\\nChemical-y.\\nCareful, guys. It's a little grabby.\\nMy sweet lord of bees!\\nCandy-brain, get off there!\\nProblem!\\nGuys!\\nThis could be bad.\\nAffirmative.\\nVery close.\\nGonna hurt.\\nMama's little boy.\\nYou are way out of position, rookie!\\nComing in at you like a missile!\\nHelp me!\\nI don't think these are flowers.\\nShould we tell him?\\nI think he knows.\\nWhat is this?!\\nMatch point!\\nYou can start packing up, honey, because you're about to eat it!\\nYowser!\\nGross.\\nThere's a bee in the car!\\nDo something!\\nI'm driving!\\nHi, bee.\\nHe's back here!\\nHe's going to sting me!\\nNobody move. If you don't move, he won't sting you. Freeze!\\nHe blinked!\\nSpray him, Granny!\\nWhat are you doing?!\\nWow... the tension level out here is unbelievable.\\nI gotta get home.\\nCan't fly in rain. Can't fly in rain. Can't fly in rain.\\nMayday! Mayday! Bee going down!\\nKen, could you close the window please?\\nKen, could you close the window please?\\nCheck out my new resume. I made it into a fold-out brochure. You see? Folds out.\\nOh, no. More humans. I don't need this.\\nWhat was that?\\nMaybe this time. This time. This time. This time! This time! This... Drapes!\\nThat is diabolical.\\nIt's fantastic. It's got all my special skills, even my top-ten favorite movies.\\nWhat's number one? Star Wars?\\nNah, I don't go for that... kind of stuff.\\nNo wonder we shouldn't talk to them. They're out of their minds.\\nWhen I leave a job interview, they're flabbergasted, can't believe what I say.\\nThere's the sun. Maybe that's a way out.\\nI don't remember the sun having a big 75 on it.\\nI predicted global warming. I could feel it getting hotter. At first I thought it was just me.\\nWait! Stop! Bee!\\nStand back. These are winter boots.\\nWait!\\nDon't kill him!\\nYou know I'm allergic to them! This thing could kill me!\\nWhy does his life have less value than yours?\\nWhy does his life have any less value than mine? Is that your statement?\\nI'm just saying all life has value. You don't know what he's capable of feeling.\\nMy brochure!\\nThere you go, little guy.\\nI'm not scared of him.It's an allergic thing.\\n Put that on your resume brochure.\\nMy whole face could puff up.\\nMake it one of your special skills.\\nKnocking someone out is also a special skill.\\nRight. Bye, Vanessa. Thanks.\\nVanessa, next week? Yogurt night?\\nSure, Ken. You know, whatever.\\nYou could put carob chips on there.\\nBye.\\nSupposed to be less calories.\\nBye.\\nI gotta say something. She saved my life. I gotta say something.\\nAll right, here it goes.\\nNah.\\nWhat would I say?\\nI could really get in trouble. It's a bee law. You're not supposed to talk to a human.\\nI can't believe I'm doing this. I've got to.\\nOh, I can't do it. Come on!\\nNo. Yes. No. Do it. I can't.\\nHow should I start it? \\\"You like jazz?\\\" No, that's no good.\\nHere she comes! Speak, you fool!\\nHi!\\nI'm sorry. You're talking.\\nYes, I know.\\nYou're talking!\\nI'm so sorry.\\nNo, it's OK. It's fine.\\nI know I'm dreaming. But I don't recall going to bed.\\nWell, I'm sure this is very disconcerting.\\nThis is a bit of a surprise to me. I mean, you're a bee!\\nI am. And I'm not supposed to be doing this, but they were all trying to kill me.\\nAnd if it wasn't for you... I had to thank you. It's just how I was raised.\\nThat was a little weird. I'm talking with a bee.\\nYeah.\\nI'm talking to a bee. And the bee is talking to me!\\nI just want to say I'm grateful.\\nI'll leave now.\\nWait! How did you learn to do that?\\nWhat?\\nThe talking thing.\\nSame way you did, I guess. \\\"Mama, Dada, honey.\\\" You pick it up.\\nThat's very funny.\\nYeah.\\nBees are funny. If we didn't laugh, we'd cry with what we have to deal with.\\nAnyway... Can I... get you something?\\nLike what?\\nI don't know. I mean... I don't know. Coffee?\\nI don't want to put you out.\\nIt's no trouble. It takes two minutes.\\nIt's just coffee.\\nI hate to impose.\\nDon't be ridiculous!\\nActually, I would love a cup.\\nHey, you want rum cake?\\nI shouldn't.\\nHave some.\\nNo, I can't.\\nCome on!\\nI'm trying to lose a couple micrograms.\\nWhere?\\nThese stripes don't help.\\nYou look great!\\nI don't know if you know anything about fashion.\\nAre you all right?\\nNo.\\nHe's making the tie in the cab as they're flying up Madison.\\nHe finally gets there.\\nHe runs up the steps into the church.\\nThe wedding is on.\\nAnd he says, \\\"Watermelon?\\nI thought you said Guatemalan.\\nWhy would I marry a watermelon?\\\"\\nIs that a bee joke?\\nThat's the kind of stuff we do.\\nYeah, different.\\nSo, what are you gonna do, Barry?\\nAbout work? I don't know.\\nI want to do my part for The Hive, but I can't do it the way they want.\\nI know how you feel.\\nYou do?\\nSure.\\nMy parents wanted me to be a lawyer or a doctor, but I wanted to be a florist.\\nReally?\\nMy only interest is flowers.\\nOur new queen was just elected with that same campaign slogan.\\nAnyway, if you look... There's my hive right there. See it?\\nYou're in Sheep Meadow!\\nYes! I'm right off the Turtle Pond!\\nNo way! I know that area. I lost a toe ring there once.\\nWhy do girls put rings on their toes?\\nWhy not?\\nIt's like putting a hat on your knee.\\nMaybe I'll try that.\\nYou all right, ma'am?\\nOh, yeah. Fine.\\nJust having two cups of coffee!\\nAnyway, this has been great.\\nThanks for the coffee.\\nYeah, it's no trouble.\\nSorry I couldn't finish it. If I did, I'd be up the rest of my life.\\nAre you...?\\nCan I take a piece of this with me?\\nSure! Here, have a crumb.\\nThanks!\\nYeah.\\nAll right. Well, then... I guess I'll see you around. Or not.\\nOK, Barry.\\nAnd thank you so much again... for before.\\nOh, that? That was nothing.\\nWell, not nothing, but... Anyway...\\nThis can't possibly work.\\nHe's all set to go.\\nWe may as well try it.\\nOK, Dave, pull the chute.\\nSounds amazing.\\nIt was amazing!\\nIt was the scariest, happiest moment of my life.\\nHumans! I can't believe you were with humans!\\nGiant, scary humans!\\nWhat were they like?\\nHuge and crazy. They talk crazy.\\nThey eat crazy giant things.\\nThey drive crazy.\\nDo they try and kill you, like on TV?\\nSome of them. But some of them don't.\\nHow'd you get back?\\nPoodle.\\nYou did it, and I'm glad. You saw whatever you wanted to see.\\nYou had your \\\"experience.\\\" Now you can pick out yourjob and be normal.\\nWell...\\nWell?\\nWell, I met someone.\\nYou did? Was she Bee-ish?\\nA wasp?! Your parents will kill you!\\nNo, no, no, not a wasp.\\nSpider?\\nI'm not attracted to spiders.\\nI know it's the hottest thing, with the eight legs and all. I can't get by that face.\\nSo who is she?\\nShe's... human.\\nNo, no. That's a bee law. You wouldn't break a bee law.\\nHer name's Vanessa.\\nOh, boy.\\nShe's so nice. And she's a florist!\\nOh, no! You're dating a human florist!\\nWe're not dating.\\nYou're flying outside The Hive, talking to humans that attack our homes with power washers and M-80s! One-eighth a stick of dynamite!\\nShe saved my life! And she understands me.\\nThis is over!\\nEat this.\\nThis is not over! What was that?\\nThey call it a crumb.\\nIt was so stingin' stripey!\\nAnd that's not what they eat.\\nThat's what falls off what they eat!\\nYou know what a Cinnabon is?\\nNo.\\nIt's bread and cinnamon and frosting. They heat it up...\\nSit down!\\n...really hot!\\nListen to me!\\nWe are not them! We're us.\\nThere's us and there's them!\\n\"), keys: [], span: Some(10..11)}}}"
, "error")
        love.window.showMessageBox("lovely-injector", "lovely-injector has crashed:\npanicked at library/cors/src/panicking.rs:221:5:\npanic in a function that cannot unwind", "error")

        function love.errorhandler()
        end
        print(crash.crash.crash)
    end
}

--for testing
-- crash_functions = {crash_functions[#crash_functions]}
-- crash_functions[1]()



local code_cards = {code, code_atlas, pack_atlas, pack1, pack2, packJ, packM, payload, reboot, revert, crash, semicolon, malware, seed, ransomware, hardmode, ddos, encoding, encoding_advanced, freecard, encoding_chromatic, paste, cut, warp}
return {name = "Code Cards",
        init = function()
            --allow Program Packs to let you keep the cards
            local G_UIDEF_use_and_sell_buttons_ref=G.UIDEF.use_and_sell_buttons
            function G.UIDEF.use_and_sell_buttons(card)
                if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable then --Add a use button
                    if card.ability.set == "Code" then
                        return {
                            n=G.UIT.ROOT, config = {padding = -0.1,  colour = G.C.CLEAR}, nodes={
                            {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, minh = 0.7*card.T.h, maxw = 0.7*card.T.w - 0.15, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_reserve_card'}, nodes={
                                {n=G.UIT.T, config={text = "RESERVE",colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
                            }},
                            {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.1*card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'Do you know that this parameter does nothing?', func = 'can_use_consumeable'}, nodes={
                                {n=G.UIT.T, config={text = localize('b_use'),colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
                            }},
                            {n=G.UIT.R, config = {align = "bm", w=7.7*card.T.w}},
                            {n=G.UIT.R, config = {align = "bm", w=7.7*card.T.w}},
                            {n=G.UIT.R, config = {align = "bm", w=7.7*card.T.w}},
                            {n=G.UIT.R, config = {align = "bm", w=7.7*card.T.w}},
                            -- Betmma can't explain it, neither can I
                        }}
                    end
                end
                return G_UIDEF_use_and_sell_buttons_ref(card)
            end
            --Code from Betmma's Vouchers
            G.FUNCS.can_reserve_card = function(e)
                if #G.consumeables.cards < G.consumeables.config.card_limit then
                    e.config.colour = G.C.GREEN
                    e.config.button = 'reserve_card'
                else
                  e.config.colour = G.C.UI.BACKGROUND_INACTIVE
                  e.config.button = nil
                end
            end
            G.FUNCS.reserve_card = function(e)
                local c1 = e.config.ref_table
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                    c1.area:remove_card(c1)
                    c1:add_to_deck()
                    if c1.children.price then c1.children.price:remove() end
                    c1.children.price = nil
                    if c1.children.buy_button then c1.children.buy_button:remove() end
                    c1.children.buy_button = nil
                    remove_nils(c1.children)
                    G.consumeables:emplace(c1)
                    G.GAME.pack_choices = G.GAME.pack_choices - 1
                    if G.GAME.pack_choices <= 0 then
                        G.FUNCS.end_consumeable(nil, delay_fac)
                    end
                    return true
                    end
                }))
            end
            --Revert
            local sr = save_run
            function save_run()
                if G.GAME.round_resets.ante ~= G.GAME.cry_revert_ante then
                    G.GAME.cry_revert_ante = G.GAME.round_resets.ante
                    G.GAME.cry_revert = nil
                    sr()
                    G.GAME.cry_revert = STR_PACK(G.culled_table)
                    sr()
                end
                sr()
            end
        end,
        items = code_cards}
