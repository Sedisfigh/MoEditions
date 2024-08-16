LOVELY_INTEGRITY = '0b21d90734efb7eb9b31c67acc30ca6aeb768dab7f203bd2e085e2262866bf82'

function win_game()
    if not G.GAME.seeded and not G.GAME.challenge then
        set_joker_win()
        set_deck_win()
        
        check_and_set_high_score('win_streak', G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt+1)
        check_and_set_high_score('current_streak', G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt+1)
        check_for_unlock({type = 'win_no_hand'})
        check_for_unlock({type = 'win_no'})
        check_for_unlock({type = 'win_custom'})
        check_for_unlock({type = 'win_deck'})
        check_for_unlock({type = 'win_stake'})
        check_for_unlock({type = 'win'})
        inc_career_stat('c_wins', 1)
    end

    set_profile_progress()

    if G.GAME.challenge then
        G.PROFILES[G.SETTINGS.profile].challenge_progress.completed[G.GAME.challenge] = true
        set_challenge_unlock()
        check_for_unlock({type = 'win_challenge'})
        G:save_settings()
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            play_sound('win')
            G.SETTINGS.paused = true

            G.FUNCS.overlay_menu{
                definition = create_UIBox_win(),
                config = {no_esc = true}
            }
            local Jimbo = nil

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 2.5,
                blocking = false,
                func = (function()
                    if G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot') then 
                        Jimbo = Card_Character({x = 0, y = 5})
                        local spot = G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot')
                        spot.config.object:remove()
                        spot.config.object = Jimbo
                        Jimbo.ui_object_updated = true
                        Jimbo:add_speech_bubble('wq_'..math.random(1,7), nil, {quip = true})
                        Jimbo:say_stuff(5)
                        if G.F_JAN_CTA then 
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    Jimbo:add_button(localize('b_wishlist'), 'wishlist_steam', G.C.DARK_EDITION, nil, true, 1.6)
                                    return true
                                end}))
                        end
                        end
                    return true
                end)
            }))
            
            return true
        end)
    }))

    if not G.GAME.seeded and not G.GAME.challenge then
        G.PROFILES[G.SETTINGS.profile].stake = math.max(G.PROFILES[G.SETTINGS.profile].stake or 1, (G.GAME.stake or 1)+1)
    end
    G:save_progress()
    G.FILE_HANDLER.force = true
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            if not G.SETTINGS.paused then
                G.GAME.current_round.round_text = 'Endless Round '
                return true
            end
        end)
    }))
end

function end_round()
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.2,
      func = function()
        local game_over = true
        local game_won = false
        G.RESET_BLIND_STATES = true
        G.RESET_JIGGLES = true
            if to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) then
                            game_over = false
            end
            if G.GAME.current_round.semicolon and game_over then
                game_over = false
            end
            for i = 1, #G.jokers.cards do
                local eval = nil
                eval = G.jokers.cards[i]:calculate_joker({end_of_round = true, game_over = game_over})
                if eval and eval.joker_repetitions then
                    rep_list = eval.joker_repetitions
                    for z=1, #rep_list do
                        if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                            for r=1, rep_list[z].repetitions do
                                card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                                if percent then percent = percent+percent_delta end
                                local ev = G.jokers.cards[i]:calculate_joker({end_of_round = true, game_over = game_over, retrigger_joker = true})
                                if ev then
                                    if ev.saved then
                                        game_over = false
                                    end
                                    card_eval_status_text(G.jokers.cards[i], 'jokers', nil, nil, nil, ev)
                                end
                            end
                        end
                    end
                end
                                if eval then
                    if eval.saved then
                        game_over = false
                    end
                    card_eval_status_text(G.jokers.cards[i], 'jokers', nil, nil, nil, eval)
                end
                G.jokers.cards[i]:calculate_rental()
                G.jokers.cards[i]:calculate_perishable()
            end
            local i = 1
            while i <= #G.jokers.cards do
                local gone = G.jokers.cards[i]:calculate_banana()
                if not gone then i = i + 1 end
            end
            i = 1
            while i <= #G.consumeables.cards do
                G.consumeables.cards[i]:calculate_rental()
                G.consumeables.cards[i]:calculate_perishable()
                local gone = G.consumeables.cards[i]:calculate_banana()
                if not gone then i = i + 1 end
            end
                        if G.GAME.round_resets.ante == G.GAME.win_ante and G.GAME.blind_on_deck == 'Boss' then
                game_won = true
                G.GAME.won = true
            end
            if game_over then
                G.STATE = G.STATES.GAME_OVER
                if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
                    G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                end
                G:save_settings()
                G.FILE_HANDLER.force = true
                G.STATE_COMPLETE = false
            else
                G.GAME.unused_discards = (G.GAME.unused_discards or 0) + G.GAME.current_round.discards_left
                if G.GAME.blind and G.GAME.blind.config.blind then 
                    discover_card(G.GAME.blind.config.blind)
                end

                if G.GAME.blind_on_deck == 'Boss' then
                    local _handname, _played, _order = 'High Card', -1, 100
                    for k, v in pairs(G.GAME.hands) do
                        if v.played > _played or (v.played == _played and _order > v.order) then 
                            _played = v.played
                            _handname = k
                        end
                    end
                    G.GAME.current_round.most_played_poker_hand = _handname
                end

                if G.GAME.blind:get_type() == 'Boss' and not G.GAME.seeded and not G.GAME.challenge  then
                    G.GAME.current_boss_streak = G.GAME.current_boss_streak + 1
                    check_and_set_high_score('boss_streak', G.GAME.current_boss_streak)
                end
                
                if G.GAME.current_round.hands_played == 1 then 
                    inc_career_stat('c_single_hand_round_streak', 1)
                else
                    if not G.GAME.seeded and not G.GAME.challenge  then
                        G.PROFILES[G.SETTINGS.profile].career_stats.c_single_hand_round_streak = 0
                        G:save_settings()
                    end
                end

                check_for_unlock({type = 'round_win'})
                set_joker_usage()
                if game_won and not G.GAME.win_notified then
                    G.GAME.win_notified = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        blockable = false,
                        func = (function()
                            if G.STATE == G.STATES.ROUND_EVAL then 
                                win_game()
                                G.GAME.won = true
                                return true
                            end
                        end)
                    }))
                end
                for i=1, #G.hand.cards do
                    --Check for hand doubling
                    local reps = {1}
                    local j = 1
                    while j <= #reps do
                        local percent = (i-0.999)/(#G.hand.cards-0.998) + (j-1)*0.1
                        if reps[j] ~= 1 then card_eval_status_text((reps[j].jokers or reps[j].seals).card, 'jokers', nil, nil, nil, (reps[j].jokers or reps[j].seals)) end
    
                        --calculate the hand effects
                        local effects = {G.hand.cards[i]:get_end_of_round_effect()}
                        G.hand.cards[i]:calculate_rental()
                        G.hand.cards[i]:calculate_perishable()
                                                for k=1, #G.jokers.cards do
                            --calculate the joker individual card effects
                            local eval = G.jokers.cards[k]:calculate_joker({cardarea = G.hand, other_card = G.hand.cards[i], individual = true, end_of_round = true})
                            if eval and eval.joker_repetitions then
                                rep_list = eval.joker_repetitions
                                for z=1, #rep_list do
                                    if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                                        for r=1, rep_list[z].repetitions do
                                            local ev = G.jokers.cards[k]:calculate_joker({cardarea = G.hand, other_card = G.hand.cards[i], individual = true, end_of_round = true, retrigger_joker = true})
                                            if ev then
                                                table.insert(effects, rep_list[z])
                                                table.insert(effects, ev)
                                            end
                                        end
                                    end
                                end
                            end
                                                        if eval then 
                                table.insert(effects, eval)
                            end
                        end

                        if reps[j] == 1 then 
                            --Check for hand doubling
                            --From Red seal
                            local eval = eval_card(G.hand.cards[i], {end_of_round = true,cardarea = G.hand, repetition = true, repetition_only = true})
                            if next(eval) and (next(effects[1]) or #effects > 1)  then 
                                for h = 1, eval.seals.repetitions do
                                    reps[#reps+1] = eval
                                end
                            end

                            --from Jokers
                            for j=1, #G.jokers.cards do
                                --calculate the joker effects
                                local eval = eval_card(G.jokers.cards[j], {cardarea = G.hand, other_card = G.hand.cards[i], repetition = true, end_of_round = true, card_effects = effects})
                                if eval and eval.jokers and eval.jokers.joker_repetitions then
                                    rep_list = eval.jokers.joker_repetitions
                                    for z=1, #rep_list do
                                        if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                                            for r=1, rep_list[z].repetitions do
                                                for s=1, eval.jokers.repetitions do
                                                    reps[#reps+1] = {from_retrigger = rep_list[z]}
                                                    for k, v in pairs(eval) do
                                                        reps[#reps][k] = v
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                                                                if next(eval) then 
                                    for h  = 1, eval.jokers.repetitions do
                                        reps[#reps+1] = eval
                                    end
                                end
                            end
                        end
        
                        for ii = 1, #effects do
                            --if this effect came from a joker
                            if effects[ii].card and not Talisman.config_file.disable_anims then
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'immediate',
                                    func = (function() effects[ii].card:juice_up(0.7);return true end)
                                }))
                            end
                            
                            --If dollars
                            if effects[ii].h_dollars then 
                                ease_dollars(effects[ii].h_dollars)
                                card_eval_status_text(G.hand.cards[i], 'dollars', effects[ii].h_dollars, percent)
                            end

                            --Any extras
                            if effects[ii].extra then
                                card_eval_status_text(G.hand.cards[i], 'extra', nil, percent, nil, effects[ii].extra)
                            end
                        end
                        j = j + 1
                    end
                end
                delay(0.3)


                local i = 1
                while i <= #G.hand.cards do
                    local gone = G.hand.cards[i]:calculate_banana()
                    if not gone then i = i + 1 end
                end
                for i = 1, #G.discard.cards do
                    G.discard.cards[i]:calculate_perishable()
                end
                for i = 1, #G.deck.cards do
                    G.deck.cards[i]:calculate_perishable()
                end
                                G.FUNCS.draw_from_hand_to_discard()
                if G.GAME.blind_on_deck == 'Boss' then
                    G.GAME.voucher_restock = nil
                    if G.GAME.modifiers.set_eternal_ante and (G.GAME.round_resets.ante == G.GAME.modifiers.set_eternal_ante) then 
                        for k, v in ipairs(G.jokers.cards) do
                            v:set_eternal(true)
                        end
                    end
                    if G.GAME.modifiers.set_joker_slots_ante and (G.GAME.round_resets.ante == G.GAME.modifiers.set_joker_slots_ante) then 
                        G.jokers.config.card_limit = 0
                    end
                    delay(0.4); ease_ante(G.GAME.blind and (G.GAME.blind.name == 'cry-Joke' or (G.GAME.blind.name == 'cry-Obsidian Orb' and G.GAME.defeated_blinds.bl_cry_joke)) and to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) * 2 and 8-G.GAME.round_resets.ante%8 or 1); cry_apply_ante_tax(); delay(0.4); check_for_unlock({type = 'ante_up', ante = G.GAME.round_resets.ante + 1})
                end
                G.FUNCS.draw_from_discard_to_deck()
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        G.STATE = G.STATES.ROUND_EVAL
                        G.STATE_COMPLETE = false

                        if G.GAME.blind_on_deck == 'Small' then
                            G.GAME.round_resets.blind_states.Small = 'Defeated'
                        elseif G.GAME.blind_on_deck == 'Big' then
                            G.GAME.round_resets.blind_states.Big = 'Defeated'
                        else
                            if not G.GAME.modifiers.cry_no_vouchers then
                                if not G.GAME.modifiers.cry_voucher_restock_antes or G.GAME.round_resets.ante % G.GAME.modifiers.cry_voucher_restock_antes == 0 then
                                    G.GAME.current_round.voucher = get_next_voucher_key()
                                end
                            else
                                very_fair_quip = pseudorandom_element(very_fair_quips, pseudoseed("cry_very_fair"))
                            end
                                                        G.GAME.round_resets.blind_states.Boss = 'Defeated'
                            for k, v in ipairs(G.playing_cards) do
                                v.ability.played_this_ante = nil
                            end
                        end

                        if G.GAME.round_resets.temp_handsize then G.hand:change_size(-G.GAME.round_resets.temp_handsize); G.GAME.round_resets.temp_handsize = nil end
                        if G.GAME.round_resets.temp_reroll_cost then G.GAME.round_resets.temp_reroll_cost = nil; calculate_reroll_cost(true) end

                        reset_idol_card()
                        reset_mail_rank()
                        reset_ancient_card()
                        reset_castle_card()                        for _, mod in ipairs(SMODS.mod_list) do
                        	if mod.reset_game_globals and type(mod.reset_game_globals) == 'function' then
                        		mod.reset_game_globals(false)
                        	end
                        end
                        for k, v in ipairs(G.playing_cards) do
                            v.ability.discarded = nil
                            v.ability.forced_selection = nil
                        end
                    return true
                    end
                }))
            end
        return true
      end
    }))
  end
  
function new_round()
    G.RESET_JIGGLES = nil
    delay(0.4)
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = function()
            G.GAME.current_round.discards_left = math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards)
            G.GAME.current_round.hands_left = (math.max(1, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands))
            G.GAME.current_round.hands_played = 0
            G.GAME.current_round.discards_used = 0
            G.GAME.current_round.reroll_cost_increase = 0
            G.GAME.current_round.used_packs = {}

            for k, v in pairs(G.GAME.hands) do 
                v.played_this_round = 0
            end

            for k, v in pairs(G.playing_cards) do
                v.ability.wheel_flipped = nil
            end

            local chaos = find_joker('Chaos the Clown')
            G.GAME.current_round.free_rerolls = #chaos
            calculate_reroll_cost(true)

            G.GAME.round_bonus.next_hands = 0
            G.GAME.round_bonus.discards = 0

            local blhash = ''
            if G.GAME.blind_on_deck == 'Small' then
                G.GAME.round_resets.blind_states.Small = 'Current'
                G.GAME.current_boss_streak = 0
                blhash = 'S'
            elseif G.GAME.blind_on_deck == 'Big' then
                G.GAME.round_resets.blind_states.Big = 'Current'
                G.GAME.current_boss_streak = 0
                blhash = 'B'
            else
                G.GAME.round_resets.blind_states.Boss = 'Current'
                blhash = 'L'
            end
            G.GAME.subhash = (G.GAME.round_resets.ante)..(blhash)

            G.GAME.blind:set_blind(G.GAME.round_resets.blind)
            if G.GAME.modifiers.cry_card_each_round then
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local front = pseudorandom_element(G.P_CARDS, pseudoseed('cry_horizon'))
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local edition = G.P_CENTERS.c_base
                        local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.c_base, {playing_card = G.playing_card})
                        card:start_materialize()
                        if G.GAME.selected_back.effect.config.cry_force_edition and G.GAME.selected_back.effect.config.cry_force_edition ~= "random" then
                            local edition = {}
                            edition[G.GAME.selected_back.effect.config.cry_force_edition] = true
                            card:set_edition(edition, true, true);
                        end
                        G.play:emplace(card)
                        table.insert(G.playing_cards, card)
                        return true
                    end}))
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        return true
                    end}))
                draw_card(G.play,G.deck, 90,'up', nil) 
            end
            if G.GAME.modifiers.cry_conveyor and #G.jokers.cards>0 then
                local duplicated_joker = copy_card(G.jokers.cards[#G.jokers.cards])
                duplicated_joker:add_to_deck()
                G.jokers:emplace(duplicated_joker)
                G.jokers.cards[1]:start_dissolve()
            end
                        G.GAME.current_round.semicolon = false
                        
            for i = 1, #G.jokers.cards do
                local effects = G.jokers.cards[i]:calculate_joker({setting_blind = true, blind = G.GAME.round_resets.blind})
                if effects and effects.joker_repetitions then
                    rep_list = effects.joker_repetitions
                    for z=1, #rep_list do
                        if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                            for r=1, rep_list[z].repetitions do
                                card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                                if percent then percent = percent+percent_delta end
                                G.jokers.cards[i]:calculate_joker({setting_blind = true, blind = G.GAME.round_resets.blind, retrigger_joker = true})
                            end
                        end
                    end
                end
                            end
            delay(0.4)

            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE = G.STATES.DRAW_TO_HAND
                    G.deck:shuffle('nr'..G.GAME.round_resets.ante)
                    G.deck:hard_set_T()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
            return true
            end
        }))
end

