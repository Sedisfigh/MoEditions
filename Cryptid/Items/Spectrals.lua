local white_hole = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-White Hole",
    key = "white_hole",
    pos = {x=0,y=0},
    loc_txt = {
        name = 'White Hole',
        text = { "{C:attention}Remove{} all hand levels,",
        "upgrade {C:legendary,E:1}most played{} poker hand",
        "by {C:attention}3{} for each removed level"
        }
    },
    cost = 4,
    atlas = "white_hole",
    hidden = true, --default soul_rate of 0.3% in spectral packs is used
    soul_set = "Planet",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        --Get most played hand type (logic yoinked from Telescope)
        local _planet, _hand, _tally = nil, nil, -1
        for k, v in ipairs(G.handlist) do
            if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                _hand = v
                _tally = G.GAME.hands[v].played
            end
        end
        if _hand then
            for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                if v.config.hand_type == _hand then
                    _planet = v.key
                end
            end
        end
        local removed_levels = 0
        for k, v in ipairs(G.handlist) do
            if G.GAME.hands[v].level > 1 then
                local this_removed_levels = G.GAME.hands[v].level - 1
                removed_levels = removed_levels + this_removed_levels
                level_up_hand(card, v, true, -this_removed_levels)
            end
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(_hand, 'poker_hands'),chips = G.GAME.hands[_hand].chips, mult = G.GAME.hands[_hand].mult, level=G.GAME.hands[_hand].level})
        level_up_hand(card, _hand, false, 3*removed_levels)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,
    --Incantation compat
    can_stack = true,
    can_divide = true,
    can_bulk_use = true,
    bulk_use = function(self, card, area, copier, number)
        --Get most played hand type (logic yoinked from Telescope)
        local _planet, _hand, _tally = nil, nil, -1
        for k, v in ipairs(G.handlist) do
            if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                _hand = v
                _tally = G.GAME.hands[v].played
            end
        end
        if _hand then
            for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                if v.config.hand_type == _hand then
                    _planet = v.key
                end
            end
        end
        local removed_levels = 0
        for k, v in ipairs(G.handlist) do
            if G.GAME.hands[v].level > 1 then
                local this_removed_levels = G.GAME.hands[v].level - 1
                removed_levels = removed_levels + this_removed_levels
                level_up_hand(card, v, true, -this_removed_levels)
            end
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(_hand, 'poker_hands'),chips = G.GAME.hands[_hand].chips, mult = G.GAME.hands[_hand].mult, level=G.GAME.hands[_hand].level})
        level_up_hand(card, _hand, false, removed_levels*3^number)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end
}
local white_hole_sprite = {
	object_type = "Atlas",
    key = "white_hole",
    path = "c_cry_white_hole.png",
    px = 71,
    py = 95
}
local quasar = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Quasar",
    key = "quasar",
    pos = {x=0,y=0},
    loc_txt = {
        name = 'Quasar',
        text = { "{C:attention}Remove{} all hand levels,",
        "upgrade {C:legendary,E:1}most played{} poker hand",
        "by {C:attention}10{} for each removed level"
        }
    },
    cost = 45,
    atlas = "quasar",
    hidden = true, --default soul_rate of 0.3% in spectral packs is used
    soul_set = "Planet",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        --Get most played hand type (logic yoinked from Telescope)
        local _planet, _hand, _tally = nil, nil, -1
        for k, v in ipairs(G.handlist) do
            if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                _hand = v
                _tally = G.GAME.hands[v].played
            end
        end
        if _hand then
            for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                if v.config.hand_type == _hand then
                    _planet = v.key
                end
            end
        end
        local removed_levels = 0
        for k, v in ipairs(G.handlist) do
            if G.GAME.hands[v].level > 1 then
                local this_removed_levels = G.GAME.hands[v].level - 1
                removed_levels = removed_levels + this_removed_levels
                level_up_hand(card, v, true, -this_removed_levels)
            end
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(_hand, 'poker_hands'),chips = G.GAME.hands[_hand].chips, mult = G.GAME.hands[_hand].mult, level=G.GAME.hands[_hand].level})
        level_up_hand(card, _hand, false, 10*removed_levels)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end,
    --Incantation compat
    can_stack = true,
    can_divide = true,
    can_bulk_use = true,
    bulk_use = function(self, card, area, copier, number)
        --Get most played hand type (logic yoinked from Telescope)
        local _planet, _hand, _tally = nil, nil, -1
        for k, v in ipairs(G.handlist) do
            if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                _hand = v
                _tally = G.GAME.hands[v].played
            end
        end
        if _hand then
            for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                if v.config.hand_type == _hand then
                    _planet = v.key
                end
            end
        end
        local removed_levels = 0
        for k, v in ipairs(G.handlist) do
            if G.GAME.hands[v].level > 1 then
                local this_removed_levels = G.GAME.hands[v].level - 1
                removed_levels = removed_levels + this_removed_levels
                level_up_hand(card, v, true, -this_removed_levels)
            end
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(_hand, 'poker_hands'),chips = G.GAME.hands[_hand].chips, mult = G.GAME.hands[_hand].mult, level=G.GAME.hands[_hand].level})
        level_up_hand(card, _hand, false, removed_levels*3^number)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end
}
local quasar_sprite = {
	object_type = "Atlas",
    key = "quasar",
    path = "c_cry_quasar.png",
    px = 71,
    py = 95
}

