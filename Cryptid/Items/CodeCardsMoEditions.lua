local code_moeditions_atlas = {
    object_type = "Atlas",
    key = "codemoeditions",
    path = "c_cry_code_moeditions.png",
    px = 71,
    py = 95
}
local ransomware = {
    object_type = "Consumable",
    set = "Code",
    name = "cry-Ransomware",
    key = "ransomware",
    pos = {x=0,y=1},
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
    atlas = "codemoeditions",
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
    pos = {x=1,y=1},
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
    atlas = "codemoeditions",
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
    pos = {x=2,y=1},
	config = {},
    loc_txt = {
        name = '://DDOS',
        text = {
			"{C:red}+2${} in shop prizes",
                        "{C:gold}+1${} interest"
        }
    },
    cost = 4,
    atlas = "codemoeditions",
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
    pos = {x=0,y=0},
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
    atlas = "codemoeditions",
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
    pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = '://ENCODING_ADVANCED',
        text = {
			"Merges editions from the leftmost 2 {C:dark_edition}jokers{}.",
                        "Cost {C:gold}80${}",
        }
    },
    cost = 8,
    atlas = "codemoeditions",

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
    pos = {x=2,y=0},
	config = {},
    loc_txt = {
        name = '://FREECARD',
        text = {
			"Multiplies {C:gold}money{} by {C:red}-1{}",
        }
    },
    cost = 4,
    atlas = "codemoeditions",
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
    pos = {x=3,y=0},
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
    atlas = "codemoeditions",
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
    pos = {x=4,y=0},
	config = {},
    loc_txt = {
        name = '://PASTE',
        text = {
			"Place the {C:dark_edition}edition{} of the leftmost {C:attention}playing card{}",
                        "to the leftmost {C:dark_edition}joker{}"
        }
    },
    cost = 4,
    atlas = "codemoeditions",
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
    pos = {x=5,y=0},
	config = {},
    loc_txt = {
        name = '://CUT',
        text = {
			"Place the {C:dark_edition}edition{} of the leftmost {C:dark_edition}joker{}",
                        "to the leftmost {C:attention}playing card{}"
        }
    },
    cost = 4,
    atlas = "codemoeditions",
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
    pos = {x=3,y=1},
	config = {},
    loc_txt = {
        name = '://WARP',
        text = {
			"Set the current {C:attention}ante{} at the current {C:gold}money{}",
        }
    },
    cost = 4,
    atlas = "codemoeditions",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.round_resets.ante = G.GAME.dollars
        G.GAME.current_round.ante = G.GAME.dollars
    end
}

local code_cards = {code_moeditions_atlas, ransomware, hardmode, ddos, encoding, encoding_advanced, freecard, encoding_chromatic, paste, cut, warp}
return {name = "Code Cards",
        items = code_cards}