G.FUNCS.draw_from_deck_to_hand = function(e)
    if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
        G.hand.config.card_limit <= 0 and #G.hand.cards == 0 then 
        G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false 
        return true
    end

    local hand_space = e
    if not hand_space then
        local limit = G.hand.config.card_limit - #G.hand.cards
        local n = 0
        while n < #G.deck.cards do
            local card = G.deck.cards[#G.deck.cards-n]
            limit = limit - 1 + (card.edition and card.edition.card_limit or 0)
            if limit < 0 then break end
            n = n + 1
        end
        hand_space = n
    end
    if G.GAME.blind.name == 'The Serpent' and
        not G.GAME.blind.disabled and
        (G.GAME.current_round.hands_played > 0 or
        G.GAME.current_round.discards_used > 0) then
            hand_space = math.min(#G.deck.cards, 3)
    end
    delay(0.3)
    for i=1, hand_space do --draw cards from deckL
        if G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK then 
            draw_card(G.deck,G.hand, i*100/hand_space,'up', true)
        else
            draw_card(G.deck,G.hand, i*100/hand_space,'up', true)
        end
    end
end

G.FUNCS.discard_cards_from_highlighted = function(e, hook)
    stop_use()
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('hand')

    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end

    if G.CONTROLLER.focused.target and G.CONTROLLER.focused.target.area == G.hand then G.card_area_focus_reset = {area = G.hand, rank = G.CONTROLLER.focused.target.rank} end
    local highlighted_count = math.min(#G.hand.highlighted, G.discard.config.card_limit - #G.play.cards)
    if highlighted_count > 0 then 
        update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
        table.sort(G.hand.highlighted, function(a,b) return a.T.x < b.T.x end)
        inc_career_stat('c_cards_discarded', highlighted_count)
        for i = 1, #G.hand.cards do
            eval_card(G.hand.cards[i], {pre_discard = true, full_hand = G.hand.highlighted, hook = hook})
        end
        for j = 1, #G.jokers.cards do
            local effects = G.jokers.cards[j]:calculate_joker({pre_discard = true, full_hand = G.hand.highlighted, hook = hook})
            if effects and effects.joker_repetitions then
                rep_list = effects.joker_repetitions
                for z=1, #rep_list do
                    if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                        for r=1, rep_list[z].repetitions do
                            card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                            if percent then percent = percent+percent_delta end
                            G.jokers.cards[j]:calculate_joker({pre_discard = true, full_hand = G.hand.highlighted, hook = hook, retrigger_joker = true})
                        end
                    end
                end
            end
                    end
        local cards = {}
        local destroyed_cards = {}
        for i=1, highlighted_count do
            local removed = false
            local eval = nil
            eval = eval_card(G.hand.highlighted[i], {discard = true, full_hand = G.hand.highlighted})
            if eval and eval.remove then
                removed = true
                card_eval_status_text(G.hand.highlighted[i], 'jokers', nil, 1, nil, eval)
            end
            for j = 1, #G.jokers.cards do
                local eval = nil
                eval = G.jokers.cards[j]:calculate_joker({discard = true, other_card =  G.hand.highlighted[i], full_hand = G.hand.highlighted})
                if eval and eval.joker_repetitions then
                    rep_list = eval.joker_repetitions
                    for z=1, #rep_list do
                        if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                            for r=1, rep_list[z].repetitions do
                                card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                                if percent then percent = percent+percent_delta end
                                local ev = G.jokers.cards[j]:calculate_joker({discard = true, other_card =  G.hand.highlighted[i], full_hand = G.hand.highlighted, retrigger_joker = true})
                                if ev then
                                    if ev.remove then removed = true end
                                    card_eval_status_text(G.jokers.cards[j], 'jokers', nil, 1, nil, ev)
                                end
                            end
                        end
                    end
                end
                                if eval then
                    if eval.remove then removed = true end
                    card_eval_status_text(G.jokers.cards[j], 'jokers', nil, 1, nil, eval)
                end
            end
            table.insert(cards, G.hand.highlighted[i])
            if removed then
                destroyed_cards[#destroyed_cards + 1] = G.hand.highlighted[i]
                if G.hand.highlighted[i].ability.name == 'Glass Card' then 
                    G.hand.highlighted[i]:shatter()
                else
                    G.hand.highlighted[i]:start_dissolve()
                end
            else 
                G.hand.highlighted[i].ability.discarded = true
                draw_card(G.hand, G.discard, i*100/highlighted_count, 'down', false, G.hand.highlighted[i])
            end
        end

        if destroyed_cards[1] then 
            for j=1, #G.jokers.cards do
                local eval = eval_card(G.jokers.cards[j], {cardarea = G.jokers, remove_playing_cards = true, removed = destroyed_cards})
                if eval and eval.jokers and eval.jokers.joker_repetitions then
                    rep_list = eval.jokers.joker_repetitions
                    for z=1, #rep_list do
                        if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                            for r=1, rep_list[z].repetitions do
                                card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                                if percent then percent = percent+percent_delta end
                                eval_card(G.jokers.cards[j], {cardarea = G.jokers, remove_playing_cards = true, removed = destroyed_cards, retrigger_joker = true})
                            end
                        end
                    end
                end
                            end
        end

        G.GAME.round_scores.cards_discarded.amt = G.GAME.round_scores.cards_discarded.amt + #cards
        check_for_unlock({type = 'discard_custom', cards = cards})
        if not hook then
            if G.GAME.modifiers.discard_cost then
                ease_dollars(-G.GAME.modifiers.discard_cost)
            end
            ease_discard(-1)
            G.GAME.current_round.discards_used = G.GAME.current_round.discards_used + 1
            G.STATE = G.STATES.DRAW_TO_HAND
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
        end
    end
end
  
G.FUNCS.play_cards_from_highlighted = function(e)
    if G.play and G.play.cards[1] then return end
    --check the hand first

    stop_use()
    G.GAME.blind.triggered = false
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('hand')

    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end
    
    table.sort(G.hand.highlighted, function(a,b) return a.T.x < b.T.x end)

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.STATE = G.STATES.HAND_PLAYED
            G.STATE_COMPLETE = true
            return true
        end
    }))
    inc_career_stat('c_cards_played', #G.hand.highlighted)
    inc_career_stat('c_hands_played', 1)
    ease_hands_played(-1)
    delay(0.4)

        for i=1, #G.hand.highlighted do
            if G.hand.highlighted[i]:is_face() then inc_career_stat('c_face_cards_played', 1) end
            G.hand.highlighted[i].base.times_played = G.hand.highlighted[i].base.times_played + 1
            G.hand.highlighted[i].ability.played_this_ante = true
            G.GAME.round_scores.cards_played.amt = G.GAME.round_scores.cards_played.amt + 1
            draw_card(G.hand, G.play, i*100/#G.hand.highlighted, 'up', nil, G.hand.highlighted[i])
        end

        check_for_unlock({type = 'run_card_replays'})

        if G.GAME.blind:press_play() then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = (function()
                    SMODS.juice_up_blind()
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    return true
                end)
            }))
            delay(0.4)
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                check_for_unlock({type = 'hand_contents', cards = G.play.cards})

                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.FUNCS.evaluate_play()
                        return true
                    end
                }))

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        check_for_unlock({type = 'play_all_hearts'})
                        G.FUNCS.draw_from_play_to_discard()
                        G.GAME.hands_played = G.GAME.hands_played + 1
                        G.GAME.current_round.hands_played = G.GAME.current_round.hands_played + 1
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.STATE_COMPLETE = false
                        return true
                    end
                }))
                return true
            end)
        }))
end

G.FUNCS.get_poker_hand_info = function(_cards)
    local poker_hands = evaluate_poker_hand(_cards)
    local scoring_hand = {}
    local text,disp_text,loc_disp_text = 'NULL','NULL', 'NULL'
    if next(poker_hands["Flush Five"]) then text = "Flush Five"; scoring_hand = poker_hands["Flush Five"][1]
    elseif next(poker_hands["Flush House"]) then text = "Flush House"; scoring_hand = poker_hands["Flush House"][1]
    elseif next(poker_hands["Five of a Kind"]) then text = "Five of a Kind"; scoring_hand = poker_hands["Five of a Kind"][1]
    elseif next(poker_hands["Straight Flush"]) then text = "Straight Flush"; scoring_hand = poker_hands["Straight Flush"][1]
    elseif next(poker_hands["Four of a Kind"]) then text = "Four of a Kind"; scoring_hand = poker_hands["Four of a Kind"][1]
    elseif next(poker_hands["Full House"]) then text = "Full House"; scoring_hand = poker_hands["Full House"][1]
    elseif next(poker_hands["Flush"]) then text = "Flush"; scoring_hand = poker_hands["Flush"][1]
    elseif next(poker_hands["Straight"]) then text = "Straight"; scoring_hand = poker_hands["Straight"][1]
    elseif next(poker_hands["Three of a Kind"]) then text = "Three of a Kind"; scoring_hand = poker_hands["Three of a Kind"][1]
    elseif next(poker_hands["Two Pair"]) then text = "Two Pair"; scoring_hand = poker_hands["Two Pair"][1]
    elseif next(poker_hands["Pair"]) then text = "Pair"; scoring_hand = poker_hands["Pair"][1]
    elseif next(poker_hands["High Card"]) then text = "High Card"; scoring_hand = poker_hands["High Card"][1] end

    disp_text = text
    if text =='Straight Flush' then
        local min = 10
        for j = 1, #scoring_hand do
            if scoring_hand[j]:get_id() < min then min =scoring_hand[j]:get_id() end
        end
        if min >= 10 then 
            disp_text = 'Royal Flush'
        end
    end
    loc_disp_text = localize(disp_text, 'poker_hands')
    return text, loc_disp_text, poker_hands, scoring_hand, disp_text
end
  