local vacuum = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Vacuum",
    key = "vacuum",
    pos = {x=0,y=0},
	config = {extra = 4},
    loc_txt = {
        name = 'Vacuum',
        text = {
			"Removes {C:red}all {C:green}modifications{}",
			"from {C:red}all{} cards in your hand,",
			"Earn {C:money}$#1#{} per {C:green}modification{} removed",
			"{C:inactive,s:0.7}(ex. Enhancements, Seals, Editions)"
        }
    },
    cost = 15,
    atlas = "vacuum",
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra}}
    end,
    can_use = function(self, card)
        return #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)
		local earnings = 0
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
			if CARD.config.center ~= G.P_CENTERS.c_base then
				earnings = earnings + 1
			end
			if CARD.edition then
				earnings = earnings + 1
			end
			if CARD.seal then
				earnings = earnings + 1
			end
            local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() CARD:flip();CARD:set_ability(G.P_CENTERS.c_base, true, nil);CARD:set_edition(nil, true);CARD:set_seal(nil, true);play_sound('tarot2', percent);CARD:juice_up(0.3, 0.3);return true end }))
        end
		ease_dollars(earnings * card.ability.extra)
    end
}
local vacuum_sprite = {
    object_type = "Atlas",
    key = "vacuum",
    
    path = "c_cry_vacuum.png",
    px = 71,
    py = 95
}
local vacuum_ex = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Vacuum_ex",
    key = "vacuum_ex",
    pos = {x=0,y=0},
	config = {extra = 10},
    loc_txt = {
        name = 'Vacuum EX',
        text = {
			"Removes {C:red}all {C:green}modifications{}",
			"from {C:red}all{} cards in your hand,",
			"Earn {C:money}$#1#{} per {C:green}modification{} removed",
			"{C:inactive,s:0.7}(ex. Enhancements, Seals, Editions)"
        }
    },
    cost = 30,
    atlas = "vacuum_ex",
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra}}
    end,
    can_use = function(self, card)
        return #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)
		local earnings = 0
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
			if CARD.config.center ~= G.P_CENTERS.c_base then
				earnings = earnings + 1
			end
			if CARD.edition then
				earnings = earnings + 1
			end
			if CARD.seal then
				earnings = earnings + 1
			end
            local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() CARD:flip();CARD:set_ability(G.P_CENTERS.c_base, true, nil);CARD:set_edition(nil, true);CARD:set_seal(nil, true);play_sound('tarot2', percent);CARD:juice_up(0.3, 0.3);return true end }))
        end
		ease_dollars(earnings * card.ability.extra)
    end
}
local vacuum_ex_sprite = {
    object_type = "Atlas",
    key = "vacuum_ex",
    
    path = "c_cry_vacuum_ex.png",
    px = 71,
    py = 95
}
local hammerspace = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Hammerspace",
    key = "hammerspace",
    pos = {x=0,y=0},
	config = {},
    loc_txt = {
        name = 'Hammerspace',
        text = {
			"Apply random {C:attention}consumables{}",
			"as if they were {C:dark_edition}Enhancements{}",
			"to your {C:attention}entire hand{}",
			"{C:red}-1{} hand size"
        }
    },
    cost = 4,
    atlas = "hammerspace",
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
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() CARD:flip();CARD:set_ability(G.P_CENTERS[pseudorandom_element(G.P_CENTER_POOLS.Consumeables, pseudoseed('cry_hammerspace')).key], true, nil);play_sound('tarot2', percent);CARD:juice_up(0.3, 0.3);return true end }))
        end
		G.hand:change_size(-1)
    end
}
local hammerspace_sprite = {
    object_type = "Atlas",
    key = "hammerspace",
    path = "s_hammerspace.png",
    px = 71,
    py = 95
}
local hammerspace_ex = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Hammerspace_ex",
    key = "hammerspace_ex",
    pos = {x=0,y=0},
	config = {},
    loc_txt = {
        name = 'Hammerspace EX',
        text = {
			"Apply random {C:attention}consumables{}",
			"as if they were {C:dark_edition}Enhancements{}",
			"to your {C:attention}entire hand{}",
			"{C:blue}+1{} hand size"
        }
    },
    cost = 20,
    atlas = "hammerspace_ex",
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
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() CARD:flip();CARD:set_ability(G.P_CENTERS[pseudorandom_element(G.P_CENTER_POOLS.Consumeables, pseudoseed('cry_hammerspace_ex')).key], true, nil);play_sound('tarot2', percent);CARD:juice_up(0.3, 0.3);return true end }))
        end
		G.hand:change_size(1)
    end
}
local hammerspace_ex_sprite = {
    object_type = "Atlas",
    key = "hammerspace_ex",
    path = "s_hammerspace_ex.png",
    px = 71,
    py = 95
}
local lock = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Lock",
    key = "lock",
    pos = {x=0,y=0},
	config = {},
    loc_txt = {
        name = 'Lock',
        text = {
			"Remove {C:red}all{} stickers from {C:red}all {C:attention}Jokers{},",
			"then apply {C:purple,E:1}Eternal{} to a random {C:attention}Joker{}"
        }
    },
    cost = 4,
    atlas = "lock",
    can_use = function(self, card)
        return #G.jokers.cards > 0
    end,
    use = function(self, card, area, copier)
		local target = #G.jokers.cards == 1 and G.jokers.cards[1] or G.jokers.cards[math.random(#G.jokers.cards)]
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        for i=1, #G.jokers.cards do
            local percent = 1.15 - (i-0.999)/(#G.jokers.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.jokers.cards[i]:flip();play_sound('card1', percent);G.jokers.cards[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.2)
        for i=1, #G.jokers.cards do
			local CARD = G.jokers.cards[i]
            local percent = 0.85 + (i-0.999)/(#G.jokers.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() CARD:flip();CARD.ability.perishable = nil;CARD.pinned = nil;CARD:set_rental(nil);CARD:set_eternal(nil);play_sound('card1', percent);CARD:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.2)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot2')
            card:juice_up(0.3, 0.5)
            return true end }))
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
            play_sound('card1', 0.9)
            target:flip()
            return true end }))
        delay(0.2)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
			play_sound('gold_seal', 1.2, 0.4)
            target:juice_up(0.3, 0.3)
            return true end }))
        delay(0.2)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
            play_sound('card1',1.1)
            target:flip()
			target:set_eternal(true)
            return true end }))
    end
}
local lock_sprite = {
    object_type = "Atlas",
    key = "lock",
    
    path = "c_cry_lock.png",
    px = 71,
    py = 95
}

