--- STEAMODDED HEADER

--- MOD_NAME: Aurinko
--- MOD_ID: aurinko
--- MOD_AUTHOR: [jenwalter666]
--- MOD_DESCRIPTION: Lets planets naturally appear with editions, applies editions to hands when leveling
--- PRIORITY: 989999999
--- BADGE_COLOR: 009cff
--- PREFIX: aurinko
--- VERSION: 0.3.0
--- LOADER_VERSION_GEQ: 1.0.0

local function round( num, idp )

	local mult = 10 ^ ( idp or 0 )
	return math.floor( num * mult + 0.5 ) / mult

end

local HoldDelay = 1.3

local luhr = level_up_hand
function level_up_hand(card, hand, instant, amount)
	amount = amount or 1
	luhr(card, hand, instant, amount)
		if card and card.ability and card.ability.consumeable and amount ~= 0 then
			if card.edition then
				local factor = 0
				local op = ''
				if card.edition.holo then
					factor = G.P_CENTERS.e_holo.config.extra * amount
					G.GAME.hands[hand].mult = math.max(G.GAME.hands[hand].mult + factor, 1)
					if not instant then
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
							play_sound('multhit1', factor < 0 and 0.5 or 1)
							card:juice_up(0.8, 0.5)
						return true end }))
						update_hand_text({delay = HoldDelay}, {mult = G.GAME.hands[hand].mult, StatusText = true})
					end
				elseif card.edition.foil then
					factor = G.P_CENTERS.e_foil.config.extra * amount
					G.GAME.hands[hand].chips = math.max(G.GAME.hands[hand].chips + factor, 0)
					if not instant then
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
							play_sound('chips1', factor < 0 and 0.5 or 1)
							card:juice_up(0.8, 0.5)
						return true end }))
						update_hand_text({delay = HoldDelay}, {chips = G.GAME.hands[hand].chips, StatusText = true})
					end
				elseif card.edition.polychrome then
					factor = G.P_CENTERS.e_polychrome.config.extra ^ math.abs(amount)
					if amount > 0 then
						op = 'x'
						G.GAME.hands[hand].mult = math.floor(math.max(G.GAME.hands[hand].mult * factor, 1))
					else
						op = '/'
						G.GAME.hands[hand].mult = math.floor(math.max(G.GAME.hands[hand].mult / factor, 1))
					end
					if not instant then
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
							play_sound('multhit2', op == '/' and 0.5 or 1)
							card:juice_up(0.8, 0.5)
						return true end }))
						update_hand_text({delay = 0}, {mult = op .. number_format(factor), StatusText = true})
						update_hand_text({delay = HoldDelay}, {mult = G.GAME.hands[hand].mult})
					end
				elseif not card.edition.negative then
					local obj = card.edition
					if obj.aurinko and type(obj.aurinko) == 'function' then
						obj:aurinko(card, hand, instant, amount)
					end
					if obj.chips then
						factor = obj.chips * amount
						G.GAME.hands[hand].chips = math.floor(math.max(G.GAME.hands[hand].chips + factor, 1))
						if not instant then
							G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
								play_sound('chips1', factor < 0 and 0.5 or 1)
								card:juice_up(0.8, 0.5)
							return true end }))
							update_hand_text({delay = HoldDelay}, {chips = G.GAME.hands[hand].chips, StatusText = true})
						end
					end
					if obj.mult then
						factor = obj.mult * amount
						G.GAME.hands[hand].mult = math.floor(math.max(G.GAME.hands[hand].mult + factor, 1))
						if not instant then
							G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
								play_sound('multhit1', factor < 0 and 0.5 or 1)
								card:juice_up(0.8, 0.5)
							return true end }))
							update_hand_text({delay = HoldDelay}, {mult = G.GAME.hands[hand].mult, StatusText = true})
						end
					end
					if SMODS.Mods['Talisman'] then
						if obj.x_chips then
							factor = obj.x_chips ^ math.abs(amount)
							if amount > 0 then
								op = 'x'
								G.GAME.hands[hand].chips = math.floor(math.max(G.GAME.hands[hand].chips * factor, 1))
							else
								op = '/'
								G.GAME.hands[hand].chips = math.floor(math.max(G.GAME.hands[hand].chips / factor, 1))
							end
							if not instant then
								G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
									play_sound('talisman_xchip', op == '/' and 0.5 or 1)
									card:juice_up(0.8, 0.5)
								return true end }))
								update_hand_text({delay = 0}, {chips = op .. number_format(factor), StatusText = true})
								update_hand_text({delay = HoldDelay}, {chips = G.GAME.hands[hand].chips})
							end
						end
						if obj.e_chips then
							factor = math.abs(amount) == 1 and obj.e_chips or obj.e_chips ^ (obj.e_chips ^ math.abs(amount))
							if amount > 0 then
								op = '^'
								G.GAME.hands[hand].chips = math.floor(math.max(G.GAME.hands[hand].chips ^ factor, 1))
							else
								op = '^1/'
								G.GAME.hands[hand].chips = math.floor(math.max(G.GAME.hands[hand].chips ^ (1 / factor), 1))
							end
							if not instant then
								G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
									play_sound('talisman_echip', op == '^1/' and 0.5 or 1)
									card:juice_up(0.8, 0.5)
								return true end }))
								update_hand_text({delay = 0}, {chips = op .. number_format(factor), StatusText = true})
								update_hand_text({delay = HoldDelay}, {chips = G.GAME.hands[hand].chips})
							end
						end
						if obj.ee_chips then
							factor = math.abs(amount) == 1 and to_big(obj.ee_chips) or to_big(obj.ee_chips):arrow(2, (obj.ee_chips ^ math.abs(amount)))
							if amount > to_big(0) then
								op = '^^'
								G.GAME.hands[hand].chips = math.floor(math.max(G.GAME.hands[hand].chips:arrow(2, factor), 1))
							else
								op = '^^1/'
								G.GAME.hands[hand].chips = math.floor(math.max(G.GAME.hands[hand].chips:arrow(2, to_big(1) / factor), 1))
							end
							if not instant then
								G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
									play_sound('talisman_eechip', op == '^^1/' and 0.5 or 1)
									card:juice_up(0.8, 0.5)
								return true end }))
								update_hand_text({delay = 0}, {chips = op .. number_format(factor), StatusText = true})
								update_hand_text({delay = HoldDelay}, {chips = G.GAME.hands[hand].chips})
							end
						end
						if obj.eee_chips then
							factor = math.abs(amount) == 1 and to_big(obj.eee_chips) or to_big(obj.eee_chips):arrow(3, (obj.eee_chips ^ math.abs(amount)))
							if amount > to_big(0) then
								op = '^^^'
								G.GAME.hands[hand].chips = math.floor(math.max(G.GAME.hands[hand].chips:arrow(3, factor), 1))
							else
								op = '^^^1/'
								G.GAME.hands[hand].chips = math.floor(math.max(G.GAME.hands[hand].chips:arrow(3, to_big(1) / factor), 1))
							end
							if not instant then
								G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
									play_sound('talisman_eeechip', op == '^^^1/' and 0.5 or 1)
									card:juice_up(0.8, 0.5)
								return true end }))
								update_hand_text({delay = 0}, {chips = op .. number_format(factor), StatusText = true})
								update_hand_text({delay = HoldDelay}, {chips = G.GAME.hands[hand].chips})
							end
						end
						if obj.hyper_chips and type(obj.hyper_chips) == 'table' then
							factor = math.abs(amount) == 1 and {obj.hyper_chips[1], to_big(obj.hyper_chips[2])} or {obj.hyper_chips[1], to_big(obj.hyper_chips[2]):arrow(obj.hyper_chips[1], (obj.hyper_chips[2] ^ math.abs(amount)))}
							if amount > to_big(0) then
								op = obj.hyper_chips[1] > 5 and ('{' .. obj.hyper_chips[1] .. '}') or string.rep('^', obj.hyper_chips[1])
								G.GAME.hands[hand].chips = math.floor(math.max(G.GAME.hands[hand].chips:arrow(factor[1], factor[2]), 1))
							else
								op = (obj.hyper_chips[1] > 5 and ('{' .. obj.hyper_chips[1] .. '}') or string.rep('^', obj.hyper_chips[1])) .. '1/'
								G.GAME.hands[hand].chips = math.floor(math.max(G.GAME.hands[hand].chips:arrow(factor[1], to_big(1) / factor[2]), 1))
							end
							if not instant then
								G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
									play_sound('talisman_eeechip', op == '^^^1/' and 0.5 or 1)
									card:juice_up(0.8, 0.5)
								return true end }))
								update_hand_text({delay = 0}, {chips = op .. number_format(factor), StatusText = true})
								update_hand_text({delay = HoldDelay}, {chips = G.GAME.hands[hand].chips})
							end
						end
					end
					if obj.x_mult then
						factor = obj.x_mult ^ math.abs(amount)
						if amount > 0 then
							op = 'x'
							G.GAME.hands[hand].mult = math.floor(math.max(G.GAME.hands[hand].mult * factor, 1))
						else
							op = '/'
							G.GAME.hands[hand].mult = math.floor(math.max(G.GAME.hands[hand].mult / factor, 1))
						end
						if not instant then
							G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
								play_sound('multhit2', op == '/' and 0.5 or 1)
								card:juice_up(0.8, 0.5)
							return true end }))
							update_hand_text({delay = 0}, {mult = op .. number_format(factor), StatusText = true})
							update_hand_text({delay = HoldDelay}, {mult = G.GAME.hands[hand].mult})
						end
					end
					if SMODS.Mods['Talisman'] then
						if obj.e_mult then
							factor = math.abs(amount) == 1 and obj.e_mult or obj.e_mult ^ (obj.e_mult ^ math.abs(amount))
							if amount > 0 then
								op = '^'
								G.GAME.hands[hand].mult = math.floor(math.max(G.GAME.hands[hand].mult ^ factor, 1))
							else
								op = '^1/'
								G.GAME.hands[hand].mult = math.floor(math.max(G.GAME.hands[hand].mult ^ (1 / factor), 1))
							end
							if not instant then
								G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
									play_sound('talisman_emult', op == '^1/' and 0.5 or 1)
									card:juice_up(0.8, 0.5)
								return true end }))
								update_hand_text({delay = 0}, {mult = op .. number_format(factor), StatusText = true})
								update_hand_text({delay = HoldDelay}, {mult = G.GAME.hands[hand].mult})
							end
						end
						if obj.ee_mult then
							factor = math.abs(amount) == 1 and to_big(obj.ee_mult) or to_big(obj.ee_mult):arrow(2, (obj.ee_mult ^ math.abs(amount)))
							if amount > to_big(0) then
								op = '^^'
								G.GAME.hands[hand].mult = math.floor(math.max(G.GAME.hands[hand].mult:arrow(2, factor), 1))
							else
								op = '^^1/'
								G.GAME.hands[hand].mult = math.floor(math.max(G.GAME.hands[hand].mult:arrow(2, to_big(1) / factor), 1))
							end
							if not instant then
								G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
									play_sound('talisman_eechip', op == '^^1/' and 0.5 or 1)
									card:juice_up(0.8, 0.5)
								return true end }))
								update_hand_text({delay = 0}, {mult = op .. number_format(factor), StatusText = true})
								update_hand_text({delay = HoldDelay}, {mult = G.GAME.hands[hand].mult})
							end
						end
						if obj.eee_mult then
							factor = math.abs(amount) == 1 and to_big(obj.eee_mult) or to_big(obj.eee_mult):arrow(3, (obj.eee_mult ^ math.abs(amount)))
							if amount > to_big(0) then
								op = '^^^'
								G.GAME.hands[hand].mult = math.floor(math.max(G.GAME.hands[hand].mult:arrow(3, factor), 1))
							else
								op = '^^^1/'
								G.GAME.hands[hand].mult = math.floor(math.max(G.GAME.hands[hand].mult:arrow(3, to_big(1) / factor), 1))
							end
							if not instant then
								G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
									play_sound('talisman_eeechip', op == '^^^1/' and 0.5 or 1)
									card:juice_up(0.8, 0.5)
								return true end }))
								update_hand_text({delay = 0}, {mult = op .. number_format(factor), StatusText = true})
								update_hand_text({delay = HoldDelay}, {mult = G.GAME.hands[hand].mult})
							end
						end
						if obj.hyper_mult and type(obj.hyper_mult) == 'table' then
							factor = math.abs(amount) == 1 and {obj.hyper_mult[1], to_big(obj.hyper_mult[2])} or {obj.hyper_mult[1], to_big(obj.hyper_mult[2]):arrow(obj.hyper_mult[1], (obj.hyper_mult[2] ^ math.abs(amount)))}
							if amount > to_big(0) then
								op = obj.hyper_mult[1] > 5 and ('{' .. obj.hyper_mult[1] .. '}') or string.rep('^', obj.hyper_mult[1])
								G.GAME.hands[hand].mult = math.floor(math.max(G.GAME.hands[hand].mult:arrow(factor[1], factor[2]), 1))
							else
								op = (obj.hyper_mult[1] > 5 and ('{' .. obj.hyper_mult[1] .. '}') or string.rep('^', obj.hyper_mult[1])) .. '1/'
								G.GAME.hands[hand].mult = math.floor(math.max(G.GAME.hands[hand].mult:arrow(factor[1], to_big(1) / factor[2]), 1))
							end
							if not instant then
								G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
									play_sound('talisman_eeechip', op == '^^^1/' and 0.5 or 1)
									card:juice_up(0.8, 0.5)
								return true end }))
								update_hand_text({delay = 0}, {mult = op .. number_format(factor), StatusText = true})
								update_hand_text({delay = HoldDelay}, {mult = G.GAME.hands[hand].mult})
							end
						end
					end
					if obj.repetitions or obj.retriggers then
						level_up_hand(nil, hand, instant, (obj.repetitions or obj.retriggers) * amount)
					end
					if obj.p_dollars then
						ease_dollars(obj.p_dollars * amount)
					end
				end
			end
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = (function() check_for_unlock{type = 'upgrade_hand', hand = hand, level = G.GAME.hands[hand].level} return true end)
		}))
end

local ccr = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	local card = ccr(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	local obj = card.config.center
	if (_type == 'Planet' or _type == 'Planet_dx' or card.ability.name == 'Black Hole') and (obj.aurinko or (card.ability.consumeable and card.ability.consumeable.hand_type)) then
		local edition = poll_edition('edi'..(key_append or '')..tostring(G.GAME.round_resets.ante), math.max(1, math.min(1 + ((G.GAME.round_resets.ante / 2) - 0.5), 10)), true)
		if edition and not edition.aurinko_blacklist then
			card:set_edition(edition)
		end
		check_for_unlock({type = 'have_edition'})
	end
	return card
end