G.FUNCS.evaluate_play = function(e)
    local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
    
    G.GAME.hands[text].played = G.GAME.hands[text].played + 1
    G.GAME.hands[text].played_this_round = G.GAME.hands[text].played_this_round + 1
    G.GAME.last_hand_played = text
    set_hand_usage(text)
    G.GAME.hands[text].visible = true

    --Add all the pure bonus cards to the scoring hand
    local pures = {}
    for i=1, #G.play.cards do
        if next(find_joker('Splash')) then
            scoring_hand[i] = G.play.cards[i]
        else
            if G.play.cards[i].ability.effect == 'Stone Card' or G.play.cards[i].config.center.always_scores then
                local inside = false
                for j=1, #scoring_hand do
                    if scoring_hand[j] == G.play.cards[i] then
                        inside = true
                    end
                end
                if not inside then table.insert(pures, G.play.cards[i]) end
            end
        end
    end
    for i=1, #pures do
        table.insert(scoring_hand, pures[i])
    end
    table.sort(scoring_hand, function (a, b) return a.T.x < b.T.x end )
    delay(0.2)
    for i=1, #scoring_hand do
        --Highlight all the cards used in scoring and play a sound indicating highlight
        highlight_card(scoring_hand[i],(i-0.999)/5,'up')
    end

    local percent = 0.3
    local percent_delta = 0.08

    if G.GAME.current_round.current_hand.handname ~= disp_text then delay(0.3) end
    update_hand_text({sound = G.GAME.current_round.current_hand.handname ~= disp_text and 'button' or nil, volume = 0.4, immediate = true, nopulse = nil,
                delay = G.GAME.current_round.current_hand.handname ~= disp_text and 0.4 or 0}, {handname=disp_text, level=G.GAME.hands[text].level, mult = G.GAME.hands[text].mult, chips = G.GAME.hands[text].chips})

    if not G.GAME.blind:debuff_hand(G.play.cards, poker_hands, text) then
        mult = mod_mult(G.GAME.hands[text].mult)
        hand_chips = mod_chips(G.GAME.hands[text].chips)

        check_for_unlock({type = 'hand', handname = text, disp_text = non_loc_disp_text, scoring_hand = scoring_hand, full_hand = G.play.cards})

        delay(0.4)

        if G.GAME.first_used_hand_level and G.GAME.first_used_hand_level > 0 then
            level_up_hand(G.deck.cards[1], text, nil, G.GAME.first_used_hand_level)
            G.GAME.first_used_hand_level = nil
        end

        local hand_text_set = false
        for i=1, #G.jokers.cards do
            --calculate the joker effects
            local effects = eval_card(G.jokers.cards[i], {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, before = true})
            if effects and effects.jokers and effects.jokers.joker_repetitions then
                rep_list = effects.jokers.joker_repetitions
                for z=1, #rep_list do
                    if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                        for r=1, rep_list[z].repetitions do
                            card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                            if percent then percent = percent+percent_delta end
                            local ef = eval_card(G.jokers.cards[i], {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, before = true, retrigger_joker = true})
                            if ef.jokers then
                                card_eval_status_text(G.jokers.cards[i], 'jokers', nil, percent, nil, effects.jokers)
                                if percent then percent = percent + percent_delta end
                                if ef.jokers.level_up then
                                    level_up_hand(G.jokers.cards[i], text)
                                end
                            end
                        end
                    end
                end
            end
                        if effects.jokers then
                card_eval_status_text(G.jokers.cards[i], 'jokers', nil, percent, nil, effects.jokers)
                percent = percent + percent_delta
                if effects.jokers.level_up then
                    level_up_hand(G.jokers.cards[i], text)
                end
            end
        end

        mult = mod_mult(G.GAME.hands[text].mult)
        hand_chips = mod_chips(G.GAME.hands[text].chips)

        local modded = false

        mult, hand_chips, modded = G.GAME.blind:modify_hand(G.play.cards, poker_hands, text, mult, hand_chips)
        mult, hand_chips = mod_mult(mult), mod_chips(hand_chips)
        if modded then update_hand_text({sound = 'chips2', modded = modded}, {chips = hand_chips, mult = mult}) end
        for i=1, #scoring_hand do
            --add cards played to list
            if scoring_hand[i].ability.effect ~= 'Stone Card' and not scoring_hand[i].config.center.no_rank then
                G.GAME.cards_played[scoring_hand[i].base.value].total = G.GAME.cards_played[scoring_hand[i].base.value].total + 1
                if not scoring_hand[i].config.center.no_suit then
                    G.GAME.cards_played[scoring_hand[i].base.value].suits[scoring_hand[i].base.suit] = true
                end
            end
            --if card is debuffed
            if scoring_hand[i].debuff then
                
                if scoring_hand[i].debuffed_by_blind then
                    G.GAME.blind.triggered = true
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = (function() SMODS.juice_up_blind();return true end)
                }))
                card_eval_status_text(scoring_hand[i], 'debuff')
            else
                --Check for play doubling
                local reps = {1}
                
                --From Red seal
                local eval = eval_card(scoring_hand[i], {repetition_only = true,cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, repetition = true})
                if next(eval) then 
                    for h = 1, eval.seals.repetitions do
                        reps[#reps+1] = eval
                    end
                end
                --From jokers
                for j=1, #G.jokers.cards do
                    --calculate the joker effects
                    local eval = eval_card(G.jokers.cards[j], {cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = scoring_hand[i], repetition = true})
                    if eval and eval.jokers and eval.jokers.repetitions and eval.jokers.joker_repetitions then
                        rep_list = eval.jokers.joker_repetitions
                        for z=1, #rep_list do
                            if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                                for r=1, rep_list[z].repetitions do
                                    for s=1, eval.jokers.repetitions do
                                        reps[#reps+1] = {from_retrigger = rep_list[z]}
                                        for k, v in pairs(eval) do
                                            reps[#reps][k] = v
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if eval and eval.jokers and not eval.jokers.repetitions then eval.jokers = nil end
                                        if next(eval) and eval.jokers then 
                        for h = 1, eval.jokers.repetitions do
                            reps[#reps+1] = eval
                        end
                    end
                end
                for j=1,#reps do
                    percent = percent + percent_delta
                    if reps[j] ~= 1 then
                        card_eval_status_text((reps[j].jokers or reps[j].seals).card, 'jokers', nil, nil, nil, (reps[j].jokers or reps[j].seals))
                        if reps[j].from_retrigger then
                            card_eval_status_text(reps[j].from_retrigger.card, 'jokers', nil, nil, nil, reps[j].from_retrigger)
                        end
                                            end
                    
                    --calculate the hand effects
                    local effects = {eval_card(scoring_hand[i], {cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, poker_hand = text})}
                    for k=1, #G.jokers.cards do
                        --calculate the joker individual card effects
                        local eval = G.jokers.cards[k]:calculate_joker({cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = scoring_hand[i], individual = true})
                        if eval and eval.joker_repetitions then
                            rep_list = eval.joker_repetitions
                            for z=1, #rep_list do
                                if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                                    for r=1, rep_list[z].repetitions do
                                        local ev = G.jokers.cards[k]:calculate_joker({cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = scoring_hand[i], individual = true, retrigger_joker = true})
                                        if ev then
                                            mod_percent = true
                                            table.insert(effects, ev)
                                            effects[#effects].from_retrigger = rep_list[z]
                                        end
                                    end
                                end
                            end
                        end
                                                if eval then 
                            table.insert(effects, eval)
                        end
                    end
                    scoring_hand[i].lucky_trigger = nil

                    for ii = 1, #effects do
                        --If chips added, do chip add event and add the chips to the total
                        if effects[ii].chips then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            hand_chips = mod_chips(hand_chips + effects[ii].chips)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                            card_eval_status_text(scoring_hand[i], 'chips', effects[ii].chips, percent)
                        end

                        --If mult added, do mult add event and add the mult to the total
                        if effects[ii].mult then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            mult = mod_mult(mult + effects[ii].mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'mult', effects[ii].mult, percent)
                        end

                        --If play dollars added, add dollars to total
                        if effects[ii].p_dollars then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            ease_dollars(effects[ii].p_dollars)
                            card_eval_status_text(scoring_hand[i], 'dollars', effects[ii].p_dollars, percent)
                        end

                        --If dollars added, add dollars to total
                        if effects[ii].dollars then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            ease_dollars(effects[ii].dollars)
                            card_eval_status_text(scoring_hand[i], 'dollars', effects[ii].dollars, percent)
                        end

                        --Any extra effects
                        if effects[ii].extra then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            local extras = {mult = false, hand_chips = false}
                            if effects[ii].extra.mult_mod then mult =mod_mult( mult + effects[ii].extra.mult_mod);extras.mult = true end
                            if effects[ii].extra.chip_mod then hand_chips = mod_chips(hand_chips + effects[ii].extra.chip_mod);extras.hand_chips = true end
                            if effects[ii].extra.swap then 
                                local old_mult = mult
                                mult = mod_mult(hand_chips)
                                hand_chips = mod_chips(old_mult)
                                extras.hand_chips = true; extras.mult = true
                            end
                            if effects[ii].extra.func then effects[ii].extra.func() end
                            update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil, effects[ii].extra)
                        end

                        if effects[ii].seals then
                            if effects[ii].seals.chips then 
                                if effects[ii].card then juice_card(effects[ii].card) end
                                hand_chips = mod_chips(hand_chips + effects[ii].seals.chips)
                                update_hand_text({delay = 0}, {chips = hand_chips})
                                card_eval_status_text(scoring_hand[i], 'chips', effects[ii].seals.chips, percent)
                            end
                            
                            if effects[ii].seals.mult then 
                                if effects[ii].card then juice_card(effects[ii].card) end
                                mult = mod_mult(mult + effects[ii].seals.mult)
                                update_hand_text({delay = 0}, {mult = mult})
                                card_eval_status_text(scoring_hand[i], 'mult', effects[ii].seals.mult, percent)
                            end
                            
                            if effects[ii].seals.p_dollars then 
                                if effects[ii].card then juice_card(effects[ii].card) end
                                ease_dollars(effects[ii].seals.p_dollars)
                                card_eval_status_text(scoring_hand[i], 'dollars', effects[ii].seals.p_dollars, percent)
                            end
                            
                            if effects[ii].seals.dollars then 
                                if effects[ii].card then juice_card(effects[ii].card) end
                                ease_dollars(effects[ii].seals.dollars)
                                card_eval_status_text(scoring_hand[i], 'dollars', effects[ii].seals.dollars, percent)
                            end
                            
                            if effects[ii].seals.x_mult then 
                                if effects[ii].card then juice_card(effects[ii].card) end
                                mult = mod_mult(mult*effects[ii].seals.x_mult)
                                update_hand_text({delay = 0}, {mult = mult})
                                card_eval_status_text(scoring_hand[i], 'x_mult', effects[ii].seals.x_mult, percent)
                            end
                        end
                        
                                                --If x_mult added, do mult add event and mult the mult to the total
                        if effects[ii].x_mult then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            mult = mod_mult(mult*effects[ii].x_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'x_mult', effects[ii].x_mult, percent)
                            if next(find_joker("cry-Exponentia")) then
                                for _, v in pairs(find_joker("cry-Exponentia")) do
                                    v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                                    card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                                end
                            end
                                                    end

                        if effects[ii].x_chips then
                        	mod_percent = true
                        	if effects[ii].card then juice_card(effects[ii].card) end
                        	chips = mod_chips(mult*effects[ii].x_chips)
                        	update_hand_text({delay = 0}, {chips = chips})
                        	card_eval_status_text(scoring_hand[i], 'x_chips', effects[ii].x_chips, percent)
                        end
                        
                        if effects[ii].pow_mult then
                        	if effects[ii].card then juice_card(effects[ii].card) end
                        	mult = mod_mult(mult^effects[ii].pow_mult)
                        	update_hand_text({delay = 0}, {mult = mult})
                        	card_eval_status_text(scoring_hand[i], 'pow_mult', effects[ii].pow_mult, percent)
                        end
                        
                                                if effects[ii].from_retrigger then
                                                    card_eval_status_text(effects[ii].from_retrigger.card, 'jokers', nil, nil, nil, effects[ii].from_retrigger)
                                                end
                                                                                                if effects[ii].x_chips then
                                                                                                	mod_percent = true
                                                                                                	if effects[ii].card then juice_card(effects[ii].card) end
                                                                                                	chips = mod_chips(mult*effects[ii].x_chips)
                                                                                                	update_hand_text({delay = 0}, {chips = chips})
                                                                                                	card_eval_status_text(scoring_hand[i], 'x_chips', effects[ii].x_chips, percent)
                                                                                                end
                                                                                                if effects[ii].e_chips then
                                                                                                	mod_percent = true
                                                                                                	if effects[ii].card then juice_card(effects[ii].card) end
                                                                                                	chips = mod_chips(chips^effects[ii].e_chips)
                                                                                                	update_hand_text({delay = 0}, {chips = chips})
                                                                                                	card_eval_status_text(scoring_hand[i], 'e_chips', effects[ii].e_chips, percent)
                                                                                                end
                                                                                                if effects[ii].ee_chips then
                                                                                                	mod_percent = true
                                                                                                	if effects[ii].card then juice_card(effects[ii].card) end
                                                                                                	chips = mod_chips(chips:arrow(2, effects[ii].ee_chips))
                                                                                                	update_hand_text({delay = 0}, {chips = chips})
                                                                                                	card_eval_status_text(scoring_hand[i], 'ee_chips', effects[ii].ee_chips, percent)
                                                                                                end
                                                                                                if effects[ii].eee_chips then
                                                                                                	mod_percent = true
                                                                                                	if effects[ii].card then juice_card(effects[ii].card) end
                                                                                                	chips = mod_chips(chips:arrow(3, effects[ii].eee_chips))
                                                                                                	update_hand_text({delay = 0}, {chips = chips})
                                                                                                	card_eval_status_text(scoring_hand[i], 'eee_chips', effects[ii].eee_chips, percent)
                                                                                                end
                                                                                                if effects[ii].hyper_chips and type(effects[ii].hyper_chips) == 'table' then
                                                                                                	mod_percent = true
                                                                                                	if effects[ii].card then juice_card(effects[ii].card) end
                                                                                                	chips = mod_chips(chips:arrow(effects[ii].hyper_chips[1], effects[ii].hyper_chips[2]))
                                                                                                	update_hand_text({delay = 0}, {chips = chips})
                                                                                                	card_eval_status_text(scoring_hand[i], 'hyper_chips', effects[ii].hyper_chips, percent)
                                                                                                end
                                                                                                if effects[ii].e_mult then
                                                                                                	mod_percent = true
                                                                                                	if effects[ii].card then juice_card(effects[ii].card) end
                                                                                                	mult = mod_mult(mult^effects[ii].e_mult)
                                                                                                	update_hand_text({delay = 0}, {mult = mult})
                                                                                                	card_eval_status_text(scoring_hand[i], 'e_mult', effects[ii].e_mult, percent)
                                                                                                end
                                                                                                if effects[ii].ee_mult then
                                                                                                	mod_percent = true
                                                                                                	if effects[ii].card then juice_card(effects[ii].card) end
                                                                                                	mult = mod_mult(mult:arrow(2, effects[ii].ee_mult))
                                                                                                	update_hand_text({delay = 0}, {mult = mult})
                                                                                                	card_eval_status_text(scoring_hand[i], 'ee_mult', effects[ii].ee_mult, percent)
                                                                                                end
                                                                                                if effects[ii].eee_mult then
                                                                                                	mod_percent = true
                                                                                                	if effects[ii].card then juice_card(effects[ii].card) end
                                                                                                	mult = mod_mult(mult:arrow(3, effects[ii].eee_mult))
                                                                                                	update_hand_text({delay = 0}, {mult = mult})
                                                                                                	card_eval_status_text(scoring_hand[i], 'eee_mult', effects[ii].eee_mult, percent)
                                                                                                end
                                                                                                if effects[ii].hyper_mult and type(effects[ii].hyper_mult) == 'table' then
                                                                                                	mod_percent = true
                                                                                                	if effects[ii].card then juice_card(effects[ii].card) end
                                                                                                	mult = mod_mult(mult:arrow(effects[ii].hyper_mult[1], effects[ii].hyper_mult[2]))
                                                                                                	update_hand_text({delay = 0}, {mult = mult})
                                                                                                	card_eval_status_text(scoring_hand[i], 'hyper_mult', effects[ii].hyper_mult, percent)
                                                                                                end
                                                                                                
                                                                                                                                                                                                --calculate the card edition effects
                        if effects[ii].edition then
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition then
                        	local trg = scoring_hand[i]
                        	local edi = trg.edition
                        	if edi.x_chips then
                        		hand_chips = mod_chips(hand_chips * edi.x_chips)
                        		update_hand_text({delay = 0}, {chips = hand_chips})
                        		card_eval_status_text(trg, 'extra', nil, percent, nil,
                        		{message = 'X'.. edi.x_chips ..' Chips',
                        		edition = true,
                        		x_chips = true})
                        	end
                        	if edi.e_chips then
                        		hand_chips = mod_chips(hand_chips ^ edi.e_chips)
                        		update_hand_text({delay = 0}, {chips = hand_chips})
                        		card_eval_status_text(trg, 'extra', nil, percent, nil,
                        		{message = '^'.. edi.e_chips ..' Chips',
                        		edition = true,
                        		e_chips = true})
                        	end
                        	if edi.ee_chips then
                        		hand_chips = mod_chips(hand_chips:arrow(2, edi.ee_chips))
                        		update_hand_text({delay = 0}, {chips = hand_chips})
                        		card_eval_status_text(trg, 'extra', nil, percent, nil,
                        		{message = '^^'.. edi.ee_chips ..' Chips',
                        		edition = true,
                        		ee_chips = true})
                        	end
                        	if edi.eee_chips then
                        		hand_chips = mod_chips(hand_chips:arrow(3, edi.eee_chips))
                        		update_hand_text({delay = 0}, {chips = hand_chips})
                        		card_eval_status_text(trg, 'extra', nil, percent, nil,
                        		{message = '^^^'.. edi.eee_chips ..' Chips',
                        		edition = true,
                        		eee_chips = true})
                        	end
                        	if edi.hyper_chips and type(edi.hyper_chips) == 'table' then
                        		hand_chips = mod_chips(hand_chips:arrow(edi.hyper_chips[1], edi.hyper_chips[2]))
                        		update_hand_text({delay = 0}, {chips = hand_chips})
                        		card_eval_status_text(trg, 'extra', nil, percent, nil,
                        		{message = (edi.hyper_chips[1] > 5 and ('{' .. edi.hyper_chips[1] .. '}') or string.rep('^', edi.hyper_chips[1])) .. edi.hyper_chips[2] ..' Chips',
                        		edition = true,
                        		eee_chips = true})
                        	end
                        	if edi.e_mult then
                        		mult = mod_mult(mult ^ edi.e_mult)
                        		update_hand_text({delay = 0}, {mult = mult})
                        		card_eval_status_text(trg, 'extra', nil, percent, nil,
                        		{message = '^'.. edi.e_mult ..' Mult',
                        		edition = true,
                        		e_mult = true})
                        	end
                        	if edi.ee_mult then
                        		mult = mod_mult(mult:arrow(2, edi.ee_mult))
                        		update_hand_text({delay = 0}, {mult = mult})
                        		card_eval_status_text(trg, 'extra', nil, percent, nil,
                        		{message = '^^'.. edi.ee_mult ..' Mult',
                        		edition = true,
                        		ee_mult = true})
                        	end
                        	if edi.eee_mult then
                        		mult = mod_mult(mult:arrow(3, edi.eee_mult))
                        		update_hand_text({delay = 0}, {mult = mult})
                        		card_eval_status_text(trg, 'extra', nil, percent, nil,
                        		{message = '^^^'.. edi.eee_mult ..' Mult',
                        		edition = true,
                        		eee_mult = true})
                        	end
                        	if edi.hyper_mult and type(edi.hyper_mult) == 'table' then
                        		mult = mod_mult(mult:arrow(edi.hyper_mult[1], edi.hyper_mult[2]))
                        		update_hand_text({delay = 0}, {mult = mult})
                        		card_eval_status_text(trg, 'extra', nil, percent, nil,
                        		{message = (edi.hyper_mult[1] > 5 and ('{' .. edi.hyper_mult[1] .. '}') or string.rep('^', edi.hyper_mult[1])) .. edi.hyper_mult[2] ..' Mult',
                        		edition = true,
                        		hyper_mult = true})
                        	end
                        end
                                                if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_astral then
                            local pow_mult = G.P_CENTERS.e_cry_astral.config.pow_mult
                            mult = mod_mult(mult ^ pow_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = '^'..pow_mult..' Mult',
                            edition = true,
                            pow_mult = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_hyperatral then
                            local pow_mult = G.P_CENTERS.e_cry_hyperastral.config.pow_mult
                            mult = mod_mult(mult ^ pow_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = '^'..pow_mult..' Mult',
                            edition = true,
                            pow_mult = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_cosmic then
                            local pow_mult = G.P_CENTERS.e_cry_cosmic.config.pow_mult
                            mult = mod_mult(mult ^ pow_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = '^'..pow_mult..' Mult',
                            edition = true,
                            pow_mult = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_hypercosmic then
                            local pow_mult = G.P_CENTERS.e_cry_hypercosmic.config.pow_mult
                            mult = mod_mult(mult ^ pow_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = '^'..pow_mult..' Mult',
                            edition = true,
                            pow_mult = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_darkmatter then
                            local pow_mult = G.P_CENTERS.e_cry_darkmatter.config.pow_mult
                            mult = mod_mult(mult ^ pow_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = '^'..pow_mult..' Mult',
                            edition = true,
                            pow_mult = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_darkvoid then
                            local pow_mult = G.P_CENTERS.e_cry_darkvoid.config.pow_mult
                            mult = mod_mult(mult ^ pow_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = '^'..pow_mult..' Mult',
                            edition = true,
                            pow_mult = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_darkvoid_balavirus then
                            local pow_mult = G.P_CENTERS.e_cry_darkvoid_balavirus.config.pow_mult
                            mult = mod_mult(mult ^ pow_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = '^'..pow_mult..' Mult',
                            edition = true,
                            pow_mult = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_bailiff then
                            local pow_mult = G.P_CENTERS.e_cry_bailiff.config.Xmult
                            mult = mod_mult(mult ^ 0)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = 'X'..pow_mult..' Mult',
                            edition = true,
                            pow_mult = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_duplicated then
                            local xscore = G.P_CENTERS.e_cry_duplicated.config.Xscore
                            mult = mod_mult(mult * 2)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = 'X'..xscore..' Mult',
                            edition = true,
                            Xscore = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_chromaticimpulsion then
                            mult = mod_mult(mult ^ 1.5)
                            update_hand_text({delay = 0}, {mult = mult})
                            G.GAME.dollars = G.GAME.dollars ^ 1.5
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_root then
                            mult = mod_mult(mult ^ 0.5)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_galvanized then
                            mult = mod_mult(mult * 3)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_hardstone then
                            mult = mod_mult(100)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_bedrock then
                            mult = mod_mult(1000)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_rainbow then
                            mult = mod_mult(mult * 15)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_hyperchrome then
                            mult = mod_mult(mult * 512)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_shadowing then
                            mult = mod_mult(mult ^ 0.5)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_graymatter then
                            mult = mod_mult(mult ^ 0.75)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_titanium then
                            mult = mod_mult(mult + 20)
                            update_hand_text({delay = 0}, {mult = mult})
                            G.GAME.dollars = G.GAME.dollars + 15
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_brilliant then
                            mult = mod_mult(mult * 2)
                            update_hand_text({delay = 0}, {mult = mult})
                            G.GAME.current_round.dicsards_left = G.GAME.current_round.dicsards_left + 1
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_chromaticplatinum then
                            mult = mod_mult(mult ^ 12)
                            update_hand_text({delay = 0}, {mult = mult})
                            G.GAME.current_round.dicsards_left = G.GAME.current_round.dicsards_left + 2
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_chromaticastral then
                            mult = mod_mult(mult ^ 1.5)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_omnichromatic then
                            mult = mod_mult(mult ^ 12)
                            update_hand_text({delay = 0}, {mult = mult})
                            G.GAME.current_round.dicsards_left = G.GAME.current_round.dicsards_left + 2
                            G.GAME.dollars = G.GAME.dollars * 2
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_opposite then
                            local Xjokers = G.P_CENTERS.e_cry_opposite.config.Xjokers
                            G.jokers.config.card_limit = G.jokers.config.card_limit + Xjokers
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_superopposite then
                            local Xjokers = G.P_CENTERS.e_cry_superopposite.config.Xjokers
                            G.jokers.config.card_limit = G.jokers.config.card_limit + Xjokers
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_ultraopposite then
                            local Xjokers = G.P_CENTERS.e_cry_ultraopposite.config.Xjokers
                            G.jokers.config.card_limit = G.jokers.config.card_limit + Xjokers
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_hyperopposite then
                            local Xjokers = G.P_CENTERS.e_cry_hyperopposite.config.Xjokers
                            G.jokers.config.card_limit = G.jokers.config.card_limit + Xjokers
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_eraser then
                            local Xjokers = G.P_CENTERS.e_cry_eraser.config.Xjokers
                            G.jokers.config.card_limit = G.jokers.config.card_limit - Xjokers
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_pocketedition then
                            local Xconsumable = G.P_CENTERS.e_cry_pocketedition.config.Xconsumable
                            G.consumeables.config.card_limit = G.consumeables.config.card_limit + Xconsumable
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_pocketedition then
                            local Xconsumable = G.P_CENTERS.e_cry_pocketedition.config.Xconsumable
                            G.consumeables.config.card_limit = G.consumeables.config.card_limit + Xconsumable
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_limitededition then
                            local Xcost = G.P_CENTERS.e_cry_limitededition.config.Xconsumable
                            G.consumeables.config.card_limit = G.consumeables.config.card_limit + Xconsumable
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_lefthanded then
                            local xhand = G.P_CENTERS.e_cry_lefthanded.config.Xhand
                            G.GAME.round_resets.hands = G.GAME.round_resets.hands + 0.15
                            G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 0.15
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_psychedelic then
                            G.GAME.current_round.hands_left = G.GAME.current_round.hands_left ^ 2
                            G.GAME.current_round.discards_left = G.GAME.current_round.discards_left ^ 2
                            mult = mod_mult(mult ^ 40)
                            update_hand_text({delay = 0}, {mult = mult})
                            G.GAME.dollars = G.GAME.dollars ^ 40
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_psychedelic_balavirus then
                            G.GAME.current_round.hands_left = G.GAME.current_round.hands_left ^ 10
                            G.GAME.current_round.discards_left = G.GAME.current_round.discards_left ^ 10
                            mult = mod_mult(mult ^ (1e+10))
                            update_hand_text({delay = 0}, {mult = mult})
                            G.GAME.dollars = G.GAME.dollars ^ (1e+10)
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_righthanded then
                            local xdiscard = G.P_CENTERS.e_cry_righthanded.config.Xdiscard
                            G.GAME.round_resets.discards = G.GAME.round_resets.discards + 0.15
                            G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + 0.15
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_trash then
                            local Xconsumable = G.P_CENTERS.e_cry_trash.config.Xconsumable
                            G.consumeables.config.card_limit = G.consumeables.config.card_limit + Xconsumable
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_trash then
                            local Xconsumable = G.P_CENTERS.e_cry_trash.config.Xconsumable
                            G.consumeables.config.card_limit = G.consumeables.config.card_limit + Xconsumable
                        end
                        
                        -- -------------------------------------------------Stake Curse Editions -------------------------------------------------
                        -- Pink Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_pinkstakecurse then
                            local Xpinkstakecurse = G.P_CENTERS.e_cry_pinkstakecurse.config.Xpinkstakecurse
                            G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*1.5
                            G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling*1.5
                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_pinkstakecurse then
                            local Xpinkstakecurse = G.P_CENTERS.e_cry_pinkstakecurse.config.Xpinkstakecurse
                            G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*1.5
                            G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling*1.5
                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_pinkstakecurse then
                            local Xpinkstakecurse = G.P_CENTERS.e_cry_pinkstakecurse.config.Xpinkstakecurse
                            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_pinkstakecurse then
                            local Xpinkstakecurse = G.P_CENTERS.e_cry_pinkstakecurse.config.Xpinkstakecurse
                            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                        end
                        -- Brown Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_brownstakecurse then
                            local Xbrownstakecurse = G.P_CENTERS.e_cry_brownstakecurse.config.Xbrownstakecurse
                            G.GAME.modifiers.cry_eternal_perishable_compat = true
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_brownstakecurse then
                            local Xbrownstakecurse = G.P_CENTERS.e_cry_brownstakecurse.config.Xbrownstakecurse
                            G.GAME.modifiers.cry_eternal_perishable_compat = true
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_brownstakecurse then
                            local Xbrownstakecurse = G.P_CENTERS.e_cry_brownstakecurse.config.Xbrownstakecurse
                            G.consumeables.config.card_limit = G.consumeables.config.card_limit + 0.1
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_brownstakecurse then
                            local Xbrownstakecurse = G.P_CENTERS.e_cry_brownstakecurse.config.Xbrownstakecurse
                            G.consumeables.config.card_limit = G.consumeables.config.card_limit + 0.1
                        end
                        -- Yellow Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_yellowstakecurse then
                            local Xyellowstakecurse = G.P_CENTERS.e_cry_yellowstakecurse.config.Xyellowstakecurse
                            G.GAME.modifiers.cry_any_stickers = true
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_yellowstakecurse then
                            local Xyellowstakecurse = G.P_CENTERS.e_cry_yellowstakecurse.config.Xyellowstakecurse
                            G.GAME.modifiers.cry_any_stickers = true
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_yellowstakecurse then
                            local Xyellowstakecurse = G.P_CENTERS.e_cry_yellowstakecurse.config.Xyellowstakecurse
                            G.GAME.dollars = G.GAME.dollars + 4
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_yellowstakecurse then
                            local Xyellowstakecurse = G.P_CENTERS.e_cry_yellowstakecurse.config.Xyellowstakecurse
                            G.GAME.dollars = G.GAME.dollars + 4
                        end
                        -- Jade Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_jadestakecurse then
                            local Xjadestakecurse = G.P_CENTERS.e_cry_jadestakecurse.config.Xjadestakecurse
                            G.GAME.modifiers.flipped_cards = 5 + Xjadestakecurse
                            Xjadestakecurse = Xjadestakecurse + 5
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_jadestakecurse then
                            local Xjadestakecurse = G.P_CENTERS.e_cry_jadestakecurse.config.Xjadestakecurse
                            G.GAME.modifiers.flipped_cards = 5 + Xjadestakecurse
                            Xjadestakecurse = Xjadestakecurse + 5
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_jadestakecurse then
                            local Xjadestakecurse = G.P_CENTERS.e_cry_jadestakecurse.config.Xjadestakecurse
                            G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 0.5
                            G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + 0.5
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_jadestakecurse then
                            local Xjadestakecurse = G.P_CENTERS.e_cry_jadestakecurse.config.Xjadestakecurse
                            G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 0.5
                            G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + 0.5
                        end
                        -- Cyan Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_cyanstakecurse then
                            local Xcyanstakecurse = G.P_CENTERS.e_cry_cyanstakecurse.config.Xcyanstakecurse
                            G.GAME.joker_rate = G.GAME.joker_rate - 1
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_cyanstakecurse then
                            local Xcyanstakecurse = G.P_CENTERS.e_cry_cyanstakecurse.config.Xcyanstakecurse
                            G.GAME.joker_rate = G.GAME.joker_rate - 1
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_cyanstakecurse then
                            local Xcyanstakecurse = G.P_CENTERS.e_cry_cyanstakecurse.config.Xcyanstakecurse
                            G.GAME.edition_rate = G.GAME.edition_rate + 2
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_cyanstakecurse then
                            local Xcyanstakecurse = G.P_CENTERS.e_cry_cyanstakecurse.config.Xcyanstakecurse
                            G.GAME.edition_rate = G.GAME.edition_rate + 2
                        end
                        -- Gray Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_graystakecurse then
                            local Xgraystakecurse = G.P_CENTERS.e_cry_graystakecurse.config.Xgraystakecurse
                            G.GAME.inflation = 0 + Xgraystakecurse
                            Xgraystakecurse = Xgraystakecurse + 2
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_graystakecurse then
                            local Xgraystakecurse = G.P_CENTERS.e_cry_graystakecurse.config.Xgraystakecurse
                            G.GAME.inflation = 0 + Xgraystakecurse
                            Xgraystakecurse = Xgraystakecurse + 2
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_graystakecurse then
                            local Xgraystakecurse = G.P_CENTERS.e_cry_graystakecurse.config.Xgraystakecurse
                            G.GAME.dollars = G.GAME.dollars * 1.2
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_graystakecurse then
                            local Xgraystakecurse = G.P_CENTERS.e_cry_graystakecurse.config.Xgraystakecurse
                            G.GAME.dollars = G.GAME.dollars * 1.2
                        end
                        -- Crimson Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_crimsonstakecurse then
                            local Xcrimsonstakecurse = G.P_CENTERS.e_cry_crimsonstakecurse.config.Xcrimsonstakecurse
                            G.GAME.inflation = G.GAME.dollars
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_crimsonstakecurse then
                            local Xcrimsonstakecurse = G.P_CENTERS.e_cry_crimsonstakecurse.config.Xcrimsonstakecurse
                            G.GAME.inflation = G.GAME.dollars
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_crimsonstakecurse then
                            local Xcrimsonstakecurse = G.P_CENTERS.e_cry_crimsonstakecurse.config.Xcrimsonstakecurse
                            G.GAME.discount_percent = 75
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_crimsonstakecurse then
                            local Xcrimsonstakecurse = G.P_CENTERS.e_cry_crimsonstakecurse.config.Xcrimsonstakecurse
                            G.GAME.discount_percent = 75
                        end
                        -- Diamond Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_diamondstakecurse then
                            local Xdiamondstakecurse = G.P_CENTERS.e_cry_diamondstakecurse.config.Xdiamondstakecurse
                            G.GAME.win_ante = G.GAME.win_ante + 1
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_diamondstakecurse then
                            local Xdiamondstakecurse = G.P_CENTERS.e_cry_diamondstakecurse.config.Xdiamondstakecurse
                            G.GAME.win_ante = G.GAME.win_ante + 1
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_diamondstakecurse then
                            local Xdiamondstakecurse = G.P_CENTERS.e_cry_diamondstakecurse.config.Xdiamondstakecurse
                            G.GAME.interest_amount = G.GAME.interest_amount + 1
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_diamondstakecurse then
                            local Xdiamondstakecurse = G.P_CENTERS.e_cry_diamondstakecurse.config.Xdiamondstakecurse
                            G.GAME.interest_amount = G.GAME.interest_amount + 1
                        end
                        -- Amber Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_amberstakecurse then
                            local Xamberstakecurse = G.P_CENTERS.e_cry_amberstakecurse.config.Xamberstakecurse
                            G.GAME.modifiers.cry_booster_packs = 1
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_amberstakecurse then
                            local Xamberstakecurse = G.P_CENTERS.e_cry_amberstakecurse.config.Xamberstakecurse
                            G.GAME.modifiers.cry_booster_packs = 1
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_amberstakecurse then
                            local Xamberstakecurse = G.P_CENTERS.e_cry_amberstakecurse.config.Xamberstakecurse
                            G.GAME.shop.joker_max = 3
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_amberstakecurse then
                            local Xamberstakecurse = G.P_CENTERS.e_cry_amberstakecurse.config.Xamberstakecurse
                            G.GAME.shop.joker_max = 3
                        end
                        -- Bronze Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_bronzestakecurse then
                            local Xbronzestakecurse = G.P_CENTERS.e_cry_bronzestakecurse.config.Xbronzestakecurse
                            G.GAME.inflation = 5
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_bronzestakecurse then
                            local Xbronzestakecurse = G.P_CENTERS.e_cry_bronzestakecurse.config.Xbronzestakecurse
                            G.GAME.inflation = 5
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_bronzestakecurse then
                            local Xbronzestakecurse = G.P_CENTERS.e_cry_bronzestakecurse.config.Xbronzestakecurse
                            G.GAME.dollars = G.GAME.dollars + G.GAME.current_round.discards_left
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_bronzestakecurse then
                            local Xbronzestakecurse = G.P_CENTERS.e_cry_bronzestakecurse.config.Xbronzestakecurse
                            G.GAME.dollars = G.GAME.dollars + G.GAME.current_round.discards_left
                        end
                        -- Quartz Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_quartzstakecurse then
                            local Xquartzstakecurse = G.P_CENTERS.e_cry_quartzstakecurse.config.Xquartzstakecurse
                            G.GAME.modifiers.cry_enable_pinned_in_shop = true
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_quartzstakecurse then
                            local Xquartzstakecurse = G.P_CENTERS.e_cry_quartzstakecurse.config.Xquartzstakecurse
                            G.GAME.modifiers.cry_enable_pinned_in_shop = true
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_quartzstakecurse then
                            local Xquartzstakecurse = G.P_CENTERS.e_cry_quartzstakecurse.config.Xquartzstakecurse
                            mult = mod_mult(mult * 1.5)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_quartzstakecurse then
                            local Xquartzstakecurse = G.P_CENTERS.e_cry_quartzstakecurse.config.Xquartzstakecurse
                            mult = mod_mult(mult * 1.5)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        -- Ruby Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_rubystakecurse then
                            local Xrubystakecurse = G.P_CENTERS.e_cry_rubystakecurse.config.Xrubystakecurse
                            G.GAME.modifiers.cry_big_boss_rate = 0 + Xrubystakecurse
                            Xrubystakecurse = Xrubystakecurse + 0.1
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_rubystakecurse then
                            local Xrubystakecurse = G.P_CENTERS.e_cry_rubystakecurse.config.Xrubystakecurse
                            G.GAME.modifiers.cry_big_boss_rate = 0 + Xrubystakecurse
                            Xrubystakecurse = Xrubystakecurse + 0.1
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_rubystakecurse then
                            local Xrubystakecurse = G.P_CENTERS.e_cry_rubystakecurse.config.Xrubystakecurse
                            G.GAME.spectral_rate = G.GAME.spectral_rate + 5
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_rubystakecurse then
                            local Xrubystakecurse = G.P_CENTERS.e_cry_rubystakecurse.config.Xrubystakecurse
                            G.GAME.spectral_rate = G.GAME.spectral_rate + 5
                        end
                        -- Glass curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_glassstakecurse then
                            local Xglassstakecurse = G.P_CENTERS.e_cry_glassstakecurse.config.Xglassstakecurse
                            G.GAME.modifiers.cry_shatter_rate = 0 + Xglassstakecurse
                            Xglassstakecurse = Xglassstakecurse + 10
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_glassstakecurse then
                            local Xglassstakecurse = G.P_CENTERS.e_cry_glassstakecurse.config.Xglassstakecurse
                            G.GAME.modifiers.cry_shatter_rate = 0 + Xglassstakecurse
                            Xglassstakecurse = Xglassstakecurse + 10
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_glassstakecurse then
                            local Xglassstakecurse = G.P_CENTERS.e_cry_glassstakecurse.config.Xglassstakecurse
                            hand_chips = mod_chips(hand_chips * G.GAME.dollars * 0.25)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_glassstakecurse then
                            local Xglassstakecurse = G.P_CENTERS.e_cry_glassstakecurse.config.Xglassstakecurse
                            hand_chips = mod_chips(hand_chips * G.GAME.dollars * 0.25)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        -- Sapphire Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_sapphirestakecurse then
                            local Xsapphirestakecurse = G.P_CENTERS.e_cry_sapphirestakecurse.config.Xsapphirestakecurse
                            G.GAME.modifiers.cry_ante_tax = 0.25
                            G.GAME.modifiers.cry_ante_tax_max = 10 + Xsapphirestakecurse
                            Xsapphirestakecurse = Xsapphirestakecurse + 10
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_sapphirestakecurse then
                            local Xsapphirestakecurse = G.P_CENTERS.e_cry_sapphirestakecurse.config.Xsapphirestakecurse
                            G.GAME.modifiers.cry_ante_tax = 0.25
                            G.GAME.modifiers.cry_ante_tax_max = 10 + Xsapphirestakecurse
                            Xsapphirestakecurse = Xsapphirestakecurse + 10
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_sapphirestakecurse then
                            local Xsapphirestakecurse = G.P_CENTERS.e_cry_sapphirestakecurse.config.Xsapphirestakecurse
                            hand_chips = mod_chips(hand_chips + 10 * Xsapphirestakecurse)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_sapphirestakecurse then
                            local Xsapphirestakecurse = G.P_CENTERS.e_cry_sapphirestakecurse.config.Xsapphirestakecurse
                            hand_chips = mod_chips(hand_chips + 10 * Xsapphirestakecurse)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        -- Emerald Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_emeraldstakecurse then
                            local Xemeraldstakecurse = G.P_CENTERS.e_cry_emeraldstakecurse.config.Xemeraldstakecurse
                            G.GAME.modifiers.cry_enable_flipped_in_shop = true
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_emeraldstakecurse then
                            local Xemeraldstakecurse = G.P_CENTERS.e_cry_emeraldstakecurse.config.Xemeraldstakecurse
                            G.GAME.modifiers.cry_enable_flipped_in_shop = true
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_emeraldstakecurse then
                            local Xemeraldstakecurse = G.P_CENTERS.e_cry_emeraldstakecurse.config.Xemeraldstakecurse
                            mult = mod_mult(mult + G.GAME.dollars * 0.1)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_emeraldstakecurse then
                            local Xemeraldstakecurse = G.P_CENTERS.e_cry_emeraldstakecurse.config.Xemeraldstakecurse
                            mult = mod_mult(mult + G.GAME.dollars * 0.1)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        -- Platinum Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_platinumstakecurse then
                            local Xplatinumstakecurse = G.P_CENTERS.e_cry_platinumstakecurse.config.Xplatinumstakecurse
                            G.GAME.modifiers.cry_no_small_blind = true
                            G.GAME.round_resets.blind_states['Small'] = 'Hide'
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_platinumstakecurse then
                            local Xplatinumstakecurse = G.P_CENTERS.e_cry_platinumstakecurse.config.Xplatinumstakecurse
                            G.GAME.modifiers.cry_no_small_blind = true
                            G.GAME.round_resets.blind_states['Small'] = 'Hide'
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_platinumstakecurse then
                            local Xplatinumstakecurse = G.P_CENTERS.e_cry_platinumstakecurse.config.Xplatinumstakecurse
                            mult = mod_mult(mult * (G.GAME.current_round.hands_played + 1))
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_platinumstakecurse then
                            local Xplatinumstakecurse = G.P_CENTERS.e_cry_platinumstakecurse.config.Xplatinumstakecurse
                            mult = mod_mult(mult * (G.GAME.current_round.hands_played + 1))
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        -- Verdant Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_verdantstakecurse then
                            local Xverdantstakecurse = G.P_CENTERS.e_cry_verdantstakecurse.config.Xverdantstakecurse
                            G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*5
                            G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling*5
                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_verdantstakecurse then
                            local Xverdantstakecurse = G.P_CENTERS.e_cry_verdantstakecurse.config.Xverdantstakecurse
                            G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*5
                            G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling*5
                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_verdantstakecurse then
                            local Xverdantstakecurse = G.P_CENTERS.e_cry_verdantstakecurse.config.Xverdantstakecurse
                            G.GAME.round_resets.discards = G.GAME.round_resets.discards + 2
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_verdantstakecurse then
                            local Xverdantstakecurse = G.P_CENTERS.e_cry_verdantstakecurse.config.Xverdantstakecurse
                            G.GAME.round_resets.discards = G.GAME.round_resets.discards +2
                        end
                        -- Ember Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_emberstakecurse then
                            local Xemberstakecurse = G.P_CENTERS.e_cry_emberstakecurse.config.Xemberstakecurse
                            G.GAME.modifiers.cry_no_sell_value = true
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_emberstakecurse then
                            local Xemberstakecurse = G.P_CENTERS.e_cry_emberstakecurse.config.Xemberstakecurse
                            G.GAME.modifiers.cry_no_sell_value = true
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_emberstakecurse then
                            local Xemberstakecurse = G.P_CENTERS.e_cry_emberstakecurse.config.Xemberstakecurse
                            G.GAME.interest_cap = 400
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_emberstakecurse then
                            local Xemberstakecurse = G.P_CENTERS.e_cry_emberstakecurse.config.Xemberstakecurse
                            G.GAME.interest_cap = 400
                        end
                        -- Dawn Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_dawnstakecurse then
                            local Xdawnstakecurse = G.P_CENTERS.e_cry_dawnstakecurse.config.Xdawnstakecurse
                            G.consumeables.config.card_limit = 1
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_dawnstakecurse then
                            local Xdawnstakecurse = G.P_CENTERS.e_cry_dawnstakecurse.config.Xdawnstakecurse
                            G.consumeables.config.card_limit = 1
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_dawnstakecurse then
                            local Xdawnstakecurse = G.P_CENTERS.e_cry_dawnstakecurse.config.Xdawnstakecurse
                            G.GAME.tarot_rate = 90
                            G.GAME.spectral_rate = 20
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_dawnstakecurse then
                            local Xdawnstakecurse = G.P_CENTERS.e_cry_dawnstakecurse.config.Xdawnstakecurse
                            G.GAME.tarot_rate = 90
                            G.GAME.spectral_rate = 20
                        end
                        -- Horizon Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_horizonstakecurse then
                            local Xhorizonstakecurse = G.P_CENTERS.e_cry_horizonstakecurse.config.Xhorizonstakecurse
                            G.GAME.playing_card_rate = 25
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_horizonstakecurse then
                            local Xhorizonstakecurse = G.P_CENTERS.e_cry_horizonstakecurse.config.Xhorizonstakecurse
                            G.GAME.playing_card_rate = 25
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_horizonstakecurse then
                            local Xhorizonstakecurse = G.P_CENTERS.e_cry_horizonstakecurse.config.Xhorizonstakecurse
                            mult = mod_mult(mult * 0.75)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_horizonstakecurse then
                            local Xhorizonstakecurse = G.P_CENTERS.e_cry_horizonstakecurse.config.Xhorizonstakecurse
                            mult = mod_mult(mult * 0.75)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        -- Blossom Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_blossomstakecurse then
                            local Xblossomstakecurse = G.P_CENTERS.e_cry_blossomstakecurse.config.Xblossomstakecurse
                            G.GAME.modifiers.cry_big_showdown = true
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_blossomstakecurse then
                            local Xblossomstakecurse = G.P_CENTERS.e_cry_blossomstakecurse.config.Xblossomstakecurse
                            G.GAME.modifiers.cry_big_showdown = true
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_blossomstakecurse then
                            local Xblossomstakecurse = G.P_CENTERS.e_cry_blossomstakecurse.config.Xblossomstakecurse
                            G.GAME.dollars = G.GAME.dollars + G.GAME.current_round.hands_left * 2
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_blossomstakecurse then
                            local Xblossomstakecurse = G.P_CENTERS.e_cry_blossomstakecurse.config.Xblossomstakecurse
                            G.GAME.dollars = G.GAME.dollars + G.GAME.current_round.hands_left * 2
                        end
                        -- Azure Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_azurestakecurse then
                            local Xazurestakecurse = G.P_CENTERS.e_cry_azurestakecurse.config.Xazurestakecurse
                            G.GAME.modifiers.cry_jkr_misprint_mod = 0.5
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_azurestakecurse then
                            local Xazurestakecurse = G.P_CENTERS.e_cry_azurestakecurse.config.Xazurestakecurse
                            G.GAME.modifiers.cry_jkr_misprint_mod = 0.5
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_azurestakecurse then
                            local Xazurestakecurse = G.P_CENTERS.e_cry_azurestakecurse.config.Xazurestakecurse
                            mult = mod_mult(mult ^ 2)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_azurestakecurse then
                            local Xazurestakecurse = G.P_CENTERS.e_cry_azurestakecurse.config.Xazurestakecurse
                            mult = mod_mult(mult ^ 2)
                            update_hand_text({delay = 0}, {mult = mult})
                        end
                        -- Ascendant Curse *
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_ascendantstakecurse then
                            local Xascendantstakecurse = G.P_CENTERS.e_cry_ascendantstakecurse.config.Xascendantstakecurse
                            G.GAME.shop.joker_max = 1
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_ascendantstakecurse then
                            local Xascendantstakecurse = G.P_CENTERS.e_cry_ascendantstakecurse.config.Xascendantstakecurse
                            G.GAME.shop.joker_max = 1
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_ascendantstakecurse then
                            local Xascendantstakecurse = G.P_CENTERS.e_cry_ascendantstakecurse.config.Xascendantstakecurse
                            G.GAME.modifiers.cry_jkr_misprint_mod = 1.5
                        end
                        if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_ascendantstakecurse then
                            local Xascendantstakecurse = G.P_CENTERS.e_cry_ascendantstakecurse.config.Xascendantstakecurse
                            G.GAME.modifiers.cry_jkr_misprint_mod = 1.5
                        end
                                                if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_mosaic then
                            local xchips = G.P_CENTERS.e_cry_mosaic.config.Xchips
                            hand_chips = mod_chips(hand_chips * xchips)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = 'X'..xchips..' Chips',
                            edition = true,
                            x_chips = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_sparkle then
                            local xchips = G.P_CENTERS.e_cry_sparkle.config.Xchips
                            hand_chips = mod_chips(hand_chips * xchips)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = 'X'..xchips..' Chips',
                            edition = true,
                            x_chips = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_greedy then
                            local xchips = G.P_CENTERS.e_cry_greedy.config.Xchips
                            hand_chips = mod_chips(hand_chips ^ 0)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = 'X'..xchips..' Chips',
                            edition = true,
                            x_chips = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_duplicated then
                            local xscore = G.P_CENTERS.e_cry_duplicated.config.Xscore
                            hand_chips = mod_chips(hand_chips * 2)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = 'X'..xscore..' Chips',
                            edition = true,
                            Xscore = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_impulsion then
                            G.GAME.dollars = G.GAME.dollars ^ 1.1
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_golden then
                            G.GAME.dollars = G.GAME.dollars + 30
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_ultragolden then
                            G.GAME.dollars = G.GAME.dollars + 90
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_chromaticimpulsion then
                            hand_chips = mod_chips(hand_chips ^ 1.5)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_darkvoid_balavirus then
                            hand_chips = mod_chips(hand_chips ^ (1e+100))
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_psychedelic then
                            hand_chips = mod_chips(hand_chips ^ 40)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_psychedelic_balavirus then
                            hand_chips = mod_chips(hand_chips ^ (1e+10))
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_brilliant then
                            hand_chips = mod_chips(hand_chips * 2)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_catalyst then
                            hand_chips = mod_chips(hand_chips * 3)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                            G.GAME.dollars = G.GAME.dollars + 1
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_hardstone then
                            hand_chips = mod_chips(100)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_bedrock then
                            hand_chips = mod_chips(1000)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_chromaticplatinum then
                            hand_chips = mod_chips(hand_chips ^ 12)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_omnichromatic then
                            hand_chips = mod_chips(hand_chips ^ 12)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_chromaticastral then
                            hand_chips = mod_chips(hand_chips ^ 1.5)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_shadowing then
                            hand_chips = mod_chips(hand_chips ^ 3)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_graymatter then
                            hand_chips = mod_chips(hand_chips ^ 6)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_blister then
                            hand_chips = mod_chips(hand_chips + 500)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_galvanized then
                            hand_chips = mod_chips(hand_chips + 1000)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_metallic then
                            G.GAME.dollars = G.GAME.dollars + 10
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_tvghost then
                            hand_chips = mod_chips(hand_chips + 60)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                            G.GAME.dollars = G.GAME.dollars * 1.25
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.cry_noisy then
                            hand_chips = mod_chips(hand_chips * 50)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                            G.GAME.dollars = G.GAME.dollars * 1.25
                        end
                        
                                                
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.bunc_glitter then
                            local xchips = G.P_CENTERS.e_bunc_glitter.config.Xchips
                            hand_chips = mod_chips(hand_chips * xchips)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                            {message = 'X'..xchips..' '..global_bunco.loc.chips,
                            edition = true,
                            x_chips = true})
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.bunc_shinygalvanized then
                            hand_chips = mod_chips(hand_chips + 100000)
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.bunc_shinygalvanized then
                            mult = mod_mult(mult * 9)
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.bunc_burnt then
                            hand_chips = mod_chips(hand_chips * 0.5)
                        end
                        if scoring_hand and scoring_hand[i] and scoring_hand[i].edition and scoring_hand[i].edition.bunc_burnt then
                            mult = mod_mult(mult * 2)
                        end
                                                    if effects[ii].edition.chip_mod then
                                                        hand_chips = mod_chips(hand_chips + effects[ii].edition.chip_mod)
                                                        local key_switch = (effects[ii].edition.chip_mod > 0 and 'a_chips' or 'a_chips_minus')
                                                        card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil, {
                                                            message = localize{type='variable', key=key_switch, vars={math.abs(effects[ii].edition.chip_mod)}},
                                                            chip_mod = true,
                                                            colour = G.C.DARK_EDITION,
                                                            edition = true
                                                        })
                                                        update_hand_text({delay = 0}, {chips = hand_chips})
                                                    end
                                                    if effects[ii].edition.mult_mod then
                                                        mult = mult + effects[ii].edition.mult_mod
                                                        card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil, {
                                                            message = localize{type='variable', key='a_mult', vars={effects[ii].edition.mult_mod}},
                                                            mult_mod = true,
                                                            colour = G.C.DARK_EDITION,
                                                            edition = true
                                                        })
                                                        update_hand_text({delay = 0}, {mult = mult})
                                                    end
                                                    if effects[ii].edition.x_mult_mod then
                                                        mult = mult * effects[ii].edition.x_mult_mod
                                                        card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil, {
                                                            message = localize{type='variable', key='a_xmult', vars={effects[ii].edition.x_mult_mod}},
                                                            x_mult_mod = true,
                                                            colour = G.C.DARK_EDITION,
                                                            edition = true
                                                        })
                                                        update_hand_text({delay = 0}, {mult = mult})
                                                    end
                                                    if effects[ii].edition.p_dollars_mod then
                                                        if effects[ii].card then juice_card(effects[ii].card) end
                                                        ease_dollars(effects[ii].edition.p_dollars_mod)
                                                        card_eval_status_text(scoring_hand[i], 'dollars', effects[ii].edition.p_dollars_mod, percent)
                                                    end
                                                    if not effects[ii].edition then
                                                    hand_chips = mod_chips(hand_chips + (effects[ii].edition.chip_mod or 0))
                            mult = mult + (effects[ii].edition.mult_mod or 0)
                            mult = mod_mult(mult*(effects[ii].edition.x_mult_mod or 1))
                            update_hand_text({delay = 0}, {
                                chips = effects[ii].edition.chip_mod and hand_chips or nil,
                                mult = (effects[ii].edition.mult_mod or effects[ii].edition.x_mult_mod) and mult or nil,
                            })
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil, {
                                message = (effects[ii].edition.chip_mod and localize{type='variable',key='a_chips',vars={effects[ii].edition.chip_mod}}) or
                                        (effects[ii].edition.mult_mod and localize{type='variable',key='a_mult',vars={effects[ii].edition.mult_mod}}) or
                                        (effects[ii].edition.x_mult_mod and localize{type='variable',key='a_xmult',vars={effects[ii].edition.x_mult_mod}}),
                                chip_mod =  effects[ii].edition.chip_mod,
                                mult_mod =  effects[ii].edition.mult_mod,
                                x_mult_mod =  effects[ii].edition.x_mult_mod,
                                colour = G.C.DARK_EDITION,
                                edition = true})end
                                if (effects and effects[ii] and effects[ii].edition and effects[ii].edition.x_mult_mod or edition_effects and edition_effects.jokers and edition_effects.jokers.x_mult_mod) and next(find_joker("cry-Exponentia")) then
                                    for _, v in pairs(find_joker("cry-Exponentia")) do
                                        v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                                        card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                                    end
                                end
                                                        end
                    end
                end
            end
        end

        delay(0.3)
        local mod_percent = false
            for i=1, #G.hand.cards do
                if mod_percent then percent = percent + percent_delta end
                mod_percent = false

                --Check for hand doubling
                local reps = {1}
                local j = 1
                while j <= #reps do
                    if reps[j] ~= 1 then
                        card_eval_status_text((reps[j].jokers or reps[j].seals).card, 'jokers', nil, nil, nil, (reps[j].jokers or reps[j].seals))
                        if reps[j].from_retrigger then
                            card_eval_status_text(reps[j].from_retrigger.card, 'jokers', nil, nil, nil, reps[j].from_retrigger)
                        end
                                                percent = percent + percent_delta
                    end

                    --calculate the hand effects
                    local effects = {eval_card(G.hand.cards[i], {cardarea = G.hand, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands})}

                    for k=1, #G.jokers.cards do
                        --calculate the joker individual card effects
                        local eval = G.jokers.cards[k]:calculate_joker({cardarea = G.hand, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = G.hand.cards[i], individual = true})
                        if eval and eval.joker_repetitions then
                            rep_list = eval.joker_repetitions
                            for z=1, #rep_list do
                                if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                                    for r=1, rep_list[z].repetitions do
                                        local ev = G.jokers.cards[k]:calculate_joker({cardarea = G.hand, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = G.hand.cards[i], individual = true, retrigger_joker = true})
                                        if ev then
                                            mod_percent = true
                                            table.insert(effects, ev)
                                            table.insert(effects, rep_list[z])
                                        end
                                    end
                                end
                            end
                        end
                                                if eval then 
                            mod_percent = true
                            table.insert(effects, eval)
                        end
                    end

                    if reps[j] == 1 then 
                        --Check for hand doubling

                        --From Red seal
                        local eval = eval_card(G.hand.cards[i], {repetition_only = true,cardarea = G.hand, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, repetition = true, card_effects = effects})
                        if next(eval) and (next(effects[1]) or #effects > 1) then 
                            for h  = 1, eval.seals.repetitions do
                                reps[#reps+1] = eval
                            end
                        end

                        --From Joker
                        for j=1, #G.jokers.cards do
                            --calculate the joker effects
                            local eval = eval_card(G.jokers.cards[j], {cardarea = G.hand, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = G.hand.cards[i], repetition = true, card_effects = effects})
                            if eval and eval.jokers and eval.jokers.repetitions and eval.jokers.joker_repetitions then
                                rep_list = eval.jokers.joker_repetitions
                                for z=1, #rep_list do
                                    if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                                        for r=1, rep_list[z].repetitions do
                                            for s=1, eval.jokers.repetitions do
                                                reps[#reps+1] = {from_retrigger = rep_list[z]}
                                                for k, v in pairs(eval) do
                                                    reps[#reps][k] = v
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if eval and eval.jokers and not eval.jokers.repetitions then eval.jokers = nil end
                                                        if next(eval) then 
                                for h  = 1, eval.jokers.repetitions do
                                    reps[#reps+1] = eval
                                end
                            end
                        end
                    end
    
                    for ii = 1, #effects do
                        --if this effect came from a joker
                        if effects[ii].card and not Talisman.config_file.disable_anims then
                            mod_percent = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'immediate',
                                func = (function() effects[ii].card:juice_up(0.7);return true end)
                            }))
                        end
                        
                        --If hold mult added, do hold mult add event and add the mult to the total
                        
                        --If dollars added, add dollars to total
                        if effects[ii].dollars then 
                            ease_dollars(effects[ii].dollars)
                            card_eval_status_text(G.hand.cards[i], 'dollars', effects[ii].dollars, percent)
                        end

                        if effects[ii].h_mult then
                            mod_percent = true
                            mult = mod_mult(mult + effects[ii].h_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(G.hand.cards[i], 'h_mult', effects[ii].h_mult, percent)
                        end

                        if effects[ii].x_mult then
                            mod_percent = true
                            mult = mod_mult(mult*effects[ii].x_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(G.hand.cards[i], 'x_mult', effects[ii].x_mult, percent)
                            if next(find_joker("cry-Exponentia")) then
                                for _, v in pairs(find_joker("cry-Exponentia")) do
                                    v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                                    card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                                end
                            end
                                                    end

                        if effects[ii].x_chips then
                        	mod_percent = true
                        	chips = mod_chips(chips*effects[ii].x_chips)
                        	update_hand_text({delay = 0}, {chips = chips})
                        	card_eval_status_text(G.hand.cards[i], 'x_chips', effects[ii].x_chips, percent)
                        end
                        
                        if effects[ii].pow_mult then
                        	mod_percent = true
                        	mult = mod_mult(mult^effects[ii].pow_mult)
                        	update_hand_text({delay = 0}, {mult = mult})
                        	card_eval_status_text(G.hand.cards[i], 'pow_mult', effects[ii].pow_mult, percent)
                        end
                        
                                                if effects[ii].x_chips then
                                                	mod_percent = true
                                                	chips = mod_chips(chips*effects[ii].x_chips)
                                                	update_hand_text({delay = 0}, {chips = chips})
                                                	card_eval_status_text(G.hand.cards[i], 'x_chips', effects[ii].x_chips, percent)
                                                end
                                                if effects[ii].e_chips then
                                                	mod_percent = true
                                                	chips = mod_chips(chips^effects[ii].e_chips)
                                                	update_hand_text({delay = 0}, {chips = chips})
                                                	card_eval_status_text(G.hand.cards[i], 'e_chips', effects[ii].e_chips, percent)
                                                end
                                                if effects[ii].ee_chips then
                                                	mod_percent = true
                                                	chips = mod_chips(chips:arrow(2, effects[ii].ee_chips))
                                                	update_hand_text({delay = 0}, {chips = chips})
                                                	card_eval_status_text(G.hand.cards[i], 'ee_chips', effects[ii].ee_chips, percent)
                                                end
                                                if effects[ii].eee_chips then
                                                	mod_percent = true
                                                	chips = mod_chips(chips:arrow(3, effects[ii].eee_chips))
                                                	update_hand_text({delay = 0}, {chips = chips})
                                                	card_eval_status_text(G.hand.cards[i], 'eee_chips', effects[ii].eee_chips, percent)
                                                end
                                                if effects[ii].hyper_chips and type(effects[ii].hyper_chips) == 'table' then
                                                	mod_percent = true
                                                	chips = mod_chips(chips:arrow(effects[ii].hyper_chips[1], effects[ii].hyper_chips[2]))
                                                	update_hand_text({delay = 0}, {chips = chips})
                                                	card_eval_status_text(G.hand.cards[i], 'hyper_chips', effects[ii].hyper_chips, percent)
                                                end
                                                if effects[ii].e_mult then
                                                	mod_percent = true
                                                	mult = mod_mult(mult^effects[ii].e_mult)
                                                	update_hand_text({delay = 0}, {mult = mult})
                                                	card_eval_status_text(G.hand.cards[i], 'e_mult', effects[ii].e_mult, percent)
                                                end
                                                if effects[ii].ee_mult then
                                                	mod_percent = true
                                                	mult = mod_mult(mult:arrow(2, effects[ii].ee_mult))
                                                	update_hand_text({delay = 0}, {mult = mult})
                                                	card_eval_status_text(G.hand.cards[i], 'ee_mult', effects[ii].ee_mult, percent)
                                                end
                                                if effects[ii].eee_mult then
                                                	mod_percent = true
                                                	mult = mod_mult(mult:arrow(3, effects[ii].eee_mult))
                                                	update_hand_text({delay = 0}, {mult = mult})
                                                	card_eval_status_text(G.hand.cards[i], 'eee_mult', effects[ii].eee_mult, percent)
                                                end
                                                if effects[ii].hyper_mult and type(effects[ii].hyper_mult) == 'table' then
                                                	mod_percent = true
                                                	mult = mod_mult(mult:arrow(effects[ii].hyper_mult[1], effects[ii].hyper_mult[2]))
                                                	update_hand_text({delay = 0}, {mult = mult})
                                                	card_eval_status_text(G.hand.cards[i], 'hyper_mult', effects[ii].hyper_mult, percent)
                                                end
                                                
                                                                                                if effects[ii].message then
                            mod_percent = true
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(G.hand.cards[i], 'extra', nil, percent, nil, effects[ii])
                        end
                    end
                    j = j +1
                end
            end
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        --Joker Effects
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        percent = percent + percent_delta
        for i=1, #G.jokers.cards + #G.consumeables.cards do
            local _card = G.jokers.cards[i] or G.consumeables.cards[i - #G.jokers.cards]
            --calculate the joker edition effects
            local edition_effects = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, edition = true})
            if edition_effects.jokers then
                edition_effects.jokers.edition = true
                if edition_effects.jokers.p_dollars_mod then
                    ease_dollars(edition_effects.jokers.p_dollars_mod)
                    card_eval_status_text(_card, 'dollars', edition_effects.jokers.p_dollars_mod, percent)
                end
                if edition_effects.jokers.chip_mod then
                    hand_chips = mod_chips(hand_chips + edition_effects.jokers.chip_mod)
                    update_hand_text({delay = 0}, {chips = hand_chips})
                    card_eval_status_text(_card, 'jokers', nil, percent, nil, {
                        message = localize{type='variable',key='a_chips',vars={edition_effects.jokers.chip_mod}},
                        chip_mod =  edition_effects.jokers.chip_mod,
                        colour =  G.C.EDITION,
                        edition = true})
                        if (effects and effects[ii] and effects[ii].edition and effects[ii].edition.x_mult_mod or edition_effects and edition_effects.jokers and edition_effects.jokers.x_mult_mod) and next(find_joker("cry-Exponentia")) then
                            for _, v in pairs(find_joker("cry-Exponentia")) do
                                v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                                card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                            end
                        end
                                        end
                if edition_effects.jokers.mult_mod then
                    mult = mod_mult(mult + edition_effects.jokers.mult_mod)
                    update_hand_text({delay = 0}, {mult = mult})
                    card_eval_status_text(_card, 'jokers', nil, percent, nil, {
                        message = localize{type='variable',key='a_mult',vars={edition_effects.jokers.mult_mod}},
                        mult_mod =  edition_effects.jokers.mult_mod,
                        colour = G.C.DARK_EDITION,
                        edition = true})
                        if (effects and effects[ii] and effects[ii].edition and effects[ii].edition.x_mult_mod or edition_effects and edition_effects.jokers and edition_effects.jokers.x_mult_mod) and next(find_joker("cry-Exponentia")) then
                            for _, v in pairs(find_joker("cry-Exponentia")) do
                                v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                                card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                            end
                        end
                                        end
                percent = percent+percent_delta
            end

            --calculate the joker effects
            local effects = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, joker_main = true})

            --Any Joker effects
            if effects.jokers then 
                local extras = {mult = false, hand_chips = false}
                if effects.jokers.mult_mod then mult = mod_mult(mult + effects.jokers.mult_mod);extras.mult = true end
                if effects.jokers.chip_mod then hand_chips = mod_chips(hand_chips + effects.jokers.chip_mod);extras.hand_chips = true end
                if effects.jokers.Xmult_mod then mult = mod_mult(mult*effects.jokers.Xmult_mod);extras.mult = true  end
                if effects.jokers.Emult_mod then mult = mod_mult(mult^effects.jokers.Emult_mod);extras.mult = true end
                if effects.jokers.EEmult_mod then mult = mod_mult(mult:arrow(2, effects.jokers.EEmult_mod));extras.mult = true end
                if effects.jokers.EEEmult_mod then mult = mod_mult(mult:arrow(3, effects.jokers.EEEmult_mod));extras.mult = true end
                if effects.jokers.hypermult_mod and type(effects.jokers.hypermult_mod) == 'table' then mult = mod_mult(mult:arrow(effects.jokers.hypermult_mod[1], effects.jokers.hypermult_mod[2]));extras.mult = true end
                if effects.jokers.Xchip_mod then hand_chips = mod_chips(hand_chips*effects.jokers.Xchip_mod);extras.hand_chips = true end
                if effects.jokers.Echip_mod then hand_chips = mod_chips(hand_chips^effects.jokers.Echip_mod);extras.hand_chips = true end
                if effects.jokers.EEchip_mod then hand_chips = mod_chips(hand_chips:arrow(2, effects.jokers.EEchip_mod));extras.hand_chips = true end
                if effects.jokers.EEEchip_mod then hand_chips = mod_chips(hand_chips:arrow(3, effects.jokers.EEEchip_mod));extras.hand_chips = true end
                if effects.jokers.hyperchip_mod and type(effects.jokers.hyperchip_mod) == 'table' then hand_chips = mod_chips(hand_chips:arrow(effects.jokers.hyperchip_mod[1], effects.jokers.hyperchip_mod[2]));extras.hand_chips = true end
                                if effects.jokers.pow_mult_mod then mult = mod_mult(mult^effects.jokers.pow_mult_mod);extras.mult = true  end
                if effects.jokers.Xchip_mod then hand_chips = mod_chips(hand_chips*effects.jokers.Xchip_mod);extras.hand_chips = true  end
                                update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult})
                card_eval_status_text(_card, 'jokers', nil, percent, nil, effects.jokers)
                if effects.jokers.joker_repetitions then
                    rep_list = effects.jokers.joker_repetitions
                    for z=1, #rep_list do
                        if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                            for r=1, rep_list[z].repetitions do
                                card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                                if percent then percent = percent+percent_delta end
                
                                local ef = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, joker_main = true, retrigger_joker = true})
                
                                --Any Joker effects
                                if ef.jokers then 
                                    local extras = {mult = false, hand_chips = false}
                                    if ef.jokers.mult_mod then mult = mod_mult(mult + ef.jokers.mult_mod);extras.mult = true end
                                    if ef.jokers.chip_mod then hand_chips = mod_chips(hand_chips + ef.jokers.chip_mod);extras.hand_chips = true end
                                    if ef.jokers.Xmult_mod then mult = mod_mult(mult*ef.jokers.Xmult_mod);extras.mult = true  end
                                    if ef.jokers.pow_mult_mod then mult = mod_mult(mult^ef.jokers.pow_mult_mod);extras.mult = true  end
                                    if ef.jokers.Xchip_mod then hand_chips = mod_chips(hand_chips*ef.jokers.Xchip_mod);extras.hand_chips = true  end
                                    update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult})
                                    card_eval_status_text(_card, 'jokers', nil, percent, nil, effects.jokers)
                                    --Exponentia
                                    if ef.jokers.Xmult_mod and ef.jokers.Xmult_mod ~= 1 and next(find_joker("cry-Exponentia")) then
                                        for _, v in pairs(find_joker("cry-Exponentia")) do
                                            v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                                            card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                                        end
                                    end
                                    if percent then percent = percent+percent_delta end
                                end
                            end
                        end
                    end
                end
                                if effects.jokers.Xmult_mod and effects.jokers.Xmult_mod ~= 1 and next(find_joker("cry-Exponentia")) then
                    for _, v in pairs(find_joker("cry-Exponentia")) do
                        v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                        card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                    end
                end
                                percent = percent+percent_delta
            end

            --Joker on Joker effects
            for _, v in ipairs(G.jokers.cards) do
                local effect = v:calculate_joker{full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_joker = _card}
                if effect and effect.joker_repetitions then
                    rep_list = effect.joker_repetitions
                    for z=1, #rep_list do
                        if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                            for r=1, rep_list[z].repetitions do
                                card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                                if percent then percent = percent+percent_delta end
                                local ef = v:calculate_joker{full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_joker = _card, retrigger_joker = true}
                                if ef then
                                    local extras = {mult = false, hand_chips = false}
                                    if ef.mult_mod then mult = mod_mult(mult + ef.mult_mod);extras.mult = true end
                                    if ef.chip_mod then hand_chips = mod_chips(hand_chips + ef.chip_mod);extras.hand_chips = true end
                                    if ef.Xmult_mod then mult = mod_mult(mult*ef.Xmult_mod);extras.mult = true  end
                                    if ef.pow_mult_mod then mult = mod_mult(mult^ef.pow_mult_mod);extras.mult = true  end
                                    if ef.Xchip_mod then hand_chips = mod_chips(hand_chips*ef.Xchip_mod);extras.hand_chips = true  end
                                    if extras.mult or extras.hand_chips then update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult}) end
                                    if extras.mult or extras.hand_chips then card_eval_status_text(v, 'jokers', nil, percent, nil, ef) end
                                    --Exponentia
                                    if ef.Xmult_mod and next(find_joker("cry-Exponentia")) then
                                        for _, v in pairs(find_joker("cry-Exponentia")) do
                                            v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                                            card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                                        end
                                    end
                                    percent = percent+percent_delta
                                end
                            end
                        end
                    end
                end
                                if effect and effect.joker_repetitions then
                    rep_list = effect.joker_repetitions
                    for z=1, #rep_list do
                        if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                            for r=1, rep_list[z].repetitions do
                                card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                                if percent then percent = percent+percent_delta end
                                local ef = v:calculate_joker{full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_joker = _card, retrigger_joker = true}
                                if ef then
                                    local extras = {mult = false, hand_chips = false}
                                    if ef.mult_mod then mult = mod_mult(mult + ef.mult_mod);extras.mult = true end
                                    if ef.chip_mod then hand_chips = mod_chips(hand_chips + ef.chip_mod);extras.hand_chips = true end
                                    if ef.Xmult_mod then mult = mod_mult(mult*ef.Xmult_mod);extras.mult = true  end
                                    if ef.pow_mult_mod then mult = mod_mult(mult^ef.pow_mult_mod);extras.mult = true  end
                                    if ef.Xchip_mod then hand_chips = mod_chips(hand_chips*ef.Xchip_mod);extras.hand_chips = true  end
                                    if extras.mult or extras.hand_chips then update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult}) end
                                    if extras.mult or extras.hand_chips then card_eval_status_text(v, 'jokers', nil, percent, nil, ef) end
                                    --Exponentia
                                    if ef.Xmult_mod and next(find_joker("cry-Exponentia")) then
                                        for _, v in pairs(find_joker("cry-Exponentia")) do
                                            v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                                            card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                                        end
                                    end
                                    percent = percent+percent_delta
                                end
                            end
                        end
                    end
                end
                                if effect then
                    local extras = {mult = false, hand_chips = false}
                    if effect.mult_mod then mult = mod_mult(mult + effect.mult_mod);extras.mult = true end
                    if effect.chip_mod then hand_chips = mod_chips(hand_chips + effect.chip_mod);extras.hand_chips = true end
                    if effect.Xmult_mod then mult = mod_mult(mult*effect.Xmult_mod);extras.mult = true  end
                    if effect.Emult_mod then mult = mod_mult(mult^effect.Emult_mod);extras.mult = true end
                    if effect.EEmult_mod then mult = mod_mult(mult:arrow(2, effect.EEmult_mod));extras.mult = true end
                    if effect.EEEmult_mod then mult = mod_mult(mult:arrow(3, effect.EEEmult_mod));extras.mult = true end
                    if effect.hypermult_mod and type(effect.hypermult_mod) == 'table' then mult = mod_mult(mult:arrow(effect.hypermult_mod[1], effect.hypermult_mod[2]));extras.mult = true end
                    if effect.Xchip_mod then hand_chips = mod_chips(hand_chips*effect.Xchip_mod);extras.hand_chips = true end
                    if effect.Echip_mod then hand_chips = mod_chips(hand_chips^effect.Echip_mod);extras.hand_chips = true end
                    if effect.EEchip_mod then hand_chips = mod_chips(hand_chips:arrow(2, effect.EEchip_mod));extras.hand_chips = true end
                    if effect.EEEchip_mod then hand_chips = mod_chips(hand_chips:arrow(3, effect.EEEchip_mod));extras.hand_chips = true end
                    if effect.hyperchip_mod and type(effect.hyperchip_mod) == 'table' then hand_chips = mod_chips(hand_chips:arrow(effect.hyperchip_mod[1], effect.hyperchip_mod[2]));extras.hand_chips = true end
                                        if effect.pow_mult_mod then mult = mod_mult(mult^effect.pow_mult_mod);extras.mult = true  end
                    if effects.Xchip_mod then hand_chips = mod_chips(hand_chips*effects.Xchip_mod);extras.hand_chips = true  end
                                        if extras.mult or extras.hand_chips then update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult}) end
                    if extras.mult or extras.hand_chips then card_eval_status_text(v, 'jokers', nil, percent, nil, effect) end
                    if effects.Xmult_mod and next(find_joker("cry-Exponentia")) then
                        for _, v in pairs(find_joker("cry-Exponentia")) do
                            v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                            card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                        end
                    end
                                        percent = percent+percent_delta
                end
            end

            if edition_effects.jokers then
                
                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.bunc_glitter then
                    local xchips = G.P_CENTERS.e_bunc_glitter.config.Xchips
                    hand_chips = mod_chips(hand_chips * xchips)
                    update_hand_text({delay = 0}, {chips = hand_chips})
                    card_eval_status_text(G.jokers.cards[i], 'extra', nil, percent, nil,
                    {message = 'X'..xchips..' '..global_bunco.loc.chips,
                    edition = true,
                    x_chips = true})
                end
                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.bunc_shinygalvanized then
                    hand_chips = mod_chips(hand_chips + 100000)
                end
                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.bunc_shinygalvanized then
                    mult = mod_mult(mult * 9)
                end
                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.bunc_burnt then
                    hand_chips = mod_chips(hand_chips * 0.5)
                end
                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.bunc_burnt then
                    mult = mod_mult(mult * 2)
                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_mosaic then
                                    local xchips = G.P_CENTERS.e_cry_mosaic.config.Xchips
                                    hand_chips = mod_chips(hand_chips * xchips)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                    card_eval_status_text(G.jokers.cards[i], 'extra', nil, percent, nil,
                                    {message = 'X'..xchips..' Chips',
                                    edition = true,
                                    x_chips = true})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_sparkle then
                                    local xchips = G.P_CENTERS.e_cry_sparkle.config.Xchips
                                    hand_chips = mod_chips(hand_chips * xchips)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                    card_eval_status_text(G.jokers.cards[i], 'extra', nil, percent, nil,
                                    {message = 'X'..xchips..' Chips',
                                    edition = true,
                                    x_chips = true})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_greedy then
                                    local xchips = G.P_CENTERS.e_cry_greedy.config.Xchips
                                    hand_chips = mod_chips(hand_chips ^ 0)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                    card_eval_status_text(G.jokers.cards[i], 'extra', nil, percent, nil,
                                    {message = 'X'..xchips..' Chips',
                                    edition = true,
                                    x_chips = true})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_duplicated then
                                    local xscore = G.P_CENTERS.e_cry_duplicated.config.Xscore
                                    hand_chips = mod_chips(hand_chips * 2)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                    card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                                    {message = 'X'..xscore..' Chips',
                                    edition = true,
                                    Xscore = true})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_impulsion then
                                    G.GAME.dollars = G.GAME.dollars ^ 1.1
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_golden then
                                    G.GAME.dollars = G.GAME.dollars + 30
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_ultragolden then
                                    G.GAME.dollars = G.GAME.dollars + 90
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_chromaticimpulsion then
                                    hand_chips = mod_chips(hand_chips ^ 1.5)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_darkvoid_balavirus then
                                    hand_chips = mod_chips(hand_chips ^ (1e+100))
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_psychedelic then
                                    hand_chips = mod_chips(hand_chips ^ 40)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_psychedelic_balavirus then
                                    hand_chips = mod_chips(hand_chips ^ (1e+10))
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_brilliant then
                                    hand_chips = mod_chips(hand_chips * 2)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_catalyst then
                                    hand_chips = mod_chips(hand_chips * 3)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                    G.GAME.dollars = G.GAME.dollars + 1
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_hardstone then
                                    hand_chips = mod_chips(100)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_bedrock then
                                    hand_chips = mod_chips(1000)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_chromaticplatinum then
                                    hand_chips = mod_chips(hand_chips ^ 12)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_omnichromatic then
                                    hand_chips = mod_chips(hand_chips ^ 12)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_chromaticastral then
                                    hand_chips = mod_chips(hand_chips ^ 1.5)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_shadowing then
                                    hand_chips = mod_chips(hand_chips ^ 3)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_graymatter then
                                    hand_chips = mod_chips(hand_chips ^ 6)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_blister then
                                    hand_chips = mod_chips(hand_chips + 500)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_galvanized then
                                    hand_chips = mod_chips(hand_chips + 1000)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_metallic then
                                    G.GAME.dollars = G.GAME.dollars + 10
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_tvghost then
                                    hand_chips = mod_chips(hand_chips + 60)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                    G.GAME.dollars = G.GAME.dollars * 1.25
                                end
                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_noisy then
                                    hand_chips = mod_chips(hand_chips * 50)
                                    update_hand_text({delay = 0}, {chips = hand_chips})
                                    G.GAME.dollars = G.GAME.dollars * 1.25
                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_astral then
                                                                    local pow_mult = G.P_CENTERS.e_cry_astral.config.pow_mult
                                                                    mult = mod_mult(mult ^ pow_mult)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    card_eval_status_text(G.jokers.cards[i], 'extra', nil, percent, nil,
                                                                    {message = '^'..pow_mult..' Mult',
                                                                    edition = true,
                                                                    pow_mult = true})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_hyperastral then
                                                                    local pow_mult = G.P_CENTERS.e_cry_hyperastral.config.pow_mult
                                                                    mult = mod_mult(mult ^ pow_mult)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    card_eval_status_text(G.jokers.cards[i], 'extra', nil, percent, nil,
                                                                    {message = '^'..pow_mult..' Mult',
                                                                    edition = true,
                                                                    pow_mult = true})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_cosmic then
                                                                    local pow_mult = G.P_CENTERS.e_cry_cosmic.config.pow_mult
                                                                    mult = mod_mult(mult ^ pow_mult)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    card_eval_status_text(G.jokers.cards[i], 'extra', nil, percent, nil,
                                                                    {message = '^'..pow_mult..' Mult',
                                                                    edition = true,
                                                                    pow_mult = true})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_hypercosmic then
                                                                    local pow_mult = G.P_CENTERS.e_cry_hypercosmic.config.pow_mult
                                                                    mult = mod_mult(mult ^ pow_mult)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    card_eval_status_text(G.jokers.cards[i], 'extra', nil, percent, nil,
                                                                    {message = '^'..pow_mult..' Mult',
                                                                    edition = true,
                                                                    pow_mult = true})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_darkmatter then
                                                                    local pow_mult = G.P_CENTERS.e_cry_darkmatter.config.pow_mult
                                                                    mult = mod_mult(mult ^ pow_mult)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    card_eval_status_text(G.jokers.cards[i], 'extra', nil, percent, nil,
                                                                    {message = '^'..pow_mult..' Mult',
                                                                    edition = true,
                                                                    pow_mult = true})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_darkvoid then
                                                                    local pow_mult = G.P_CENTERS.e_cry_darkvoid.config.pow_mult
                                                                    mult = mod_mult(mult ^ pow_mult)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    card_eval_status_text(G.jokers.cards[i], 'extra', nil, percent, nil,
                                                                    {message = '^'..pow_mult..' Mult',
                                                                    edition = true,
                                                                    pow_mult = true})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_darkvoid_balavirus then
                                                                    local pow_mult = G.P_CENTERS.e_cry_darkvoid_balavirus.config.pow_mult
                                                                    mult = mod_mult(mult ^ pow_mult)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    card_eval_status_text(G.jokers.cards[i], 'extra', nil, percent, nil,
                                                                    {message = '^'..pow_mult..' Mult',
                                                                    edition = true,
                                                                    pow_mult = true})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_bailiff then
                                                                    local pow_mult = G.P_CENTERS.e_cry_bailiff.config.Xmult
                                                                    mult = mod_mult(mult ^ 0)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                                                                    {message = 'X'..pow_mult..' Mult',
                                                                    edition = true,
                                                                    pow_mult = true})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_duplicated then
                                                                    local xscore = G.P_CENTERS.e_cry_duplicated.config.Xscore
                                                                    mult = mod_mult(mult * 2)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil,
                                                                    {message = 'X'..xscore..' Mult',
                                                                    edition = true,
                                                                    Xscore = true})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_psychedelic then
                                                                    G.GAME.current_round.hands_left = G.GAME.current_round.hands_left ^ 2
                                                                    G.GAME.current_round.discards_left = G.GAME.current_round.discards_left ^ 2
                                                                    mult = mod_mult(mult ^ 40)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    G.GAME.dollars = G.GAME.dollars ^ 40
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_psychedelic_balavirus then
                                                                    G.GAME.current_round.hands_left = G.GAME.current_round.hands_left ^ 10
                                                                    G.GAME.current_round.discards_left = G.GAME.current_round.discards_left ^ 10
                                                                    mult = mod_mult(mult ^ (1e+10))
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    G.GAME.dollars = G.GAME.dollars ^ (1e+10)
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_brilliant then
                                                                    mult = mod_mult(mult * 2)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + 1
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_rainbow then
                                                                    mult = mod_mult(mult * 15)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_chromaticimpulsion then
                                                                    mult = mod_mult(mult ^ 1.5)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    G.GAME.dollars = G.GAME.dollars ^ 1.5
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_root then
                                                                    mult = mod_mult(mult ^ 0.5)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_hardstone then
                                                                    mult = mod_mult(100)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_bedrock then
                                                                    mult = mod_mult(1000)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_hyperchrome then
                                                                    mult = mod_mult(mult * 512)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_shadowing then
                                                                    mult = mod_mult(mult ^ 0.5)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_graymatter then
                                                                    mult = mod_mult(mult ^ 0.75)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_titanium then
                                                                    mult = mod_mult(mult + 20)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    G.GAME.dollars = G.GAME.dollars + 15
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_chromaticplatinum then
                                                                    mult = mod_mult(mult ^ 12)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + 2
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_chromaticastral then
                                                                    mult = mod_mult(mult ^ 1.5)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_omnichromatic then
                                                                    mult = mod_mult(mult ^ 12)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                    G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + 2
                                                                    G.GAME.dollars = G.GAME.dollars * 2
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_lefthanded then
                                                                    local Xhand = G.P_CENTERS.e_cry_lefthanded.config.Xhand
                                                                    G.GAME.round_resets.hands = G.GAME.round_resets.hands + 0.15
                                                                    G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 0.15
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_righthanded then
                                                                    local xdiscard = G.P_CENTERS.e_cry_righthanded.config.Xdiscard
                                                                    G.GAME.round_resets.discards = G.GAME.round_resets.discards + 0.15
                                                                    G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + 0.15
                                                                end
                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition and G.jokers.cards[i].edition.cry_galvanized then
                                                                    mult = mod_mult(mult * 3)
                                                                    update_hand_text({delay = 0}, {mult = mult})
                                                                end
                                                                                                                                if G.jokers.cards and G.jokers.cards[i] and G.jokers.cards[i].edition then
                                                                                                                                	local trg = G.jokers.cards[i]
                                                                                                                                	local edi = trg.edition
                                                                                                                                	if edi.x_chips then
                                                                                                                                		hand_chips = mod_chips(hand_chips * edi.x_chips)
                                                                                                                                		update_hand_text({delay = 0}, {chips = hand_chips})
                                                                                                                                		card_eval_status_text(trg, 'extra', nil, percent, nil,
                                                                                                                                		{message = 'X'.. edi.x_chips ..' Chips',
                                                                                                                                		edition = true,
                                                                                                                                		x_chips = true})
                                                                                                                                	end
                                                                                                                                	if edi.e_chips then
                                                                                                                                		hand_chips = mod_chips(hand_chips ^ edi.e_chips)
                                                                                                                                		update_hand_text({delay = 0}, {chips = hand_chips})
                                                                                                                                		card_eval_status_text(trg, 'extra', nil, percent, nil,
                                                                                                                                		{message = '^'.. edi.e_chips ..' Chips',
                                                                                                                                		edition = true,
                                                                                                                                		e_chips = true})
                                                                                                                                	end
                                                                                                                                	if edi.ee_chips then
                                                                                                                                		hand_chips = mod_chips(hand_chips:arrow(2, edi.ee_chips))
                                                                                                                                		update_hand_text({delay = 0}, {chips = hand_chips})
                                                                                                                                		card_eval_status_text(trg, 'extra', nil, percent, nil,
                                                                                                                                		{message = '^^'.. edi.ee_chips ..' Chips',
                                                                                                                                		edition = true,
                                                                                                                                		ee_chips = true})
                                                                                                                                	end
                                                                                                                                	if edi.eee_chips then
                                                                                                                                		hand_chips = mod_chips(hand_chips:arrow(3, edi.eee_chips))
                                                                                                                                		update_hand_text({delay = 0}, {chips = hand_chips})
                                                                                                                                		card_eval_status_text(trg, 'extra', nil, percent, nil,
                                                                                                                                		{message = '^^^'.. edi.eee_chips ..' Chips',
                                                                                                                                		edition = true,
                                                                                                                                		eee_chips = true})
                                                                                                                                	end
                                                                                                                                	if edi.hyper_chips and type(edi.hyper_chips) == 'table' then
                                                                                                                                		hand_chips = mod_chips(hand_chips:arrow(edi.hyper_chips[1], edi.hyper_chips[2]))
                                                                                                                                		update_hand_text({delay = 0}, {chips = hand_chips})
                                                                                                                                		card_eval_status_text(trg, 'extra', nil, percent, nil,
                                                                                                                                		{message = (edi.hyper_chips[1] > 5 and ('{' .. edi.hyper_chips[1] .. '}') or string.rep('^', edi.hyper_chips[1])) .. edi.hyper_chips[2] ..' Chips',
                                                                                                                                		edition = true,
                                                                                                                                		eee_chips = true})
                                                                                                                                	end
                                                                                                                                	if edi.e_mult then
                                                                                                                                		mult = mod_mult(mult ^ edi.e_mult)
                                                                                                                                		update_hand_text({delay = 0}, {mult = mult})
                                                                                                                                		card_eval_status_text(trg, 'extra', nil, percent, nil,
                                                                                                                                		{message = '^'.. edi.e_mult ..' Mult',
                                                                                                                                		edition = true,
                                                                                                                                		e_mult = true})
                                                                                                                                	end
                                                                                                                                	if edi.ee_mult then
                                                                                                                                		mult = mod_mult(mult:arrow(2, edi.ee_mult))
                                                                                                                                		update_hand_text({delay = 0}, {mult = mult})
                                                                                                                                		card_eval_status_text(trg, 'extra', nil, percent, nil,
                                                                                                                                		{message = '^^'.. edi.ee_mult ..' Mult',
                                                                                                                                		edition = true,
                                                                                                                                		ee_mult = true})
                                                                                                                                	end
                                                                                                                                	if edi.eee_mult then
                                                                                                                                		mult = mod_mult(mult:arrow(3, edi.eee_mult))
                                                                                                                                		update_hand_text({delay = 0}, {mult = mult})
                                                                                                                                		card_eval_status_text(trg, 'extra', nil, percent, nil,
                                                                                                                                		{message = '^^^'.. edi.eee_mult ..' Mult',
                                                                                                                                		edition = true,
                                                                                                                                		eee_mult = true})
                                                                                                                                	end
                                                                                                                                	if edi.hyper_mult and type(edi.hyper_mult) == 'table' then
                                                                                                                                		mult = mod_mult(mult:arrow(edi.hyper_mult[1], edi.hyper_mult[2]))
                                                                                                                                		update_hand_text({delay = 0}, {mult = mult})
                                                                                                                                		card_eval_status_text(trg, 'extra', nil, percent, nil,
                                                                                                                                		{message = (edi.hyper_mult[1] > 5 and ('{' .. edi.hyper_mult[1] .. '}') or string.rep('^', edi.hyper_mult[1])) .. edi.hyper_mult[2] ..' Mult',
                                                                                                                                		edition = true,
                                                                                                                                		hyper_mult = true})
                                                                                                                                	end
                                                                                                                                end
                                                                                                                                                                                                                                                                if edition_effects.jokers.x_mult_mod then
                    mult = mod_mult(mult*edition_effects.jokers.x_mult_mod)
                    update_hand_text({delay = 0}, {mult = mult})
                    card_eval_status_text(_card, 'jokers', nil, percent, nil, {
                        message = localize{type='variable',key='a_xmult',vars={edition_effects.jokers.x_mult_mod}},
                        x_mult_mod =  edition_effects.jokers.x_mult_mod,
                        colour =  G.C.EDITION,
                        edition = true})
                        if (effects and effects[ii] and effects[ii].edition and effects[ii].edition.x_mult_mod or edition_effects and edition_effects.jokers and edition_effects.jokers.x_mult_mod) and next(find_joker("cry-Exponentia")) then
                            for _, v in pairs(find_joker("cry-Exponentia")) do
                                v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                                card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                            end
                        end
                                        end
                percent = percent+percent_delta
            end
        end

        if G.betmma_abilities then
            for i=1,#G.betmma_abilities.cards do
                local _card=G.betmma_abilities.cards[i]
                local effects = eval_card(_card, {
                    cardarea = G.jokers,
                    full_hand = G.play.cards,
                    scoring_hand = scoring_hand,
                    scoring_name = text,
                    poker_hands = poker_hands,
                    joker_main = true
                })
            
                -- Any Joker effects
                if effects.jokers then
                    local extras = {
                        mult = false,
                        hand_chips = false
                    }
                    if effects.jokers.mult_mod then
                        mult = mod_mult(mult + effects.jokers.mult_mod);
                        extras.mult = true
                    end
                    if effects.jokers.chip_mod then
                        hand_chips = mod_chips(hand_chips + effects.jokers.chip_mod);
                        extras.hand_chips = true
                    end
                    if effects.jokers.Xmult_mod then
                        mult = mod_mult(mult * effects.jokers.Xmult_mod);
                        extras.mult = true
                    end
                    if effects.jokers.pow_mult_mod then
                        mult = mod_mult(mult ^ effects.jokers.pow_mult_mod);
                        extras.mult = true
                    end
                    if effects.jokers.Xchip_mod then
                        hand_chips = mod_chips(hand_chips * effects.jokers.Xchip_mod);
                        extras.hand_chips = true
                    end
                    update_hand_text({
                        delay = 0
                    }, {
                        chips = extras.hand_chips and hand_chips,
                        mult = extras.mult and mult
                    })
                    card_eval_status_text(_card, 'jokers', nil, percent, nil, effects.jokers)
                    if effects.jokers.joker_repetitions then
                        rep_list = effects.jokers.joker_repetitions
                        for z=1, #rep_list do
                            if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                                for r=1, rep_list[z].repetitions do
                                    card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                                    if percent then percent = percent+percent_delta end
                    
                                    local ef = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, joker_main = true, retrigger_joker = true})
                    
                                    --Any Joker effects
                                    if ef.jokers then 
                                        local extras = {mult = false, hand_chips = false}
                                        if ef.jokers.mult_mod then mult = mod_mult(mult + ef.jokers.mult_mod);extras.mult = true end
                                        if ef.jokers.chip_mod then hand_chips = mod_chips(hand_chips + ef.jokers.chip_mod);extras.hand_chips = true end
                                        if ef.jokers.Xmult_mod then mult = mod_mult(mult*ef.jokers.Xmult_mod);extras.mult = true  end
                                        if ef.jokers.pow_mult_mod then mult = mod_mult(mult^ef.jokers.pow_mult_mod);extras.mult = true  end
                                        if ef.jokers.Xchip_mod then hand_chips = mod_chips(hand_chips*ef.jokers.Xchip_mod);extras.hand_chips = true  end
                                        update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult})
                                        card_eval_status_text(_card, 'jokers', nil, percent, nil, effects.jokers)
                                        --Exponentia
                                        if ef.jokers.Xmult_mod and ef.jokers.Xmult_mod ~= 1 and next(find_joker("cry-Exponentia")) then
                                            for _, v in pairs(find_joker("cry-Exponentia")) do
                                                v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                                                card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                                            end
                                        end
                                        if percent then percent = percent+percent_delta end
                                    end
                                end
                            end
                        end
                    end
                                        if effects.jokers.Xmult_mod and effects.jokers.Xmult_mod ~= 1 and next(find_joker("cry-Exponentia")) then
                        for _, v in pairs(find_joker("cry-Exponentia")) do
                            v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                            card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                        end
                    end
                                        if effects.jokers.joker_repetitions then
                        rep_list = effects.jokers.joker_repetitions
                        for z = 1, #rep_list do
                            if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                                for r = 1, rep_list[z].repetitions do
                                    card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                                    if percent then
                                        percent = percent + percent_delta
                                    end
            
                                    local ef = eval_card(_card, {
                                        cardarea = G.betmma_abilities,
                                        full_hand = G.play.cards,
                                        scoring_hand = scoring_hand,
                                        scoring_name = text,
                                        poker_hands = poker_hands,
                                        joker_main = true,
                                        retrigger_joker = true
                                    })
            
                                    -- Any Joker effects
                                    if ef.jokers then
                                        local extras = {
                                            mult = false,
                                            hand_chips = false
                                        }
                                        if ef.jokers.mult_mod then
                                            mult = mod_mult(mult + ef.jokers.mult_mod);
                                            extras.mult = true
                                        end
                                        if ef.jokers.chip_mod then
                                            hand_chips = mod_chips(hand_chips + ef.jokers.chip_mod);
                                            extras.hand_chips = true
                                        end
                                        if ef.jokers.Xmult_mod then
                                            mult = mod_mult(mult * ef.jokers.Xmult_mod);
                                            extras.mult = true
                                        end
                                        if ef.jokers.pow_mult_mod then
                                            mult = mod_mult(mult ^ ef.jokers.pow_mult_mod);
                                            extras.mult = true
                                        end
                                        if ef.jokers.Xchip_mod then
                                            hand_chips = mod_chips(hand_chips * ef.jokers.Xchip_mod);
                                            extras.hand_chips = true
                                        end
                                        update_hand_text({
                                            delay = 0
                                        }, {
                                            chips = extras.hand_chips and hand_chips,
                                            mult = extras.mult and mult
                                        })
                                        card_eval_status_text(_card, 'jokers', nil, percent, nil, effects.jokers)
                                        if effects.jokers.joker_repetitions then
                                            rep_list = effects.jokers.joker_repetitions
                                            for z=1, #rep_list do
                                                if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                                                    for r=1, rep_list[z].repetitions do
                                                        card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                                                        if percent then percent = percent+percent_delta end
                                        
                                                        local ef = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, joker_main = true, retrigger_joker = true})
                                        
                                                        --Any Joker effects
                                                        if ef.jokers then 
                                                            local extras = {mult = false, hand_chips = false}
                                                            if ef.jokers.mult_mod then mult = mod_mult(mult + ef.jokers.mult_mod);extras.mult = true end
                                                            if ef.jokers.chip_mod then hand_chips = mod_chips(hand_chips + ef.jokers.chip_mod);extras.hand_chips = true end
                                                            if ef.jokers.Xmult_mod then mult = mod_mult(mult*ef.jokers.Xmult_mod);extras.mult = true  end
                                                            if ef.jokers.pow_mult_mod then mult = mod_mult(mult^ef.jokers.pow_mult_mod);extras.mult = true  end
                                                            if ef.jokers.Xchip_mod then hand_chips = mod_chips(hand_chips*ef.jokers.Xchip_mod);extras.hand_chips = true  end
                                                            update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult})
                                                            card_eval_status_text(_card, 'jokers', nil, percent, nil, effects.jokers)
                                                            --Exponentia
                                                            if ef.jokers.Xmult_mod and ef.jokers.Xmult_mod ~= 1 and next(find_joker("cry-Exponentia")) then
                                                                for _, v in pairs(find_joker("cry-Exponentia")) do
                                                                    v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                                                                    card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                                                                end
                                                            end
                                                            if percent then percent = percent+percent_delta end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                                                                if effects.jokers.Xmult_mod and effects.jokers.Xmult_mod ~= 1 and next(find_joker("cry-Exponentia")) then
                                            for _, v in pairs(find_joker("cry-Exponentia")) do
                                                v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                                                card_eval_status_text(v, 'extra', nil, nil, nil, {message = "^"..v.ability.extra.pow_mult.." Mult"})
                                            end
                                        end
                                                                                -- Exponentia
                                        if ef.jokers.Xmult_mod and ef.jokers.Xmult_mod ~= 1 and next(find_joker("cry-Exponentia")) then
                                            for _, v in pairs(find_joker("cry-Exponentia")) do
                                                v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                                                card_eval_status_text(v, 'extra', nil, nil, nil, {
                                                    message = "^" .. v.ability.extra.pow_mult .. " Mult"
                                                })
                                            end
                                        end
                                        if percent then
                                            percent = percent + percent_delta
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if effects.jokers.Xmult_mod and effects.jokers.Xmult_mod ~= 1 and next(find_joker("cry-Exponentia")) then
                        for _, v in pairs(find_joker("cry-Exponentia")) do
                            v.ability.extra.pow_mult = v.ability.extra.pow_mult + v.ability.extra.pow_mult_mod
                            card_eval_status_text(v, 'extra', nil, nil, nil, {
                                message = "^" .. v.ability.extra.pow_mult .. " Mult"
                            })
                        end
                    end
                    percent = percent+percent_delta
                end
            end
            
        end
                local nu_chip, nu_mult = G.GAME.selected_back:trigger_effect{context = 'final_scoring_step', chips = hand_chips, mult = mult}
        mult = mod_mult(nu_mult or mult)
        hand_chips = mod_chips(nu_chip or hand_chips)

        local cards_destroyed = {}
        for i=1, #scoring_hand do
            local destroyed = nil
            --un-highlight all cards
            highlight_card(scoring_hand[i],(i-0.999)/(#scoring_hand-0.998),'down')

            for j = 1, #G.jokers.cards do
                destroyed = G.jokers.cards[j]:calculate_joker({destroying_card = scoring_hand[i], full_hand = G.play.cards})
                if destroyed and destroyed.joker_repetitions then
                    rep_list = destroyed.joker_repetitions
                    for z=1, #rep_list do
                        if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                            for r=1, rep_list[z].repetitions do
                                card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                                if percent then percent = percent+percent_delta end
                                G.jokers.cards[j]:calculate_joker({destroying_card = scoring_hand[i], full_hand = G.play.cards})
                            end
                        end
                    end
                end
                                if destroyed then break end
            end

            if ((scoring_hand[i].ability.name == 'Glass Card' and not scoring_hand[i].debuff and pseudorandom('glass') < G.GAME.probabilities.normal/scoring_hand[i].ability.extra) or (G.GAME.modifiers.cry_shatter_rate and pseudorandom('cry_shatter') < 1/G.GAME.modifiers.cry_shatter_rate)) and not scoring_hand[i].ability.eternal then
                destroyed = true
            end
            if scoring_hand[i]:calculate_seal({destroying_card = scoring_hand[i], full_hand = G.play.cards}) then
                destroyed = true
            end

            if destroyed then 
                if scoring_hand[i].ability.name == 'Glass Card' then 
                    scoring_hand[i].shattered = true
                else 
                    scoring_hand[i].destroyed = true
                end 
                cards_destroyed[#cards_destroyed+1] = scoring_hand[i]
            end
        end
        for j=1, #G.jokers.cards do
            local eval = eval_card(G.jokers.cards[j], {cardarea = G.jokers, remove_playing_cards = true, removed = cards_destroyed})
            if eval and eval.jokers and eval.jokers.joker_repetitions then
                rep_list = eval.jokers.joker_repetitions
                for z=1, #rep_list do
                    if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                        for r=1, rep_list[z].repetitions do
                            card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                            if percent then percent = percent+percent_delta end
                            eval_card(G.jokers.cards[j], {cardarea = G.jokers, remove_playing_cards = true, removed = cards_destroyed, retrigger_joker = true})
                        end
                    end
                end
            end
                    end

        local glass_shattered = {}
        for k, v in ipairs(cards_destroyed) do
            if v.shattered then glass_shattered[#glass_shattered+1] = v end
        end

        check_for_unlock{type = 'shatter', shattered = glass_shattered}
        
        for i=1, #cards_destroyed do
            G.E_MANAGER:add_event(Event({
                func = function()
                    if cards_destroyed[i].ability.name == 'Glass Card' then 
                        cards_destroyed[i]:shatter()
                    else
                        cards_destroyed[i]:start_dissolve()
                    end
                  return true
                end
              }))
        end
    else
        mult = mod_mult(0)
        hand_chips = mod_chips(0)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                SMODS.juice_up_blind()
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
                return true
            end)
        }))

        play_area_status_text("Not Allowed!")--localize('k_not_allowed_ex'), true)
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        --Joker Debuff Effects
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        for i=1, #G.jokers.cards do
            
            --calculate the joker effects
            local effects = eval_card(G.jokers.cards[i], {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, debuffed_hand = true})
            if effects and effects.jokers and effects.jokers.joker_repetitions then
                rep_list = effects.jokers.joker_repetitions
                for z=1, #rep_list do
                    if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                        for r=1, rep_list[z].repetitions do
                            card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                            if percent then percent = percent+percent_delta end
                            local ef = eval_card(G.jokers.cards[i], {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, debuffed_hand = true, retrigger_joker = true})
            
                            --Any Joker effects
                            if ef.jokers then
                                card_eval_status_text(G.jokers.cards[i], 'jokers', nil, percent, nil, ef.jokers)
                                if percent then percent = percent+percent_delta end
                            end
                        end
                    end
                end
            end
            
            --Any Joker effects
            if effects.jokers then
                card_eval_status_text(G.jokers.cards[i], 'jokers', nil, percent, nil, effects.jokers)
                percent = percent+percent_delta
            end
        end
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'after',delay = 0.4,
        func = (function()  update_hand_text({delay = 0, immediate = true}, {mult = 0, chips = 0, chip_total = G.GAME.blind.cry_cap_score and G.GAME.blind:cry_cap_score(math.floor(hand_chips*mult)) or math.floor(hand_chips*mult), level = '', handname = ''});play_sound('button', 0.9, 0.6);return true end)
      }))
      check_and_set_high_score('hand', hand_chips*mult)

      check_for_unlock({type = 'chip_score', chips = math.floor(hand_chips*mult)})
   
    if to_big(hand_chips)*mult > to_big(0) then
        delay(0.8)
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function() play_sound('chips2');return true end)
        }))
    end
    G.E_MANAGER:add_event(Event({
      trigger = 'ease',
      blocking = false,
      ref_table = G.GAME,
      ref_value = 'chips',
      ease_to = G.GAME.chips + (G.GAME.blind.cry_cap_score and G.GAME.blind:cry_cap_score(math.floor(hand_chips*mult)) or math.floor(hand_chips*mult)),
      delay =  0.5,
      func = (function(t) return math.floor(t) end)
    }))
    G.E_MANAGER:add_event(Event({
      trigger = 'ease',
      blocking = true,
      ref_table = G.GAME.current_round.current_hand,
      ref_value = 'chip_total',
      ease_to = 0,
      delay =  0.5,
      func = (function(t) return math.floor(t) end)
    }))
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = (function() G.GAME.current_round.current_hand.handname = '';return true end)
    }))
    delay(0.3)

    for i=1, #G.jokers.cards do
        --calculate the joker after hand played effects
        local effects = eval_card(G.jokers.cards[i], {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, after = true})
        if effects and effects.jokers and effects.jokers.joker_repetitions then
            rep_list = effects.jokers.joker_repetitions
            for z=1, #rep_list do
                if type(rep_list[z]) == 'table' and rep_list[z].repetitions then
                    for r=1, rep_list[z].repetitions do
                        card_eval_status_text(rep_list[z].card, 'jokers', nil, nil, nil, rep_list[z])
                        if percent then percent = percent+percent_delta end
                        local ef = eval_card(G.jokers.cards[i], {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, after = true, retrigger_joker = true})
        
                        --Any Joker effects
                        if ef.jokers then
                            card_eval_status_text(G.jokers.cards[i], 'jokers', nil, percent, nil, ef.jokers)
                            if percent then percent = percent+percent_delta end
                        end
                    end
                end
            end
        end
                if effects.jokers then
            card_eval_status_text(G.jokers.cards[i], 'jokers', nil, percent, nil, effects.jokers)
            percent = percent + percent_delta
        end
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()     
            if G.GAME.modifiers.debuff_played_cards then 
                for k, v in ipairs(scoring_hand) do v.ability.perma_debuff = true end
            end
        return true end)
      }))

  end
  
  G.FUNCS.draw_from_play_to_discard = function(e)
    local play_count = #G.play.cards
    local it = 1
    for k, v in ipairs(G.play.cards) do
        if (not v.shattered) and (not v.destroyed) then 
            draw_card(G.play,G.discard, it*100/play_count,'down', false, v)
            it = it + 1
        end
    end
  end

  G.FUNCS.draw_from_play_to_hand = function(cards)
    local gold_count = #cards
    for i=1, gold_count do --draw cards from play
        if not cards[i].shattered and not cards[i].destroyed then
            draw_card(G.play,G.hand, i*100/gold_count,'up', true, cards[i])
        end
    end
  end
  
  G.FUNCS.draw_from_discard_to_deck = function(e)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            local discard_count = #G.discard.cards
            for i=1, discard_count do --draw cards from deck
                draw_card(G.discard, G.deck, i*100/discard_count,'up', nil ,nil, 0.005, i%2==0, nil, math.max((21-i)/20,0.7))
            end
            return true
        end
      }))
  end

  G.FUNCS.draw_from_hand_to_deck = function(e)
    local hand_count = #G.hand.cards
    for i=1, hand_count do --draw cards from deck
        draw_card(G.hand, G.deck, i*100/hand_count,'down', nil, nil,  0.08)
    end
  end
  
  G.FUNCS.draw_from_hand_to_discard = function(e)
    local hand_count = #G.hand.cards
    for i=1, hand_count do
        draw_card(G.hand,G.discard, i*100/hand_count,'down', nil, nil, 0.07)
    end