local trade = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Trade",
    key = "trade",
    pos = {x=0,y=0},
	config = {},
    loc_txt = {
        name = 'Trade',
        text = {
			"{C:attention}Lose{} a random Voucher,",
            "gain {C:attention}2{} random Vouchers"
        }
    },
    cost = 4,
    atlas = "trade",
    can_use = function(self, card)
        for _, v in pairs(G.GAME.used_vouchers) do
            if v then return true end
        end
        return false
    end,
    use = function(self, card, area, copier)
        local usable_vouchers = {}
        for k, _ in pairs(G.GAME.used_vouchers) do
            local can_use = true
            for kk, __ in pairs(G.GAME.used_vouchers) do
                local v = G.P_CENTERS[kk]
                if v.requires then
                    for _, vv in pairs(v.requires) do
                        if vv == k then
                            can_use = false
                            break
                        end
                    end
                end
            end
            if can_use then
                usable_vouchers[#usable_vouchers+1] = k
            end
        end
        local unredeemed_voucher = pseudorandom_element(usable_vouchers, pseudoseed("cry_trade"))
        --redeem extra voucher code based on Betmma's Vouchers
        local area
        if G.STATE == G.STATES.HAND_PLAYED then
            if not G.redeemed_vouchers_during_hand then
                G.redeemed_vouchers_during_hand = CardArea(
                    G.play.T.x, G.play.T.y, G.play.T.w, G.play.T.h, 
                    {type = 'play', card_limit = 5})
            end
            area = G.redeemed_vouchers_during_hand
        else
            area = G.play
        end
        local card = create_card('Voucher', area, nil, nil, nil, nil, unredeemed_voucher)
        card:start_materialize()
        area:emplace(card)
        card.cost=0
        card.shop_voucher=false
        local current_round_voucher=G.GAME.current_round.voucher
        card:unredeem()
        G.GAME.current_round.voucher=current_round_voucher
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay =  0,
            func = function() 
                card:start_dissolve()
                return true
            end})) 
        for i = 1, 2 do
            local area
            if G.STATE == G.STATES.HAND_PLAYED then
                if not G.redeemed_vouchers_during_hand then
                    G.redeemed_vouchers_during_hand = CardArea(
                        G.play.T.x, G.play.T.y, G.play.T.w, G.play.T.h, 
                        {type = 'play', card_limit = 5})
                end
                area = G.redeemed_vouchers_during_hand
            else
                area = G.play
            end
            local _pool = get_current_pool('Voucher', nil, nil, nil, true)
            local center = pseudorandom_element(_pool, pseudoseed('cry_trade_redeem'))
            local it = 1
            while center == 'UNAVAILABLE' do
                it = it + 1
                center = pseudorandom_element(_pool, pseudoseed('cry_trade_redeem_resample'..it))
            end
            local card = create_card('Voucher', area, nil, nil, nil, nil, center)
            card:start_materialize()
            area:emplace(card)
            card.cost=0
            card.shop_voucher=false
            local current_round_voucher=G.GAME.current_round.voucher
            card:redeem()
            G.GAME.current_round.voucher=current_round_voucher
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay =  0,
                func = function() 
                    card:start_dissolve()
                    return true
                end})) 
        end
    end
}
local trade_sprite = {
    object_type = "Atlas",
    key = "trade",
    path = "c_cry_trade.png",
    px = 71,
    py = 95
}
local analog = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Analog",
    key = "analog",
    pos = {x=0,y=0},
	config = {copies = 2, ante = 1},
    loc_txt = {
        name = 'Analog',
        text = {
			"Create {C:attention}#1#{} copies of a",
            "random {C:attention}Joker{}, destroy",
            "all other Jokers, {C:attention}+#2#{} Ante"
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.copies,center.ability.ante}}
    end,
    cost = 4,
    atlas = "analog",
    can_use = function(self, card)
        return #G.jokers.cards > 0
    end,
    use = function(self, card, area, copier)
        local deletable_jokers = {}
        for k, v in pairs(G.jokers.cards) do
            if not v.ability.eternal then deletable_jokers[#deletable_jokers + 1] = v end
        end
        local chosen_joker = pseudorandom_element(G.jokers.cards, pseudoseed('cry_analog_choice'))
        local _first_dissolve = nil
        G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.75, func = function()
            for k, v in pairs(deletable_jokers) do
                if v ~= chosen_joker then 
                    v:start_dissolve(nil, _first_dissolve)
                    _first_dissolve = true
                end
            end
            return true end }))
        for i = 1, card.ability.copies do
            G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.4, func = function()
                local card = copy_card(chosen_joker)
                card:start_materialize()
                card:add_to_deck()
                G.jokers:emplace(card)
                return true end }))
        end
        ease_ante(card.ability.ante)
    end
}
local analog_sprite = {
    object_type = "Atlas",
    key = "analog",
    path = "c_cry_analog.png",
    px = 71,
    py = 95
}
local analog_ex = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Analog_ex",
    key = "analog_ex",
    pos = {x=0,y=0},
	config = {copies = 3, ante = 0},
    loc_txt = {
        name = 'Analog EX',
        text = {
			"Create {C:attention}#1#{} copies of a",
            "random {C:attention}Joker{}, destroy",
            "all other Jokers"
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.copies,center.ability.ante}}
    end,
    cost = 20,
    atlas = "analog_ex",
    can_use = function(self, card)
        return #G.jokers.cards > 0
    end,
    use = function(self, card, area, copier)
        local deletable_jokers = {}
        for k, v in pairs(G.jokers.cards) do
            if not v.ability.eternal then deletable_jokers[#deletable_jokers + 1] = v end
        end
        local chosen_joker = pseudorandom_element(G.jokers.cards, pseudoseed('cry_analog_choice'))
        local _first_dissolve = nil
        G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.75, func = function()
            for k, v in pairs(deletable_jokers) do
                if v ~= chosen_joker then 
                    v:start_dissolve(nil, _first_dissolve)
                    _first_dissolve = true
                end
            end
            return true end }))
        for i = 1, card.ability.copies do
            G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.4, func = function()
                local card = copy_card(chosen_joker)
                card:start_materialize()
                card:add_to_deck()
                G.jokers:emplace(card)
                return true end }))
        end
        ease_ante(card.ability.ante)
    end
}
local analog_ex_sprite = {
    object_type = "Atlas",
    key = "analog_ex",
    path = "c_cry_analog_ex.png",
    px = 71,
    py = 95
}
local replica = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Replica",
    key = "replica",
    pos = {x=0,y=0},
	config = {},
    loc_txt = {
        name = 'Replica',
        text = {
			"Convert all cards in hand to a",
            "{C:attention}random{} card held in hand"
        }
    },
    cost = 4,
    atlas = "replica",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local chosen_card = pseudorandom_element(G.hand.cards, pseudoseed('cry_replica_choice'))
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            card:juice_up(0.3, 0.5)
            return true end }))
        for i=1, #G.hand.cards do
            local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('card1', percent);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
        end
        for i=1, #G.hand.cards do
            if not G.hand.cards[i].ability.eternal then
                G.E_MANAGER:add_event(Event({func = function()
                    copy_card(chosen_card, G.hand.cards[i])
                return true end }))
            end
        end 
        for i=1, #G.hand.cards do
            local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.5)
    end
}
local replica_sprite = {
    object_type = "Atlas",
    key = "replica",
    path = "c_cry_replica.png",
    px = 71,
    py = 95
}
local bothand = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Bothand",
    key = "bothand",
    pos = {x=0,y=0},
	config = {},
    loc_txt = {
        name = 'Bot Hand',
        text = {
			"Convert your {C:gold}money{} into",
            "permanent {C:blue}hands{} {C:grey}(1 / 10$){}",
            "Set {C:gold}money{} to {C:gold}0${}"
        }
    },
    cost = 6,
    atlas = "bothand",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + G.GAME.dollars*0.1
        G.GAME.dollars = 0
    end,
}
local bothand_sprite = {
    object_type = "Atlas",
    key = "bothand",
    path = "c_cry_bothand.png",
    px = 71,
    py = 95
}
local nail = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Nail",
    key = "nail",
    pos = {x=0,y=0},
	config = {},
    loc_txt = {
        name = 'Nail',
        text = {
			"Convert your {C:gold}money{} into",
            "permanent {C:red}discards{} {C:grey}(1 / 10$){}",
            "Set {C:gold}money{} to {C:gold}0${}"
        }
    },
    cost = 6,
    atlas = "nail",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + G.GAME.dollars*0.1
        G.GAME.dollars = 0
    end,
}
local nail_sprite = {
    object_type = "Atlas",
    key = "nail",
    path = "c_cry_nail.png",
    px = 71,
    py = 95
}
local screwdriver = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Screwdriver",
    key = "screwdriver",
    pos = {x=0,y=0},
	config = {},
    loc_txt = {
        name = 'Screwdriver',
        text = {
			"Convert your {C:gold}money{} into",
            "permanent {C:dark_edition}jokers slot{} {C:grey}(1 / 10$){}",
            "Set {C:gold}money{} to {C:gold}0${}"
        }
    },
    cost = 6,
    atlas = "screwdriver",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.jokers.config.card_limit = G.jokers.config.card_limit + G.GAME.dollars*0.1
        G.GAME.dollars = 0
    end,
}
local screwdriver_sprite = {
    object_type = "Atlas",
    key = "screwdriver",
    path = "c_cry_screwdriver.png",
    px = 71,
    py = 95
}
local box = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Box",
    key = "box",
    pos = {x=0,y=0},
	config = {},
    loc_txt = {
        name = 'Box',
        text = {
			"Convert your {C:gold}money{} into",
            "permanent {C:attention}consumeables slot{} {C:grey}(1 / 10$){}",
            "Set {C:gold}money{} to {C:gold}0${}"
        }
    },
    cost = 6,
    atlas = "box",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + G.GAME.dollars*0.1
        G.GAME.dollars = 0
    end,
}
local box_sprite = {
    object_type = "Atlas",
    key = "box",
    path = "c_cry_box.png",
    px = 71,
    py = 95
}