end

G.FUNCS.evaluate_round = function()
    local pitch = 0.95
    local dollars = 0

    if to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) then
        add_round_eval_row({dollars = G.GAME.blind.dollars, name='blind1', pitch = pitch, above_dot_bar = true})
        pitch = pitch + 0.06
        dollars = dollars + G.GAME.blind.dollars
    else
        add_round_eval_row({dollars = 0, name='blind1', pitch = pitch, saved = true, above_dot_bar = true})
        pitch = pitch + 0.06
    end

    for k, v in pairs(SMODS.DollarRows) do
        if v and v.payout and type(v.payout) == 'function' and v.above_dot_bar then
            money_gained = v:payout()
            add_round_eval_row({dollars = money_gained, bonus = true, name='payout_arg_'..v.key,pitch = pitch, payout_arg = v, above_dot_bar = true})
            pitch = pitch + 0.06
            dollars = dollars + money_gained
        end
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 1.3*math.min(G.GAME.blind.dollars+2, 7)/2*0.15 + 0.5,
        func = function()
          G.GAME.blind:defeat()
          return true
        end
      }))
    delay(0.2)
    G.E_MANAGER:add_event(Event({
        func = function()
            ease_background_colour_blind(G.STATES.ROUND_EVAL, '')
            return true
        end
    }))
    G.GAME.selected_back:trigger_effect({context = 'eval'})

    if G.GAME.current_round.hands_left > 0 and not G.GAME.modifiers.no_extra_hand_money then
        add_round_eval_row({dollars = G.GAME.current_round.hands_left*(G.GAME.modifiers.money_per_hand or 1), disp = G.GAME.current_round.hands_left, bonus = true, name='hands', pitch = pitch})
        pitch = pitch + 0.06
        dollars = dollars + G.GAME.current_round.hands_left*(G.GAME.modifiers.money_per_hand or 1)
    end
    if G.GAME.current_round.discards_left > 0 and G.GAME.modifiers.money_per_discard then
        add_round_eval_row({dollars = G.GAME.current_round.discards_left*(G.GAME.modifiers.money_per_discard), disp = G.GAME.current_round.discards_left, bonus = true, name='discards', pitch = pitch})
        pitch = pitch + 0.06
        dollars = dollars +  G.GAME.current_round.discards_left*(G.GAME.modifiers.money_per_discard)
    end
    for k, v in pairs(SMODS.DollarRows) do
        if v and v.payout and type(v.payout) == 'function' and not v.above_dot_bar then
            money_gained = v:payout()
            add_round_eval_row({dollars = money_gained, bonus = true, name='payout_arg_'..v.key,pitch = pitch, payout_arg = v})
            pitch = pitch + 0.06
            dollars = dollars + money_gained
        end
    end
    for i = 1, #G.jokers.cards do
        local ret = G.jokers.cards[i]:calculate_dollar_bonus()
        if ret then
            add_round_eval_row({dollars = ret, bonus = true, name='joker'..i, pitch = pitch, card = G.jokers.cards[i]})
            pitch = pitch + 0.06
            dollars = dollars + ret
        end
    end
    for i = 1, #G.GAME.tags do
        local ret = G.GAME.tags[i]:apply_to_run({type = 'eval'})
        if ret then
            add_round_eval_row({dollars = ret.dollars, bonus = true, name='tag'..i, pitch = pitch, condition = ret.condition, pos = ret.pos, tag = ret.tag})
            pitch = pitch + 0.06
            dollars = dollars + ret.dollars
        end
    end
    if G.GAME.dollars >= 5 and not G.GAME.modifiers.no_interest and G.GAME.cry_payload then
        add_round_eval_row({bonus = true, payload = G.GAME.cry_payload, name='interest_payload', pitch = pitch, dollars = G.GAME.interest_amount*G.GAME.cry_payload*math.min(math.floor(G.GAME.dollars/5), G.GAME.interest_cap/5)})
        pitch = pitch + 0.06
        if not G.GAME.seeded and not G.GAME.challenge then
            if G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/5), G.GAME.interest_cap/5) == G.GAME.interest_amount*G.GAME.interest_cap/5 then 
                G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak = G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak + 1
            else
                G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak = 0
            end
        end
        check_for_unlock({type = 'interest_streak'})
        dollars = dollars + G.GAME.interest_amount*G.GAME.cry_payload*math.min(math.floor(G.GAME.dollars/5), G.GAME.interest_cap/5)
        G.GAME.cry_payload = nil
    elseif G.GAME.dollars >= 5 and not G.GAME.modifiers.no_interest then
        add_round_eval_row({bonus = true, name='interest', pitch = pitch, dollars = G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/5), G.GAME.interest_cap/5)})
        pitch = pitch + 0.06
        if not G.GAME.seeded and not G.GAME.challenge then
            if G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/5), G.GAME.interest_cap/5) == G.GAME.interest_amount*G.GAME.interest_cap/5 then 
                G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak = G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak + 1
            else
                G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak = 0
            end
        end
        check_for_unlock({type = 'interest_streak'})
        dollars = dollars + G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/5), G.GAME.interest_cap/5)
    end

    pitch = pitch + 0.06

    add_round_eval_row({name = 'bottom', dollars = dollars})
    Talisman.dollars = dollars
end

G.FUNCS.tutorial_controller = function()
    if G.F_SKIP_TUTORIAL then
        G.SETTINGS.tutorial_complete = true
        G.SETTINGS.tutorial_progress = nil
        return
    end
    G.SETTINGS.tutorial_progress = G.SETTINGS.tutorial_progress or 
    {
        forced_shop = {'j_joker', 'c_empress'},
        forced_voucher = 'v_grabber',
        forced_tags = {'tag_handy', 'tag_garbage'},
        hold_parts = {},
        completed_parts = {},
    }
    if not G.SETTINGS.paused and (not G.SETTINGS.tutorial_complete) then
        if G.STATE == G.STATES.BLIND_SELECT and G.blind_select and not G.SETTINGS.tutorial_progress.completed_parts['small_blind'] then
            G.SETTINGS.tutorial_progress.section = 'small_blind'
            G.FUNCS.tutorial_part('small_blind')
            G.SETTINGS.tutorial_progress.completed_parts['small_blind']  = true
            G:save_progress()
        end
        if G.STATE == G.STATES.BLIND_SELECT and G.blind_select and not G.SETTINGS.tutorial_progress.completed_parts['big_blind'] and G.GAME.round > 0 then
            G.SETTINGS.tutorial_progress.section = 'big_blind'
            G.FUNCS.tutorial_part('big_blind')
            G.SETTINGS.tutorial_progress.completed_parts['big_blind']  = true
            G.SETTINGS.tutorial_progress.forced_tags = nil
            G:save_progress()
        end
        if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['second_hand'] and G.SETTINGS.tutorial_progress.hold_parts['big_blind'] then
            G.SETTINGS.tutorial_progress.section = 'second_hand'
            G.FUNCS.tutorial_part('second_hand')
            G.SETTINGS.tutorial_progress.completed_parts['second_hand']  = true
            G:save_progress()
        end
        if G.SETTINGS.tutorial_progress.hold_parts['second_hand'] then
            G.SETTINGS.tutorial_complete = true
        end
        if not G.SETTINGS.tutorial_progress.completed_parts['first_hand_section'] then 
            if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['first_hand'] then
                G.SETTINGS.tutorial_progress.section = 'first_hand'
                G.FUNCS.tutorial_part('first_hand')
                G.SETTINGS.tutorial_progress.completed_parts['first_hand']  = true
                G:save_progress()
            end
            if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['first_hand_2'] and G.SETTINGS.tutorial_progress.hold_parts['first_hand']  then
                G.FUNCS.tutorial_part('first_hand_2')
                G.SETTINGS.tutorial_progress.completed_parts['first_hand_2']  = true
                G:save_progress()
            end
            if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['first_hand_3'] and G.SETTINGS.tutorial_progress.hold_parts['first_hand_2']  then
                G.FUNCS.tutorial_part('first_hand_3')
                G.SETTINGS.tutorial_progress.completed_parts['first_hand_3']  = true
                G:save_progress()
            end
            if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['first_hand_4'] and G.SETTINGS.tutorial_progress.hold_parts['first_hand_3']  then
                G.FUNCS.tutorial_part('first_hand_4')
                G.SETTINGS.tutorial_progress.completed_parts['first_hand_4']  = true
                G.SETTINGS.tutorial_progress.completed_parts['first_hand_section']  = true
                G:save_progress()
            end
        end
         if G.STATE == G.STATES.SHOP and G.shop and G.shop.VT.y < 5 and not G.SETTINGS.tutorial_progress.completed_parts['shop_1'] then
            G.SETTINGS.tutorial_progress.section = 'shop'
            G.FUNCS.tutorial_part('shop_1')
            G.SETTINGS.tutorial_progress.completed_parts['shop_1']  = true
            G.SETTINGS.tutorial_progress.forced_voucher = nil
            G:save_progress()
        end
    end