local backpack = {
    object_type = "Consumable",
    set = "Spectral",
    name = "cry-Backpack",
    key = "backpack",
    pos = {x=0,y=0},
	config = {},
    loc_txt = {
        name = 'Backpack',
        text = {
			"Store an {C:dark_edition}edition{} from",
                        "an highlighted {C:dark_edition}joker{}"
        }
    },
    cost = 6,
    atlas = "backpack",
    can_use = function(self, card)
        return #G.jokers.highlighted + #G.hand.highlighted == 1 and G.jokers.highlighted[1] and G.jokers.highlighted[1].edition
    end,
    use = function(self, card, area, copier)
        if G.jokers.highlighted[1].edition.foil then
            G.jokers.highlighted[1]:set_edition({
            				foil = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil, nil, nil, nil, 'c_cry_foiledition', 'backpack')
            card:set_edition({foil = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.holo then
            G.jokers.highlighted[1]:set_edition({
            				holo = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_holoedition', 'backpack')
            card:set_edition({holo = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.polychrome then
            G.jokers.highlighted[1]:set_edition({
            				polychrome = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_polychromeedition', 'backpack')
            card:set_edition({polychrome = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.negative then
            G.jokers.highlighted[1]:set_edition({
            				negative = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_negativeedition', 'backpack')
            card:set_edition({negative = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.phantom then
            G.jokers.highlighted[1]:set_edition({
            				phantom = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_phantomedition', 'backpack')
            card:set_edition({phantom = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.tentacle then
            G.jokers.highlighted[1]:set_edition({
            				tentacle = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_tentacleedition', 'backpack')
            card:set_edition({tentacle = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.kraken then
            G.jokers.highlighted[1]:set_edition({
            				kraken = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_krakenedition', 'backpack')
            card:set_edition({kraken = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cthulhu then
            G.jokers.highlighted[1]:set_edition({
            				cthulhu = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_cthulhuedition', 'backpack')
            card:set_edition({cthulhu = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.bunc_glitter then
            G.jokers.highlighted[1]:set_edition({
            				bunc_glitter = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_glitteredition', 'backpack')
            card:set_edition({bunc_glitter = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.bunc_balavirussquare then
            G.jokers.highlighted[1]:set_edition({
            				bunc_balavirussquare = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_balavirussquareedition', 'backpack')
            card:set_edition({bunc_balavirussquare = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.bunc_fluorescent then
            G.jokers.highlighted[1]:set_edition({
            				bunc_fluorescent = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_fluorescentedition', 'backpack')
            card:set_edition({bunc_fluorescent = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.bunc_shinygalvanized then
            G.jokers.highlighted[1]:set_edition({
            				bunc_shinygalvanized = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_shinygalvanizededition', 'backpack')
            card:set_edition({bunc_shinygalvanized = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.bunc_burnt then
            G.jokers.highlighted[1]:set_edition({
            				bunc_burnt = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_burntedition', 'backpack')
            card:set_edition({bunc_burnt = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_opposite then
            G.jokers.highlighted[1]:set_edition({
            				cry_opposite = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_oppositeedition', 'backpack')
            card:set_edition({cry_opposite = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_superopposite then
            G.jokers.highlighted[1]:set_edition({
            				cry_superopposite = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_superoppositeedition', 'backpack')
            card:set_edition({cry_superopposite = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_ultraopposite then
            G.jokers.highlighted[1]:set_edition({
            				cry_ultraopposite = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_ultraoppositeedition', 'backpack')
            card:set_edition({cry_ultraopposite = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_hyperopposite then
            G.jokers.highlighted[1]:set_edition({
            				cry_hyperopposite = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_hyperoppositeedition', 'backpack')
            card:set_edition({cry_hyperopposite = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_eraser then
            G.jokers.highlighted[1]:set_edition({
            				cry_eraser = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_eraseredition', 'backpack')
            card:set_edition({cry_eraser = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_mosaic then
            G.jokers.highlighted[1]:set_edition({
            				cry_mosaic = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_mosaicedition', 'backpack')
            card:set_edition({cry_mosaic = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_sparkle then
            G.jokers.highlighted[1]:set_edition({
            				cry_sparkle = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_sparkleedition', 'backpack')
            card:set_edition({cry_sparkle = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_oversat then
            G.jokers.highlighted[1]:set_edition({
            				cry_oversat = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_oversatedition', 'backpack')
            card:set_edition({cry_oversat = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_glitched then
            G.jokers.highlighted[1]:set_edition({
            				cry_glitched = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_glitchededition', 'backpack')
            card:set_edition({cry_glitched = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_glitchoversat then
            G.jokers.highlighted[1]:set_edition({
            				cry_glitchoversat = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_glitchoversatedition', 'backpack')
            card:set_edition({cry_glitchoversat = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_ultraglitch then
            G.jokers.highlighted[1]:set_edition({
            				cry_ultraglitch = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_ultraglitchedition', 'backpack')
            card:set_edition({cry_ultraglitch = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_absoluteglitch then
            G.jokers.highlighted[1]:set_edition({
            				cry_absoluteglitch = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_absoluteglitchedition', 'backpack')
            card:set_edition({cry_absoluteglitch = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_astral then
            G.jokers.highlighted[1]:set_edition({
            				cry_astral = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_astraledition', 'backpack')
            card:set_edition({cry_astral = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_hyperastral then
            G.jokers.highlighted[1]:set_edition({
            				cry_hyperastral = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_hyperastraledition', 'backpack')
            card:set_edition({cry_hyperastral = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_blur then
            G.jokers.highlighted[1]:set_edition({
            				cry_blur = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_bluredition', 'backpack')
            card:set_edition({cry_blur = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_blind then
            G.jokers.highlighted[1]:set_edition({
            				cry_blind = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_blindedition', 'backpack')
            card:set_edition({cry_blind = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_eyesless then
            G.jokers.highlighted[1]:set_edition({
            				cry_eyesless = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_eyeslessedition', 'backpack')
            card:set_edition({cry_eyesless = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_expensive then
            G.jokers.highlighted[1]:set_edition({
            				cry_expensive = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_expensiveedition', 'backpack')
            card:set_edition({cry_expensive = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_veryexpensive then
            G.jokers.highlighted[1]:set_edition({
            				cry_veryexpensive = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_veryexpensiveedition', 'backpack')
            card:set_edition({cry_veryexpensive = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_tooexpensive then
            G.jokers.highlighted[1]:set_edition({
            				cry_tooexpensive = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_tooexpensiveedition', 'backpack')
            card:set_edition({cry_tooexpensive = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_unobtainable then
            G.jokers.highlighted[1]:set_edition({
            				cry_unobtainable = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_unobtainableedition', 'backpack')
            card:set_edition({cry_unobtainable = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_shiny then
            G.jokers.highlighted[1]:set_edition({
            				cry_shiny = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_shinyedition', 'backpack')
            card:set_edition({cry_shiny = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_ultrashiny then
            G.jokers.highlighted[1]:set_edition({
            				cry_ultrashiny = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_ultrashinyedition', 'backpack')
            card:set_edition({cry_ultrashiny = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_balavirus then
            G.jokers.highlighted[1]:set_edition({
            				cry_balavirus = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_balavirusedition', 'backpack')
            card:set_edition({cry_balavirus = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_cosmic then
            G.jokers.highlighted[1]:set_edition({
            				cry_cosmic = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_cosmicedition', 'backpack')
            card:set_edition({cry_cosmic = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_hypercosmic then
            G.jokers.highlighted[1]:set_edition({
            				cry_hypercosmic = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_hypercosmicedition', 'backpack')
            card:set_edition({cry_hypercosmic = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_darkmatter then
            G.jokers.highlighted[1]:set_edition({
            				cry_darkmatter = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_darkmatteredition', 'backpack')
            card:set_edition({cry_darkmatter = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_darkvoid then
            G.jokers.highlighted[1]:set_edition({
            				cry_darkvoid = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_darkvoidedition', 'backpack')
            card:set_edition({cry_darkvoid = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_pocketedition then
            G.jokers.highlighted[1]:set_edition({
            				cry_pocketedition = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_pocketeditionedition', 'backpack')
            card:set_edition({cry_pocketedition = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_limitededition then
            G.jokers.highlighted[1]:set_edition({
            				cry_limitededition = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_limitededitionedition', 'backpack')
            card:set_edition({cry_limitededition = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_greedy then
            G.jokers.highlighted[1]:set_edition({
            				cry_greedy = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_greedyedition', 'backpack')
            card:set_edition({cry_greedy = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_bailiff then
            G.jokers.highlighted[1]:set_edition({
            				cry_bailiff = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_bailiffedition', 'backpack')
            card:set_edition({cry_bailiff = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_duplicated then
            G.jokers.highlighted[1]:set_edition({
            				cry_duplicated = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_duplicatededition', 'backpack')
            card:set_edition({cry_duplicated = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_trash then
            G.jokers.highlighted[1]:set_edition({
            				cry_trash = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_trashedition', 'backpack')
            card:set_edition({cry_trash = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_lefthanded then
            G.jokers.highlighted[1]:set_edition({
            				cry_lefthanded = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_lefthandededition', 'backpack')
            card:set_edition({cry_lefthanded = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_righthanded then
            G.jokers.highlighted[1]:set_edition({
            				cry_righthanded = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_righthandededition', 'backpack')
            card:set_edition({cry_righthanded = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_pinkstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_pinkstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_pinkstakecurseedition', 'backpack')
            card:set_edition({cry_pinkstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_brownstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_brownstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_brownstakecurseedition', 'backpack')
            card:set_edition({cry_brownstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_yellowstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_yellowstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_yellowstakecurseedition', 'backpack')
            card:set_edition({cry_yellowstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_jadestakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_jadestakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_jadestakecurseedition', 'backpack')
            card:set_edition({cry_jadestakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_cyanstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_cyanstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_cyanstakecurseedition', 'backpack')
            card:set_edition({cry_cyanstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_graystakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_graystakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_graystakecurseedition', 'backpack')
            card:set_edition({cry_graystakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_crimsonstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_crimsonstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_crimsonstakecurseedition', 'backpack')
            card:set_edition({cry_crimsonstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_diamondstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_diamondstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_diamondstakecurseedition', 'backpack')
            card:set_edition({cry_diamondstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_amberstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_amberstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_amberstakecurseedition', 'backpack')
            card:set_edition({cry_amberstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_bronzestakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_bronzestakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_bronzestakecurseedition', 'backpack')
            card:set_edition({cry_bronzestakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_quartzstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_quartzstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_quartzstakecurseedition', 'backpack')
            card:set_edition({cry_quartzstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_rubystakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_rubystakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_rubystakecurseedition', 'backpack')
            card:set_edition({cry_rubystakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_glassstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_glassstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_glassstakecurseedition', 'backpack')
            card:set_edition({cry_glassstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_sapphirestakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_sapphirestakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_sapphirestakecurseedition', 'backpack')
            card:set_edition({cry_sapphirestakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_emeraldstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_emeraldstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_emeraldstakecurseedition', 'backpack')
            card:set_edition({cry_emeraldstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_platinumstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_platinumstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_platinumstakecurseedition', 'backpack')
            card:set_edition({cry_platinumstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_verdantstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_verdantstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_verdantstakecurseedition', 'backpack')
            card:set_edition({cry_verdantstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_emberstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_emberstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_emberstakecurseedition', 'backpack')
            card:set_edition({cry_emberstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_dawnstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_dawnstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_dawnstakecurseedition', 'backpack')
            card:set_edition({cry_dawnstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_horizonstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_horizonstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_horizonstakecurseedition', 'backpack')
            card:set_edition({cry_horizonstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_blossomstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_blossomstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_blossomstakecurseedition', 'backpack')
            card:set_edition({cry_blossomstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_azurestakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_azurestakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_azurestakecurseedition', 'backpack')
            card:set_edition({cry_azurestakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_ascendantstakecurse then
            G.jokers.highlighted[1]:set_edition({
            				cry_ascendantstakecurse = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_ascendantstakecurseedition', 'backpack')
            card:set_edition({cry_ascendantstakecurse = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_brilliant then
            G.jokers.highlighted[1]:set_edition({
            				cry_brilliant = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_brilliantedition', 'backpack')
            card:set_edition({cry_brilliant = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_blister then
            G.jokers.highlighted[1]:set_edition({
            				cry_blister = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_blisteredition', 'backpack')
            card:set_edition({cry_blister = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_galvanized then
            G.jokers.highlighted[1]:set_edition({
            				cry_galvanized = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_galvanizededition', 'backpack')
            card:set_edition({cry_galvanized = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_chromaticplatinum then
            G.jokers.highlighted[1]:set_edition({
            				cry_chromaticplatinum = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_chromaticplatinumedition', 'backpack')
            card:set_edition({cry_chromaticplatinum = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_metallic then
            G.jokers.highlighted[1]:set_edition({
            				cry_metallic = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_metallicedition', 'backpack')
            card:set_edition({cry_metallic = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_titanium then
            G.jokers.highlighted[1]:set_edition({
            				cry_titanium = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_titaniumedition', 'backpack')
            card:set_edition({cry_titanium = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_omnichromatic then
            G.jokers.highlighted[1]:set_edition({
            				cry_omnichromatic = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_omnichromaticedition', 'backpack')
            card:set_edition({cry_omnichromatic = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_chromaticastral then
            G.jokers.highlighted[1]:set_edition({
            				cry_chromaticastral = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_chromaticastraledition', 'backpack')
            card:set_edition({cry_chromaticastral = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_tvghost then
            G.jokers.highlighted[1]:set_edition({
            				cry_tvghost = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_tvghostedition', 'backpack')
            card:set_edition({cry_tvghost = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_noisy then
            G.jokers.highlighted[1]:set_edition({
            				cry_noisy = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_noisyedition', 'backpack')
            card:set_edition({cry_noisy = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_rainbow then
            G.jokers.highlighted[1]:set_edition({
            				cry_rainbow = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_rainbowedition', 'backpack')
            card:set_edition({cry_rainbow = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_hyperchrome then
            G.jokers.highlighted[1]:set_edition({
            				cry_hyperchrome = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_hyperchromeedition', 'backpack')
            card:set_edition({cry_hyperchrome = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_shadowing then
            G.jokers.highlighted[1]:set_edition({
            				cry_shadowing = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_shadowingedition', 'backpack')
            card:set_edition({cry_shadowing = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_graymatter then
            G.jokers.highlighted[1]:set_edition({
            				cry_graymatter = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_graymatteredition', 'backpack')
            card:set_edition({cry_graymatter = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_hardstone then
            G.jokers.highlighted[1]:set_edition({
            				cry_hardstone = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_hardstoneedition', 'backpack')
            card:set_edition({cry_hardstone = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_impulsion then
            G.jokers.highlighted[1]:set_edition({
            				cry_impulsion = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_impulsionedition', 'backpack')
            card:set_edition({cry_impulsion = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_chromaticimpulsion then
            G.jokers.highlighted[1]:set_edition({
            				cry_chromaticimpulsion = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_chromaticimpulsionedition', 'backpack')
            card:set_edition({cry_chromaticimpulsion = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_psychedelic then
            G.jokers.highlighted[1]:set_edition({
            				cry_psychedelic = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_psychedelicedition', 'backpack')
            card:set_edition({cry_psychedelic = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_bedrock then
            G.jokers.highlighted[1]:set_edition({
            				cry_bedrock = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_bedrockedition', 'backpack')
            card:set_edition({cry_bedrock = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_golden then
            G.jokers.highlighted[1]:set_edition({
            				cry_golden = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_goldenedition', 'backpack')
            card:set_edition({cry_golden = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_ultragolden then
            G.jokers.highlighted[1]:set_edition({
            				cry_ultragolden = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_ultragoldenedition', 'backpack')
            card:set_edition({cry_ultragolden = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_root then
            G.jokers.highlighted[1]:set_edition({
            				cry_root = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_rootedition', 'backpack')
            card:set_edition({cry_root = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_catalyst then
            G.jokers.highlighted[1]:set_edition({
            				cry_catalyst = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_catalystedition', 'backpack')
            card:set_edition({cry_catalyst = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_eyesless_balavirus then
            G.jokers.highlighted[1]:set_edition({
            				cry_eyesless_balavirus = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_eyesless_balavirusedition', 'backpack')
            card:set_edition({cry_eyesless_balavirus = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_absoluteglitch_balavirus then
            G.jokers.highlighted[1]:set_edition({
            				cry_absoluteglitch_balavirus = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_absoluteglitch_balavirusedition', 'backpack')
            card:set_edition({cry_absoluteglitch_balavirus = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_darkvoid_balavirus then
            G.jokers.highlighted[1]:set_edition({
            				cry_darkvoid_balavirus = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_darkvoid_balavirusedition', 'backpack')
            card:set_edition({cry_darkvoid_balavirus = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        elseif G.jokers.highlighted[1].edition.cry_psychedelic_balavirus then
            G.jokers.highlighted[1]:set_edition({
            				cry_psychedelic_balavirus = false
            			})
            local card = create_card('Editioncard', G.consumeables, nil,  nil, nil, nil, 'c_cry_psychedelic_balavirusedition', 'backpack')
            card:set_edition({cry_psychedelic_balavirus = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card)
        end
    end,
}
local backpack_sprite = {
    object_type = "Atlas",
    key = "backpack",
    path = "c_cry_backpack.png",
    px = 71,
    py = 95
}

return {name = "Spectrals", 
        init = function()
            --Trade - undo redeeming vouchers
            function Card:unredeem()
                if self.ability.set == "Voucher" then
                    stop_use()
                    if not self.config.center.discovered then
                        discover_card(self.config.center)
                    end
            
                    self.states.hover.can = false
                    G.GAME.used_vouchers[self.config.center_key] = nil
                    local top_dynatext = nil
                    local bot_dynatext = nil
                    
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                            top_dynatext = DynaText({string = localize{type = 'name_text', set = self.config.center.set, key = self.config.center.key}, colours = {G.C.RED}, rotate = 1,shadow = true, bump = true,float=true, scale = 0.9, pop_in = 0.6/G.SPEEDFACTOR, pop_in_rate = 1.5*G.SPEEDFACTOR})
                            bot_dynatext = DynaText({string = "Unredeemed...", colours = {G.C.RED}, rotate = 2,shadow = true, bump = true,float=true, scale = 0.9, pop_in = 1.4/G.SPEEDFACTOR, pop_in_rate = 1.5*G.SPEEDFACTOR, pitch_shift = 0.25})
                            self:juice_up(0.3, 0.5)
                            play_sound('card1')
                            play_sound('timpani')
                            self.children.top_disp = UIBox{
                                definition =    {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
                                                    {n=G.UIT.O, config={object = top_dynatext}}
                                                }},
                                config = {align="tm", offset = {x=0,y=0},parent = self}
                            }
                            self.children.bot_disp = UIBox{
                                    definition =    {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
                                                        {n=G.UIT.O, config={object = bot_dynatext}}
                                                    }},
                                    config = {align="bm", offset = {x=0,y=0},parent = self}
                                }
                        return true end }))
                    G.GAME.current_round.voucher = nil
            
                    self:unapply_to_run()
            
                    delay(0.6)
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 2.6, func = function()
                        top_dynatext:pop_out(4)
                        bot_dynatext:pop_out(4)
                        return true end }))
                    
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.5, func = function()
                        self.children.top_disp:remove()
                        self.children.top_disp = nil
                        self.children.bot_disp:remove()
                        self.children.bot_disp = nil
                    return true end }))
                end
            end
            function Card:unapply_to_run(center)
                local center_table = {
                    name = center and center.name or self and self.ability.name,
                    extra = center and center.config.extra or self and self.ability.extra
                }
                local obj = center or self.config.center
                if obj.unredeem and type(obj.unredeem) == 'function' then
                    obj:unredeem(self)
                    return
                end
                if center_table.name == 'Overstock' or center_table.name == 'Overstock Plus' then
                    G.E_MANAGER:add_event(Event({func = function()
                        change_shop_size(-1)
                        return true end }))
                end
                if center_table.name == 'Tarot Merchant' or center_table.name == 'Tarot Tycoon' then
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.tarot_rate = G.GAME.tarot_rate / center_table.extra
                        return true end }))
                end
                if center_table.name == 'Planet Merchant' or center_table.name == 'Planet Tycoon' then
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.planet_rate = G.GAME.planet_rate / center_table.extra
                        return true end }))
                end
                if center_table.name == 'Hone' or center_table.name == 'Glow Up' then
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.edition_rate = G.GAME.edition_rate / center_table.extra
                        return true end }))
                end
                if center_table.name == 'Magic Trick' then
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.playing_card_rate = 0
                        return true end }))
                end
                if center_table.name == 'Crystal Ball' then
                    G.E_MANAGER:add_event(Event({func = function()
                        G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
                        return true end }))
                end
                if center_table.name == 'Clearance Sale' then
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.discount_percent = 0
                        for k, v in pairs(G.I.CARD) do
                            if v.set_cost then v:set_cost() end
                        end
                        return true end }))
                end
                if center_table.name == 'Liquidation' then
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.discount_percent = G.P_CENTERS.v_clearance_sale.extra
                        for k, v in pairs(G.I.CARD) do
                            if v.set_cost then v:set_cost() end
                        end
                        return true end }))
                end
                if center_table.name == 'Reroll Surplus' or center_table.name == 'Reroll Glut' then
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + self.ability.extra
                        G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost + self.ability.extra)
                        return true end }))
                end
                if center_table.name == 'Seed Money' then
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.interest_cap = center_table.extra
                        return true end }))
                end
                if center_table.name == 'Money Tree' then
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.interest_cap = G.P_CENTERS.v_seed_money.extra
                        return true end }))
                end
                if center_table.name == 'Grabber' or center_table.name == 'Nacho Tong' then
                    G.GAME.round_resets.hands = G.GAME.round_resets.hands - center_table.extra
                    ease_hands_played(-center_table.extra)
                end
                if center_table.name == 'Paint Brush' or center_table.name == 'Palette' then
                    G.hand:change_size(-1)
                end
                if center_table.name == 'Wasteful' or center_table.name == 'Recyclomancy' then
                    G.GAME.round_resets.discards = G.GAME.round_resets.discards - center_table.extra
                    ease_discard(-center_table.extra)
                end
                if center_table.name == 'Antimatter' then
                    G.E_MANAGER:add_event(Event({func = function()
                        if G.jokers then 
                            G.jokers.config.card_limit = G.jokers.config.card_limit - 1
                        end
                        return true end }))
                end
                if center_table.name == 'Hieroglyph' or center_table.name == 'Petroglyph' then
                    ease_ante(center_table.extra)
                    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante+center_table.extra
            
                    if center_table.name == 'Hieroglyph' then
                        G.GAME.round_resets.hands = G.GAME.round_resets.hands + center_table.extra
                        ease_hands_played(center_table.extra)
                    end
                    if center_table.name == 'Petroglyph' then
                        G.GAME.round_resets.discards = G.GAME.round_resets.discards + center_table.extra
                        ease_discard(center_table.extra)
                    end
                end
            end
        end,
        items = {white_hole_sprite, quasar_sprite, vacuum_sprite, vacuum_ex_sprite, hammerspace_sprite, hammerspace_ex_sprite, lock_sprite, trade_sprite, analog_sprite, analog_ex_sprite, replica_sprite, bothand_sprite, nail_sprite, screwdriver_sprite, box_sprite, backpack_sprite, white_hole, quasar, vacuum, vacuum_ex, hammerspace, hammerspace_ex, lock, trade, analog, analog_ex, replica, bothand, nail, screwdriver, box, backpack}}