end

G.FUNCS.tutorial_part = function(_part)
    local step = 1
    G.SETTINGS.paused = true
    if _part == 'small_blind' then 
        step = tutorial_info({
            text_key = 'sb_1',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'sb_2',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'sb_3',
            highlight = {
                G.blind_select.UIRoot.children[1].children[1].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[1].config.object:get_UIE_by_ID('blind_desc'),
            },
            attach = {major =  G.blind_select.UIRoot.children[1].children[1], type = 'tr', offset = {x = 2, y = 4}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'sb_4',
            highlight = {
                G.blind_select.UIRoot.children[1].children[1]
            },
            snap_to = function() 
                if G.blind_select and G.blind_select.UIRoot and G.blind_select.UIRoot.children[1] and G.blind_select.UIRoot.children[1].children[1] and G.blind_select.UIRoot.children[1].children[1].config.object then 
                    return G.blind_select.UIRoot.children[1].children[1].config.object:get_UIE_by_ID('select_blind_button') end
                end,
            attach = {major =  G.blind_select.UIRoot.children[1].children[1], type = 'tr', offset = {x = 2, y = 4}},
            step = step,
            no_button = true,
            button_listen = 'select_blind'
        })
    elseif _part == 'big_blind' then 
        step = tutorial_info({
            text_key = 'bb_1',
            highlight = {
                G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('blind_desc'),
            },
            hard_set = true,
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'bb_2',
            highlight = {
                G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('tag_desc'),
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'bb_3',
            highlight = {
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_desc'),
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'bb_4',
            highlight = {
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_desc'),
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_extras'),
                G.HUD:get_UIE_by_ID('hud_ante')
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'bb_5',
            loc_vars = {G.GAME.win_ante},
            highlight = {
                G.blind_select,
                G.HUD:get_UIE_by_ID('hud_ante')
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
            no_button = true,
            snap_to = function() 
                if G.blind_select and G.blind_select.UIRoot and G.blind_select.UIRoot.children[1] and G.blind_select.UIRoot.children[1].children[2] and
                G.blind_select.UIRoot.children[1].children[2].config.object then 
                    return G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('select_blind_button') end
                end,
            button_listen = 'select_blind'
        })
    elseif _part == 'first_hand' then
        step = tutorial_info({
            text_key = 'fh_1',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'fh_2',
            highlight = {
                G.HUD:get_UIE_by_ID('hand_text_area')
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'fh_3',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            highlight = {
                G.HUD:get_UIE_by_ID('run_info_button')
            },
            no_button = true,
            button_listen = 'run_info',
            snap_to = function() return G.HUD:get_UIE_by_ID('run_info_button') end,
            step = step,
        })
    elseif _part == 'first_hand_2' then
        step = tutorial_info({
            hard_set = true,
            text_key = 'fh_4',
            highlight = {
                G.hand,
                G.HUD:get_UIE_by_ID('run_info_button')
            },
            attach = {major = G.hand, type = 'cl', offset = {x = -1.5, y = 0}},
            snap_to = function() return G.hand.cards[1] end,
            step = step,
        })
        step = tutorial_info({
            text_key = 'fh_5',
            highlight = {
                G.hand,
                G.buttons:get_UIE_by_ID('play_button'),
                G.HUD:get_UIE_by_ID('run_info_button')
            },
            attach = {major = G.hand, type = 'cl', offset = {x = -1.5, y = 0}},
            no_button = true,
            button_listen = 'play_cards_from_highlighted',
            step = step,
        })
    elseif _part == 'first_hand_3' then
        step = tutorial_info({
            hard_set = true,
            text_key = 'fh_6',
            highlight = {
                G.hand,
                G.buttons:get_UIE_by_ID('discard_button'),
                G.HUD:get_UIE_by_ID('run_info_button')
            },
            attach = {major = G.hand, type = 'cl', offset = {x = -1.5, y = 0}},
            no_button = true,
            button_listen = 'discard_cards_from_highlighted',
            step = step,
        })
    elseif _part == 'first_hand_4' then
        step = tutorial_info({
            hard_set = true,
            text_key = 'fh_7',
            highlight = {
                G.HUD:get_UIE_by_ID('hud_hands').parent,
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'fh_8',
            highlight = {
                G.HUD:get_UIE_by_ID('hud_hands').parent,
                G.HUD:get_UIE_by_ID('row_dollars_chips'),
                G.HUD_blind
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
    elseif _part == 'second_hand' then
        step = tutorial_info({
            text_key = 'sh_1',
            hard_set = true,
            highlight = {
                G.jokers
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        local empress = find_joker('The Empress')[1]
        if empress then 
            step = tutorial_info({
                text_key = 'sh_2',
                highlight = {
                    empress
                },
                attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
                step = step,
            })
            step = tutorial_info({
                text_key = 'sh_3',
                attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
                highlight = {
                    empress,
                    G.hand
                },
                no_button = true,
                button_listen = 'use_card',
                snap_to = function() return G.hand.cards[1] end,
                step = step,
            })
        end
    elseif _part == 'shop_1' then
        step = tutorial_info({
            hard_set = true,
            text_key = 's_1',
            highlight = {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent
            },
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 4}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_2',
            highlight = {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_jokers.cards[2],
            },
            snap_to = function() return G.shop_jokers.cards[2] end,
            attach = {major = G.shop, type = 'tr', offset = {x = -0.5, y = 6}},
            no_button = true,
            button_listen = 'buy_from_shop',
            step = step,
        })
        step = tutorial_info({
            text_key = 's_3',
            loc_vars = {#G.P_CENTER_POOLS.Joker},
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.jokers.cards[1],
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_4',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.jokers.cards[1],
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_5',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.jokers,
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_6',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_jokers.cards[1],
            } end,
            snap_to = function() return G.shop_jokers.cards[1] end,
            no_button = true,
            button_listen = 'buy_from_shop',
            attach = {major = G.shop, type = 'tr', offset = {x = -0.5, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_7',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.consumeables.cards[#G.consumeables.cards],
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_8',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.consumeables
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_9',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_vouchers,
            } end,
            snap_to = function() return G.shop_vouchers.cards[1] end,
            attach = {major = G.shop, type = 'tr', offset = {x = -4, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_10',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_vouchers,
            } end,
            attach = {major = G.shop, type = 'tr', offset = {x = -4, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_11',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_booster,
            } end,
            snap_to = function() return G.shop_booster.cards[1] end,
            attach = {major = G.shop, type = 'tl', offset = {x = 3, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_12',
            highlight = function() return {
                G.shop:get_UIE_by_ID('next_round_button'),
            } end,
            snap_to = function() if G.shop then return G.shop:get_UIE_by_ID('next_round_button') end end,
            no_button = true,
            button_listen = 'toggle_shop',
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
    end

    
    G.E_MANAGER:add_event(Event({
        blockable = false,
        timer = 'REAL',
        func = function()
            if (G.OVERLAY_TUTORIAL.step == step and
            not G.OVERLAY_TUTORIAL.step_complete) or G.OVERLAY_TUTORIAL.skip_steps then
                if G.OVERLAY_TUTORIAL.Jimbo then G.OVERLAY_TUTORIAL.Jimbo:remove() end
                if G.OVERLAY_TUTORIAL.content then G.OVERLAY_TUTORIAL.content:remove() end
                G.OVERLAY_TUTORIAL:remove()
                G.OVERLAY_TUTORIAL = nil
                G.SETTINGS.tutorial_progress.hold_parts[_part]=true
                return true
            end
            return G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
        end
    }), 'tutorial') 
    G.SETTINGS.paused = false
end