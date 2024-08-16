LOVELY_INTEGRITY = '1c226911685629ece790bae67f81fe13278b1815f823a7a7a1ff562c8970e600'

if (love.system.getOS() == 'OS X' ) and (jit.arch == 'arm64' or jit.arch == 'arm') then jit.off() end
lua_reload = require('lua_reload')
lua_reload.Inject()
require "engine/object"
require "bit"
require "engine/string_packer"
require "engine/controller"
require "back"
require "tag"
require "engine/event"
require "engine/node"
require "engine/moveable"
require "engine/sprite"
require "engine/animatedsprite"
require "functions/misc_functions"
require "game"
require "globals"
require "engine/ui"
require "functions/UI_definitions"
require "functions/state_events"
require "functions/common_events"
require "functions/button_callbacks"
require "functions/misc_functions"
require "functions/test_functions"
require "card"
require "cardarea"
require "blind"
require "card_character"
require "engine/particles"
require "engine/text"
require "challenges"

math.randomseed( G.SEED )

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0
	local dt_smooth = 1/100
	local run_time = 0

	-- Main loop time.
	return function()
		run_time = love.timer.getTime()
		-- Process events.
		if love.event and G and G.CONTROLLER then
			love.event.pump()
			local _n,_a,_b,_c,_d,_e,_f,touched
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				if name == 'touchpressed' then
					touched = true
				elseif name == 'mousepressed' then 
					_n,_a,_b,_c,_d,_e,_f = name,a,b,c,d,e,f
				else
					love.handlers[name](a,b,c,d,e,f)
				end
			end
			if _n then 
				love.handlers['mousepressed'](_a,_b,_c,touched)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end
		dt_smooth = math.min(0.8*dt_smooth + 0.2*dt, 0.1)
		-- Call update and draw
		if love.update then love.update(dt_smooth) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			if love.draw then love.draw() end
			love.graphics.present()
		end

		run_time = math.min(love.timer.getTime() - run_time, 0.1)
		G.FPS_CAP = G.FPS_CAP or 500
		if run_time < 1./G.FPS_CAP then love.timer.sleep(1./G.FPS_CAP - run_time) end
	end
end

function love.load() 
	G:start_up()
	--Steam integration
	local os = love.system.getOS()
	if os == 'OS X' or os == 'Windows' then 
		local st = nil
		--To control when steam communication happens, make sure to send updates to steam as little as possible
		if os == 'OS X' then
			local dir = love.filesystem.getSourceBaseDirectory()
			local old_cpath = package.cpath
			package.cpath = package.cpath .. ';' .. dir .. '/?.so'
			st = require 'luasteam'
			package.cpath = old_cpath
		else
			st = require 'luasteam'
		end

		st.send_control = {
			last_sent_time = -200,
			last_sent_stage = -1,
			force = false,
		}
		if not (st.init and st:init()) then
			st = nil
		end
		--Set up the render window and the stage for the splash screen, then enter the gameloop with :update
		G.STEAM = st
	else
	end

	--Set the mouse to invisible immediately, this visibility is handled in the G.CONTROLLER
	love.mouse.setVisible(false)
end

function love.quit()
	--Steam integration
	if G.SOUND_MANAGER then G.SOUND_MANAGER.channel:push({type = 'stop'}) end
	if G.STEAM then G.STEAM:shutdown() end
end

function love.update( dt )
	--Perf monitoring checkpoint
    timer_checkpoint(nil, 'update', true)
    G:update(dt)
end

function love.draw()
	--Perf monitoring checkpoint
    timer_checkpoint(nil, 'draw', true)
	G:draw()
end

function love.keypressed(key)
	if not _RELEASE_MODE and G.keybind_mapping[key] then love.gamepadpressed(G.CONTROLLER.keyboard_controller, G.keybind_mapping[key])
	else
		G.CONTROLLER:set_HID_flags('mouse')
		G.CONTROLLER:key_press(key)
	end
end

function love.keyreleased(key)
	if not _RELEASE_MODE and G.keybind_mapping[key] then love.gamepadreleased(G.CONTROLLER.keyboard_controller, G.keybind_mapping[key])
	else
		G.CONTROLLER:set_HID_flags('mouse')
		G.CONTROLLER:key_release(key)
	end
end

function love.gamepadpressed(joystick, button)
	button = G.button_mapping[button] or button
	G.CONTROLLER:set_gamepad(joystick)
    G.CONTROLLER:set_HID_flags('button', button)
    G.CONTROLLER:button_press(button)
end

function love.gamepadreleased(joystick, button)
	button = G.button_mapping[button] or button
    G.CONTROLLER:set_gamepad(joystick)
    G.CONTROLLER:set_HID_flags('button', button)
    G.CONTROLLER:button_release(button)
end

function love.mousepressed(x, y, button, touch)
    G.CONTROLLER:set_HID_flags(touch and 'touch' or 'mouse')
    if button == 1 then 
		G.CONTROLLER:queue_L_cursor_press(x, y)
	end
	if button == 2 then
		G.CONTROLLER:queue_R_cursor_press(x, y)
	end
end


function love.mousereleased(x, y, button)
    if button == 1 then G.CONTROLLER:L_cursor_release(x, y) end
end

function love.mousemoved(x, y, dx, dy, istouch)
	G.CONTROLLER.last_touch_time = G.CONTROLLER.last_touch_time or -1
	if next(love.touch.getTouches()) ~= nil then
		G.CONTROLLER.last_touch_time = G.TIMERS.UPTIME
	end
    G.CONTROLLER:set_HID_flags(G.CONTROLLER.last_touch_time > G.TIMERS.UPTIME - 0.2 and 'touch' or 'mouse')
end

function love.joystickaxis( joystick, axis, value )
    if math.abs(value) > 0.2 and joystick:isGamepad() then
		G.CONTROLLER:set_gamepad(joystick)
        G.CONTROLLER:set_HID_flags('axis')
    end
end

function love.errhand(msg)
	if G.F_NO_ERROR_HAND then return end
	msg = tostring(msg)

	if G.SETTINGS.crashreports and _RELEASE_MODE and G.F_CRASH_REPORTS then 
		local http_thread = love.thread.newThread([[
			local https = require('https')
			CHANNEL = love.thread.getChannel("http_channel")

			while true do
				--Monitor the channel for any new requests
				local request = CHANNEL:demand()
				if request then
					https.request(request)
				end
			end
		]])
		local http_channel = love.thread.getChannel('http_channel')
		http_thread:start()
		local httpencode = function(str)
			local char_to_hex = function(c)
				return string.format("%%%02X", string.byte(c))
			end
			str = str:gsub("\n", "\r\n"):gsub("([^%w _%%%-%.~])", char_to_hex):gsub(" ", "+")
			return str
		end
		

		local error = msg
		local file = string.sub(msg, 0,  string.find(msg, ':'))
		local function_line = string.sub(msg, string.len(file)+1)
		function_line = string.sub(function_line, 0, string.find(function_line, ':')-1)
		file = string.sub(file, 0, string.len(file)-1)
		local trace = debug.traceback()
		local boot_found, func_found = false, false
		for l in string.gmatch(trace, "(.-)\n") do
			if string.match(l, "boot.lua") then
				boot_found = true
			elseif boot_found and not func_found then
				func_found = true
				trace = ''
				function_line = string.sub(l, string.find(l, 'in function')+12)..' line:'..function_line
			end

			if boot_found and func_found then 
				trace = trace..l..'\n'
			end
		end

		http_channel:push('https://958ha8ong3.execute-api.us-east-2.amazonaws.com/?error='..httpencode(error)..'&file='..httpencode(file)..'&function_line='..httpencode(function_line)..'&trace='..httpencode(trace)..'&version='..(G.VERSION))
	end

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
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end
	love.graphics.reset()
	local font = love.graphics.setNewFont("resources/fonts/m6x11plus.ttf", 20)

	love.graphics.clear(G.C.BLACK)
	love.graphics.origin()


	local p = 'Oops! Something went wrong:\n'..msg..'\n\n'..(not _RELEASE_MODE and debug.traceback() or G.SETTINGS.crashreports and
		'Since you are opted in to sending crash reports, LocalThunk HQ was sent some useful info about what happened.\nDon\'t worry! There is no identifying or personal information. If you would like\nto opt out, change the \'Crash Report\' setting to Off' or
		'Crash Reports are set to Off. If you would like to send crash reports, please opt in in the Game settings.\nThese crash reports help us avoid issues like this in the future')

	local function draw()
		local pos = love.window.toPixels(70)
		love.graphics.push()
		love.graphics.clear(G.C.BLACK)
		love.graphics.setColor(1., 1., 1., 1.)
		love.graphics.printf(p, font, pos, pos, love.graphics.getWidth() - pos)
		love.graphics.pop()
		love.graphics.present()

	end

	while true do
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return
			elseif e == "keypressed" and a == "escape" then
				return
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return
				end
			end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end

end

function love.resize(w, h)
	if w/h < 1 then --Dont allow the screen to be too square, since pop in occurs above and below screen
		h = w/1
	end

	--When the window is resized, this code resizes the Canvas, then places the 'room' or gamearea into the middle without streching it
	if w/h < G.window_prev.orig_ratio then
		G.TILESCALE = G.window_prev.orig_scale*w/G.window_prev.w
	else
		G.TILESCALE = G.window_prev.orig_scale*h/G.window_prev.h
	end

	if G.ROOM then
		G.ROOM.T.w = G.TILE_W
		G.ROOM.T.h = G.TILE_H
		G.ROOM_ATTACH.T.w = G.TILE_W
		G.ROOM_ATTACH.T.h = G.TILE_H		

		if w/h < G.window_prev.orig_ratio then
			G.ROOM.T.x = G.ROOM_PADDING_W
			G.ROOM.T.y = (h/(G.TILESIZE*G.TILESCALE) - (G.ROOM.T.h+G.ROOM_PADDING_H))/2 + G.ROOM_PADDING_H/2
		else
			G.ROOM.T.y = G.ROOM_PADDING_H
			G.ROOM.T.x = (w/(G.TILESIZE*G.TILESCALE) - (G.ROOM.T.w+G.ROOM_PADDING_W))/2 + G.ROOM_PADDING_W/2
		end

		G.ROOM_ORIG = {
            x = G.ROOM.T.x,
            y = G.ROOM.T.y,
            r = G.ROOM.T.r
        }

		if G.buttons then G.buttons:recalculate() end
		if G.HUD then G.HUD:recalculate() end
	end

	G.WINDOWTRANS = {
		x = 0, y = 0,
		w = G.TILE_W+2*G.ROOM_PADDING_W, 
		h = G.TILE_H+2*G.ROOM_PADDING_H,
		real_window_w = w,
		real_window_h = h
	}

	G.CANV_SCALE = 1

	if love.system.getOS() == 'Windows' and false then --implement later if needed
		local render_w, render_h = love.window.getDesktopDimensions(G.SETTINGS.WINDOW.selcted_display)
		local unscaled_dims = love.window.getFullscreenModes(G.SETTINGS.WINDOW.selcted_display)[1]

		local DPI_scale = math.floor((0.5*unscaled_dims.width/render_w + 0.5*unscaled_dims.height/render_h)*500 + 0.5)/500

		if DPI_scale > 1.1 then
			G.CANV_SCALE = 1.5

			G.AA_CANVAS = love.graphics.newCanvas(G.WINDOWTRANS.real_window_w*G.CANV_SCALE, G.WINDOWTRANS.real_window_h*G.CANV_SCALE, {type = '2d', readable = true})
			G.AA_CANVAS:setFilter('linear', 'linear')
		else
			G.AA_CANVAS = nil
		end
	end

	G.CANVAS = love.graphics.newCanvas(w*G.CANV_SCALE, h*G.CANV_SCALE, {type = '2d', readable = true})
	G.CANVAS:setFilter('linear', 'linear')
end 
Brainstorm = {}
function initBrainstorm()
	local lovely = require("lovely")
	local nativefs = require("nativefs")
	assert(load(nativefs.read(lovely.mod_dir .. "/Brainstorm/Brainstorm_main.lua")))()
	assert(load(nativefs.read(lovely.mod_dir .. "/Brainstorm/Brainstorm_UI.lua")))()
	assert(load(nativefs.read(lovely.mod_dir .. "/Brainstorm/Brainstorm_keyhandler.lua")))()
	assert(load(nativefs.read(lovely.mod_dir .. "/Brainstorm/Brainstorm_reroll.lua")))()
	if nativefs.getInfo(lovely.mod_dir .. "/Brainstorm/settings.lua") then
		local settings_file = STR_UNPACK(nativefs.read((lovely.mod_dir .. "/Brainstorm/settings.lua")))
		if settings_file ~= nil then
			Brainstorm.SETTINGS = settings_file
		end
	end
  _RELEASE_MODE = not Brainstorm.SETTINGS.debug_mode
end



--- STEAMODDED CORE
--- MODULE CORE

SMODS = {}
SMODS.GUI = {}
SMODS.GUI.DynamicUIManager = {}

MODDED_VERSION = "1.0.0-ALPHA-0720a-STEAMODDED"

function STR_UNPACK(str)
	local chunk, err = loadstring(str)
	if chunk then
		setfenv(chunk, {}) -- Use an empty environment to prevent access to potentially harmful functions
		local success, result = pcall(chunk)
		if success then
			return result
		else
			print("Error unpacking string: " .. result)
			return nil
		end
	else
		print("Error loading string: " .. err)
		return nil
	end
end


local gameMainMenuRef = Game.main_menu
function Game:main_menu(change_context)
	gameMainMenuRef(self, change_context)
	UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = {
				align = "cm",
				colour = G.C.UI.TRANSPARENT_DARK
			},
			nodes = {
				{
					n = G.UIT.T,
					config = {
						scale = 0.3,
						text = MODDED_VERSION,
						colour = G.C.UI.TEXT_LIGHT
					}
				}
			}
		},
		config = {
			align = "tri",
			bond = "Weak",
			offset = {
				x = 0,
				y = 0.3
			},
			major = G.ROOM_ATTACH
		}
	})
end

local gameUpdateRef = Game.update
function Game:update(dt)
	if G.STATE ~= G.STATES.SPLASH and G.MAIN_MENU_UI then
		local node = G.MAIN_MENU_UI:get_UIE_by_ID("main_menu_play")

		if node and not node.children.alert then
			node.children.alert = UIBox({
				definition = create_UIBox_card_alert({
					text = localize('b_modded_version'),
					no_bg = true,
					scale = 0.4,
					text_rot = -0.2
				}),
				config = {
					align = "tli",
					offset = {
						x = -0.1,
						y = 0
					},
					major = node,
					parent = node
				}
			})
			node.children.alert.states.collide.can = false
		end
	end
	gameUpdateRef(self, dt)
end

local function wrapText(text, maxChars)
	local wrappedText = ""
	local currentLineLength = 0

	for word in text:gmatch("%S+") do
		if currentLineLength + #word <= maxChars then
			wrappedText = wrappedText .. word .. ' '
			currentLineLength = currentLineLength + #word + 1
		else
			wrappedText = wrappedText .. '\n' .. word .. ' '
			currentLineLength = #word + 1
		end
	end

	return wrappedText
end

-- Helper function to concatenate author names
local function concatAuthors(authors)
	if type(authors) == "table" then
		return table.concat(authors, ", ")
	end
	return authors or localize('b_unknown')
end


SMODS.LAST_SELECTED_MOD_TAB = "mod_desc"
function create_UIBox_mods(args)
	local mod = G.ACTIVE_MOD_UI
	if not SMODS.LAST_SELECTED_MOD_TAB then SMODS.LAST_SELECTED_MOD_TAB = "mod_desc" end

	local mod_tabs = {}
	table.insert(mod_tabs, buildModDescTab(mod))
	if mod.added_obj then table.insert(mod_tabs, buildAdditionsTab(mod)) end
	local credits_func = mod.credits_tab
	if credits_func and type(credits_func) == 'function' then 
		table.insert(mod_tabs, {
			label = localize("b_credits"),
			chosen = SMODS.LAST_SELECTED_MOD_TAB == "credits" or false,
			tab_definition_function = function(...)
				SMODS.LAST_SELECTED_MOD_TAB = "credits"
				return credits_func(...)
			end
		})
	end
	local config_func = mod.config_tab
	if config_func and type(config_func) == 'function' then 
		table.insert(mod_tabs, {
			label = localize("b_config"),
			chosen = SMODS.LAST_SELECTED_MOD_TAB == "config" or false,
			tab_definition_function = function(...)
				SMODS.LAST_SELECTED_MOD_TAB = "config"
				return config_func(...)
			end
		})
	end

	local custom_ui_func = mod.extra_tabs
	if custom_ui_func and type(custom_ui_func) == 'function' then
		local custom_tabs = custom_ui_func()
		if next(custom_tabs) and #custom_tabs == 0 then custom_tabs = { custom_tabs } end
		for i, v in ipairs(custom_tabs) do
			local id = mod.id..'_'..i
			v.chosen = (SMODS.LAST_SELECTED_MOD_TAB == id) or false
			v.label = v.label or ''
			local def = v.tab_definition_function
			assert(def, ('Custom defined mod tab with label "%s" from mod with id %s is missing definition function'):format(v.label, mod.id))
			v.tab_definition_function = function(...)
				SMODS.LAST_SELECTED_MOD_TAB = id
				return def(...)
			end
			table.insert(mod_tabs, v)
		end
	end

	return (create_UIBox_generic_options({
		back_func = "mods_button",
		contents = {
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "tm"
				},
				nodes = {
					create_tabs({
						snap_to_nav = true,
						colour = G.C.BOOSTER,
						tabs = mod_tabs
					})
				}
			}
		}
	}))
end

function buildModDescTab(mod)
	G.E_MANAGER:add_event(Event({
		blockable = false,
		func = function()
		  G.REFRESH_ALERTS = nil
		return true
		end
	}))
	local modNodes = {}
	local scale = 0.75  -- Scale factor for text
	local maxCharsPerLine = 50

	local wrappedDescription = wrapText(mod.description, maxCharsPerLine)

	local authors = localize('b_author'.. (#mod.author > 1 and 's' or '')) .. ': ' .. concatAuthors(mod.author)

	-- Authors names in blue
	table.insert(modNodes, {
		n = G.UIT.R,
		config = {
			padding = 0,
			align = "cm",
			r = 0.1,
			emboss = 0.1,
			outline = 1,
			padding = 0.07
		},
		nodes = {
			{
				n = G.UIT.T,
				config = {
					text = authors,
					shadow = true,
					scale = scale * 0.65,
					colour = G.C.BLUE,
				}
			}
		}
	})

	-- Mod description
	table.insert(modNodes, {
		n = G.UIT.R,
		config = {
			padding = 0.2,
			align = "cm"
		},
		nodes = {
			{
				n = G.UIT.T,
				config = {
					text = wrappedDescription,
					shadow = true,
					scale = scale * 0.5,
					colour = G.C.UI.TEXT_LIGHT
				}
			}
		}
	})

	local custom_ui_func = mod.custom_ui
	if custom_ui_func and type(custom_ui_func) == 'function' then
		custom_ui_func(modNodes)
	end

	return {
		label = mod.name,
		chosen = SMODS.LAST_SELECTED_MOD_TAB == "mod_desc" or false,
		tab_definition_function = function()
			return {
				n = G.UIT.ROOT,
				config = {
					emboss = 0.05,
					minh = 6,
					r = 0.1,
					minw = 6,
					align = "tm",
					padding = 0.2,
					colour = G.C.BLACK
				},
				nodes = modNodes
			}
		end
	}
end

function buildAdditionsTab(mod)
	local consumable_nodes = {}
	for _, key in ipairs(SMODS.ConsumableType.obj_buffer) do
		local id = 'your_collection_'..key:lower()..'s'
		consumable_nodes[#consumable_nodes+1] = UIBox_button({button = id, label = {localize('b_'..key:lower()..'_cards')}, count = modsCollectionTally(G.P_CENTER_POOLS[key]), minw = 4, id = id, colour = G.C.SECONDARY_SET[key], func = 'is_collection_empty'})
	end

	local t = {n=G.UIT.R, config={align = "cm",padding = 0.2, minw = 7}, nodes={
		{n=G.UIT.C, config={align = "cm", padding = 0.15}, nodes={
		UIBox_button({button = 'your_collection_jokers', label = {localize('b_jokers')}, count = modsCollectionTally(G.P_CENTER_POOLS["Joker"]),  minw = 5, minh = 1.7, scale = 0.6, id = 'your_collection_jokers', func = 'is_collection_empty'}),
		UIBox_button({button = 'your_collection_decks', label = {localize('b_decks')}, count = modsCollectionTally(G.P_CENTER_POOLS["Back"]), minw = 5, id = 'your_collection_decks', func = 'is_collection_empty'}),
		UIBox_button({button = 'your_collection_vouchers', label = {localize('b_vouchers')}, count = modsCollectionTally(G.P_CENTER_POOLS["Voucher"]), minw = 5, id = 'your_collection_vouchers', func = 'is_collection_empty'}),
		{n=G.UIT.R, config={align = "cm", padding = 0.1, r=0.2, colour = G.C.BLACK}, nodes={
		  {n=G.UIT.C, config={align = "cm", maxh=2.9}, nodes={
			{n=G.UIT.T, config={text = localize('k_cap_consumables'), scale = 0.45, colour = G.C.L_BLACK, vert = true, maxh=2.2}},
		  }},
		  {n=G.UIT.C, config={align = "cm", padding = 0.15}, nodes = consumable_nodes}
		}},
	  }},
	  {n=G.UIT.C, config={align = "cm", padding = 0.15}, nodes={
		UIBox_button({button = 'your_collection_enhancements', label = {localize('b_enhanced_cards')}, count = modsCollectionTally(G.P_CENTER_POOLS["Enhanced"]), minw = 5, id = 'your_collection_enhancements', func = 'is_collection_empty'}),
		UIBox_button({button = 'your_collection_seals', label = {localize('b_seals')}, count = modsCollectionTally(G.P_CENTER_POOLS["Seal"]), minw = 5, id = 'your_collection_seals', func = 'is_collection_empty'}),
		UIBox_button({button = 'your_collection_editions', label = {localize('b_editions')}, count = modsCollectionTally(G.P_CENTER_POOLS["Edition"]), minw = 5, id = 'your_collection_editions', func = 'is_collection_empty'}),
		UIBox_button({button = 'your_collection_boosters', label = {localize('b_booster_packs')}, count = modsCollectionTally(G.P_CENTER_POOLS["Booster"]), minw = 5, id = 'your_collection_boosters', func = 'is_collection_empty'}),
		UIBox_button({button = 'your_collection_tags', label = {localize('b_tags')}, count = modsCollectionTally(G.P_TAGS), minw = 5, id = 'your_collection_tags', func = 'is_collection_empty'}),
		UIBox_button({button = 'your_collection_blinds', label = {localize('b_blinds')}, count = modsCollectionTally(G.P_BLINDS), minw = 5, minh = 2.0, id = 'your_collection_blinds', focus_args = {snap_to = true}, func = 'is_collection_empty'}),
		UIBox_button({button = 'your_collection_other_gameobjects', label = {localize('k_other')}, minw = 5, id = 'your_collection_other_gameobjects', focus_args = {snap_to = true}, func = 'is_other_gameobject_tabs'}),
	  }}
	}}

	local modNodes = {}
	table.insert(modNodes, t)
	return {
		label = localize("b_additions"),
		chosen = SMODS.LAST_SELECTED_MOD_TAB == "additions" or false,
		tab_definition_function = function()
			SMODS.LAST_SELECTED_MOD_TAB = "additions"
			return {
				n = G.UIT.ROOT,
				config = {
					emboss = 0.05,
					minh = 6,
					r = 0.1,
					minw = 6,
					align = "tm",
					padding = 0.2,
					colour = G.C.BLACK
				},
				nodes = modNodes
			}
		end
	}
end

-- Disable alerts when in Additions tab
local set_alerts_ref = set_alerts
function set_alerts()
	if G.ACTIVE_MOD_UI then
	else 
		set_alerts_ref()
	end
end

G.FUNCS.your_collection_other_gameobjects = function(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu{
	  definition = create_UIBox_Other_GameObjects(),
	}
end

function create_UIBox_Other_GameObjects()
	local custom_gameobject_tabs = {{}}
	for _, mod in pairs(SMODS.Mods) do
		local curr_height = 0
		local curr_col = 1
		if mod.custom_collection_tabs and type(mod.custom_collection_tabs) == "function" then
			object_tabs = mod.custom_collection_tabs()
			for _, tab in ipairs(object_tabs) do
				table.insert(custom_gameobject_tabs[curr_col], tab)
				curr_height = curr_height + tab.nodes[1].config.minh
				if curr_height > 6 then --TODO: Verify that this is the ideal number to use
					curr_height = 0
					curr_col = curr_col + 1
					custom_gameobject_tabs[curr_col] = {}
				end
			end
		end
	end

	local custom_gameobject_rows = {}
	for _, v in ipairs(custom_gameobject_tabs) do
		table.insert(custom_gameobject_rows, {n=G.UIT.C, config={align = "cm", padding = 0.15}, nodes = v})
	end
	local t = {n=G.UIT.C, config={align = "cm", r = 0.1, colour = G.C.BLACK, padding = 0.1, emboss = 0.05, minw = 7}, nodes={
		{n=G.UIT.R, config={align = "cm", padding = 0.15}, nodes = custom_gameobject_rows}
	}}

	return create_UIBox_generic_options({ back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection', contents = {t}})
end

-- TODO: Optimize this. 
function modsCollectionTally(pool, set)
	local set = set or nil
	local obj_tally = {tally = 0, of = 0}

	for _, v in pairs(pool) do
		if v.mod and G.ACTIVE_MOD_UI.id == v.mod.id then
			if set then
				if v.set and v.set == set then
					obj_tally.of = obj_tally.of+1
					if v.discovered then 
						obj_tally.tally = obj_tally.tally+1
					end
				end
			else
				obj_tally.of = obj_tally.of+1
				if v.discovered then 
					obj_tally.tally = obj_tally.tally+1
				end
			end
		end
	end

	return obj_tally
end

-- TODO: Make better solution
G.FUNCS.is_collection_empty = function(e)
	if e.config.count and e.config.count.of <= 0 then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.RED
        e.config.button = e.config.id
    end
end

-- TODO: Make more efficient? 
G.FUNCS.is_other_gameobject_tabs = function(e)
	local is_other_gameobject_tab = nil
	for _, mod in pairs(SMODS.Mods) do
		if mod.custom_collection_tabs then is_other_gameobject_tab = true end
	end
	if is_other_gameobject_tab then
		e.config.colour = G.C.RED
        e.config.button = e.config.id
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

-- TODO: Make better solution
local UIBox_button_ref = UIBox_button
function UIBox_button(args)
	local button = UIBox_button_ref(args)
	button.nodes[1].config.count = args.count
	return button
end

function buildModtag(mod)
    local tag_pos, tag_message, tag_atlas = { x = 0, y = 0 }, "load_success", mod.prefix and mod.prefix .. '_modicon' or 'modicon'
    local specific_vars = {}

    if not mod.can_load then
        tag_message = "load_failure"
        tag_atlas = "mod_tags"
        specific_vars = {}
        if next(mod.load_issues.dependencies) then
			tag_message = tag_message..'_d'
            table.insert(specific_vars, concatAuthors(mod.load_issues.dependencies))
        end
        if next(mod.load_issues.conflicts) then
            tag_message = tag_message .. '_c'
            table.insert(specific_vars, concatAuthors(mod.load_issues.conflicts))
        end
        if mod.load_issues.outdated then tag_message = 'load_failure_o' end
		if mod.load_issues.version_mismatch then
            tag_message = 'load_failure_i'
			specific_vars = {mod.load_issues.version_mismatch, MODDED_VERSION:gsub('-STEAMODDED', '')}
		end
		if mod.disabled then
			tag_pos = {x = 1, y = 0}
			tag_message = 'load_disabled'
		end
    end


    local tag_sprite_tab = nil
    
    local tag_sprite = Sprite(0, 0, 0.8*1, 0.8*1, G.ASSET_ATLAS[tag_atlas] or G.ASSET_ATLAS['tags'], tag_pos)
    tag_sprite.T.scale = 1
    tag_sprite_tab = {n= G.UIT.C, config={align = "cm", padding = 0}, nodes={
        {n=G.UIT.O, config={w=0.8*1, h=0.8*1, colour = G.C.BLUE, object = tag_sprite, focus_with_object = true}},
    }}
    tag_sprite:define_draw_steps({
        {shader = 'dissolve', shadow_height = 0.05},
        {shader = 'dissolve'},
    })
    tag_sprite.float = true
    tag_sprite.states.hover.can = true
    tag_sprite.states.drag.can = false
    tag_sprite.states.collide.can = true

    tag_sprite.hover = function(_self)
        if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
            if not _self.hovering and _self.states.visible then
                _self.hovering = true
                if _self == tag_sprite then
                    _self.hover_tilt = 3
                    _self:juice_up(0.05, 0.02)
                    play_sound('paper1', math.random()*0.1 + 0.55, 0.42)
                    play_sound('tarot2', math.random()*0.1 + 0.55, 0.09)
                end
                tag_sprite.ability_UIBox_table = generate_card_ui({set = "Other", discovered = false, key = tag_message}, nil, specific_vars, 'Other', nil, false)
                _self.config.h_popup =  G.UIDEF.card_h_popup(_self)
                _self.config.h_popup_config ={align = 'cl', offset = {x=-0.1,y=0},parent = _self}
                Node.hover(_self)
                if _self.children.alert then 
                    _self.children.alert:remove()
                    _self.children.alert = nil
                    G:save_progress()
                end
            end
        end
    end
    tag_sprite.stop_hover = function(_self) _self.hovering = false; Node.stop_hover(_self); _self.hover_tilt = 0 end

    tag_sprite:juice_up()

    return tag_sprite_tab
end

-- Helper function to create a clickable mod box
local function createClickableModBox(modInfo, scale)
	local col, text_col
	modInfo.should_enable = not modInfo.disabled
    if modInfo.can_load then
        col = G.C.BOOSTER
    elseif modInfo.disabled then
        col = G.C.UI.BACKGROUND_INACTIVE
    else
        col = mix_colours(G.C.RED, G.C.UI.BACKGROUND_INACTIVE, 0.7)
        text_col = G.C.TEXT_DARK
    end
	local but = UIBox_button {
        label = { " " .. modInfo.name .. " ", localize('b_by') .. concatAuthors(modInfo.author) .. " " },
        shadow = true,
        scale = scale,
        colour = col,
        text_colour = text_col,
        button = "openModUI_" .. modInfo.id,
        minh = 0.8,
        minw = 7
    }
    if modInfo.version ~= '0.0.0' then
		local function invert(c)
			return {1-c[1], 1-c[2], 1-c[3], c[4]}
		end
        table.insert(but.nodes[1].nodes[1].nodes, {
            n = G.UIT.T,
            config = {
                text = ('(%s)'):format(modInfo.version),
                scale = scale*0.8,
                colour = mix_colours(invert(col), G.C.UI.TEXT_INACTIVE, 0.8),
                shadow = true,
            },
        })
    end
	return {
		n = G.UIT.R,
		config = { padding = 0, align = "cm" },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					buildModtag(modInfo)
				}
            },
			{
				n = G.UIT.C,
                config = { align = "cm", padding = 0.1 },
				nodes = {},
			},
			{ n = G.UIT.C, config = { padding = 0, align = "cm" }, nodes = { but } },
			create_toggle({
				label = '',
				ref_table = modInfo,
				ref_value = 'should_enable',
				col = true,
				w = 0,
				h = 0.5,
				callback = (
					function(_set_toggle)
						if not modInfo.should_enable then
							NFS.write(modInfo.path .. '.lovelyignore', '')
							if NFS.getInfo(modInfo.path .. 'lovely') or NFS.getInfo(modInfo.path .. 'lovely.toml') then
								SMODS.full_restart = true
							else
								SMODS.partial_reload = true
							end
						else
							NFS.remove(modInfo.path .. '.lovelyignore')
							if NFS.getInfo(modInfo.path .. 'lovely') or NFS.getInfo(modInfo.path .. 'lovely.toml') then
								SMODS.full_restart = true
							else
								SMODS.partial_reload = true
							end
						end
					end
				)
			}),
    }}
	
end

function G.FUNCS.openModsDirectory(options)
    if not love.filesystem.exists("Mods") then
        love.filesystem.createDirectory("Mods")
    end

    love.system.openURL("file://"..love.filesystem.getSaveDirectory().."/Mods")
end

function G.FUNCS.mods_buttons_page(options)
    if not options or not options.cycle_config then
        return
    end
end

function SMODS.save_mod_config(mod)
	if not mod.config or not next(mod.config) then return end
	local serialized = 'return '..serialize(mod.config)
	NFS.write(mod.path..'config.lua', serialized)
end

function G.FUNCS.exit_mods(e)
	for _, v in pairs(SMODS.Mods) do
		SMODS.save_mod_config(v)
	end
    if SMODS.full_restart then
		-- launch a new instance of the game and quit the current one
		SMODS.restart_game()
    elseif SMODS.partial_reload then
		-- re-initialize steamodded
        SMODS.reload()
    end
	G.FUNCS.exit_overlay_menu(e)
end

function create_UIBox_mods_button()
	local scale = 0.75
	return (create_UIBox_generic_options({
		back_func = 'exit_mods',
		contents = {
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "cm"
				},
				nodes = {
					create_tabs({
						snap_to_nav = true,
						colour = G.C.BOOSTER,
						tabs = {
							{
								label = localize('b_mods'),
								chosen = true,
								tab_definition_function = function()
									return SMODS.GUI.DynamicUIManager.initTab({
										updateFunctions = {
											modsList = G.FUNCS.update_mod_list,
										},
										staticPageDefinition = SMODS.GUI.staticModListContent()
									})
								end
							},
							{

								label = localize('b_steamodded_credits'),
								tab_definition_function = function()
									return {
										n = G.UIT.ROOT,
										config = {
											emboss = 0.05,
											minh = 6,
											r = 0.1,
											minw = 6,
											align = "cm",
											padding = 0.2,
											colour = G.C.BLACK
										},
										nodes = {
											{
												n = G.UIT.R,
												config = {
													padding = 0,
													align = "cm"
												},
												nodes = {
													{
														n = G.UIT.T,
														config = {
															text = localize('b_mod_loader'),
															shadow = true,
															scale = scale * 0.8,
															colour = G.C.UI.TEXT_LIGHT
														}
													}
												}
											},
											{
												n = G.UIT.R,
												config = {
													padding = 0,
													align = "cm"
												},
												nodes = {
													{
														n = G.UIT.T,
														config = {
															text = localize('b_developed_by'),
															shadow = true,
															scale = scale * 0.8,
															colour = G.C.UI.TEXT_LIGHT
														}
													},
													{
														n = G.UIT.T,
														config = {
															text = "Steamo",
															shadow = true,
															scale = scale * 0.8,
															colour = G.C.BLUE
														}
													}
												}
                                            },
											{
												n = G.UIT.R,
												config = {
													padding = 0,
													align = "cm"
												},
												nodes = {
													{
														n = G.UIT.T,
														config = {
															text = localize('b_rewrite_by'),
															shadow = true,
															scale = scale * 0.8,
															colour = G.C.UI.TEXT_LIGHT
														}
													},
													{
														n = G.UIT.T,
														config = {
															text = "Aure",
															shadow = true,
															scale = scale * 0.8,
															colour = G.C.BLUE
														}
													}
												}
											},
											{
												n = G.UIT.R,
												config = {
													padding = 0.2,
													align = "cm",
												},
												nodes = {
													UIBox_button({
														minw = 3.85,
														button = "steamodded_github",
														label = {localize('b_github_project')}
													})
												}
											},
											{
												n = G.UIT.R,
												config = {
													padding = 0.2,
													align = "cm"
												},
												nodes = {
													{
														n = G.UIT.T,
														config = {
															text = localize('b_github_bugs_1')..'\n'..localize('b_github_bugs_2'),
															shadow = true,
															scale = scale * 0.5,
															colour = G.C.UI.TEXT_LIGHT
														}
                                                    },
													
												}
                                            },
										}
									}
								end
                            },
                            {
                                label = localize('b_steamodded_settings'),
								tab_definition_function = function()
                                    return {
                                        n = G.UIT.ROOT,
                                        config = {
                                            align = "cm",
                                            padding = 0.05,
                                            colour = G.C.CLEAR,
                                        },
                                        nodes = {
                                            create_toggle {
												label = localize('b_disable_mod_badges')
											}
										}
									}
								end
							}
						}
					})
				}
			}
		}
	}))
end

function G.FUNCS.steamodded_github(e)
	love.system.openURL("https://github.com/Steamopollys/Steamodded")
end

function G.FUNCS.mods_button(e)
	G.SETTINGS.paused = true
	SMODS.LAST_SELECTED_MOD_TAB = nil

	G.FUNCS.overlay_menu({
		definition = create_UIBox_mods_button()
	})
end

local create_UIBox_main_menu_buttonsRef = create_UIBox_main_menu_buttons
function create_UIBox_main_menu_buttons()
	local modsButton = UIBox_button({
		id = "mods_button",
		minh = 1.55,
		minw = 1.85,
		col = true,
		button = "mods_button",
		colour = G.C.BOOSTER,
		label = {localize('b_mods_cap')},
		scale = 0.45 * 1.2
	})
	local menu = create_UIBox_main_menu_buttonsRef()
	table.insert(menu.nodes[1].nodes[1].nodes, modsButton)
	menu.nodes[1].nodes[1].config = {align = "cm", padding = 0.15, r = 0.1, emboss = 0.1, colour = G.C.L_BLACK, mid = true}
	return menu
end

local create_UIBox_profile_buttonRef = create_UIBox_profile_button
function create_UIBox_profile_button()
	local profile_menu = create_UIBox_profile_buttonRef()
	profile_menu.nodes[1].config = {align = "cm", padding = 0.11, r = 0.1, emboss = 0.1, colour = G.C.L_BLACK}
	return(profile_menu)
end

-- Disable achievments and crash report upload
function initGlobals()
	G.F_NO_ACHIEVEMENTS = true
	G.F_CRASH_REPORTS = false
end

function G.FUNCS.update_mod_list(args)
	if not args or not args.cycle_config then return end
	SMODS.GUI.DynamicUIManager.updateDynamicAreas({
		["modsList"] = SMODS.GUI.dynamicModListContent(args.cycle_config.current_option)
	})
end

-- Same as Balatro base game code, but accepts a value to match against (rather than the index in the option list)
-- e.g. create_option_cycle({ current_option = 1 })  vs. SMODS.GUID.createOptionSelector({ current_option = "Page 1/2" })
function SMODS.GUI.createOptionSelector(args)
	args = args or {}
	args.colour = args.colour or G.C.RED
	args.options = args.options or {
		'Option 1',
		'Option 2'
	}

	local current_option_index = 1
	for i, option in ipairs(args.options) do
		if option == args.current_option then
			current_option_index = i
			break
		end
	end
	args.current_option_val = args.options[current_option_index]
	args.current_option = current_option_index
	args.opt_callback = args.opt_callback or nil
	args.scale = args.scale or 1
	args.ref_table = args.ref_table or nil
	args.ref_value = args.ref_value or nil
	args.w = (args.w or 2.5)*args.scale
	args.h = (args.h or 0.8)*args.scale
	args.text_scale = (args.text_scale or 0.5)*args.scale
	args.l = '<'
	args.r = '>'
	args.focus_args = args.focus_args or {}
	args.focus_args.type = 'cycle'

	local info = nil
	if args.info then
		info = {}
		for k, v in ipairs(args.info) do
			table.insert(info, {n=G.UIT.R, config={align = "cm", minh = 0.05}, nodes={
				{n=G.UIT.T, config={text = v, scale = 0.3*args.scale, colour = G.C.UI.TEXT_LIGHT}}
			}})
		end
		info =  {n=G.UIT.R, config={align = "cm", minh = 0.05}, nodes=info}
	end

	local disabled = #args.options < 2
	local pips = {}
	for i = 1, #args.options do
		pips[#pips+1] = {n=G.UIT.B, config={w = 0.1*args.scale, h = 0.1*args.scale, r = 0.05, id = 'pip_'..i, colour = args.current_option == i and G.C.WHITE or G.C.BLACK}}
	end

	local choice_pips = not args.no_pips and {n=G.UIT.R, config={align = "cm", padding = (0.05 - (#args.options > 15 and 0.03 or 0))*args.scale}, nodes=pips} or nil

	local t =
	{n=G.UIT.C, config={align = "cm", padding = 0.1, r = 0.1, colour = G.C.CLEAR, id = args.id and (not args.label and args.id or nil) or nil, focus_args = args.focus_args}, nodes={
		{n=G.UIT.C, config={align = "cm",r = 0.1, minw = 0.6*args.scale, hover = not disabled, colour = not disabled and args.colour or G.C.BLACK,shadow = not disabled, button = not disabled and 'option_cycle' or nil, ref_table = args, ref_value = 'l', focus_args = {type = 'none'}}, nodes={
			{n=G.UIT.T, config={ref_table = args, ref_value = 'l', scale = args.text_scale, colour = not disabled and G.C.UI.TEXT_LIGHT or G.C.UI.TEXT_INACTIVE}}
		}},
		args.mid and
				{n=G.UIT.C, config={id = 'cycle_main'}, nodes={
					{n=G.UIT.R, config={align = "cm", minh = 0.05}, nodes={
						args.mid
					}},
					not disabled and choice_pips or nil
				}}
				or {n=G.UIT.C, config={id = 'cycle_main', align = "cm", minw = args.w, minh = args.h, r = 0.1, padding = 0.05, colour = args.colour,emboss = 0.1, hover = true, can_collide = true, on_demand_tooltip = args.on_demand_tooltip}, nodes={
			{n=G.UIT.R, config={align = "cm"}, nodes={
				{n=G.UIT.R, config={align = "cm"}, nodes={
					{n=G.UIT.O, config={object = DynaText({string = {{ref_table = args, ref_value = "current_option_val"}}, colours = {G.C.UI.TEXT_LIGHT},pop_in = 0, pop_in_rate = 8, reset_pop_in = true,shadow = true, float = true, silent = true, bump = true, scale = args.text_scale, non_recalc = true})}},
				}},
				{n=G.UIT.R, config={align = "cm", minh = 0.05}, nodes={
				}},
				not disabled and choice_pips or nil
			}}
		}},
		{n=G.UIT.C, config={align = "cm",r = 0.1, minw = 0.6*args.scale, hover = not disabled, colour = not disabled and args.colour or G.C.BLACK,shadow = not disabled, button = not disabled and 'option_cycle' or nil, ref_table = args, ref_value = 'r', focus_args = {type = 'none'}}, nodes={
			{n=G.UIT.T, config={ref_table = args, ref_value = 'r', scale = args.text_scale, colour = not disabled and G.C.UI.TEXT_LIGHT or G.C.UI.TEXT_INACTIVE}}
		}},
	}}

	if args.cycle_shoulders then
		t =
		{n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR}, nodes = {
			{n=G.UIT.C, config={minw = 0.7,align = "cm", colour = G.C.CLEAR,func = 'set_button_pip', focus_args = {button = 'leftshoulder', type = 'none', orientation = 'cm', scale = 0.7, offset = {x = -0.1, y = 0}}}, nodes = {}},
			{n=G.UIT.C, config={id = 'cycle_shoulders', padding = 0.1}, nodes={t}},
			{n=G.UIT.C, config={minw = 0.7,align = "cm", colour = G.C.CLEAR,func = 'set_button_pip', focus_args = {button = 'rightshoulder', type = 'none', orientation = 'cm', scale = 0.7, offset = {x = 0.1, y = 0}}}, nodes = {}},
		}}
	else
		t =
		{n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, padding = 0.0}, nodes = {
			t
		}}
	end
	if args.label or args.info then
		t = {n=G.UIT.R, config={align = "cm", padding = 0.05, id = args.id or nil}, nodes={
			args.label and {n=G.UIT.R, config={align = "cm"}, nodes={
				{n=G.UIT.T, config={text = args.label, scale = 0.5*args.scale, colour = G.C.UI.TEXT_LIGHT}}
			}} or nil,
			t,
			info,
		}}
	end
	return t
end

local function generateBaseNode(staticPageDefinition)
	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			minh = 6,
			r = 0.1,
			minw = 8,
			align = "cm",
			padding = 0.2,
			colour = G.C.BLACK
		},
		nodes = {
			staticPageDefinition
		}
	}
end

-- Initialize a tab with sections that can be updated dynamically (e.g. modifying text labels, showing additional UI elements after toggling buttons, etc.)
function SMODS.GUI.DynamicUIManager.initTab(args)
	local updateFunctions = args.updateFunctions
	local staticPageDefinition = args.staticPageDefinition

	for _, updateFunction in pairs(updateFunctions) do
		G.E_MANAGER:add_event(Event({func = function()
			updateFunction{cycle_config = {current_option = 1}}
			return true
		end}))
	end
	return generateBaseNode(staticPageDefinition)
end

-- Call this to trigger an update for a list of dynamic content areas
function SMODS.GUI.DynamicUIManager.updateDynamicAreas(uiDefinitions)
	for id, uiDefinition in pairs(uiDefinitions) do
		local dynamicArea = G.OVERLAY_MENU:get_UIE_by_ID(id)
		if dynamicArea and dynamicArea.config.object then
			dynamicArea.config.object:remove()
			dynamicArea.config.object = UIBox{
				definition = uiDefinition,
				config = {offset = {x=0, y=0}, align = 'cm', parent = dynamicArea}
			}
		end
	end
end

local function recalculateModsList(page)
	local modsPerPage = 4
	local startIndex = (page - 1) * modsPerPage + 1
	local endIndex = startIndex + modsPerPage - 1
	local totalPages = math.ceil(#SMODS.mod_list / modsPerPage)
	local currentPage = localize('k_page') .. ' ' .. page .. "/" .. totalPages
	local pageOptions = {}
	for i = 1, totalPages do
		table.insert(pageOptions, (localize('k_page') .. ' ' .. tostring(i) .. "/" .. totalPages))
	end
	local showingList = #SMODS.mod_list > 0

	return currentPage, pageOptions, showingList, startIndex, endIndex, modsPerPage
end

-- Define the content in the pane that does not need to update
-- Should include OBJECT nodes that indicate where the dynamic content sections will be populated
-- EX: in this pane the 'modsList' node will contain the dynamic content which is defined in the function below
function SMODS.GUI.staticModListContent()
	local scale = 0.75
	local currentPage, pageOptions, showingList = recalculateModsList(1)
	return {
		n = G.UIT.ROOT,
		config = {
			minh = 6,
			r = 0.1,
			minw = 10,
			align = "tm",
			padding = 0.2,
			colour = G.C.BLACK
		},
		nodes = {
			-- row container
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.05 },
				nodes = {
					-- column container
					{
						n = G.UIT.C,
						config = { align = "cm", minw = 3, padding = 0.2, r = 0.1, colour = G.C.CLEAR },
						nodes = {
							-- title row
							{
								n = G.UIT.R,
								config = {
									padding = 0.05,
									align = "cm"
								},
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = localize('b_mod_list'),
											shadow = true,
											scale = scale * 0.6,
											colour = G.C.UI.TEXT_LIGHT
										}
									}
								}
							},

							-- add some empty rows for spacing
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0.05 },
								nodes = {}
							},
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0.05 },
								nodes = {}
							},
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0.05 },
								nodes = {}
							},
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0.05 },
								nodes = {}
							},

							-- dynamic content rendered in this row container
							-- list of 4 mods on the current page
							{
								n = G.UIT.R,
								config = {
									padding = 0.05,
									align = "cm",
									minh = 2,
									minw = 4
								},
								nodes = {
									{n=G.UIT.O, config={id = 'modsList', object = Moveable()}},
								}
							},

							-- another empty row for spacing
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0.3 },
								nodes = {}
							},

							-- page selector
							-- does not appear when list of mods is empty
							showingList and SMODS.GUI.createOptionSelector({label = "", scale = 0.8, options = pageOptions, opt_callback = 'update_mod_list', no_pips = true, current_option = (
									currentPage
							)}) or nil
						}
					},
				}
			},
		}
	}
end

function SMODS.GUI.dynamicModListContent(page)
    local scale = 0.75
    local _, __, showingList, startIndex, endIndex, modsPerPage = recalculateModsList(page)

    local modNodes = {}

    -- If no mods are loaded, show a default message
    if showingList == false then
        table.insert(modNodes, {
            n = G.UIT.R,
            config = {
                padding = 0,
                align = "cm"
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        text = localize('b_no_mods'),
                        shadow = true,
                        scale = scale * 0.5,
                        colour = G.C.UI.TEXT_DARK
                    }
                }
            }
        })
        table.insert(modNodes, {
            n = G.UIT.R,
            config = {
                padding = 0,
                align = "cm",
            },
            nodes = {
                UIBox_button({
                    label = { localize('b_open_mods_dir') },
                    shadow = true,
                    scale = scale,
                    colour = G.C.BOOSTER,
                    button = "openModsDirectory",
                    minh = 0.8,
                    minw = 8
                })
            }
        })
    else
        local modCount = 0
		local id = 0
		
		for _, condition in ipairs({
			function(m) return not m.can_load and not m.disabled end,
			function(m) return m.can_load end,
			function(m) return m.disabled end,
		}) do
			for _, modInfo in ipairs(SMODS.mod_list) do
				if modCount >= modsPerPage then break end
				if condition(modInfo) then
					id = id + 1
					if id >= startIndex and id <= endIndex then
						table.insert(modNodes, createClickableModBox(modInfo, scale * 0.5))
						modCount = modCount + 1
					end
				end
			end
		end
    end

    return {
        n = G.UIT.C,
        config = {
            r = 0.1,
            align = "cm",
            padding = 0.2,
        },
        nodes = modNodes
    }
end

function SMODS.init_settings()
    SMODS.SETTINGS = {
        no_mod_badges = false,
    }
end


----------------------------------------------
------------MOD CORE END----------------------

--- STEAMODDED CORE
--- MODULE STACKTRACE
-- NOTE: This is a modifed version of https://github.com/ignacio/StackTracePlus/blob/master/src/StackTracePlus.lua
-- Licensed under the MIT License. See https://github.com/ignacio/StackTracePlus/blob/master/LICENSE
-- The MIT License
-- Copyright (c) 2010 Ignacio Burgueño
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
-- tables
function loadStackTracePlus()
    local _G = _G
    local string, io, debug, coroutine = string, io, debug, coroutine

    -- functions
    local tostring, print, require = tostring, print, require
    local next, assert = next, assert
    local pcall, type, pairs, ipairs = pcall, type, pairs, ipairs
    local error = error

    assert(debug, "debug table must be available at this point")

    local io_open = io.open
    local string_gmatch = string.gmatch
    local string_sub = string.sub
    local table_concat = table.concat

    local _M = {
        max_tb_output_len = 70 -- controls the maximum length of the 'stringified' table before cutting with ' (more...)'
    }

    -- this tables should be weak so the elements in them won't become uncollectable
    local m_known_tables = {
        [_G] = "_G (global table)"
    }
    local function add_known_module(name, desc)
        local ok, mod = pcall(require, name)
        if ok then
            m_known_tables[mod] = desc
        end
    end

    add_known_module("string", "string module")
    add_known_module("io", "io module")
    add_known_module("os", "os module")
    add_known_module("table", "table module")
    add_known_module("math", "math module")
    add_known_module("package", "package module")
    add_known_module("debug", "debug module")
    add_known_module("coroutine", "coroutine module")

    -- lua5.2
    add_known_module("bit32", "bit32 module")
    -- luajit
    add_known_module("bit", "bit module")
    add_known_module("jit", "jit module")
    -- lua5.3
    if _VERSION >= "Lua 5.3" then
        add_known_module("utf8", "utf8 module")
    end

    local m_user_known_tables = {}

    local m_known_functions = {}
    for _, name in ipairs { -- Lua 5.2, 5.1
    "assert", "collectgarbage", "dofile", "error", "getmetatable", "ipairs", "load", "loadfile", "next", "pairs",
    "pcall", "print", "rawequal", "rawget", "rawlen", "rawset", "require", "select", "setmetatable", "tonumber",
    "tostring", "type", "xpcall", -- Lua 5.1
    "gcinfo", "getfenv", "loadstring", "module", "newproxy", "setfenv", "unpack" -- TODO: add table.* etc functions
    } do
        if _G[name] then
            m_known_functions[_G[name]] = name
        end
    end

    local m_user_known_functions = {}

    local function safe_tostring(value)
        local ok, err = pcall(tostring, value)
        if ok then
            return err
        else
            return ("<failed to get printable value>: '%s'"):format(err)
        end
    end

    -- Private:
    -- Parses a line, looking for possible function definitions (in a very naïve way)
    -- Returns '(anonymous)' if no function name was found in the line
    local function ParseLine(line)
        assert(type(line) == "string")
        -- print(line)
        local match = line:match("^%s*function%s+(%w+)")
        if match then
            -- print("+++++++++++++function", match)
            return match
        end
        match = line:match("^%s*local%s+function%s+(%w+)")
        if match then
            -- print("++++++++++++local", match)
            return match
        end
        match = line:match("^%s*local%s+(%w+)%s+=%s+function")
        if match then
            -- print("++++++++++++local func", match)
            return match
        end
        match = line:match("%s*function%s*%(") -- this is an anonymous function
        if match then
            -- print("+++++++++++++function2", match)
            return "(anonymous)"
        end
        return "(anonymous)"
    end

    -- Private:
    -- Tries to guess a function's name when the debug info structure does not have it.
    -- It parses either the file or the string where the function is defined.
    -- Returns '?' if the line where the function is defined is not found
    local function GuessFunctionName(info)
        -- print("guessing function name")
        if type(info.source) == "string" and info.source:sub(1, 1) == "@" then
            local file, err = io_open(info.source:sub(2), "r")
            if not file then
                print("file not found: " .. tostring(err)) -- whoops!
                return "?"
            end
            local line
            for _ = 1, info.linedefined do
                line = file:read("*l")
            end
            if not line then
                print("line not found") -- whoops!
                return "?"
            end
            return ParseLine(line)
        elseif type(info.source) == "string" and info.source:sub(1, 6) == "=[love" then
            return "(Love2D Function)"
        else
            local line
            local lineNumber = 0
            for l in string_gmatch(info.source, "([^\n]+)\n-") do
                lineNumber = lineNumber + 1
                if lineNumber == info.linedefined then
                    line = l
                    break
                end
            end
            if not line then
                print("line not found") -- whoops!
                return "?"
            end
            return ParseLine(line)
        end
    end

    ---
    -- Dumper instances are used to analyze stacks and collect its information.
    --
    local Dumper = {}

    Dumper.new = function(thread)
        local t = {
            lines = {}
        }
        for k, v in pairs(Dumper) do
            t[k] = v
        end

        t.dumping_same_thread = (thread == coroutine.running())

        -- if a thread was supplied, bind it to debug.info and debug.get
        -- we also need to skip this additional level we are introducing in the callstack (only if we are running
        -- in the same thread we're inspecting)
        if type(thread) == "thread" then
            t.getinfo = function(level, what)
                if t.dumping_same_thread and type(level) == "number" then
                    level = level + 1
                end
                return debug.getinfo(thread, level, what)
            end
            t.getlocal = function(level, loc)
                if t.dumping_same_thread then
                    level = level + 1
                end
                return debug.getlocal(thread, level, loc)
            end
        else
            t.getinfo = debug.getinfo
            t.getlocal = debug.getlocal
        end

        return t
    end

    -- helpers for collecting strings to be used when assembling the final trace
    function Dumper:add(text)
        self.lines[#self.lines + 1] = text
    end
    function Dumper:add_f(fmt, ...)
        self:add(fmt:format(...))
    end
    function Dumper:concat_lines()
        return table_concat(self.lines)
    end

    ---
    -- Private:
    -- Iterates over the local variables of a given function.
    --
    -- @param level The stack level where the function is.
    --
    function Dumper:DumpLocals(level)
        local prefix = "\t "
        local i = 1

        if self.dumping_same_thread then
            level = level + 1
        end

        local name, value = self.getlocal(level, i)
        if not name then
            return
        end
        self:add("\tLocal variables:\r\n")
        while name do
            if type(value) == "number" then
                self:add_f("%s%s = number: %g\r\n", prefix, name, value)
            elseif type(value) == "boolean" then
                self:add_f("%s%s = boolean: %s\r\n", prefix, name, tostring(value))
            elseif type(value) == "string" then
                self:add_f("%s%s = string: %q\r\n", prefix, name, value)
            elseif type(value) == "userdata" then
                self:add_f("%s%s = %s\r\n", prefix, name, safe_tostring(value))
            elseif type(value) == "nil" then
                self:add_f("%s%s = nil\r\n", prefix, name)
            elseif type(value) == "table" then
                if m_known_tables[value] then
                    self:add_f("%s%s = %s\r\n", prefix, name, m_known_tables[value])
                elseif m_user_known_tables[value] then
                    self:add_f("%s%s = %s\r\n", prefix, name, m_user_known_tables[value])
                else
                    local txt = "{"
                    for k, v in pairs(value) do
                        txt = txt .. safe_tostring(k) .. ":" .. safe_tostring(v)
                        if #txt > _M.max_tb_output_len then
                            txt = txt .. " (more...)"
                            break
                        end
                        if next(value, k) then
                            txt = txt .. ", "
                        end
                    end
                    self:add_f("%s%s = %s  %s\r\n", prefix, name, safe_tostring(value), txt .. "}")
                end
            elseif type(value) == "function" then
                local info = self.getinfo(value, "nS")
                local fun_name = info.name or m_known_functions[value] or m_user_known_functions[value]
                if info.what == "C" then
                    self:add_f("%s%s = C %s\r\n", prefix, name,
                        (fun_name and ("function: " .. fun_name) or tostring(value)))
                else
                    local source = info.short_src
                    if source:sub(2, 7) == "string" then
                        source = source:sub(9) -- uno más, por el espacio que viene (string "Baragent.Main", por ejemplo)
                    end
                    -- for k,v in pairs(info) do print(k,v) end
                    fun_name = fun_name or GuessFunctionName(info)
                    self:add_f("%s%s = Lua function '%s' (defined at line %d of chunk %s)\r\n", prefix, name, fun_name,
                        info.linedefined, source)
                end
            elseif type(value) == "thread" then
                self:add_f("%sthread %q = %s\r\n", prefix, name, tostring(value))
            end
            i = i + 1
            name, value = self.getlocal(level, i)
        end
    end

    ---
    -- Public:
    -- Collects a detailed stack trace, dumping locals, resolving function names when they're not available, etc.
    -- This function is suitable to be used as an error handler with pcall or xpcall
    --
    -- @param thread An optional thread whose stack is to be inspected (defaul is the current thread)
    -- @param message An optional error string or object.
    -- @param level An optional number telling at which level to start the traceback (default is 1)
    --
    -- Returns a string with the stack trace and a string with the original error.
    --
    function _M.stacktrace(thread, message, level)
        if type(thread) ~= "thread" then
            -- shift parameters left
            thread, message, level = nil, thread, message
        end

        thread = thread or coroutine.running()

        level = level or 1

        local dumper = Dumper.new(thread)

        local original_error

        if type(message) == "table" then
            dumper:add("an error object {\r\n")
            local first = true
            for k, v in pairs(message) do
                if first then
                    dumper:add("  ")
                    first = false
                else
                    dumper:add(",\r\n  ")
                end
                dumper:add(safe_tostring(k))
                dumper:add(": ")
                dumper:add(safe_tostring(v))
            end
            dumper:add("\r\n}")
            original_error = dumper:concat_lines()
        elseif type(message) == "string" then
            dumper:add(message)
            original_error = message
        end

        dumper:add("\r\n")
        dumper:add [[
Stack Traceback
===============
]]
        -- print(error_message)

        local level_to_show = level
        if dumper.dumping_same_thread then
            level = level + 1
        end

        local info = dumper.getinfo(level, "nSlf")
        while info do
            if info.what == "main" then
                if string_sub(info.source, 1, 1) == "@" then
                    dumper:add_f("(%d) main chunk of file '%s' at line %d\r\n", level_to_show,
                        string_sub(info.source, 2), info.currentline)
                elseif info.source and info.source:sub(1, 1) == "=" then
                    local str = info.source:sub(3, -2)
                    local props = {}
                    -- Split by space
                    for v in string.gmatch(str, "[^%s]+") do
                        table.insert(props, v)
                    end
                    local source = table.remove(props, 1)
                    if source == "love" then
                        dumper:add_f("(%d) main chunk of Love2D file '%s' at line %d\r\n", level_to_show,
                            table.concat(props, " "):sub(2, -2), info.currentline)
                    elseif source == "SMODS" then
                        local modID = table.remove(props, 1)
                        local fileName = table.concat(props, " ")
                        dumper:add_f("(%d) main chunk of file '%s' at line %d (from mod with id %s)\r\n", level_to_show,
                            fileName:sub(2, -2), info.currentline, modID)
                    else
                        dumper:add_f("(%d) main chunk of %s at line %d\r\n", level_to_show, info.source, info.currentline)
                    end
                else
                    dumper:add_f("(%d) main chunk of %s at line %d\r\n", level_to_show, info.source, info.currentline)
                end
            elseif info.what == "C" then
                -- print(info.namewhat, info.name)
                -- for k,v in pairs(info) do print(k,v, type(v)) end
                local function_name = m_user_known_functions[info.func] or m_known_functions[info.func] or info.name or
                                          tostring(info.func)
                dumper:add_f("(%d) %s C function '%s'\r\n", level_to_show, info.namewhat, function_name)
                -- dumper:add_f("%s%s = C %s\r\n", prefix, name, (m_known_functions[value] and ("function: " .. m_known_functions[value]) or tostring(value)))
            elseif info.what == "tail" then
                -- print("tail")
                -- for k,v in pairs(info) do print(k,v, type(v)) end--print(info.namewhat, info.name)
                dumper:add_f("(%d) tail call\r\n", level_to_show)
                dumper:DumpLocals(level)
            elseif info.what == "Lua" then
                local source = info.short_src
                local function_name = m_user_known_functions[info.func] or m_known_functions[info.func] or info.name
                if source:sub(2, 7) == "string" then
                    source = source:sub(9)
                end
                local was_guessed = false
                if not function_name or function_name == "?" then
                    -- for k,v in pairs(info) do print(k,v, type(v)) end
                    function_name = GuessFunctionName(info)
                    was_guessed = true
                end
                -- test if we have a file name
                local function_type = (info.namewhat == "") and "function" or info.namewhat
                if info.source and info.source:sub(1, 1) == "@" then
                    dumper:add_f("(%d) Lua %s '%s' at file '%s:%d'%s\r\n", level_to_show, function_type, function_name,
                        info.source:sub(2), info.currentline, was_guessed and " (best guess)" or "")
                elseif info.source and info.source:sub(1, 1) == '#' then
                    dumper:add_f("(%d) Lua %s '%s' at template '%s:%d'%s\r\n", level_to_show, function_type,
                        function_name, info.source:sub(2), info.currentline, was_guessed and " (best guess)" or "")
                elseif info.source and info.source:sub(1, 1) == "=" then
                    local str = info.source:sub(3, -2)
                    local props = {}
                    -- Split by space
                    for v in string.gmatch(str, "[^%s]+") do
                        table.insert(props, v)
                    end
                    local source = table.remove(props, 1)
                    if source == "love" then
                        dumper:add_f("(%d) Love2D %s at file '%s:%d'%s\r\n", level_to_show, function_type,
                            table.concat(props, " "):sub(2, -2), info.currentline, was_guessed and " (best guess)" or "")
                    elseif source == "SMODS" then
                        local modID = table.remove(props, 1)
                        local fileName = table.concat(props, " ")
                        dumper:add_f("(%d) Lua %s '%s' at file '%s:%d' (from mod with id %s)%s\r\n", level_to_show,
                            function_type, function_name, fileName:sub(2, -2), info.currentline, modID,
                            was_guessed and " (best guess)" or "")
                    else
                        dumper:add_f("(%d) Lua %s '%s' at line %d of chunk '%s'\r\n", level_to_show, function_type,
                            function_name, info.currentline, source)
                    end
                else
                    dumper:add_f("(%d) Lua %s '%s' at line %d of chunk '%s'\r\n", level_to_show, function_type,
                        function_name, info.currentline, source)
                end
                dumper:DumpLocals(level)
            else
                dumper:add_f("(%d) unknown frame %s\r\n", level_to_show, info.what)
            end

            level = level + 1
            level_to_show = level_to_show + 1
            info = dumper.getinfo(level, "nSlf")
        end

        return dumper:concat_lines(), original_error
    end

    --
    -- Adds a table to the list of known tables
    function _M.add_known_table(tab, description)
        if m_known_tables[tab] then
            error("Cannot override an already known table")
        end
        m_user_known_tables[tab] = description
    end

    --
    -- Adds a function to the list of known functions
    function _M.add_known_function(fun, description)
        if m_known_functions[fun] then
            error("Cannot override an already known function")
        end
        m_user_known_functions[fun] = description
    end

    return _M
end

-- Note: The below code is not from the original StackTracePlus.lua
local stackTraceAlreadyInjected = false

function getDebugInfoForCrash()
    local info = "Additional Context:\nBalatro Version: " .. VERSION .. "\nModded Version: " .. MODDED_VERSION
    local major, minor, revision, codename = love.getVersion()
    info = info .. string.format("\nLove2D Version: %d.%d.%d", major, minor, revision)

    local lovely_success, lovely = pcall(require, "lovely")
    if lovely_success then
        info = info .. "\nLovely Version: " .. lovely.version
    end
    if SMODS.mod_list then
        info = info .. "\nSteamodded Mods:"
        local enabled_mods = {}
        for _, v in ipairs(SMODS.mod_list) do
            if v.can_load then table.insert(enabled_mods, v) end
        end
        for k, v in ipairs(enabled_mods) do
            info = info .. "\n    " .. k .. ": " .. v.name .. " by " .. concatAuthors(v.author) .. " [ID: " .. v.id ..
                       (v.priority ~= 0 and (", Priority: " .. v.priority) or "") .. (v.version and v.version ~= '0.0.0' and (", Version: " .. v.version) or "") .. "]"
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

function injectStackTrace()
    if (stackTraceAlreadyInjected) then
        return
    end
    stackTraceAlreadyInjected = true
    local STP = loadStackTracePlus()
    local utf8 = require("utf8")

    -- Modifed from https://love2d.org/wiki/love.errorhandler
    function love.errorhandler(msg)
        msg = tostring(msg)

        sendErrorMessage("Oops! The game crashed\n" .. STP.stacktrace(msg), 'StackTrace')

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

        love.graphics.clear(G.C.BLACK)
        love.graphics.origin()

        local trace = STP.stacktrace("", 3)

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
            sendInfoMessage(msg, 'StackTrace')
        else
            table.insert(err, "\n" .. "Failed to get additional context :/")
            sendErrorMessage("Failed to get additional context :/\n" .. msg, 'StackTrace')
        end

        for l in trace:gmatch("(.-)\n") do
            table.insert(err, l)
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
            love.graphics.clear(G.C.BLACK)
            calcEndHeight()
            love.graphics.printf(p, pos, pos - scrollOffset, love.graphics.getWidth() - pos * 2)
            if scrollOffset ~= endHeight then
            love.graphics.polygon("fill", love.graphics.getWidth() - (pos / 2), love.graphics.getHeight() - arrowSize,
                love.graphics.getWidth() - (pos / 2) + arrowSize, love.graphics.getHeight() - (arrowSize * 2),
                love.graphics.getWidth() - (pos / 2) - arrowSize, love.graphics.getHeight() - (arrowSize * 2))
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

        p = p .. "\n\nPress R to restart the game"
        if love.system then
            p = p .. "\nPress Ctrl+C or tap to copy this error"
        end

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

injectStackTrace()

-- ----------------------------------------------
-- --------MOD CORE API STACKTRACE END-----------

--- STEAMODDED CORE
--- UTILITY FUNCTIONS
function inspect(table)
	if type(table) ~= 'table' then
		return "Not a table"
	end

	local str = ""
	for k, v in pairs(table) do
		local valueStr = type(v) == "table" and "table" or tostring(v)
		str = str .. tostring(k) .. ": " .. valueStr .. "\n"
	end

	return str
end

function inspectDepth(table, indent, depth)
	if depth and depth > 5 then  -- Limit the depth to avoid deep nesting
		return "Depth limit reached"
	end

	if type(table) ~= 'table' then  -- Ensure the object is a table
		return "Not a table"
	end

	local str = ""
	if not indent then indent = 0 end

	for k, v in pairs(table) do
		local formatting = string.rep("  ", indent) .. tostring(k) .. ": "
		if type(v) == "table" then
			str = str .. formatting .. "\n"
			str = str .. inspectDepth(v, indent + 1, (depth or 0) + 1)
		elseif type(v) == 'function' then
			str = str .. formatting .. "function\n"
		elseif type(v) == 'boolean' then
			str = str .. formatting .. tostring(v) .. "\n"
		else
			str = str .. formatting .. tostring(v) .. "\n"
		end
	end

	return str
end

function inspectFunction(func)
    if type(func) ~= 'function' then
        return "Not a function"
    end

    local info = debug.getinfo(func)
    local result = "Function Details:\n"

    if info.what == "Lua" then
        result = result .. "Defined in Lua\n"
    else
        result = result .. "Defined in C or precompiled\n"
    end

    result = result .. "Name: " .. (info.name or "anonymous") .. "\n"
    result = result .. "Source: " .. info.source .. "\n"
    result = result .. "Line Defined: " .. info.linedefined .. "\n"
    result = result .. "Last Line Defined: " .. info.lastlinedefined .. "\n"
    result = result .. "Number of Upvalues: " .. info.nups .. "\n"

    return result
end

function SMODS._save_d_u(o)
    assert(not o._discovered_unlocked_overwritten)
    o._d, o._u = o.discovered, o.unlocked
    o._saved_d_u = true
end

function SMODS.SAVE_UNLOCKS()
    boot_print_stage("Saving Unlocks")
	G:save_progress()
    -------------------------------------
    local TESTHELPER_unlocks = false and not _RELEASE_MODE
    -------------------------------------
    if not love.filesystem.getInfo(G.SETTINGS.profile .. '') then
        love.filesystem.createDirectory(G.SETTINGS.profile ..
            '')
    end
    if not love.filesystem.getInfo(G.SETTINGS.profile .. '/' .. 'meta.jkr') then
        love.filesystem.append(
            G.SETTINGS.profile .. '/' .. 'meta.jkr', 'return {}')
    end

    convert_save_to_meta()

    local meta = STR_UNPACK(get_compressed(G.SETTINGS.profile .. '/' .. 'meta.jkr') or 'return {}')
    meta.unlocked = meta.unlocked or {}
    meta.discovered = meta.discovered or {}
    meta.alerted = meta.alerted or {}

    G.P_LOCKED = {}
    for k, v in pairs(G.P_CENTERS) do
        if not v.wip and not v.demo then
            if TESTHELPER_unlocks then
                v.unlocked = true; v.discovered = true; v.alerted = true
            end --REMOVE THIS
            if not v.unlocked and (string.find(k, '^j_') or string.find(k, '^b_') or string.find(k, '^v_')) and meta.unlocked[k] then
                v.unlocked = true
            end
            if not v.unlocked and (string.find(k, '^j_') or string.find(k, '^b_') or string.find(k, '^v_')) then
                G.P_LOCKED[#G.P_LOCKED + 1] = v
            end
            if not v.discovered and (string.find(k, '^j_') or string.find(k, '^b_') or string.find(k, '^e_') or string.find(k, '^c_') or string.find(k, '^p_') or string.find(k, '^v_')) and meta.discovered[k] then
                v.discovered = true
            end
            if v.discovered and meta.alerted[k] or v.set == 'Back' or v.start_alerted then
                v.alerted = true
            elseif v.discovered then
                v.alerted = false
            end
        end
    end

	table.sort(G.P_LOCKED, function (a, b) return a.order and b.order and a.order < b.order end)

	for k, v in pairs(G.P_BLINDS) do
        v.key = k
        if not v.wip and not v.demo then 
            if TESTHELPER_unlocks then v.discovered = true; v.alerted = true  end --REMOVE THIS
            if not v.discovered and meta.discovered[k] then 
                v.discovered = true
            end
            if v.discovered and meta.alerted[k] then 
                v.alerted = true
            elseif v.discovered then
                v.alerted = false
            end
        end
    end
	for k, v in pairs(G.P_TAGS) do
        v.key = k
        if not v.wip and not v.demo then 
            if TESTHELPER_unlocks then v.discovered = true; v.alerted = true  end --REMOVE THIS
            if not v.discovered and meta.discovered[k] then 
                v.discovered = true
            end
            if v.discovered and meta.alerted[k] then 
                v.alerted = true
            elseif v.discovered then
                v.alerted = false
            end
        end
    end
    for k, v in pairs(G.P_SEALS) do
        v.key = k
        if not v.wip and not v.demo then
            if TESTHELPER_unlocks then
                v.discovered = true; v.alerted = true
            end                                                                   --REMOVE THIS
            if not v.discovered and meta.discovered[k] then
                v.discovered = true
            end
            if v.discovered and meta.alerted[k] then
                v.alerted = true
            elseif v.discovered then
                v.alerted = false
            end
        end
    end
    for _, t in ipairs{
        G.P_CENTERS,
        G.P_BLINDS,
        G.P_TAGS,
        G.P_SEALS,
    } do
        for k, v in pairs(t) do
            v._discovered_unlocked_overwritten = true
        end
    end
end

function SMODS.process_loc_text(ref_table, ref_value, loc_txt, key)
    local target = (type(loc_txt) == 'table') and
    (loc_txt[G.SETTINGS.language] or loc_txt['default'] or loc_txt['en-us']) or loc_txt
    if key and (type(target) == 'table') then target = target[key] end
    if not (type(target) == 'string' or target and next(target)) then return end
    ref_table[ref_value] = target
end

function SMODS.handle_loc_file(path)
    local dir = path .. 'localization/'
	local file_name
    for k, v in ipairs({ dir .. G.SETTINGS.language .. '.lua', dir .. 'default.lua', dir .. 'en-us.lua' }) do
        if NFS.getInfo(v) then
            file_name = v
            break
        end
    end
    if not file_name then return end
    local loc_table = assert(loadstring(NFS.read(file_name)))()
    local function recurse(target, ref_table)
        if type(target) ~= 'table' then return end --this shouldn't happen unless there's a bad return value
        for k, v in pairs(target) do
            if not ref_table[k] or (type(v) ~= 'table') then
                ref_table[k] = v
            else
                recurse(v, ref_table[k])
            end
        end
    end
	recurse(loc_table, G.localization)
end

function SMODS.insert_pool(pool, center, replace)
	if replace == nil then replace = center.taken_ownership end
	if replace then
		for k, v in ipairs(pool) do
            if v.key == center.key then
                pool[k] = center
            end
		end
    else
		local prev_order = (pool[#pool] and pool[#pool].order) or 0
		if prev_order ~= nil then 
			center.order = prev_order + 1
		end
		table.insert(pool, center)
	end
end

function SMODS.remove_pool(pool, key)
    local j
    for i, v in ipairs(pool) do
        if v.key == key then j = i end
    end
    if j then return table.remove(pool, j) end
end

function SMODS.juice_up_blind()
    local ui_elem = G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff')
    for _, v in ipairs(ui_elem.children) do
        v.children[1]:juice_up(0.3, 0)
    end
    G.GAME.blind:juice_up()
end

function SMODS.eval_this(_card, effects)
    if effects then
        local extras = { mult = false, hand_chips = false }
        if effects.mult_mod then
            mult = mod_mult(mult + effects.mult_mod); extras.mult = true
        end
        if effects.chip_mod then
            hand_chips = mod_chips(hand_chips + effects.chip_mod); extras.hand_chips = true
        end
        if effects.Xmult_mod then
            mult = mod_mult(mult * effects.Xmult_mod); extras.mult = true
        end
        update_hand_text({ delay = 0 }, { chips = extras.hand_chips and hand_chips, mult = extras.mult and mult })
        if effects.message then
            card_eval_status_text(_card, 'jokers', nil, nil, nil, effects)
        end
    end
end

-- Return an array of all (non-debuffed) jokers or consumables with key `key`.
-- Debuffed jokers count if `count_debuffed` is true.
-- This function replaces find_joker(); please use SMODS.find_card() instead
-- to avoid name conflicts with other mods.
function SMODS.find_card(key, count_debuffed)
    local results = {}
    if not G.jokers or not G.jokers.cards then return {} end
    for k, v in pairs(G.jokers.cards) do
        if v and type(v) == 'table' and v.config.center.key == key and (count_debuffed or not v.debuff) then
            table.insert(results, v)
        end
    end
    for k, v in pairs(G.consumeables.cards) do
        if v and type(v) == 'table' and v.config.center.key == key and (count_debuffed or not v.debuff) then
            table.insert(results, v)
        end
    end
    return results
end

function SMODS.create_card(t)
    if not t.area and t.key and G.P_CENTERS[t.key] then
        t.area = G.P_CENTERS[t.key].consumeable and G.consumeables or G.P_CENTERS[t.key].set == 'Joker' and G.jokers
    end
    if not t.area and not t.key and t.set and SMODS.ConsumableTypes[t.set] then
        t.area = G.consumeables
    end
    SMODS.bypass_create_card_edition = t.no_edition
    local _card = create_card(t.set, t.area, t.legendary, t.rarity, t.skip_materialize, t.soulable, t.key, t.key_append)
    SMODS.bypass_create_card_edition = nil
    return _card
end

-- Recalculate whether a card should be debuffed
function SMODS.recalc_debuff(card)
    G.GAME.blind:debuff_card(card)
end

function SMODS.reload()
    local lfs = love.filesystem
    local function recurse(dir)
        local files = lfs.getDirectoryItems(dir)
        for i, v in ipairs(files) do
            local file = (dir == '') and v or (dir .. '/' .. v)
            sendTraceMessage(file)
            if v == 'Mods' or v:len() == 1 then
                -- exclude save files
            elseif lfs.isFile(file) then
                lua_reload.ReloadFile(file)
            elseif lfs.isDirectory(file) then
                recurse(file)
            end
        end
    end
    recurse('')
    SMODS.booted = false
    G:init_item_prototypes()
    initSteamodded()
end

function SMODS.restart_game()
	if love.system.getOS() ~= 'OS X' then
		love.system.openURL('steam://rungameid/2379780')
	else
		os.execute('sh "/Users/$USER/Library/Application Support/Steam/steamapps/common/Balatro/run_lovely.sh" &')
	end
	love.event.quit()
end

function SMODS.create_mod_badges(obj, badges)
    if not G.SETTINGS.no_mod_badges and obj and obj.mod and obj.mod.display_name and not obj.no_mod_badges then
        local mods = {}
        badges.mod_set = badges.mod_set or {}
        if not badges.mod_set[obj.mod.id] and not obj.no_main_mod_badge then table.insert(mods, obj.mod) end
        badges.mod_set[obj.mod.id] = true
        if obj.dependencies then
            for _, v in ipairs(obj.dependencies) do
                local m = SMODS.Mods[v]
                if not badges.mod_set[m.id] then
                    table.insert(mods, m)
                    badges.mod_set[m.id] = true
                end
            end
        end
        for i, mod in ipairs(mods) do
            local mod_name = string.sub(mod.display_name, 1, 20)
            local size = 0.9
            local font = G.LANG.font
            local max_text_width = 2 - 2*0.05 - 4*0.03*size - 2*0.03
            local calced_text_width = 0
            -- Math reproduced from DynaText:update_text
            for _, c in utf8.chars(mod_name) do
                local tx = font.FONT:getWidth(c)*(0.33*size)*G.TILESCALE*font.FONTSCALE + 2.7*1*G.TILESCALE*font.FONTSCALE
                calced_text_width = calced_text_width + tx/(G.TILESIZE*G.TILESCALE)
            end
            local scale_fac =
                calced_text_width > max_text_width and max_text_width/calced_text_width
                or 1
            badges[#badges + 1] = {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.R, config={align = "cm", colour = mod.badge_colour or G.C.GREEN, r = 0.1, minw = 2, minh = 0.36, emboss = 0.05, padding = 0.03*size}, nodes={
                  {n=G.UIT.B, config={h=0.1,w=0.03}},
                  {n=G.UIT.O, config={object = DynaText({string = mod_name or 'ERROR', colours = {mod.badge_text_colour or G.C.WHITE},float = true, shadow = true, offset_y = -0.05, silent = true, spacing = 1*scale_fac, scale = 0.33*size*scale_fac})}},
                  {n=G.UIT.B, config={h=0.1,w=0.03}},
                }}
              }}
        end
    end
end

function SMODS.create_loc_dump()
    local _old, _new = SMODS.dump_loc.pre_inject, G.localization
    local _dump = {}
    local function recurse(old, new, dump)
        for k, _ in pairs(new) do
            if type(new[k]) == 'table' then
                dump[k] = {}
                if not old[k] then
                    dump[k] = new[k]
                else
                    recurse(old[k], new[k], dump[k])
                end
            elseif old[k] ~= new[k] then
                dump[k] = new[k]
            end
        end
    end
    recurse(_old, _new, _dump)
    local function cleanup(dump)
        for k, v in pairs(dump) do
            if type(v) == 'table' then
                cleanup(v)
                if not next(v) then dump[k] = nil end
            end
        end
    end
    cleanup(_dump)
    local str = 'return ' .. serialize(_dump)
	NFS.createDirectory(SMODS.dump_loc.path..'localization/')
	NFS.write(SMODS.dump_loc.path..'localization/dump.lua', str)
end

-- Serializes an input table in valid Lua syntax
-- Keys must be of type number or string
-- Values must be of type number, boolean, string or table
function serialize(t, indent)
    indent = indent or ''
    local str = '{\n'
	for k, v in ipairs(t) do
        str = str .. indent .. '\t'
		if type(v) == 'number' then
            str = str .. v
        elseif type(v) == 'boolean' then
            str = str .. (v and 'true' or 'false')
        elseif type(v) == 'string' then
            str = str .. serialize_string(v)
        elseif type(v) == 'table' then
            str = str .. serialize(v, indent .. '\t')
        else
            -- not serializable
            str = str .. 'nil'
        end
		str = str .. ',\n'
	end
    for k, v in pairs(t) do
		if type(k) == 'string' then
        	str = str .. indent .. '\t' .. '[' .. serialize_string(k) .. '] = '
            
			if type(v) == 'number' then
				str = str .. v
            elseif type(v) == 'boolean' then
                str = str .. (v and 'true' or 'false')
			elseif type(v) == 'string' then
				str = str .. serialize_string(v)
			elseif type(v) == 'table' then
				str = str .. serialize(v, indent .. '\t')
			else
				-- not serializable
                str = str .. 'nil'
			end
			str = str .. ',\n'
		end
    end
    str = str .. indent .. '}'
	return str
end

function serialize_string(s)
	return string.format("%q", s)
end

-- Starting with `t`, insert any key-value pairs from `defaults` that don't already
-- exist in `t` into `t`. Modifies `t`.
-- Returns `t`, the result of the merge.
--
-- `nil` inputs count as {}; `false` inputs count as a table where
-- every possible key maps to `false`. Therefore,
-- * `t == nil` is weak and falls back to `defaults`
-- * `t == false` explicitly ignores `defaults`
-- (This function might not return a table, due to the above)
function SMODS.merge_defaults(t, defaults)
    if t == false then return false end
    if defaults == false then return false end

    -- Add in the keys from `defaults`, returning a table
    if defaults == nil then return t end
    if t == nil then t = {} end
    for k, v in pairs(defaults) do
        if t[k] == nil then
            t[k] = v
        end
    end
    return t
end

--#region palettes
G.SETTINGS.selected_colours = G.SETTINGS.selected_colours or {}
G.PALETTE = {}

G.FUNCS.update_recolor = function(args)
    G.SETTINGS.selected_colours[args.cycle_config.type] = SMODS.Palettes[args.cycle_config.type][args.to_val]
	G:save_settings()
	G.FUNCS.update_atlas(args.cycle_config.type)
end

-- Set the atlases of all cards of the correct type to be the new palette
G.FUNCS.update_atlas = function(type)
	local atlas_keys = {}
	if type == "Suits" then
		atlas_keys = {"cards_1", "ui_1"}
		G.C["SO_1"].Clubs = G.SETTINGS.selected_colours[type].new_colours[1] or G.C["SO_1"].Clubs
		G.C["SO_1"].Spades = G.SETTINGS.selected_colours[type].new_colours[2] or G.C["SO_1"].Spades
		G.C["SO_1"].Diamonds = G.SETTINGS.selected_colours[type].new_colours[3] or G.C["SO_1"].Diamonds
		G.C["SO_1"].Hearts = G.SETTINGS.selected_colours[type].new_colours[4] or G.C["SO_1"].Hearts
		G.C.SUITS = G.C.SO_1
			
	else
		for _,v in pairs(G.P_CENTER_POOLS[type]) do
			atlas_keys[v.atlas or type] = v.atlas or type
		end
	end
	for _,v in pairs(atlas_keys) do
		if G.ASSET_ATLAS[v][G.SETTINGS.selected_colours[type].name] then
			G.ASSET_ATLAS[v].image = G.ASSET_ATLAS[v][G.SETTINGS.selected_colours[type].name].image
		end
	end
end

G.FUNCS.card_colours = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
      definition = G.UIDEF.card_colours(),
    }
  end

G.UIDEF.card_colours = function()
    local nodeRet = {}
    for _,k in ipairs(SMODS.Palettes.Types) do
		local v = SMODS.Palettes[k]
        if #v.names > 1 then
            nodeRet[#nodeRet+1] = create_option_cycle({w = 4,scale = 0.8, label = k.." colours" ,options = v.names, opt_callback = "update_recolor", current_option = G.SETTINGS.selected_colours[k].order, type=k})
        end
    end
    local t = create_UIBox_generic_options({back_func = 'options', contents = nodeRet})
    return t
end

G.FUNCS.recolour_image = function(x,y,r,g,b,a)
	if G.PALETTE.NEW.old_colours then
		for i=1, #G.PALETTE.NEW.old_colours do
			local defaultColour = G.PALETTE.NEW.old_colours[i]
			if defaultColour[1] == r and defaultColour[2] == g and defaultColour[3] == b then
				r = G.PALETTE.NEW.new_colours[i][1]
				g = G.PALETTE.NEW.new_colours[i][2]
				b = G.PALETTE.NEW.new_colours[i][3]
				return r,g,b,a
			end
		end
	end
	return r, g, b, a
end

function HEX_HSL(base_colour)
	local rgb = HEX(base_colour)
	local low = math.min(rgb[1], rgb[2], rgb[3])
	local high = math.max(rgb[1], rgb[2], rgb[3])
	local delta = high - low
	local sum = high + low
	local hsl = {0, 0, 0.5 * sum, rgb[4]}
	
	if delta == 0 then return hsl end
	
	if hsl[3] == 1 or hsl[3] == 0 then
		hsl[2] = 0
	else
		hsl[2] = delta/1-math.abs(2*hsl[3] - 1)
	end
	
	if high == rgb[1] then
		hsl[1] = ((rgb[2]-rgb[3])/delta) % 6
	elseif high == rgb[2] then
		hsl[1] = 2 + (rgb[3]-rgb[1])/delta
	else
		hsl[1] = 4 + (rgb[1]-rgb[2])/delta 
	end
	hsl[1] = hsl[1]/6
	return hsl
end

function HSL_RGB(base_colour)
	if base_colour[2] < 0.0001 then return {base_colour[3], base_colour[3], base_colour[3], base_colour[4]} end
	local t = (base_colour[3] < 0.5 and (base_colour[2]*base_colour[3] + base_colour[3]) or (-1 * base_colour[2] * base_colour[3] + (base_colour[2]+base_colour[3])))
	local s = 2 * base_colour[3] - t

	return {HUE(s, t, base_colour[1] + (1/3)), HUE(s,t,base_colour[1]), HUE(s,t,base_colour[1] - (1/3)), base_colour[4]}
end

function HUE(s, t, h)
	local hs = (h % 1) * 6
	if hs < 1 then return (t-s) * hs + s end
	if hs < 3 then return t end
	if hs < 4 then return (t-s) * (4-hs) + s end
	return s
end

--#endregion

--- STEAMODDED CORE
--- OVERRIDES

--#region blind UI
-- Recreate all lines of the blind description.
-- This callback is called each frame.
---@param e {}
--**e** Is the UIE that called this function
G.FUNCS.HUD_blind_debuff = function(e)
	local scale = 0.4
	local num_lines = #G.GAME.blind.loc_debuff_lines
	while G.GAME.blind.loc_debuff_lines[num_lines] == '' do
		num_lines = num_lines - 1
	end
	local padding = 0.05
	if num_lines > 5 then
		local excess_height = (0.3 + padding)*(num_lines - 5)
		padding = padding - excess_height / (num_lines + 1)
	end
	e.config.padding = padding
	if num_lines > #e.children then
		for i = #e.children+1, num_lines do
			local node_def = {n = G.UIT.R, config = {align = "cm", minh = 0.3, maxw = 4.2}, nodes = {
				{n = G.UIT.T, config = {ref_table = G.GAME.blind.loc_debuff_lines, ref_value = i, scale = scale * 0.9, colour = G.C.UI.TEXT_LIGHT}}}}
			e.UIBox:set_parent_child(node_def, e)
		end
	elseif num_lines < #e.children then
		for i = num_lines+1, #e.children do
			e.children[i]:remove()
			e.children[i] = nil
		end
	end
	e.UIBox:recalculate()
	assert(G.HUD_blind == e.UIBox)
end
--#endregion
--#region stakes UI
function SMODS.applied_stakes_UI(i, stake_desc_rows, num_added)
	if num_added == nil then num_added = { val = 0 } end
	if G.P_CENTER_POOLS['Stake'][i].applied_stakes then
		for _, v in pairs(G.P_CENTER_POOLS['Stake'][i].applied_stakes) do
			if v ~= "white" then
				--todo: manage this with pages
				if num_added.val < 8 then
					local i = G.P_STAKES["stake_" .. v].stake_level
					local _stake_desc = {}
					local _stake_center = G.P_CENTER_POOLS.Stake[i]
					localize { type = 'descriptions', key = _stake_center.key, set = _stake_center.set, nodes = _stake_desc }
					local _full_desc = {}
					for k, v in ipairs(_stake_desc) do
						_full_desc[#_full_desc + 1] = {n = G.UIT.R, config = {align = "cm"}, nodes = v}
					end
					_full_desc[#_full_desc] = nil
					stake_desc_rows[#stake_desc_rows + 1] = {n = G.UIT.R, config = {align = "cm" }, nodes = {
						{n = G.UIT.C, config = {align = 'cm'}, nodes = { 
							{n = G.UIT.C, config = {align = "cm", colour = get_stake_col(i), r = 0.1, minh = 0.35, minw = 0.35, emboss = 0.05 }, nodes = {}},
							{n = G.UIT.B, config = {w = 0.1, h = 0.1}}}},
						{n = G.UIT.C, config = {align = "cm", padding = 0.03, colour = G.C.WHITE, r = 0.1, minh = 0.7, minw = 4.8 }, nodes =
							_full_desc},}}
				end
				num_added.val = num_added.val + 1
				num_added.val = SMODS.applied_stakes_UI(G.P_STAKES["stake_" .. v].stake_level, stake_desc_rows,
					num_added)
			end
		end
	end
end

-- We're overwriting so much that it's better to just remake this
function G.UIDEF.deck_stake_column(_deck_key)
	local deck_usage = G.PROFILES[G.SETTINGS.profile].deck_usage[_deck_key]
	local stake_col = {}
	local valid_option = nil
	local num_stakes = #G.P_CENTER_POOLS['Stake']
	for i = #G.P_CENTER_POOLS['Stake'], 1, -1 do
		local _wins = deck_usage and deck_usage.wins[i] or 0
		if (deck_usage and deck_usage.wins[i - 1]) or i == 1 or G.PROFILES[G.SETTINGS.profile].all_unlocked then valid_option = true end
		stake_col[#stake_col + 1] = {n = G.UIT.R, config = {id = i, align = "cm", colour = _wins > 0 and G.C.GREY or G.C.CLEAR, outline = 0, outline_colour = G.C.WHITE, r = 0.1, minh = 2 / num_stakes, minw = valid_option and 0.45 or 0.25, func = 'RUN_SETUP_check_back_stake_highlight'}, nodes = {
			{n = G.UIT.R, config = {align = "cm", minh = valid_option and 1.36 / num_stakes or 1.04 / num_stakes, minw = valid_option and 0.37 or 0.13, colour = _wins > 0 and get_stake_col(i) or G.C.UI.TRANSPARENT_LIGHT, r = 0.1}, nodes = {}}}}
		if i > 1 then stake_col[#stake_col + 1] = {n = G.UIT.R, config = {align = "cm", minh = 0.8 / num_stakes, minw = 0.04 }, nodes = {} } end
	end
	return {n = G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes = stake_col}
end

--#endregion
--#region straights and view deck UI
function get_straight(hand)
	local ret = {}
	local four_fingers = next(SMODS.find_card('j_four_fingers'))
	local can_skip = next(SMODS.find_card('j_shortcut'))
	if #hand < (5 - (four_fingers and 1 or 0)) then return ret end
	local t = {}
	local RANKS = {}
	for i = 1, #hand do
		if hand[i]:get_id() > 0 then
			local rank = hand[i].base.value
			RANKS[rank] = RANKS[rank] or {}
			RANKS[rank][#RANKS[rank] + 1] = hand[i]
		end
	end
	local straight_length = 0
	local straight = false
	local skipped_rank = false
	local vals = {}
	for k, v in pairs(SMODS.Ranks) do
		if v.straight_edge then
			table.insert(vals, k)
		end
	end
	local init_vals = {}
	for _, v in ipairs(vals) do
		init_vals[v] = true
	end
	if not next(vals) then table.insert(vals, 'Ace') end
	local initial = true
	local br = false
	local end_iter = false
	local i = 0
	while 1 do
		end_iter = false
		if straight_length >= (5 - (four_fingers and 1 or 0)) then
			straight = true
		end
		i = i + 1
		if br or (i > #SMODS.Rank.obj_buffer + 1) then break end
		if not next(vals) then break end
		for _, val in ipairs(vals) do
			if init_vals[val] and not initial then br = true end
			if RANKS[val] then
				straight_length = straight_length + 1
				skipped_rank = false
				for _, vv in ipairs(RANKS[val]) do
					t[#t + 1] = vv
				end
				vals = SMODS.Ranks[val].next
				initial = false
				end_iter = true
				break
			end
		end
		if not end_iter then
			local new_vals = {}
			for _, val in ipairs(vals) do
				for _, r in ipairs(SMODS.Ranks[val].next) do
					table.insert(new_vals, r)
				end
			end
			vals = new_vals
			if can_skip and not skipped_rank then
				skipped_rank = true
			else
				straight_length = 0
				skipped_rank = false
				if not straight then t = {} end
				if straight then break end
			end
		end
	end
	if not straight then return ret end
	table.insert(ret, t)
	return ret
end

function G.UIDEF.deck_preview(args)
	local _minh, _minw = 0.35, 0.5
	local suit_labels = {}
	local suit_counts = {}
	local mod_suit_counts = {}
	for _, v in ipairs(SMODS.Suit.obj_buffer) do
		suit_counts[v] = 0
		mod_suit_counts[v] = 0
	end
	local mod_suit_diff = false
	local wheel_flipped, wheel_flipped_text = 0, nil
	local flip_col = G.C.WHITE
	local rank_counts = {}
	local deck_tables = {}
	remove_nils(G.playing_cards)
	table.sort(G.playing_cards, function(a, b) return a:get_nominal('suit') > b:get_nominal('suit') end)
	local SUITS = {}
	for _, suit in ipairs(SMODS.Suit.obj_buffer) do
		SUITS[suit] = {}
		for _, rank in ipairs(SMODS.Rank.obj_buffer) do
			SUITS[suit][rank] = {}
		end
	end
	local stones = nil
	local suit_map = {}
	for i = #SMODS.Suit.obj_buffer, 1, -1 do
		suit_map[#suit_map + 1] = SMODS.Suit.obj_buffer[i]
	end
	local rank_name_mapping = {}
	for i = #SMODS.Rank.obj_buffer, 1, -1 do
		rank_name_mapping[#rank_name_mapping + 1] = SMODS.Rank.obj_buffer[i]
	end
	for k, v in ipairs(G.playing_cards) do
		if v.ability.effect == 'Stone Card' then
			stones = stones or 0
		end
		if (v.area and v.area == G.deck) or v.ability.wheel_flipped then
			if v.ability.wheel_flipped and not (v.area and v.area == G.deck) then wheel_flipped = wheel_flipped + 1 end
			if v.ability.effect == 'Stone Card' then
				stones = stones + 1
			else
				for kk, vv in pairs(suit_counts) do
					if v.base.suit == kk then suit_counts[kk] = suit_counts[kk] + 1 end
					if v:is_suit(kk) then mod_suit_counts[kk] = mod_suit_counts[kk] + 1 end
				end
				if SUITS[v.base.suit][v.base.value] then
					table.insert(SUITS[v.base.suit][v.base.value], v)
				end
				rank_counts[v.base.value] = (rank_counts[v.base.value] or 0) + 1
			end
		end
	end

	wheel_flipped_text = (wheel_flipped > 0) and
		{n = G.UIT.T, config = {text = '?', colour = G.C.FILTER, scale = 0.25, shadow = true}}
	or nil
	flip_col = wheel_flipped_text and mix_colours(G.C.FILTER, G.C.WHITE, 0.7) or G.C.WHITE

	suit_labels[#suit_labels + 1] = {n = G.UIT.R, config = {align = "cm", r = 0.1, padding = 0.04, minw = _minw, minh = 2 * _minh + 0.25}, nodes = {
		stones and {n = G.UIT.T, config = {text = localize('ph_deck_preview_stones') .. ': ', colour = G.C.WHITE, scale = 0.25, shadow = true}}
		or nil,
		stones and {n = G.UIT.T, config = {text = '' .. stones, colour = (stones > 0 and G.C.WHITE or G.C.UI.TRANSPARENT_LIGHT), scale = 0.4, shadow = true}}
		or nil,}}

	local _row = {}
	local _bg_col = G.C.JOKER_GREY
	for k, v in ipairs(rank_name_mapping) do
		local _tscale = 0.3
		local _colour = G.C.BLACK
		local rank_col = SMODS.Ranks[v].face and G.C.WHITE or _bg_col
		rank_col = mix_colours(rank_col, _bg_col, 0.8)

		local _col = {n = G.UIT.C, config = {align = "cm" }, nodes = {
			{n = G.UIT.C, config = {align = "cm", r = 0.1, minw = _minw, minh = _minh, colour = rank_col, emboss = 0.04, padding = 0.03 }, nodes = {
				{n = G.UIT.R, config = {align = "cm" }, nodes = {
					{n = G.UIT.T, config = {text = '' .. SMODS.Ranks[v].shorthand, colour = _colour, scale = 1.6 * _tscale } },}},
				{n = G.UIT.R, config = {align = "cm", minw = _minw + 0.04, minh = _minh, colour = G.C.L_BLACK, r = 0.1 }, nodes = {
					{n = G.UIT.T, config = {text = '' .. (rank_counts[v] or 0), colour = flip_col, scale = _tscale, shadow = true } }}}}}}}
		table.insert(_row, _col)
	end
	table.insert(deck_tables, {n = G.UIT.R, config = {align = "cm", padding = 0.04 }, nodes = _row })

	for _, suit in ipairs(suit_map) do
		if not (SMODS.Suits[suit].hidden and suit_counts[suit] == 0) then
			_row = {}
			_bg_col = mix_colours(G.C.SUITS[suit], G.C.L_BLACK, 0.7)
			for _, rank in ipairs(rank_name_mapping) do
				local _tscale = #SUITS[suit][rank] > 0 and 0.3 or 0.25
				local _colour = #SUITS[suit][rank] > 0 and flip_col or G.C.UI.TRANSPARENT_LIGHT

				local _col = {n = G.UIT.C, config = {align = "cm", padding = 0.05, minw = _minw + 0.098, minh = _minh }, nodes = {
					{n = G.UIT.T, config = {text = '' .. #SUITS[suit][rank], colour = _colour, scale = _tscale, shadow = true, lang = G.LANGUAGES['en-us'] } },}}
				table.insert(_row, _col)
			end
			table.insert(deck_tables,
				{n = G.UIT.R, config = {align = "cm", r = 0.1, padding = 0.04, minh = 0.4, colour = _bg_col }, nodes =
					_row})
		end
	end

	for k, v in ipairs(suit_map) do
		if not (SMODS.Suits[v].hidden and suit_counts[v] == 0) then
			local t_s = Sprite(0, 0, 0.3, 0.3,
				G.ASSET_ATLAS[SMODS.Suits[v][G.SETTINGS.colourblind_option and "hc_ui_atlas" or "lc_ui_atlas"]] or
				G.ASSET_ATLAS[("ui_" .. (G.SETTINGS.colourblind_option and "2" or "1"))], SMODS.Suits[v].ui_pos)
			t_s.states.drag.can = false
			t_s.states.hover.can = false
			t_s.states.collide.can = false

			if mod_suit_counts[v] ~= suit_counts[v] then mod_suit_diff = true end

			suit_labels[#suit_labels + 1] =
			{n = G.UIT.R, config = {align = "cm", r = 0.1, padding = 0.03, colour = G.C.JOKER_GREY }, nodes = {
				{n = G.UIT.C, config = {align = "cm", minw = _minw, minh = _minh }, nodes = {
					{n = G.UIT.O, config = {can_collide = false, object = t_s } }}},
				{n = G.UIT.C, config = {align = "cm", minw = _minw * 2.4, minh = _minh, colour = G.C.L_BLACK, r = 0.1 }, nodes = {
					{n = G.UIT.T, config = {text = '' .. suit_counts[v], colour = flip_col, scale = 0.3, shadow = true, lang = G.LANGUAGES['en-us'] } },
					mod_suit_counts[v] ~= suit_counts[v] and {n = G.UIT.T, config = {text = ' (' .. mod_suit_counts[v] .. ')', colour = mix_colours(G.C.BLUE, G.C.WHITE, 0.7), scale = 0.28, shadow = true, lang = G.LANGUAGES['en-us'] } }
					or nil,}}}}
		end
	end


	local t = {n = G.UIT.ROOT, config = {align = "cm", colour = G.C.JOKER_GREY, r = 0.1, emboss = 0.05, padding = 0.07}, nodes = {
		{n = G.UIT.R, config = {align = "cm", r = 0.1, emboss = 0.05, colour = G.C.BLACK, padding = 0.1}, nodes = {
			{n = G.UIT.R, config = {align = "cm"}, nodes = {
				{n = G.UIT.C, config = {align = "cm", padding = 0.04}, nodes = suit_labels },
				{n = G.UIT.C, config = {align = "cm", padding = 0.02}, nodes = deck_tables }}},
			mod_suit_diff and {n = G.UIT.R, config = {align = "cm" }, nodes = {
				{n = G.UIT.C, config = {padding = 0.3, r = 0.1, colour = mix_colours(G.C.BLUE, G.C.WHITE, 0.7) }, nodes = {} },
				{n = G.UIT.T, config = {text = ' ' .. localize('ph_deck_preview_effective'), colour = G.C.WHITE, scale = 0.3 } },}}
			or nil,
			wheel_flipped_text and {n = G.UIT.R, config = {align = "cm" }, nodes = {
				{n = G.UIT.C, config = {padding = 0.3, r = 0.1, colour = flip_col }, nodes = {} },
				{n = G.UIT.T, config = {
						text = ' ' .. (wheel_flipped > 1 and
							localize { type = 'variable', key = 'deck_preview_wheel_plural', vars = { wheel_flipped } } or
							localize { type = 'variable', key = 'deck_preview_wheel_singular', vars = { wheel_flipped } }),
						colour = G.C.WHITE,
						scale = 0.3}},}}
			or nil,}}}}
	return t
end

function G.UIDEF.view_deck(unplayed_only)
	local deck_tables = {}
	remove_nils(G.playing_cards)
	G.VIEWING_DECK = true
	table.sort(G.playing_cards, function(a, b) return a:get_nominal('suit') > b:get_nominal('suit') end)
	local SUITS = {}
	local suit_map = {}
	for i = #SMODS.Suit.obj_buffer, 1, -1 do
		SUITS[SMODS.Suit.obj_buffer[i]] = {}
		suit_map[#suit_map + 1] = SMODS.Suit.obj_buffer[i]
	end
	for k, v in ipairs(G.playing_cards) do
		table.insert(SUITS[v.base.suit], v)
	end
	local num_suits = 0
	for j = 1, #suit_map do
		if SUITS[suit_map[j]][1] then num_suits = num_suits + 1 end
	end
	for j = 1, #suit_map do
		if SUITS[suit_map[j]][1] then
			local view_deck = CardArea(
				G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h,
				6.5 * G.CARD_W,
				((num_suits > 8) and 0.2 or (num_suits > 4) and (1 - 0.1 * num_suits) or 0.6) * G.CARD_H,
				{
					card_limit = #SUITS[suit_map[j]],
					type = 'title',
					view_deck = true,
					highlight_limit = 0,
					card_w = G
						.CARD_W * 0.7,
					draw_layers = { 'card' }
				})
			table.insert(deck_tables,
				{n = G.UIT.R, config = {align = "cm", padding = 0}, nodes = {
					{n = G.UIT.O, config = {object = view_deck}}}}
			)

			for i = 1, #SUITS[suit_map[j]] do
				if SUITS[suit_map[j]][i] then
					local greyed, _scale = nil, 0.7
					if unplayed_only and not ((SUITS[suit_map[j]][i].area and SUITS[suit_map[j]][i].area == G.deck) or SUITS[suit_map[j]][i].ability.wheel_flipped) then
						greyed = true
					end
					local copy = copy_card(SUITS[suit_map[j]][i], nil, _scale)
					copy.greyed = greyed
					copy.T.x = view_deck.T.x + view_deck.T.w / 2
					copy.T.y = view_deck.T.y

					copy:hard_set_T()
					view_deck:emplace(copy)
				end
			end
		end
	end

	local flip_col = G.C.WHITE

	local suit_tallies = {}
	local mod_suit_tallies = {}
	for _, v in ipairs(suit_map) do
		suit_tallies[v] = 0
		mod_suit_tallies[v] = 0
	end
	local rank_tallies = {}
	local mod_rank_tallies = {}
	local rank_name_mapping = SMODS.Rank.obj_buffer
	for _, v in ipairs(rank_name_mapping) do
		rank_tallies[v] = 0
		mod_rank_tallies[v] = 0
	end
	local face_tally = 0
	local mod_face_tally = 0
	local num_tally = 0
	local mod_num_tally = 0
	local ace_tally = 0
	local mod_ace_tally = 0
	local wheel_flipped = 0

	for k, v in ipairs(G.playing_cards) do
		if v.ability.name ~= 'Stone Card' and (not unplayed_only or ((v.area and v.area == G.deck) or v.ability.wheel_flipped)) then
			if v.ability.wheel_flipped and not (v.area and v.area == G.deck) and unplayed_only then wheel_flipped = wheel_flipped + 1 end
			--For the suits
			suit_tallies[v.base.suit] = (suit_tallies[v.base.suit] or 0) + 1
			for kk, vv in pairs(mod_suit_tallies) do
				mod_suit_tallies[kk] = (vv or 0) + (v:is_suit(kk) and 1 or 0)
			end

			--for face cards/numbered cards/aces
			local card_id = v:get_id()
			face_tally = face_tally + ((SMODS.Ranks[v.base.value].face) and 1 or 0)
			mod_face_tally = mod_face_tally + (v:is_face() and 1 or 0)
			if not SMODS.Ranks[v.base.value].face and card_id ~= 14 then
				num_tally = num_tally + 1
				if not v.debuff then mod_num_tally = mod_num_tally + 1 end
			end
			if card_id == 14 then
				ace_tally = ace_tally + 1
				if not v.debuff then mod_ace_tally = mod_ace_tally + 1 end
			end

			--ranks
			rank_tallies[v.base.value] = rank_tallies[v.base.value] + 1
			if not v.debuff then mod_rank_tallies[v.base.value] = mod_rank_tallies[v.base.value] + 1 end
		end
	end
	local modded = face_tally ~= mod_face_tally
	for kk, vv in pairs(mod_suit_tallies) do
		modded = modded or (vv ~= suit_tallies[kk])
		if modded then break end
	end

	if wheel_flipped > 0 then flip_col = mix_colours(G.C.FILTER, G.C.WHITE, 0.7) end

	local rank_cols = {}
	for i = #rank_name_mapping, 1, -1 do
		local mod_delta = mod_rank_tallies[i] ~= rank_tallies[i]
		rank_cols[#rank_cols + 1] = {n = G.UIT.R, config = {align = "cm", padding = 0.07}, nodes = {
			{n = G.UIT.C, config = {align = "cm", r = 0.1, padding = 0.04, emboss = 0.04, minw = 0.5, colour = G.C.L_BLACK}, nodes = {
				{n = G.UIT.T, config = {text = SMODS.Ranks[rank_name_mapping[i]].shorthand, colour = G.C.JOKER_GREY, scale = 0.35, shadow = true}},}},
			{n = G.UIT.C, config = {align = "cr", minw = 0.4}, nodes = {
				mod_delta and {n = G.UIT.O, config = {
						object = DynaText({
							string = { { string = '' .. rank_tallies[i], colour = flip_col }, { string = '' .. mod_rank_tallies[i], colour = G.C.BLUE } },
							colours = { G.C.RED }, scale = 0.4, y_offset = -2, silent = true, shadow = true, pop_in_rate = 10, pop_delay = 4
						})}}
				or {n = G.UIT.T, config = {text = rank_tallies[rank_name_mapping[i]], colour = flip_col, scale = 0.45, shadow = true } },}}}}
	end

	local tally_ui = {
		-- base cards
		{n = G.UIT.R, config = {align = "cm", minh = 0.05, padding = 0.07}, nodes = {
			{n = G.UIT.O, config = {
					object = DynaText({ 
						string = { 
							{ string = localize('k_base_cards'), colour = G.C.RED }, 
							modded and { string = localize('k_effective'), colour = G.C.BLUE } or nil
						},
						colours = { G.C.RED }, silent = true, scale = 0.4, pop_in_rate = 10, pop_delay = 4
					})
				}}}},
		-- aces, faces and numbered cards
		{n = G.UIT.R, config = {align = "cm", minh = 0.05, padding = 0.1}, nodes = {
			tally_sprite(
				{ x = 1, y = 0 },
				{ { string = '' .. ace_tally, colour = flip_col }, { string = '' .. mod_ace_tally, colour = G.C.BLUE } },
				{ localize('k_aces') }
			), --Aces
			tally_sprite(
				{ x = 2, y = 0 },
				{ { string = '' .. face_tally, colour = flip_col }, { string = '' .. mod_face_tally, colour = G.C.BLUE } },
				{ localize('k_face_cards') }
			), --Face
			tally_sprite(
				{ x = 3, y = 0 },
				{ { string = '' .. num_tally, colour = flip_col }, { string = '' .. mod_num_tally, colour = G.C.BLUE } },
				{ localize('k_numbered_cards') }
			), --Numbers
		}},
	}
	-- add suit tallies
	local i = 1
	local n_nodes = {}
	while i <= #suit_map do
		while #n_nodes < 2 and i <= #suit_map do
			if not (SMODS.Suits[suit_map[i]].hidden and suit_tallies[suit_map[i]] == 0) then
				table.insert(n_nodes, tally_sprite(
					SMODS.Suits[suit_map[i]].ui_pos,
					{
						{ string = '' .. suit_tallies[suit_map[i]], colour = flip_col },
						{ string = '' .. mod_suit_tallies[suit_map[i]], colour = G.C.BLUE }
					},
					{ localize(suit_map[i], 'suits_plural') },
					suit_map[i]
				))
			end
			i = i + 1
		end
		if #n_nodes > 0 then
			local n = {n = G.UIT.R, config = {align = "cm", minh = 0.05, padding = 0.1}, nodes = n_nodes}
			table.insert(tally_ui, n)
			n_nodes = {}
		end
	end
	local t = {n = G.UIT.ROOT, config = {align = "cm", colour = G.C.CLEAR}, nodes = {
		{n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {}},
		{n = G.UIT.R, config = {align = "cm"}, nodes = {
			{n = G.UIT.C, config = {align = "cm", minw = 1.5, minh = 2, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes = {
				{n = G.UIT.C, config = {align = "cm", padding = 0.1}, nodes = {
					{n = G.UIT.R, config = {align = "cm", r = 0.1, colour = G.C.L_BLACK, emboss = 0.05, padding = 0.15}, nodes = {
						{n = G.UIT.R, config = {align = "cm"}, nodes = {
							{n = G.UIT.O, config = {
									object = DynaText({ string = G.GAME.selected_back.loc_name, colours = {G.C.WHITE}, bump = true, rotate = true, shadow = true, scale = 0.6 - string.len(G.GAME.selected_back.loc_name) * 0.01 })
								}},}},
						{n = G.UIT.R, config = {align = "cm", r = 0.1, padding = 0.1, minw = 2.5, minh = 1.3, colour = G.C.WHITE, emboss = 0.05}, nodes = {
							{n = G.UIT.O, config = {
									object = UIBox {
										definition = G.GAME.selected_back:generate_UI(nil, 0.7, 0.5, G.GAME.challenge), config = {offset = { x = 0, y = 0 } }
									}
								}}}}}},
					{n = G.UIT.R, config = {align = "cm", r = 0.1, outline_colour = G.C.L_BLACK, line_emboss = 0.05, outline = 1.5}, nodes = 
						tally_ui}}},
				{n = G.UIT.C, config = {align = "cm"}, nodes = rank_cols},
				{n = G.UIT.B, config = {w = 0.1, h = 0.1}},}},
			{n = G.UIT.B, config = {w = 0.2, h = 0.1}},
			{n = G.UIT.C, config = {align = "cm", padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes =
				deck_tables}}},
		{n = G.UIT.R, config = {align = "cm", minh = 0.8, padding = 0.05}, nodes = {
			modded and {n = G.UIT.R, config = {align = "cm"}, nodes = {
				{n = G.UIT.C, config = {padding = 0.3, r = 0.1, colour = mix_colours(G.C.BLUE, G.C.WHITE, 0.7)}, nodes = {}},
				{n = G.UIT.T, config = {text = ' ' .. localize('ph_deck_preview_effective'), colour = G.C.WHITE, scale = 0.3}},}}
			or nil,
			wheel_flipped > 0 and {n = G.UIT.R, config = {align = "cm"}, nodes = {
				{n = G.UIT.C, config = {padding = 0.3, r = 0.1, colour = flip_col}, nodes = {}},
				{n = G.UIT.T, config = {
						text = ' ' .. (wheel_flipped > 1 and
							localize { type = 'variable', key = 'deck_preview_wheel_plural', vars = { wheel_flipped } } or
							localize { type = 'variable', key = 'deck_preview_wheel_singular', vars = { wheel_flipped } }),
						colour = G.C.WHITE, scale = 0.3
					}},}}
			or nil,}}}}
	return t
end

--#endregion
--#region poker hands
local init_game_object_ref = Game.init_game_object
function Game:init_game_object()
	local t = init_game_object_ref(self)
	for _, key in ipairs(SMODS.PokerHand.obj_buffer) do
		t.hands[key] = {}
		for k, v in pairs(SMODS.PokerHands[key]) do
			-- G.GAME needs to be able to be serialized
            -- TODO this is too specific; ex. nested tables with simple keys
            -- are fine.
            -- In fact, the check should just warn you if you have a key that
            -- can't be serialized.
			if type(v) == 'number' or type(v) == 'boolean' or k == 'example' then
				t.hands[key][k] = v
			end
		end
	end
	return t
end

-- why bother patching when i basically change everything
function G.FUNCS.get_poker_hand_info(_cards)
	local poker_hands = evaluate_poker_hand(_cards)
	local scoring_hand = {}
	local text, disp_text, loc_disp_text = 'NULL', 'NULL', 'NULL'
	for _, v in ipairs(G.handlist) do
		if next(poker_hands[v]) then
			text = v
			scoring_hand = poker_hands[v][1]
			break
		end
	end
	disp_text = text
	local _hand = SMODS.PokerHands[text]
	if text == 'Straight Flush' then
		local royal = true
		for j = 1, #scoring_hand do
			local rank = SMODS.Ranks[scoring_hand[j].base.value]
			royal = royal and (rank.key == 'Ace' or rank.key == '10' or rank.face)
		end
		if royal then
			disp_text = 'Royal Flush'
		end
	elseif _hand and _hand.modify_display_text and type(_hand.modify_display_text) == 'function' then
		disp_text = _hand:modify_display_text(_cards, scoring_hand) or disp_text
	end
	loc_disp_text = localize(disp_text, 'poker_hands')
	return text, loc_disp_text, poker_hands, scoring_hand, disp_text
end

function create_UIBox_current_hands(simple)
	G.current_hands = {}
	local index = 0
	for _, v in ipairs(G.handlist) do
		local ui_element = create_UIBox_current_hand_row(v, simple)
		G.current_hands[index + 1] = ui_element
		if ui_element then
			index = index + 1
		end
		if index >= 10 then
			break
		end
	end

	local visible_hands = {}
	for _, v in ipairs(G.handlist) do
		if G.GAME.hands[v].visible then
			table.insert(visible_hands, v)
		end
	end

	local hand_options = {}
	for i = 1, math.ceil(#visible_hands / 10) do
		table.insert(hand_options,
			localize('k_page') .. ' ' .. tostring(i) .. '/' .. tostring(math.ceil(#visible_hands / 10)))
	end

	local object = {n = G.UIT.ROOT, config = {align = "cm", colour = G.C.CLEAR}, nodes = {
		{n = G.UIT.R, config = {align = "cm", padding = 0.04}, nodes =
			G.current_hands},
		{n = G.UIT.R, config = {align = "cm", padding = 0}, nodes = {
			create_option_cycle({
				options = hand_options,
				w = 4.5,
				cycle_shoulders = true,
				opt_callback = 'your_hands_page',
				focus_args = { snap_to = true, nav = 'wide' },
				current_option = 1,
				colour = G.C.RED,
				no_pips = true
			})}}}}

	local t = {n = G.UIT.ROOT, config = {align = "cm", minw = 3, padding = 0.1, r = 0.1, colour = G.C.CLEAR}, nodes = {
		{n = G.UIT.O, config = {
				id = 'hand_list',
				object = UIBox {
					definition = object, config = {offset = { x = 0, y = 0 }, align = 'cm'}
				}
			}}}}
	return t
end

G.FUNCS.your_hands_page = function(args)
	if not args or not args.cycle_config then return end
	G.current_hands = {}


	local index = 0
	for _, v in ipairs(G.handlist) do
		local ui_element = create_UIBox_current_hand_row(v, simple)
		if index >= (0 + 10 * (args.cycle_config.current_option - 1)) and index < 10 * args.cycle_config.current_option then
			G.current_hands[index - (10 * (args.cycle_config.current_option - 1)) + 1] = ui_element
		end

		if ui_element then
			index = index + 1
		end

		if index >= 10 * args.cycle_config.current_option then
			break
		end
	end

	local visible_hands = {}
	for _, v in ipairs(G.handlist) do
		if G.GAME.hands[v].visible then
			table.insert(visible_hands, v)
		end
	end

	local hand_options = {}
	for i = 1, math.ceil(#visible_hands / 10) do
		table.insert(hand_options,
			localize('k_page') .. ' ' .. tostring(i) .. '/' .. tostring(math.ceil(#visible_hands / 10)))
	end

	local object = {n = G.UIT.ROOT, config = {align = "cm", colour = G.C.CLEAR }, nodes = {
			{n = G.UIT.R, config = {align = "cm", padding = 0.04 }, nodes = G.current_hands
			},
			{n = G.UIT.R, config = {align = "cm", padding = 0 }, nodes = {
					create_option_cycle({
						options = hand_options,
						w = 4.5,
						cycle_shoulders = true,
						opt_callback =
						'your_hands_page',
						focus_args = { snap_to = true, nav = 'wide' },
						current_option = args.cycle_config.current_option,
						colour = G
							.C.RED,
						no_pips = true
					})
				}
			}
		}
	}

	local hand_list = G.OVERLAY_MENU:get_UIE_by_ID('hand_list')
	if hand_list then
		if hand_list.config.object then
			hand_list.config.object:remove()
		end
		hand_list.config.object = UIBox {
			definition = object, config = {offset = { x = 0, y = 0 }, align = 'cm', parent = hand_list }
		}
	end
end
--#endregion
--#region editions
function create_UIBox_your_collection_editions(exit)
	local deck_tables = {}
	local edition_pool = {}
	if G.ACTIVE_MOD_UI then
		for _, v in pairs(G.P_CENTER_POOLS.Edition) do
			if v.mod and G.ACTIVE_MOD_UI.id == v.mod.id then edition_pool[#edition_pool+1] = v end
		end
	else
		edition_pool = G.P_CENTER_POOLS.Edition
	end
	local rows, cols = (#edition_pool > 5 and 2 or 1), 5
	local page = 0

	sendInfoMessage("Creating collections")
	G.your_collection = {}
	for j = 1, rows do
		G.your_collection[j] = CardArea(G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h, 5.3 * G.CARD_W, 1.03 * G.CARD_H,
			{
				card_limit = cols,
				type = 'title',
				highlight_limit = 0,
				collection = true
			})
		table.insert(deck_tables,
			{n = G.UIT.R, config = {align = "cm", padding = 0, no_fill = true}, nodes = {
				{n = G.UIT.O, config = {object = G.your_collection[j]}}}}
		)
	end

	sendInfoMessage("Sorting collections")
	table.sort(edition_pool, function(a, b) return a.order < b.order end)

	local count = math.min(cols * rows, #edition_pool)
	local index = 1 + (rows * cols * page)
	sendInfoMessage("Adding cards")
	for j = 1, rows do
		sendInfoMessage("Adding card in row "..tostring(j))
		for i = 1, cols do
			sendInfoMessage("Adding card in pos "..tostring(i))
			local edition = edition_pool[index]

			if not edition then
				break
			end
			local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w / 2, G.your_collection[j].T.y,
				G.CARD_W, G.CARD_H, nil, edition)
			card:start_materialize(nil, i > 1 or j > 1)
			if edition.discovered then card:set_edition(edition.key, true, true) end
			G.your_collection[j]:emplace(card)
			index = index + 1
		end
		if index > count then
			break
		end
	end

	local edition_options = {}

	local t = create_UIBox_generic_options({
		infotip = localize('ml_edition_seal_enhancement_explanation'),
		back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or exit or 'your_collection',
		snap_back = true,
		contents = { 
			{n = G.UIT.R, config = {align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes = 
				deck_tables}}
	})

	if #edition_pool > rows * cols then
		for i = 1, math.ceil(#edition_pool / (rows * cols)) do
			table.insert(edition_options, localize('k_page') .. ' ' .. tostring(i) .. '/' ..
				tostring(math.ceil(#edition_pool / (rows * cols))))
		end
		t = create_UIBox_generic_options({
			infotip = localize('ml_edition_seal_enhancement_explanation'),
			back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or exit or 'your_collection',
			snap_back = true,
			contents = {
				{n = G.UIT.R, config = {align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes = 
					deck_tables},
				{n = G.UIT.R, config = {align = "cm"}, nodes = { 
					create_option_cycle({
						options = edition_options,
						w = 4.5,
						cycle_shoulders = true,
						opt_callback = 'your_collection_editions_page',
						focus_args = { snap_to = true, nav = 'wide' },
						current_option = 1,
						r = rows,
						c = cols,
						colour = G.C.RED,
						no_pips = true
					})}}
			}
		})
	end
	return t
end

G.FUNCS.your_collection_editions_page = function(args)
	if not args or not args.cycle_config then
		return
	end
	local edition_pool = {}
	if G.ACTIVE_MOD_UI then
		for _, v in ipairs(G.P_CENTER_POOLS.Edition) do
			if v.mod and G.ACTIVE_MOD_UI.id == v.mod.id then edition_pool[#edition_pool+1] = v end
		end
	else
		edition_pool = G.P_CENTER_POOLS.Edition
	end
	local rows = (#edition_pool > 5 and 2 or 1)
	local cols = 5
	local page = args.cycle_config.current_option
	if page > math.ceil(#edition_pool / (rows * cols)) then
		page = page - math.ceil(#edition_pool / (rows * cols))
	end
	local count = rows * cols
	local offset = (rows * cols) * (page - 1)

	for j = 1, #G.your_collection do
		for i = #G.your_collection[j].cards, 1, -1 do
			if G.your_collection[j] ~= nil then
				local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
				c:remove()
				c = nil
			end
		end
	end

	for j = 1, rows do
		for i = 1, cols do
			if count % rows > 0 and i <= count % rows and j == cols then
				offset = offset - 1
				break
			end
			local idx = i + (j - 1) * cols + offset
			if idx > #edition_pool then return end
			local edition = edition_pool[idx]
			local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w / 2, G.your_collection[j].T.y,
				G.CARD_W, G.CARD_H, G.P_CARDS.empty, edition)
			if edition.discovered then card:set_edition(edition.key, true, true) end
			card:start_materialize(nil, i > 1 or j > 1)
			G.your_collection[j]:emplace(card)
		end
	end
end

-- self = pass the card
-- edition =
-- nil (removes edition)
-- OR key as string
-- OR { name_of_edition = true } (key without e_). This is from the base game, prefer using a string.
-- OR another card's self.edition table
-- immediate = boolean value
-- silent = boolean value
function Card:set_edition(edition, immediate, silent)
	-- Check to see if negative is being removed and reduce card_limit accordingly
	if (self.added_to_deck or self.joker_added_to_deck_but_debuffed or (self.area == G.hand and not self.debuff)) and self.edition and self.edition.card_limit then
		if self.ability.consumeable and self.area == G.consumeables then
			G.consumeables.config.card_limit = G.consumeables.config.card_limit - self.edition.card_limit
		elseif self.ability.set == 'Joker' and self.area == G.jokers then
			G.jokers.config.card_limit = G.jokers.config.card_limit - self.edition.card_limit
		elseif self.area == G.hand then
			G.hand.config.card_limit = G.hand.config.card_limit - self.edition.card_limit
		end
	end

	local edition_type = nil
	if type(edition) == 'string' then
		assert(string.sub(edition, 1, 2) == 'e_')
		edition_type = string.sub(edition, 3)
	elseif type(edition) == 'table' then
		if edition.type then
			edition_type = edition.type
		else
			for k, v in pairs(edition) do
				if v then
					assert(not edition_type)
					edition_type = k
				end
			end
		end
	end

	if not edition_type or edition_type == 'base' then
		if self.edition == nil then -- early exit
			return
		end
		self.edition = nil -- remove edition from card
		self:set_cost()
		if not silent then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = not immediate and 0.2 or 0,
				blockable = not immediate,
				func = function()
					self:juice_up(1, 0.5)
					play_sound('whoosh2', 1.2, 0.6)
					return true
				end
			}))
		end
		return
	end

	self.edition = {}
	self.edition[edition_type] = true
	self.edition.type = edition_type
	self.edition.key = 'e_' .. edition_type

	for k, v in pairs(G.P_CENTERS['e_' .. edition_type].config) do
		if type(v) == 'table' then
			self.edition[k] = copy_table(v)
		else
			self.edition[k] = v
		end
		if k == 'card_limit' and (self.added_to_deck or self.joker_added_to_deck_but_debuffed or (self.area == G.hand and not self.debuff)) and G.jokers and G.consumeables then
			if self.ability.consumeable then
				G.consumeables.config.card_limit = G.consumeables.config.card_limit + v
			elseif self.ability.set == 'Joker' then
				G.jokers.config.card_limit = G.jokers.config.card_limit + v
			elseif self.area == G.hand and not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) then
				G.hand.config.card_limit = G.hand.config.card_limit + v
				G.E_MANAGER:add_event(Event({
					trigger = 'immediate',
					func = function()
						G.FUNCS.draw_from_deck_to_hand()
						return true
					end
				}))
			end
		end
	end

	if self.area and self.area == G.jokers then
		if self.edition then
			if not G.P_CENTERS['e_' .. (self.edition.type)].discovered then
				discover_card(G.P_CENTERS['e_' .. (self.edition.type)])
			end
		else
			if not G.P_CENTERS['e_base'].discovered then
				discover_card(G.P_CENTERS['e_base'])
			end
		end
	end

	if self.edition and not silent then
		local ed = G.P_CENTERS['e_' .. (self.edition.type)]
		G.CONTROLLER.locks.edition = true
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = not immediate and 0.2 or 0,
			blockable = not immediate,
			func = function()
				if self.edition then
					self:juice_up(1, 0.5)
					play_sound(ed.sound.sound, ed.sound.per, ed.sound.vol)
				end
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.1,
			func = function()
				G.CONTROLLER.locks.edition = false
				return true
			end
		}))
	end

	if G.jokers and self.area == G.jokers then
		check_for_unlock({ type = 'modify_jokers' })
	end

	self:set_cost()
end

-- _key = key value for random seed
-- _mod = scale of chance against base card (does not change guaranteed weights)
-- _no_neg = boolean value to disable negative edition
-- _guaranteed = boolean value to determine whether an edition is guaranteed
-- _options = list of keys of editions to include in the poll
-- OR list of tables { name = key, weight = number }
function poll_edition(_key, _mod, _no_neg, _guaranteed, _options)
	local _modifier = 1
	local edition_poll = pseudorandom(pseudoseed(_key or 'edition_generic')) -- Generate the poll value
	local available_editions = {}                                          -- Table containing a list of editions and their weights

	if not _options then
		_options = { 'e_negative', 'e_polychrome', 'e_holo', 'e_foil' }
		if _key == "wheel_of_fortune" or _key == "aura" then -- set base game edition polling
		else
			for _, v in ipairs(G.P_CENTER_POOLS.Edition) do
				if v.in_shop then
					table.insert(_options, v.key)
				end
			end
		end
	end
	for _, v in ipairs(_options) do
		local edition_option = {}
		if type(v) == 'string' then
			assert(string.sub(v, 1, 2) == 'e_')
			edition_option = { name = v, weight = G.P_CENTERS[v].weight }
		elseif type(v) == 'table' then
			assert(string.sub(v.name, 1, 2) == 'e_')
			edition_option = { name = v.name, weight = v.weight }
		end
		table.insert(available_editions, edition_option)
	end

	-- Calculate total weight of editions
	local total_weight = 0
	for _, v in ipairs(available_editions) do
		total_weight = total_weight + (v.weight) -- total all the weights of the polled editions
	end
	-- sendDebugMessage("Edition weights: "..total_weight, "EditionAPI")
	-- If not guaranteed, calculate the base card rate to maintain base 4% chance of editions
	if not _guaranteed then
		_modifier = _mod or 1
		total_weight = total_weight + (total_weight / 4 * 96) -- Find total weight with base_card_rate as 96%
		for _, v in ipairs(available_editions) do
			v.weight = G.P_CENTERS[v.name]:get_weight()   -- Apply game modifiers where appropriate (defined in edition declaration)
		end
	end
	-- sendDebugMessage("Total weight: "..total_weight, "EditionAPI")
	-- sendDebugMessage("Editions: "..#available_editions, "EditionAPI")
	-- sendDebugMessage("Poll: "..edition_poll, "EditionAPI")

	-- Calculate whether edition is selected
	local weight_i = 0
	for _, v in ipairs(available_editions) do
		weight_i = weight_i + v.weight * _modifier
		-- sendDebugMessage(v.name.." weight is "..v.weight*_modifier)
		-- sendDebugMessage("Checking for "..v.name.." at "..(1 - (weight_i)/total_weight), "EditionAPI")
		if edition_poll > 1 - (weight_i) / total_weight then
			if not (v.name == 'e_negative' and _no_neg) then -- skip return if negative is selected and _no_neg is true
				-- sendDebugMessage("Matched edition: "..v.name, "EditionAPI")
				return v.name
			end
		end
	end

	return nil
end

--#endregion
--#region enhancements UI
function create_UIBox_your_collection_enhancements(exit)
	local deck_tables = {}
	local rows, cols = 2, 4
	local page = 0
	local enhancement_pool = {}
	if G.ACTIVE_MOD_UI then
		for _, v in ipairs(G.P_CENTER_POOLS.Enhanced) do
			if v.mod and G.ACTIVE_MOD_UI.id == v.mod.id then enhancement_pool[#enhancement_pool+1] = v end
		end
	else
		enhancement_pool = G.P_CENTER_POOLS.Enhanced
	end

	G.your_collection = {}
	for j = 1, rows do
		G.your_collection[j] = CardArea(G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h, 4.25 * G.CARD_W, 1.03 * G.CARD_H,
			{
				card_limit = cols,
				type = 'title',
				highlight_limit = 0,
				collection = true
			})
		table.insert(deck_tables,
			{n = G.UIT.R, config = {align = "cm", padding = 0, no_fill = true}, nodes = {
				{n = G.UIT.O, config = {object = G.your_collection[j]}}}
		})
	end

	table.sort(enhancement_pool, function(a, b) return a.order < b.order end)

	local count = math.min(cols * rows, #enhancement_pool)
	local index = 1 + (rows * cols * page)
	for j = 1, rows do
		for i = 1, cols do
			local center = enhancement_pool[index]
			if not center then
				break
			end
			local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w / 2, G.your_collection[j].T.y, G
			.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
			card:set_ability(center, true, true)
			G.your_collection[j]:emplace(card)
			index = index + 1
		end
		if index > count then
			break
		end
	end

	local enhancement_options = {}

	local t = create_UIBox_generic_options({
		infotip = localize('ml_edition_seal_enhancement_explanation'),
		back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or exit or 'your_collection',
		snap_back = true,
		contents = {
			{n = G.UIT.R, config = {align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05 }, nodes =
				deck_tables}
		}
	})

	if #enhancement_pool > rows * cols then
		for i = 1, math.ceil(#enhancement_pool / (rows * cols)) do
			table.insert(enhancement_options, localize('k_page') .. ' ' .. tostring(i) .. '/' ..
				tostring(math.ceil(#enhancement_pool / (rows * cols))))
		end
		t = create_UIBox_generic_options({
			infotip = localize('ml_edition_seal_enhancement_explanation'),
			back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or exit or 'your_collection',
			snap_back = true,
			contents = {
				{n = G.UIT.R, config = {align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes = 
					deck_tables},
				{n = G.UIT.R, config = {align = "cm"}, nodes = {
					create_option_cycle({
						options = enhancement_options,
						w = 4.5,
						cycle_shoulders = true,
						opt_callback = 'your_collection_enhancements_page',
						focus_args = { snap_to = true, nav = 'wide' },
						current_option = 1,
						r = rows,
						c = cols,
						colour = G.C.RED,
						no_pips = true
					})}}
			}
		})
	end
	return t
end

G.FUNCS.your_collection_enhancements_page = function(args)
	if not args or not args.cycle_config then
		return
	end
	local rows = 2
	local cols = 4
	local page = args.cycle_config.current_option
	local enhancement_pool = {}
	if G.ACTIVE_MOD_UI then
		for _, v in ipairs(G.P_CENTER_POOLS.Enhanced) do
			if v.mod and G.ACTIVE_MOD_UI.id == v.mod.id then enhancement_pool[#enhancement_pool+1] = v end
		end
	else
		enhancement_pool = G.P_CENTER_POOLS.Enhanced
	end
	if page > math.ceil(#enhancement_pool / (rows * cols)) then
		page = page - math.ceil(#enhancement_pool / (rows * cols))
	end
	local count = rows * cols
	local offset = (rows * cols) * (page - 1)

	for j = 1, #G.your_collection do
		for i = #G.your_collection[j].cards, 1, -1 do
			if G.your_collection[j] ~= nil then
				local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
				c:remove()
				c = nil
			end
		end
	end

	for j = 1, rows do
		for i = 1, cols do
			if count % rows > 0 and i <= count % rows and j == cols then
				offset = offset - 1
				break
			end
			local idx = i + (j - 1) * cols + offset
			if idx > #enhancement_pool then return end
			local center = enhancement_pool[idx]
			local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w / 2, G.your_collection[j].T.y,
				G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
			card:set_ability(center, true, true)
			card:start_materialize(nil, i > 1 or j > 1)
			G.your_collection[j]:emplace(card)
		end
	end
end
--#endregion

--- STEAMODDED CORE
--- MODULE API

function loadAPIs()
    -------------------------------------------------------------------------------------------------
    --- API CODE GameObject
    -------------------------------------------------------------------------------------------------

    --- GameObject base class. You should always use the appropriate subclass to register your object.
    SMODS.GameObject = Object:extend()
    SMODS.GameObject.subclasses = {}
    function SMODS.GameObject:extend(o)
        local cls = Object.extend(self)
        for k, v in pairs(o or {}) do
            cls[k] = v
        end
        self.subclasses[#self.subclasses + 1] = cls
        cls.subclasses = {}
        return cls
    end

    function SMODS.GameObject:__call(o)
        o = o or {}
        assert(o.mod == nil)
        o.mod = SMODS.current_mod
        setmetatable(o, self)
        for _, v in ipairs(o.required_params or {}) do
            assert(not (o[v] == nil), ('Missing required parameter for %s declaration: %s'):format(o.set, v))
        end
        if o:check_duplicate_register() then return end
        -- also updates o.prefix_config
        SMODS.add_prefixes(self, o)
        if o:check_duplicate_key() then return end
        o:register()
        --TODO: Use better check to enable "Additions" tab
        if SMODS.current_mod then SMODS.current_mod.added_obj = true end
        return o
    end

    function SMODS.modify_key(obj, prefix, condition, key)
        key = key or 'key'
        -- condition == nil counts as true
        if condition ~= false and obj[key] and prefix then
            if string.sub(obj[key], 1, #prefix + 1) == prefix..'_' then
                sendWarnMessage(("Attempted to prefix field %s=%s on object %s, already prefixed"):format(key, obj[key], obj.key), obj.set)
                return
            end
            obj[key] = prefix .. '_' .. obj[key]
        end
    end

    function SMODS.add_prefixes(cls, obj, from_take_ownership)
        if obj.prefix_config == false then return end
        obj.prefix_config = obj.prefix_config or {}
        if obj.raw_key then
            sendWarnMessage(([[The field `raw_key` on %s is deprecated.
Set `prefix_config.key = false` on your object instead.]]):format(obj.key), obj.set)
            obj.prefix_config.key = false
        end
        -- keep class defaults for unmodified keys in prefix_config
        obj.prefix_config = SMODS.merge_defaults(obj.prefix_config, cls.prefix_config)
        local mod = SMODS.current_mod
        obj.prefix_config = SMODS.merge_defaults(obj.prefix_config, mod and mod.prefix_config)
        obj.original_key = obj.key
        local key_cfg = obj.prefix_config.key
        if key_cfg ~= false then
            if type(key_cfg) ~= 'table' then key_cfg = {} end
            if not from_take_ownership then
                if obj.set == 'Palette' then SMODS.modify_key(obj, obj.type and obj.type:lower(), key_cfg.type) end
                SMODS.modify_key(obj, mod and mod.prefix, key_cfg.mod)
            end
            SMODS.modify_key(obj, cls.class_prefix, key_cfg.class)
        end
        local atlas_cfg = obj.prefix_config.atlas
        if atlas_cfg ~= false then
            if type(atlas_cfg) ~= 'table' then atlas_cfg = {} end
            for _, v in ipairs({ 'atlas', 'hc_atlas', 'lc_atlas', 'hc_ui_atlas', 'lc_ui_atlas', 'sticker_atlas' }) do
                if rawget(obj, v) then SMODS.modify_key(obj, mod and mod.prefix, atlas_cfg[v], v) end
            end
        end
        local shader_cfg = obj.prefix_config.shader
        SMODS.modify_key(obj, mod and mod.prefix, shader_cfg, 'shader')
        local card_key_cfg = obj.prefix_config.card_key
        SMODS.modify_key(obj, mod and mod.prefix, card_key_cfg, 'card_key')
    end

    function SMODS.GameObject:check_duplicate_register()
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
            return true
        end
        return false
    end

    -- Checked on __call but not take_ownership. For take_ownership, the key must exist
    function SMODS.GameObject:check_duplicate_key()
        if self.obj_table[self.key] or (self.get_obj and self:get_obj(self.key)) then
            sendWarnMessage(('Object %s has the same key as an existing object, not registering.'):format(self.key), self.set)
            sendWarnMessage('If you want to modify an existing object, use take_ownership()', self.set)
            return true
        end
        return false
    end

    function SMODS.GameObject:register()
        if self:check_dependencies() then
            self.obj_table[self.key] = self
            self.obj_buffer[#self.obj_buffer + 1] = self.key
            self.registered = true
        end
    end

    function SMODS.GameObject:check_dependencies()
        local keep = true
        if self.dependencies then
            -- ensure dependencies are a table
            if type(self.dependencies) == 'string' then self.dependencies = { self.dependencies } end
            for _, v in ipairs(self.dependencies) do
                self.mod.optional_dependencies[v] = true
                if not SMODS.Mods[v] then keep = false end
            end
        end
        return keep
    end

    function SMODS.GameObject:process_loc_text()
        SMODS.process_loc_text(G.localization.descriptions[self.set], self.key, self.loc_txt)
    end

    -- Inject all direct instances `o` of the class by calling `o:inject()`.
    -- Also inject anything necessary for the class itself.
    function SMODS.GameObject:inject_class()
        local o = nil
        for i, key in ipairs(self.obj_buffer) do
            o = self.obj_table[key]
            boot_print_stage(('Injecting %s: %s'):format(o.set, o.key))
            o.atlas = o.atlas or o.set

            if o._discovered_unlocked_overwritten then
                assert(o._saved_d_u)
                o.discovered, o.unlocked = o._d, o._u
                o._discovered_unlocked_overwritten = false
            else
                SMODS._save_d_u(o)
            end

            -- Add centers to pools
            o:inject(i)

            -- Setup Localize text
            o:process_loc_text()

            sendInfoMessage(
                ('Injected game object %s of type %s')
                :format(o.key, o.set), o.set or 'GameObject'
            )
        end
    end

    --- Takes control of vanilla objects. Child class must implement get_obj for this to function.
    function SMODS.GameObject:take_ownership(key, obj, silent)
        if self.check_duplicate_register(obj) then return end
        assert(obj.key == nil or obj.key == key)
        obj.key = key
        assert(obj.mod == nil)
        SMODS.add_prefixes(self, obj, true)
        key = obj.key
        local orig_o = self.obj_table[key] or (self.get_obj and self:get_obj(key))
        if not orig_o then
            sendWarnMessage(
                ('Cannot take ownership of %s: Does not exist.'):format(key), self.set
            )
            return
        end
        local is_loc_modified = obj.loc_txt or obj.loc_vars or obj.generate_ui
        if is_loc_modified then orig_o.is_loc_modified = true end
        if not orig_o.is_loc_modified then
            -- Setting generate_ui to this sentinel value
            -- makes vanilla localization code run instead of SMODS's code
            orig_o.generate_ui = 0
        end
        -- TODO
        -- it's unclear how much we should modify `obj` on a failed take_ownership call.
        -- do we make sure the metatable is set early, or wait until the end?
        setmetatable(orig_o, self)
        if orig_o.mod then
            orig_o.dependencies = orig_o.dependencies or {}
            if not silent then table.insert(orig_o.dependencies, SMODS.current_mod.id) end
        else
            orig_o.mod = SMODS.current_mod
            if silent then orig_o.no_main_mod_badge = true end
            orig_o.rarity_original = orig_o.rarity
        end
        if orig_o._saved_d_u then
            orig_o.discovered, orig_o.unlocked = orig_o._d, orig_o._u
            orig_o._saved_d_u = false
            orig_o._discovered_unlocked_overwritten = false
        end
        for k, v in pairs(obj) do orig_o[k] = v end
        SMODS._save_d_u(orig_o)
        orig_o.taken_ownership = true
        orig_o:register()
        return orig_o
    end

    -- Inject all SMODS Objects that are part of this class or a subclass.
    function SMODS.injectObjects(class)
        if class.obj_table and class.obj_buffer then
            class:inject_class()
        else
            for _, subclass in ipairs(class.subclasses) do SMODS.injectObjects(subclass) end
        end
    end

    -- Internal function
    -- Creates a list of objects from a list of keys.
    -- Currently used for a special case when selecting a random suit/rank.
    function SMODS.GameObject:obj_list(reversed)
        local lb, ub, step = 1, #self.obj_buffer, 1
        if reversed then lb, ub, step = ub, lb, -1 end
        local res = {}
        for i = lb, ub, step do
          res[#res+1] = self.obj_table[self.obj_buffer[i]]
        end
        return res
    end

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Language
    -------------------------------------------------------------------------------------------------

    SMODS.Languages = {}
    SMODS.Language = SMODS.GameObject:extend {
        obj_table = SMODS.Languages,
        obj_buffer = {},
        required_params = {
            'key',
            'label',
            'path',
            'font',
        },
        prefix_config = { key = false },
        process_loc_text = function() end,
        inject = function(self)
            self.full_path = self.mod.path .. 'localization/' .. self.path
            if type(self.font) == 'number' then
                self.font = G.FONTS[self.font]
            end
            G.LANGUAGES[self.key] = self
        end,
        inject_class = function(self)
            SMODS.Language.super.inject_class(self)
            G:set_language()
        end
    }

    -------------------------------------------------------------------------------------------------
    ----- INTERNAL API CODE GameObject._Loc_Pre
    -------------------------------------------------------------------------------------------------

    SMODS._Loc_Pre = SMODS.GameObject:extend {
        obj_table = {},
        obj_buffer = {},
        silent = true,
        register = function() error('INTERNAL CLASS, DO NOT CALL') end,
        inject_class = function()
            SMODS.handle_loc_file(SMODS.path)
            if SMODS.dump_loc then SMODS.dump_loc.pre_inject = copy_table(G.localization) end
            for _, mod in ipairs(SMODS.mod_list) do
                if mod.process_loc_text and type(mod.process_loc_text) == 'function' then
                    mod.process_loc_text()
                end
            end
        end
    }

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Atlas
    -------------------------------------------------------------------------------------------------

    SMODS.Atlases = {}
    SMODS.Atlas = SMODS.GameObject:extend {
        obj_table = SMODS.Atlases,
        obj_buffer = {},
        required_params = {
            'key',
            'path',
            'px',
            'py'
        },
        atlas_table = 'ASSET_ATLAS',
        set = 'Atlas',
        register = function(self)
            if self.registered then
                sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
                return
            end
            if self.language then
                self.key_noloc = self.key
                self.key = ('%s_%s'):format(self.key, self.language)
            end
            -- needed for changing high contrast settings, apparently
            self.name = self.key
            SMODS.Atlas.super.register(self)
        end,
        inject = function(self)
            local file_path = type(self.path) == 'table' and
                (self.path[G.SETTINGS.language] or self.path['default'] or self.path['en-us']) or self.path
            if file_path == 'DEFAULT' then return end
            -- language specific sprites override fully defined sprites only if that language is set
            if self.language and not (G.SETTINGS.language == self.language) then return end
            if not self.language and self.obj_table[('%s_%s'):format(self.key, G.SETTINGS.language)] then return end
            self.full_path = (self.mod and self.mod.path or SMODS.path) ..
                'assets/' .. G.SETTINGS.GRAPHICS.texture_scaling .. 'x/' .. file_path
            local file_data = assert(NFS.newFileData(self.full_path),
                ('Failed to collect file data for Atlas %s'):format(self.key))
            self.image_data = assert(love.image.newImageData(file_data),
                ('Failed to initialize image data for Atlas %s'):format(self.key))
            self.image = love.graphics.newImage(self.image_data,
                { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })
            G[self.atlas_table][self.key_noloc or self.key] = self
        end,
        process_loc_text = function() end,
        inject_class = function(self) 
            G:set_render_settings() -- restore originals first in case a texture pack was disabled
            SMODS.Atlas.super.inject_class(self)
        end
    }

    SMODS.Atlas {
        key = 'mod_tags',
        path = 'mod_tags.png',
        px = 34,
        py = 34,
    }

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Sound
    -------------------------------------------------------------------------------------------------

    SMODS.Sounds = {}
    SMODS.Sound = SMODS.GameObject:extend {
        obj_buffer = {},
        obj_table = SMODS.Sounds,
        stop_sounds = {},
        replace_sounds = {},
        required_params = {
            'key',
            'path'
        },
        process_loc_text = function() end,
        register = function(self)
            if self.registered then
                sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
                return
            end
            if self.language then
                self.key = ('%s_%s'):format(self.key, self.language)
            end
            self.sound_code = self.key
            if self.replace then
                local replace, times, args
                if type(self.replace) == 'table' then
                    replace, times, args = self.replace.key, self.replace.times or -1, self.replace.args
                else
                    replace, times = self.replace, -1
                end
                self.replace_sounds[replace] = { key = self.key, times = times, args = args }
            end
            SMODS.Sound.super.register(self)
        end,
        inject = function(self)
            local file_path = type(self.path) == 'table' and
                (self.path[G.SETTINGS.language] or self.path['default'] or self.path['en-us']) or self.path
            if file_path == 'DEFAULT' then return end
            -- language specific sounds override fully defined sounds only if that language is set
            if self.language and not (G.SETTINGS.language == self.language) then return end
            if not self.language and self.obj_table[('%s_%s'):format(self.key, G.SETTINGS.language)] then return end
            self.full_path = (self.mod and self.mod.path or SMODS.path) ..
                'assets/sounds/' .. file_path
            --load with a temp file path in case LOVE doesn't like the mod directory
            local file = NFS.read(self.full_path)
            love.filesystem.write("steamodded-temp-" .. file_path, file)
            self.sound = love.audio.newSource(
                "steamodded-temp-" .. file_path,
                ((string.find(self.key, 'music') or string.find(self.key, 'stream')) and "stream" or 'static')
            )
            love.filesystem.remove("steamodded-temp-" .. file_path)
        end,
        register_global = function(self)
            local mod = SMODS.current_mod
            if not mod then return end
            for _, filename in ipairs(NFS.getDirectoryItems(mod.path .. 'assets/sounds/')) do
                local extension = string.sub(filename, -4)
                if extension == '.ogg' or extension == '.mp3' or extension == '.wav' then -- please use .ogg or .wav files
                    local sound_code = string.sub(filename, 1, -5)
                    self {
                        key = sound_code,
                        path = filename,
                    }
                end
            end
        end,
        play = function(self, pitch, volume, stop_previous_instance, key)
            local sound = self or SMODS.Sounds[key]
            if not sound then return false end

            stop_previous_instance = stop_previous_instance and true
            volume = volume or 1
            sound.sound:setPitch(pitch or 1)

            local sound_vol = volume * (G.SETTINGS.SOUND.volume / 100.0)
            if string.find(sound.sound_code, 'music') then
                sound_vol = sound_vol * (G.SETTINGS.SOUND.music_volume / 100.0)
            else
                sound_vol = sound_vol * (G.SETTINGS.SOUND.game_sounds_volume / 100.0)
            end
            if sound_vol <= 0 then
                sound.sound:setVolume(0)
            else
                sound.sound:setVolume(sound_vol)
            end

            if stop_previous_instance and sound.sound:isPlaying() then
                sound.sound:stop()
            end
            love.audio.play(sound.sound)
        end,
        create_stop_sound = function(self, key, times)
            times = times or -1
            self.stop_sounds[key] = times
        end,
        create_replace_sound = function(self, replace_sound)
            self.replace = replace_sound
            local replace, times, args
            if type(self.replace) == 'table' then
                replace, times, args = self.replace.key, self.replace.times or -1, self.replace.args
            else
                replace, times = self.replace, -1
            end
            self.replace_sounds[replace] = { key = self.key, times = times, args = args }
        end
    }

    local play_sound_ref = play_sound
    function play_sound(sound_code, per, vol)
        local sound = SMODS.Sounds[sound_code]
        if sound then
            sound:play(per, vol, true)
            return
        end
        local replace_sound = SMODS.Sound.replace_sounds[sound_code]
        if replace_sound then
            local sound = SMODS.Sounds[replace_sound.key]
            local rt
            if replace_sound.args then
                local args = replace_sound.args
                sound:play(args.pitch, args.volume, args.stop_previous_instance)
                if not args.continue_base_sound then rt = true end
            else
                sound:play(per, vol)
                rt = true
            end
            if replace_sound.times > 0 then replace_sound.times = replace_sound.times - 1 end
            if replace_sound.times == 0 then SMODS.Sound.replace_sounds[sound_code] = nil end
            if rt then return end
        end
        local stop_sound = SMODS.Sound.stop_sounds[sound_code]
        if stop_sound then
            if stop_sound > 0 then
                SMODS.Sound.stop_sounds[sound_code] = stop_sound - 1
            end
            return
        end

        return play_sound_ref(sound_code, per, vol)
    end

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Stake
    -------------------------------------------------------------------------------------------------

    SMODS.Stakes = {}
    SMODS.Stake = SMODS.GameObject:extend {
        obj_table = SMODS.Stakes,
        obj_buffer = {},
        class_prefix = 'stake',
        unlocked = false,
        set = 'Stake',
        atlas = 'chips',
        pos = { x = 0, y = 0 },
        injected = false,
        required_params = {
            'key',
            'pos',
            'applied_stakes'
        },
        inject_class = function(self)
            G.P_CENTER_POOLS[self.set] = {}
            G.P_STAKES = {}
            SMODS.Stake.super.inject_class(self)
        end,
        inject = function(self)
            if not self.injected then
                -- Inject stake in the correct spot
                local count = #G.P_CENTER_POOLS[self.set] + 1
                if self.above_stake then
                    count = G.P_STAKES[self.class_prefix .. "_" .. self.above_stake].stake_level + 1
                end
                self.order = count
                self.stake_level = count
                for _, v in pairs(G.P_STAKES) do
                    if v.stake_level >= self.stake_level then
                        v.stake_level = v.stake_level + 1
                        v.order = v.stake_level
                    end
                end
                G.P_STAKES[self.key] = self
                -- Sticker sprites (stake_ prefix is removed for vanilla compatiblity)
                if self.sticker_pos ~= nil then
                    G.shared_stickers[self.key:sub(7)] = Sprite(0, 0, G.CARD_W, G.CARD_H,
                        G.ASSET_ATLAS[self.sticker_atlas] or G.ASSET_ATLAS["stickers"], self.sticker_pos)
                    G.sticker_map[self.stake_level] = self.key:sub(7)
                else
                    G.sticker_map[self.stake_level] = nil
                end
            else
                G.P_STAKES[self.key] = self
            end
            G.P_CENTER_POOLS[self.set] = {}
            for _, v in pairs(G.P_STAKES) do
                SMODS.insert_pool(G.P_CENTER_POOLS[self.set], v)
            end
            table.sort(G.P_CENTER_POOLS[self.set], function(a, b) return a.stake_level < b.stake_level end)
            G.C.STAKES = {}
            for i = 1, #G.P_CENTER_POOLS[self.set] do
                G.C.STAKES[i] = G.P_CENTER_POOLS[self.set][i].colour or G.C.WHITE
            end
            self.injected = true
        end,
        process_loc_text = function(self)
            -- empty loc_txt indicates there are existing values that shouldn't be changed or it isn't necessary
            if not self.loc_txt or not next(self.loc_txt) then return end
            local target = self.loc_txt[G.SETTINGS.language] or self.loc_txt['default'] or self.loc_txt['en-us'] or
                self.loc_txt
            local applied_text = "{s:0.8}" .. localize('b_applies_stakes_1')
            local any_applied
            for _, v in pairs(self.applied_stakes) do
                any_applied = true
                applied_text = applied_text ..
                    localize { set = self.set, key = self.class_prefix .. '_' .. v, type = 'name_text' } .. ', '
            end
            applied_text = applied_text:sub(1, -3)
            if not any_applied then
                applied_text = "{s:0.8}"
            else
                applied_text = applied_text .. localize('b_applies_stakes_2')
            end
            local desc_target = copy_table(target.description)
            table.insert(desc_target.text, applied_text)
            G.localization.descriptions[self.set][self.key] = desc_target
            SMODS.process_loc_text(G.localization.descriptions["Other"], self.key:sub(7) .. "_sticker", self.loc_txt,
                'sticker')
        end,
        get_obj = function(self, key) return G.P_STAKES[key] end
    }

    function SMODS.setup_stake(i)
        if G.P_CENTER_POOLS['Stake'][i].modifiers then
            G.P_CENTER_POOLS['Stake'][i].modifiers()
        end
        if G.P_CENTER_POOLS['Stake'][i].applied_stakes then
            for _, v in pairs(G.P_CENTER_POOLS['Stake'][i].applied_stakes) do
                SMODS.setup_stake(G.P_STAKES["stake_" .. v].stake_level)
            end
        end
    end

    --Register vanilla stakes
    G.P_STAKES = {}
    SMODS.Stake {
        name = "White Stake",
        key = "white",
        unlocked_stake = "red",
        unlocked = true,
        applied_stakes = {},
        pos = { x = 0, y = 0 },
        sticker_pos = { x = 1, y = 0 },
        colour = G.C.WHITE,
        loc_txt = {}
    }
    SMODS.Stake {
        name = "Red Stake",
        key = "red",
        unlocked_stake = "green",
        applied_stakes = { "white" },
        pos = { x = 1, y = 0 },
        sticker_pos = { x = 2, y = 0 },
        modifiers = function()
            G.GAME.modifiers.no_blind_reward = G.GAME.modifiers.no_blind_reward or {}
            G.GAME.modifiers.no_blind_reward.Small = true
        end,
        colour = G.C.RED,
        loc_txt = {}
    }
    SMODS.Stake {
        name = "Green Stake",
        key = "green",
        unlocked_stake = "black",
        applied_stakes = { "red" },
        pos = { x = 2, y = 0 },
        sticker_pos = { x = 3, y = 0 },
        modifiers = function()
            G.GAME.modifiers.scaling = math.max(G.GAME.modifiers.scaling or 0, 2)
        end,
        colour = G.C.GREEN,
        loc_txt = {}
    }
    SMODS.Stake {
        name = "Black Stake",
        key = "black",
        unlocked_stake = "blue",
        applied_stakes = { "green" },
        pos = { x = 4, y = 0 },
        sticker_pos = { x = 0, y = 1 },
        modifiers = function()
            G.GAME.modifiers.enable_eternals_in_shop = true
        end,
        colour = G.C.BLACK,
        loc_txt = {}
    }
    SMODS.Stake {
        name = "Blue Stake",
        key = "blue",
        unlocked_stake = "purple",
        applied_stakes = { "black" },
        pos = { x = 3, y = 0 },
        sticker_pos = { x = 4, y = 0 },
        modifiers = function()
            G.GAME.starting_params.discards = G.GAME.starting_params.discards - 1
        end,
        colour = G.C.BLUE,
        loc_txt = {}
    }
    SMODS.Stake {
        name = "Purple Stake",
        key = "purple",
        unlocked_stake = "orange",
        applied_stakes = { "blue" },
        pos = { x = 0, y = 1 },
        sticker_pos = { x = 1, y = 1 },
        modifiers = function()
            G.GAME.modifiers.scaling = math.max(G.GAME.modifiers.scaling or 0, 3)
        end,
        colour = G.C.PURPLE,
        loc_txt = {}
    }
    SMODS.Stake {
        name = "Orange Stake",
        key = "orange",
        unlocked_stake = "gold",
        applied_stakes = { "purple" },
        pos = { x = 1, y = 1 },
        sticker_pos = { x = 2, y = 1 },
        modifiers = function()
            G.GAME.modifiers.enable_perishables_in_shop = true
        end,
        colour = G.C.ORANGE,
        loc_txt = {}
    }
    SMODS.Stake {
        name = "Gold Stake",
        key = "gold",
        applied_stakes = { "orange" },
        pos = { x = 2, y = 1 },
        sticker_pos = { x = 3, y = 1 },
        modifiers = function()
            G.GAME.modifiers.enable_rentals_in_shop = true
        end,
        colour = G.C.GOLD,
        shiny = true,
        loc_txt = {}
    }


    -------------------------------------------------------------------------------------------------
    ------- API CODE GameObject.ConsumableType
    -------------------------------------------------------------------------------------------------

    SMODS.ConsumableTypes = {}
    SMODS.ConsumableType = SMODS.GameObject:extend {
        obj_table = SMODS.ConsumableTypes,
        obj_buffer = {},
        set = 'ConsumableType',
        required_params = {
            'key',
            'primary_colour',
            'secondary_colour',
        },
        prefix_config = { key = false }, -- TODO? should consumable types have a mod prefix?
        collection_rows = { 6, 6 },
        create_UIBox_your_collection = function(self)
            local deck_tables = {}

            G.your_collection = {}
            for j = 1, #self.collection_rows do
                G.your_collection[j] = CardArea(
                    G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h,
                    (self.collection_rows[j] + 0.25) * G.CARD_W,
                    1 * G.CARD_H,
                    { card_limit = self.collection_rows[j], type = 'title', highlight_limit = 0, collection = true })
                table.insert(deck_tables,
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0, no_fill = true },
                        nodes = {
                            { n = G.UIT.O, config = { object = G.your_collection[j] } }
                        }
                    }
                )
            end

            local consumable_pool = {}
            if G.ACTIVE_MOD_UI then
                for _, v in ipairs(G.P_CENTER_POOLS[self.key]) do
                    if v.mod and G.ACTIVE_MOD_UI.id == v.mod.id then consumable_pool[#consumable_pool+1] = v end
                end
            else
                consumable_pool = G.P_CENTER_POOLS[self.key]
            end

            local sum = 0
            for j = 1, #G.your_collection do
                for i = 1, self.collection_rows[j] do
                    sum = sum + 1
                    local center = consumable_pool[sum]
                    if not center then break end
                    local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w / 2, G.your_collection[j].T.y,
                        G.CARD_W, G.CARD_H, nil, center)
                    card:start_materialize(nil, i > 1 or j > 1)
                    G.your_collection[j]:emplace(card)
                end
            end

            local center_options = {}
            for i = 1, math.ceil(#consumable_pool / sum) do
                table.insert(center_options,
                    localize('k_page') ..
                    ' ' .. tostring(i) .. '/' .. tostring(math.ceil(#consumable_pool / sum)))
            end

            INIT_COLLECTION_CARD_ALERTS()
            local option_nodes = { create_option_cycle({
                options = center_options,
                w = 4.5,
                cycle_shoulders = true,
                opt_callback = 'your_collection_' .. string.lower(self.key) .. '_page',
                focus_args = { snap_to = true, nav = 'wide' },
                current_option = 1,
                colour = G.C.RED,
                no_pips = true
            }) }
            if SMODS.Palettes[self.key] and #SMODS.Palettes[self.key].names > 1 then
                option_nodes[#option_nodes + 1] = create_option_cycle({
                    w = 4.5,
                    scale = 0.8,
                    options = SMODS.Palettes[self.key].names,
                    opt_callback = "update_recolor",
                    current_option = G.SETTINGS.selected_colours[self.key].order,
                    type = self.key
                })
            end
            local t = create_UIBox_generic_options({
                back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection',
                contents = {
                    { n = G.UIT.R, config = { align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05 }, nodes = deck_tables },
                    { n = G.UIT.R, config = { align = "cm", padding = 0 },                                                           nodes = option_nodes },
                }
            })
            return t
        end,
        inject = function(self)
            G.P_CENTER_POOLS[self.key] = G.P_CENTER_POOLS[self.key] or {}
            G.localization.descriptions[self.key] = G.localization.descriptions[self.key] or {}
            G.C.SET[self.key] = self.primary_colour
            G.C.SECONDARY_SET[self.key] = self.secondary_colour
            G.FUNCS['your_collection_' .. string.lower(self.key) .. 's'] = function(e)
                G.SETTINGS.paused = true
                G.FUNCS.overlay_menu {
                    definition = self:create_UIBox_your_collection(),
                }
            end
            G.FUNCS['your_collection_' .. string.lower(self.key) .. '_page'] = function(args)
                if not args or not args.cycle_config then return end
                for j = 1, #G.your_collection do
                    for i = #G.your_collection[j].cards, 1, -1 do
                        local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
                        c:remove()
                        c = nil
                    end
                end
                local sum = 0
                for j = 1, #G.your_collection do
                    sum = sum + self.collection_rows[j]
                end

                local consumable_pool = {}
                if G.ACTIVE_MOD_UI then
                    for _, v in ipairs(G.P_CENTER_POOLS[self.key]) do
                        if v.mod and G.ACTIVE_MOD_UI.id == v.mod.id then consumable_pool[#consumable_pool+1] = v end
                    end
                else
                    consumable_pool = G.P_CENTER_POOLS[self.key]
                end

                sum = sum * (args.cycle_config.current_option - 1)
                for j = 1, #G.your_collection do
                    for i = 1, self.collection_rows[j] do
                        sum = sum + 1
                        local center = consumable_pool[sum]
                        if not center then break end
                        local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w / 2,
                            G.your_collection[j].T.y, G
                            .CARD_W, G.CARD_H, G.P_CARDS.empty, center)
                        card:start_materialize(nil, i > 1 or j > 1)
                        G.your_collection[j]:emplace(card)
                    end
                end
                INIT_COLLECTION_CARD_ALERTS()
            end
            if self.rarities then
                self.rarity_pools = {}
                local total = 0
                for _, v in ipairs(self.rarities) do
                    total = total + v.rate
                end
                for _, v in ipairs(self.rarities) do
                    v.rate = v.rate / total
                    self.rarity_pools[v.key] = {}
                end
            end
        end,
        inject_card = function(self, center)
            if self.rarities and self.rarity_pools[center.rarity] then
                SMODS.insert_pool(self.rarity_pools[center.rarity], center)
            end
        end,
        delete_card = function(self, center)
            if self.rarities and self.rarity_pools[center.rarity] then
                SMODS.remove_pool(self.rarity_pools[center.rarity], center)
            end
        end,
        process_loc_text = function(self)
            if not next(self.loc_txt) then return end
            SMODS.process_loc_text(G.localization.misc.dictionary, 'k_' .. string.lower(self.key), self.loc_txt, 'name')
            SMODS.process_loc_text(G.localization.misc.dictionary, 'b_' .. string.lower(self.key) .. '_cards',
                self.loc_txt, 'collection')
            -- SMODS.process_loc_text(G.localization.misc.labels, string.lower(self.key), self.loc_txt, 'label') -- redundant
            SMODS.process_loc_text(G.localization.descriptions.Other, 'undiscovered_' .. string.lower(self.key),
                self.loc_txt, 'undiscovered')
        end,
        generate_colours = function(self, base_colour, alternate_colour)
            if not self.colour_shifter then return HEX("000000") end
            local colours = {}
            for i = 1, #self.colour_shifter do
                local new_colour = {}
                for j = 1, 4 do
                    table.insert(new_colour, math.max(0, math.min(1, base_colour[j] + self.colour_shifter[i][j])))
                end
                table.insert(colours, HSL_RGB(new_colour))
            end
            if self.colour_shifter_alt then
                for i = 1, #self.colour_shifter_alt do
                    local new_colour = {}
                    for j = 1, 4 do
                        table.insert(new_colour,
                            math.max(0, math.min(1, alternate_colour[j] + self.colour_shifter_alt[i][j])))
                    end
                    table.insert(colours, HSL_RGB(new_colour))
                end
            end
            return colours
        end
    }

    SMODS.ConsumableType {
        key = 'Tarot',
        collection_rows = { 5, 6 },
        primary_colour = G.C.SET.Tarot,
        secondary_colour = G.C.SECONDARY_SET.Tarot,
        inject_card = function(self, center)
            SMODS.ConsumableType.inject_card(self, center)
            SMODS.insert_pool(G.P_CENTER_POOLS['Tarot_Planet'], center)
        end,
        delete_card = function(self, center)
            SMODS.ConsumableType.delete_card(self, center)
            SMODS.remove_pool(G.P_CENTER_POOLS['Tarot_Planet'], center.key)
        end,
        loc_txt = {},
        colour_shifter = { { 0, -0.06, -0.60, 0 }, { 0, 0.30, -0.35, 0 }, { 0, 0.20, -0.15, 0 }, { 0, 0, 0, 0 }, { 0, -0.50, 0.20, 0 } }
    }
    SMODS.ConsumableType {
        key = 'Planet',
        collection_rows = { 6, 6 },
        primary_colour = G.C.SET.Planet,
        secondary_colour = G.C.SECONDARY_SET.Planet,
        inject_card = function(self, center)
            SMODS.ConsumableType.inject_card(self, center)
            SMODS.insert_pool(G.P_CENTER_POOLS['Tarot_Planet'], center)
        end,
        delete_card = function(self, center)
            SMODS.ConsumableType.delete_card(self, center)
            SMODS.remove_pool(G.P_CENTER_POOLS['Tarot_Planet'], center.key)
        end,
        loc_txt = {},
        colour_shifter = { { 0, -0.23, -0.26, 0 }, { 0, 0, 0, 0 }, { 0, -0.10, 0.16, 0 }, { 0.04, -0.35, 0.42, 0 }, { -1, -1, 1, 0 } }
    }
    SMODS.ConsumableType {
        key = 'Spectral',
        collection_rows = { 4, 5 },
        primary_colour = G.C.SET.Spectral,
        secondary_colour = G.C.SECONDARY_SET.Spectral,
        loc_txt = {},
        colour_shifter = { { -0.3, -0.48, -0.61, 0 }, { -0.3, -0.49, -0.48, 0 }, { 0, -0.46, -0.05, 0 }, { -0.02, -0.3, -0.085, 0 }, { 0.08, -0.21, -0.4, 0 }, { 0, -0.03, -0.24, 0 }, { 0, -0.22, -0.31, 0 }, { 0, -0.19, -0.29, 0 }, { 0, -0.21, -0.28, 0 }, { 0, -0.04, -0.125, 0 }, { 0, 0, 0, 0 }, { 0, -0.07, 0.07, 0 }, { 0, -0.1, 0.05, 0 }, { 0, -0.28, 0.12, 0 }, { 0, -0.4, 0, 0 }, { -0.03, -0.47, 0.1, 0 } },
        colour_shifter_alt = { { -0.015, -0.32, -0.24, 0 }, { 0, -0.22, -0.22, 0 }, { 0, -0.24, -0.13, 0 }, { 0, -0.17, 0.13, 0 }, { 0, -0.03, 0.08, 0 }, { 0, 0, 0, 0 } }
    }

    local game_init_game_object_ref = Game.init_game_object
    function Game:init_game_object()
        local t = game_init_game_object_ref(self)
        for _, v in pairs(SMODS.ConsumableTypes) do
            local key = v.key:lower() .. '_rate'
            t[key] = v.shop_rate or t[key] or 0
        end
        return t
    end

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Center
    -------------------------------------------------------------------------------------------------

    SMODS.Centers = {}
    --- Shared class for center objects. Holds no default values; only register an object directly using this if it doesn't fit any subclass, creating one isn't justified and you know what you're doing.
    SMODS.Center = SMODS.GameObject:extend {
        obj_table = SMODS.Centers,
        obj_buffer = {},
        get_obj = function(self, key) return G.P_CENTERS[key] end,
        register = function(self)
            -- 0.9.8 defense
            self.name = self.name or self.key
            SMODS.Center.super.register(self)
        end,
        inject = function(self)
            G.P_CENTERS[self.key] = self
            SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self)
        end,
        delete = function(self)
            G.P_CENTERS[self.key] = nil
            SMODS.remove_pool(G.P_CENTER_POOLS[self.set], self.key)
            local j
            for i, v in ipairs(self.obj_buffer) do
                if v == self.key then j = i end
            end
            if j then table.remove(self.obj_buffer, j) end
            self = nil
            return true
        end,
        generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
            local target = {
                type = 'descriptions',
                key = self.key,
                set = self.set,
                nodes = desc_nodes,
                vars =
                    specific_vars or {}
            }
            local res = {}
            if self.loc_vars and type(self.loc_vars) == 'function' then
                res = self:loc_vars(info_queue, card) or {}
                target.vars = res.vars or target.vars
                target.key = res.key or target.key
            end
            if not full_UI_table.name then
                full_UI_table.name = localize { type = 'name', set = self.set, key = target.key or self.key, nodes = full_UI_table.name }
            end
            if specific_vars and specific_vars.debuffed and not res.replace_debuff then
                target = { type = 'other', key = 'debuffed_' ..
                (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes }
            end
            if res.main_start then
                desc_nodes[#desc_nodes + 1] = res.main_start
            end
            localize(target)
            if res.main_end then
                desc_nodes[#desc_nodes + 1] = res.main_end
            end
        end
    }

    -------------------------------------------------------------------------------------------------
    ------- API CODE GameObject.Center.Joker
    -------------------------------------------------------------------------------------------------

    SMODS.Joker = SMODS.Center:extend {
        rarity = 1,
        unlocked = true,
        discovered = false,
        blueprint_compat = false,
        perishable_compat = true,
        eternal_compat = true,
        pos = { x = 0, y = 0 },
        cost = 3,
        config = {},
        set = 'Joker',
        atlas = 'Joker',
        class_prefix = 'j',
        required_params = {
            'key',
        },
        inject = function(self)
            -- call the parent function to ensure all pools are set
            SMODS.Center.inject(self)
            if self.taken_ownership and self.rarity_original == self.rarity then
                SMODS.remove_pool(G.P_JOKER_RARITY_POOLS[self.rarity_original], self.key)
                SMODS.insert_pool(G.P_JOKER_RARITY_POOLS[self.rarity], self, false)
            else
                SMODS.insert_pool(G.P_JOKER_RARITY_POOLS[self.rarity], self)
            end
        end
    }

    -------------------------------------------------------------------------------------------------
    ------- API CODE GameObject.Center.Consumable
    -------------------------------------------------------------------------------------------------

    SMODS.Consumable = SMODS.Center:extend {
        unlocked = true,
        discovered = false,
        consumeable = true,
        pos = { x = 0, y = 0 },
        atlas = 'Tarot',
        legendaries = {},
        cost = 3,
        config = {},
        class_prefix = 'c',
        required_params = {
            'set',
            'key',
        },
        inject = function(self)
            SMODS.Center.inject(self)
            SMODS.insert_pool(G.P_CENTER_POOLS['Consumeables'], self)
            self.type = SMODS.ConsumableTypes[self.set]
            if self.hidden then
                self.soul_set = self.soul_set or 'Spectral'
                self.soul_rate = self.soul_rate or 0.003
                table.insert(self.legendaries, self)
            end
            if self.type and self.type.inject_card and type(self.type.inject_card) == 'function' then
                self.type:inject_card(self)
            end
        end,
        delete = function(self)
            if self.type and self.type.delete_card and type(self.type.delete_card) == 'function' then
                self.type:delete_card(self)
            end
            SMODS.remove_pool(G.P_CENTER_POOLS['Consumeables'], self.key)
            SMODS.Consumable.super.delete(self)
        end,
        loc_vars = function(self, info_queue)
            return {}
        end
    }
    -- TODO make this set of functions extendable by ConsumableTypes
    SMODS.Tarot = SMODS.Consumable:extend {
        set = 'Tarot',
    }
    SMODS.Planet = SMODS.Consumable:extend {
        set = 'Planet',
        atlas = 'Planet',
    }
    SMODS.Spectral = SMODS.Consumable:extend {
        set = 'Spectral',
        atlas = 'Spectral',
        cost = 4,
    }


    -------------------------------------------------------------------------------------------------
    ------- API CODE GameObject.Center.Voucher
    -------------------------------------------------------------------------------------------------

    SMODS.Voucher = SMODS.Center:extend {
        set = 'Voucher',
        cost = 10,
        atlas = 'Voucher',
        discovered = false,
        unlocked = true,
        available = true,
        pos = { x = 0, y = 0 },
        config = {},
        class_prefix = 'v',
        required_params = {
            'key',
        }
    }

    -------------------------------------------------------------------------------------------------
    ------- API CODE GameObject.Center.Back
    -------------------------------------------------------------------------------------------------

    SMODS.Back = SMODS.Center:extend {
        set = 'Back',
        discovered = false,
        unlocked = true,
        atlas = 'centers',
        pos = { x = 0, y = 0 },
        config = {},
        unlock_condition = {},
        stake = 1,
        class_prefix = 'b',
        required_params = {
            'key',
        },
        register = function(self)
            -- game expects a name, so ensure it's set
            self.name = self.name or self.key
            SMODS.Back.super.register(self)
        end
    }

    -- set the correct stake level for unlocks when injected (spares me from completely overwriting the unlock checks)
    local function stake_mod(stake)
        return {
            inject = function(self)
                self.unlock_condition.stake = SMODS.Stakes[stake].stake_level
                SMODS.Back.inject(self)
            end
        }
    end
    SMODS.Back:take_ownership('zodiac', stake_mod('stake_red'))
    SMODS.Back:take_ownership('painted', stake_mod('stake_green'))
    SMODS.Back:take_ownership('anaglyph', stake_mod('stake_black'))
    SMODS.Back:take_ownership('plasma', stake_mod('stake_blue'))
    SMODS.Back:take_ownership('erratic', stake_mod('stake_orange'))

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Center.Booster
    -------------------------------------------------------------------------------------------------

    SMODS.OPENED_BOOSTER = nil
    SMODS.Booster = SMODS.Center:extend {
        required_params = {
            'key',
        },
        class_prefix = 'p',
        set = "Booster",
        atlas = "Booster",
        pos = {x = 0, y = 0},
        loc_txt = {},
        discovered = false,
        weight = 1,
        cost = 4,
        config = {extra = 3, choose = 1},
        process_loc_text = function(self)
            SMODS.process_loc_text(G.localization.descriptions.Other, self.key, self.loc_txt)
            SMODS.process_loc_text(G.localization.misc.dictionary, 'k_booster_group_'..self.key, self.loc_txt, 'group_name')
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = {card.ability.choose, card.ability.extra} }
        end,
        generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
            local target = {
                type = 'other',
                key = self.key,
                nodes = desc_nodes,
                vars = {}
            }
            if self.loc_vars and type(self.loc_vars) == 'function' then
                local res = self:loc_vars(info_queue, card) or {}
                target.vars = res.vars or target.vars
                target.key = res.key or target.key
            end
            if not full_UI_table.name then 
                full_UI_table.name = localize{type = 'name', set = 'Other', key = self.key, nodes = full_UI_table.name}
            end
            localize(target)
        end,
        create_card = function(self, card)
            -- Example
            -- return create_card("Joker", G.pack_cards, nil, nil, true, true, nil, 'buf')
        end,
        update_pack = function(self, dt)
            if G.buttons then self.buttons:remove(); G.buttons = nil end
            if G.shop then G.shop.alignment.offset.y = G.ROOM.T.y+11 end
        
            if not G.STATE_COMPLETE then
                G.STATE_COMPLETE = true
                G.CONTROLLER.interrupt.focus = true
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        if self.sparkles then
                            G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                                timer = self.sparkles.timer or 0.015,
                                scale = self.sparkles.scale or 0.1,
                                initialize = true,
                                lifespan = self.sparkles.lifespan or 3,
                                speed = self.sparkles.speed or 0.2,
                                padding = self.sparkles.padding or -1,
                                attach = G.ROOM_ATTACH,
                                colours = self.sparkles.colours or {G.C.WHITE, lighten(G.C.GOLD, 0.2)},
                                fill = true
                            })
                        end
                        G.booster_pack = UIBox{
                            definition = self:pack_uibox(),
                            config = {align="tmi", offset = {x=0,y=G.ROOM.T.y + 9}, major = G.hand, bond = 'Weak'}
                        }
                        G.booster_pack.alignment.offset.y = -2.2
                        G.ROOM.jiggle = G.ROOM.jiggle + 3
                        self:ease_background_colour()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                                if self.draw_hand == true then G.FUNCS.draw_from_deck_to_hand() end
        
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'after',
                                    delay = 0.5,
                                    func = function()
                                        G.CONTROLLER:recall_cardarea_focus('pack_cards')
                                        return true
                                    end}))
                                return true
                            end
                        }))  
                        return true
                    end
                }))  
            end
        end,
        ease_background_colour = function(self)
            ease_colour(G.C.DYN_UI.MAIN, G.C.FILTER)
            ease_background_colour{new_colour = G.C.FILTER, special_colour = G.C.BLACK, contrast = 2}
        end,
        pack_uibox = function(self)
            local _size = SMODS.OPENED_BOOSTER.ability.extra
            G.pack_cards = CardArea(
                G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
                math.max(1,math.min(_size,5))*G.CARD_W*1.1,
                1.05*G.CARD_H, 
                {card_limit = _size, type = 'consumeable', highlight_limit = 1})

            local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
                {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                        {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
                            {n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
                {n=G.UIT.R, config={align = "cm"}, nodes={}},
                {n=G.UIT.R, config={align = "tm"}, nodes={
                    {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
                    {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
                        UIBox_dyn_container({
                            {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
                                {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                    {n=G.UIT.O, config={object = DynaText({string = localize(self.group_key or ('k_booster_group_'..self.key)), colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
                                {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                                    {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                                    {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
                        }),}},
                    {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
                        {n=G.UIT.R,config={minh =0.2}, nodes={}},
                        {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
                            {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
            return t
        end,
    }

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.UndiscoveredSprite
    -------------------------------------------------------------------------------------------------

    SMODS.UndiscoveredSprites = {}
    SMODS.UndiscoveredSprite = SMODS.GameObject:extend {
        obj_buffer = {},
        obj_table = SMODS.UndiscoveredSprites,
        inject_class = function() end,
        prefix_config = { key = false },
        required_params = {
            'key',
            'atlas',
            'pos',
        }
    }
    SMODS.UndiscoveredSprite { key = 'Joker', atlas = 'Joker', pos = G.j_undiscovered.pos }
    SMODS.UndiscoveredSprite { key = 'Edition', atlas = 'Joker', pos = G.j_undiscovered.pos }
    SMODS.UndiscoveredSprite { key = 'Tarot', atlas = 'Tarot', pos = G.t_undiscovered.pos }
    SMODS.UndiscoveredSprite { key = 'Planet', atlas = 'Tarot', pos = G.p_undiscovered.pos }
    SMODS.UndiscoveredSprite { key = 'Spectral', atlas = 'Tarot', pos = G.s_undiscovered.pos }
    SMODS.UndiscoveredSprite { key = 'Voucher', atlas = 'Voucher', pos = G.v_undiscovered.pos }
    SMODS.UndiscoveredSprite { key = 'Booster', atlas = 'Booster', pos = G.booster_undiscovered.pos }

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Blind
    -------------------------------------------------------------------------------------------------

    SMODS.Blinds = {}
    SMODS.Blind = SMODS.GameObject:extend {
        obj_table = SMODS.Blinds,
        obj_buffer = {},
        class_prefix = 'bl',
        debuff = {},
        vars = {},
        dollars = 5,
        mult = 2,
        atlas = 'blind_chips',
        discovered = false,
        pos = { x = 0, y = 0 },
        required_params = {
            'key',
        },
        set = 'Blind',
        get_obj = function(self, key) return G.P_BLINDS[key] end,
        register = function(self)
            self.name = self.name or self.key
            SMODS.Blind.super.register(self)
        end,
        inject = function(self, i)
            -- no pools to query length of, so we assign order manually
            if not self.taken_ownership then
                self.order = 30 + i
            end
            G.P_BLINDS[self.key] = self
        end
    }
    SMODS.Blind:take_ownership('eye', {
        set_blind = function(self, reset, silent)
            if not reset then
                G.GAME.blind.hands = {}
                for _, v in ipairs(G.handlist) do
                    G.GAME.blind.hands[v] = false
                end
            end
        end
    })
    SMODS.Blind:take_ownership('wheel', {
        loc_vars = function(self)
            return { vars = { G.GAME.probabilities.normal } }
        end,
        process_loc_text = function(self)
            G.localization.descriptions.Blind['bl_wheel'].text[1] =
                "#1#"..G.localization.descriptions.Blind['bl_wheel'].text[1]
            SMODS.Blind.process_loc_text(self)
        end
    })

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Seal
    -------------------------------------------------------------------------------------------------

    SMODS.Seals = {}
    SMODS.Seal = SMODS.GameObject:extend {
        obj_table = SMODS.Seals,
        obj_buffer = {},
        rng_buffer = { 'Purple', 'Gold', 'Blue', 'Red' },
        badge_to_key = {},
        set = 'Seal',
        class_prefix = 's',
        atlas = 'centers',
        pos = { x = 0, y = 0 },
        discovered = false,
        badge_colour = HEX('FFFFFF'),
        required_params = {
            'key',
            'pos',
        },
        inject = function(self)
            G.P_SEALS[self.key] = self
            G.shared_seals[self.key] = Sprite(0, 0, G.CARD_W, G.CARD_H,
                G.ASSET_ATLAS[self.atlas] or G.ASSET_ATLAS['centers'], self.pos)
            self.badge_to_key[self.key:lower() .. '_seal'] = self.key
            SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self)
            self.rng_buffer[#self.rng_buffer + 1] = self.key
        end,
        process_loc_text = function(self)
            SMODS.process_loc_text(G.localization.descriptions.Other, self.key:lower() .. '_seal', self.loc_txt,
                'description')
            SMODS.process_loc_text(G.localization.misc.labels, self.key:lower() .. '_seal', self.loc_txt, 'label')
        end,
        get_obj = function(self, key) return G.P_SEALS[key] end
    }

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Suit
    -------------------------------------------------------------------------------------------------

    SMODS.inject_p_card = function(suit, rank)
        G.P_CARDS[suit.card_key .. '_' .. rank.card_key] = {
            name = rank.key .. ' of ' .. suit.key,
            value = rank.key,
            suit = suit.key,
            pos = { x = rank.pos.x, y = rank.suit_map[suit.key] or suit.pos.y },
            lc_atlas = rank.suit_map[suit.key] and rank.lc_atlas or suit.lc_atlas,
            hc_atlas = rank.suit_map[suit.key] and rank.hc_atlas or suit.hc_atlas,
        }
    end
    SMODS.remove_p_card = function(suit, rank)
        G.P_CARDS[suit.card_key .. '_' .. rank.card_key] =  nil
    end

    SMODS.Suits = {}
    SMODS.Suit = SMODS.GameObject:extend {
        obj_table = SMODS.Suits,
        obj_buffer = {},
        used_card_keys = {},
        set = 'Suit',
        required_params = {
            'key',
            'card_key',
            'pos',
            'ui_pos',
        },
        hc_atlas = 'cards_2',
        lc_atlas = 'cards_1',
        hc_ui_atlas = 'ui_2',
        lc_ui_atlas = 'ui_1',
        hc_colour = HEX '000000',
        lc_colour = HEX '000000',
        max_nominal = {
            value = 0,
        },
        register = function(self)
            -- 0.9.8 compat
            self.name = self.name or self.key
            if self.used_card_keys[self.card_key] then
                sendWarnMessage(('Tried to use duplicate card key %s, aborting registration'):format(self.card_key), self.set)
                return
            end
            self.used_card_keys[self.card_key] = true
            self.max_nominal.value = self.max_nominal.value + 0.01
            self.suit_nominal = self.max_nominal.value
            SMODS.Suit.super.register(self)
        end,
        inject = function(self)
            for _, rank in pairs(SMODS.Ranks) do
                SMODS.inject_p_card(self, rank)
            end
        end,
        delete = function(self)
            local i
            for j, v in ipairs(self.obj_buffer) do
                if v == self.key then i = j end
            end
            for _, rank in pairs(SMODS.Ranks) do
                SMODS.remove_p_card(self, rank)
            end
            self.used_card_keys[self.card_key] = nil
            table.remove(self.obj_buffer, i)
        end,
        process_loc_text = function(self)
            -- empty loc_txt indicates there are existing values that shouldn't be changed
            SMODS.process_loc_text(G.localization.misc.suits_plural, self.key, self.loc_txt, 'plural')
            SMODS.process_loc_text(G.localization.misc.suits_singular, self.key, self.loc_txt, 'singular')
            if not self.keep_base_colours then
                if type(self.lc_colour) == 'string' then self.lc_colour = HEX(self.lc_colour) end
                if type(self.hc_colour) == 'string' then self.hc_colour = HEX(self.hc_colour) end
                G.C.SO_1[self.key] = self.lc_colour
                G.C.SO_2[self.key] = self.hc_colour
                G.C.SUITS[self.key] = G.C["SO_" .. (G.SETTINGS.colourblind_option and 2 or 1)][self.key]
            end
        end,
    }
    SMODS.Suit {
        key = 'Diamonds',
        card_key = 'D',
        pos = { y = 2 },
        ui_pos = { x = 1, y = 1 },
        keep_base_colours = true,
    }
    SMODS.Suit {
        key = 'Clubs',
        card_key = 'C',
        pos = { y = 1 },
        ui_pos = { x = 2, y = 1 },
        keep_base_colours = true,
    }
    SMODS.Suit {
        key = 'Hearts',
        card_key = 'H',
        pos = { y = 0 },
        ui_pos = { x = 0, y = 1 },
        keep_base_colours = true,
    }
    SMODS.Suit {
        key = 'Spades',
        card_key = 'S',
        pos = { y = 3 },
        ui_pos = { x = 3, y = 1 },
        keep_base_colours = true,
    }
    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Rank
    -------------------------------------------------------------------------------------------------

    SMODS.Ranks = {}
    SMODS.Rank = SMODS.GameObject:extend {
        obj_table = SMODS.Ranks,
        obj_buffer = {},
        used_card_keys = {},
        set = 'Rank',
        required_params = {
            'key',
            'pos',
            'nominal',
        },
        hc_atlas = 'cards_2',
        lc_atlas = 'cards_1',
        strength_effect = {
            fixed = 1,
            random = false,
            ignore = false
        },
        next = {},
        straight_edge = false,
        -- TODO we need a better system for what this is doing.
        -- We should allow setting a playing card's atlas and position to any values,
        -- and we should also ensure that it's easy to create an atlas with a standard
        -- arrangement: x and y set according to rank and suit.

        -- Currently suit_map does the following:
        -- suit_map forces a playing card's atlas to be rank.hc_atlas/lc_atlas,
        -- and not the atlas defined on the suit of the playing card;
        -- additionally pos.y is set according to the corresponding value in the
        -- suit_map
        suit_map = {
            Hearts = 0,
            Clubs = 1,
            Diamonds = 2,
            Spades = 3,
        },
        max_id = {
            value = 1,
        },
        register = function(self)
            if self.used_card_keys[self.card_key] then
                sendWarnMessage(('Tried to use duplicate card key %s, aborting registration'):format(self.card_key), self.set)
                return
            end
            self.used_card_keys[self.card_key] = true
            self.max_id.value = self.max_id.value + 1
            self.id = self.max_id.value
            self.shorthand = self.shorthand or self.key
            self.sort_nominal = self.nominal + (self.face_nominal or 0)
            if self:check_dependencies() and not self.obj_table[self.key] then
                self.obj_table[self.key] = self
                local j
                -- keep buffer sorted in ascending nominal order
                for i = 1, #self.obj_buffer - 1 do
                    if self.obj_table[self.obj_buffer[i]].sort_nominal > self.sort_nominal then
                        j = i
                        break
                    end
                end
                if j then
                    table.insert(self.obj_buffer, j, self.key)
                else
                    table.insert(self.obj_buffer, self.key)
                end
            end
        end,
        process_loc_text = function(self)
            SMODS.process_loc_text(G.localization.misc.ranks, self.key, self.loc_txt)
        end,
        inject = function(self)
            for _, suit in pairs(SMODS.Suits) do
                SMODS.inject_p_card(suit, self)
            end
        end,
        delete = function(self)
            local i
            for j, v in ipairs(self.obj_buffer) do
                if v == self.key then i = j end
            end
            for _, suit in pairs(SMODS.Suits) do
                SMODS.remove_p_card(suit, self)
            end
            self.used_card_keys[self.card_key] = nil
            table.remove(self.obj_buffer, i)
        end
    }
    for _, v in ipairs({ 2, 3, 4, 5, 6, 7, 8, 9 }) do
        SMODS.Rank {
            key = v .. '',
            card_key = v .. '',
            pos = { x = v - 2 },
            nominal = v,
            next = { (v + 1) .. '' },
        }
    end
    SMODS.Rank {
        key = '10',
        card_key = 'T',
        pos = { x = 8 },
        nominal = 10,
        next = { 'Jack' },
    }
    SMODS.Rank {
        key = 'Jack',
        card_key = 'J',
        pos = { x = 9 },
        nominal = 10,
        face_nominal = 0.1,
        face = true,
        shorthand = 'J',
        next = { 'Queen' },
    }
    SMODS.Rank {
        key = 'Queen',
        card_key = 'Q',
        pos = { x = 10 },
        nominal = 10,
        face_nominal = 0.2,
        face = true,
        shorthand = 'Q',
        next = { 'King' },
    }
    SMODS.Rank {
        key = 'King',
        card_key = 'K',
        pos = { x = 11 },
        nominal = 10,
        face_nominal = 0.3,
        face = true,
        shorthand = 'K',
        next = { 'Ace' },
    }
    SMODS.Rank {
        key = 'Ace',
        card_key = 'A',
        pos = { x = 12 },
        nominal = 11,
        face_nominal = 0.4,
        shorthand = 'A',
        straight_edge = true,
        next = { '2' },
    }
    -- make consumable effects compatible with added suits
    -- TODO put this in utils.lua
    local function juice_flip(used_tarot)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.cards do
            local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip(); play_sound('card1', percent); G.hand.cards[i]:juice_up(0.3, 0.3); return true
                end
            }))
        end
    end
    SMODS.Consumable:take_ownership('strength', {
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_tarot:juice_up(0.3, 0.5)
                    return true
                end
            }))
            for i = 1, #G.hand.highlighted do
                local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.highlighted[i]:flip(); play_sound('card1', percent); G.hand.highlighted[i]:juice_up(0.3,
                            0.3); return true
                    end
                }))
            end
            delay(0.2)
            for i = 1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        local _card = G.hand.highlighted[i]
                        local suit_data = SMODS.Suits[_card.base.suit]
                        local suit_prefix = suit_data.card_key
                        local rank_data = SMODS.Ranks[_card.base.value]
                        local behavior = rank_data.strength_effect or { fixed = 1, ignore = false, random = false }
                        local rank_suffix = ''
                        if behavior.ignore or not next(rank_data.next) then
                            return true
                        elseif behavior.random then
                            -- TODO doesn't respect in_pool
                            local r = pseudorandom_element(rank_data.next, pseudoseed('strength'))
                            rank_suffix = SMODS.Ranks[r].card_key
                        else
                            local ii = (behavior.fixed and rank_data.next[behavior.fixed]) and behavior.fixed or 1
                            rank_suffix = SMODS.Ranks[rank_data.next[ii]].card_key
                        end
                        _card:set_base(G.P_CARDS[suit_prefix .. '_' .. rank_suffix])
                        return true
                    end
                }))
            end
            for i = 1, #G.hand.highlighted do
                local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.highlighted[i]:flip(); play_sound('tarot2', percent, 0.6); G.hand.highlighted[i]
                            :juice_up(
                                0.3, 0.3); return true
                    end
                }))
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.hand:unhighlight_all(); return true
                end
            }))
            delay(0.5)
        end,
    })
    SMODS.Consumable:take_ownership('sigil', {
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            juice_flip(used_tarot)
            local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('sigil'))
            for i = 1, #G.hand.cards do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local _card = G.hand.cards[i]
                        local _rank = SMODS.Ranks[_card.base.value]
                        _card:set_base(G.P_CARDS[_suit.card_key .. '_' .. _rank.card_key])
                        return true
                    end
                }))
            end
            for i = 1, #G.hand.cards do
                local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.cards[i]:flip(); play_sound('tarot2', percent, 0.6); G.hand.cards[i]:juice_up(0.3, 0.3); return true
                    end
                }))
            end
            delay(0.5)
        end,
    })
    SMODS.Consumable:take_ownership('ouija', {
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            juice_flip(used_tarot)
            local _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('ouija'))
            for i = 1, #G.hand.cards do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local _card = G.hand.cards[i]
                        local _suit = SMODS.Suits[_card.base.suit]
                        _card:set_base(G.P_CARDS[_suit.card_key .. '_' .. _rank.card_key])
                        return true
                    end
                }))
            end
            G.hand:change_size(-1)
            for i = 1, #G.hand.cards do
                local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.cards[i]:flip(); play_sound('tarot2', percent, 0.6); G.hand.cards[i]:juice_up(0.3, 0.3); return true
                    end
                }))
            end
            delay(0.5)
        end,
    })
    local function random_destroy(used_tarot)
        local destroyed_cards = {}
        destroyed_cards[#destroyed_cards + 1] = pseudorandom_element(G.hand.cards, pseudoseed('random_destroy'))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                for i = #destroyed_cards, 1, -1 do
                    local card = destroyed_cards[i]
                    if card.ability.name == 'Glass Card' then
                        card:shatter()
                    else
                        card:start_dissolve(nil, i ~= #destroyed_cards)
                    end
                end
                return true
            end
        }))
        return destroyed_cards
    end
    SMODS.Consumable:take_ownership('grim', {
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            local destroyed_cards = random_destroy(used_tarot)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.7,
                func = function()
                    local cards = {}
                    for i = 1, card.ability.extra do
                        cards[i] = true
                        -- TODO preserve suit vanilla RNG
                        local _suit, _rank =
                            pseudorandom_element(SMODS.Suits, pseudoseed('grim_create')).card_key, 'A'
                        local cen_pool = {}
                        for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                            if v.key ~= 'm_stone' and not v.overrides_base_rank then
                                cen_pool[#cen_pool + 1] = v
                            end
                        end
                        create_playing_card({
                            front = G.P_CARDS[_suit .. '_' .. _rank],
                            center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
                        }, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
                    end
                    playing_card_joker_effects(cards)
                    return true
                end
            }))
            delay(0.3)
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({ remove_playing_cards = true, removed = destroyed_cards })
            end
        end,
    })
    SMODS.Consumable:take_ownership('familiar', {
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            local destroyed_cards = random_destroy(used_tarot)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.7,
                func = function()
                    local cards = {}
                    for i = 1, card.ability.extra do
                        cards[i] = true
                        -- TODO preserve suit vanilla RNG
                        local faces = {}
                        for _, v in ipairs(SMODS.Rank.obj_buffer) do
                            local r = SMODS.Ranks[v]
                            if r.face then table.insert(faces, r) end
                        end
                        local _suit, _rank =
                            pseudorandom_element(SMODS.Suits, pseudoseed('familiar_create')).card_key,
                            pseudorandom_element(faces, pseudoseed('familiar_create')).card_key
                        local cen_pool = {}
                        for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                            if v.key ~= 'm_stone' and not v.overrides_base_rank then
                                cen_pool[#cen_pool + 1] = v
                            end
                        end
                        create_playing_card({
                            front = G.P_CARDS[_suit .. '_' .. _rank],
                            center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
                        }, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
                    end
                    playing_card_joker_effects(cards)
                    return true
                end
            }))
            delay(0.3)
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({ remove_playing_cards = true, removed = destroyed_cards })
            end
        end,
    })
    SMODS.Consumable:take_ownership('incantation', {
        use = function(self, card, area, copier)
            local used_tarot = copier or card
            local destroyed_cards = random_destroy(used_tarot)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.7,
                func = function()
                    local cards = {}
                    for i = 1, card.ability.extra do
                        cards[i] = true
                        -- TODO preserve suit vanilla RNG
                        local numbers = {}
                        for _, v in ipairs(SMODS.Rank.obj_buffer) do
                            local r = SMODS.Ranks[v]
                            if v ~= 'Ace' and not r.face then table.insert(numbers, r) end
                        end
                        local _suit, _rank =
                            pseudorandom_element(SMODS.Suits, pseudoseed('incantation_create')).card_key,
                            pseudorandom_element(numbers, pseudoseed('incantation_create')).card_key
                        local cen_pool = {}
                        for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                            if v.key ~= 'm_stone' and not v.overrides_base_rank then
                                cen_pool[#cen_pool + 1] = v
                            end
                        end
                        create_playing_card({
                            front = G.P_CARDS[_suit .. '_' .. _rank],
                            center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
                        }, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
                    end
                    playing_card_joker_effects(cards)
                    return true
                end
            }))
            delay(0.3)
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({ remove_playing_cards = true, removed = destroyed_cards })
            end
        end,
    })

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.PokerHand
    -------------------------------------------------------------------------------------------------

    SMODS.PokerHands = {}
    SMODS.PokerHand = SMODS.GameObject:extend {
        obj_table = SMODS.PokerHands,
        obj_buffer = {},
        required_params = {
            'key',
            'above_hand',
            'mult',
            'chips',
            'l_mult',
            'l_chips',
            'example',
        },
        order_lookup = {},
        visible = true,
        played = 0,
        played_this_round = 0,
        level = 1,
        class_prefix = 'h',
        set = 'PokerHand',
        process_loc_text = function(self)
            SMODS.process_loc_text(G.localization.misc.poker_hands, self.key, self.loc_txt, 'name')
            SMODS.process_loc_text(G.localization.misc.poker_hand_descriptions, self.key, self.loc_txt, 'description')
        end,
        register = function(self)
            if self:check_dependencies() and not self.obj_table[self.key] then
                local j
                for i, v in ipairs(G.handlist) do
                    if v == self.above_hand then j = i end
                end
                -- insertion must not happen more than once, so do it on registration
                table.insert(G.handlist, j, self.key)
                self.order_lookup[j] = (self.order_lookup[j] or 0) - 0.001
                self.order = j + self.order_lookup[j]
                self.s_mult = self.mult
                self.s_chips = self.chips
                self.visible = self.visible
                self.level = self.level
                self.played = self.played
                self.played_this_round = self.played_this_round
                self.obj_table[self.key] = self
                self.obj_buffer[#self.obj_buffer + 1] = self.key
            end
        end,
        inject = function(self) end
    }

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Challenge
    -------------------------------------------------------------------------------------------------

    SMODS.Challenges = {}
    SMODS.Challenge = SMODS.GameObject:extend {
        obj_table = SMODS.Challenges,
        obj_buffer = {},
        get_obj = function(self, key)
            for _, v in ipairs(G.CHALLENGES) do
                if v.id == key then return v end
            end
        end,
        set = "Challenge",
        required_params = {
            'key',
        },
        deck = { type = "Challenge Deck" },
        rules = { custom = {}, modifiers = {} },
        jokers = {},
        consumeables = {},
        vouchers = {},
        restrictions = { banned_cards = {}, banned_tags = {}, banned_other = {} },
        unlocked = function(self) return true end,
        class_prefix = 'c',
        process_loc_text = function(self)
            SMODS.process_loc_text(G.localization.misc.challenge_names, self.key, self.loc_txt)
        end,
        register = function(self)
            if self.registered then
                sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
                return
            end
            self.id = self.key
            -- only needs to be called once
            SMODS.insert_pool(G.CHALLENGES, self)
            SMODS.Challenge.super.register(self)
        end,
        inject = function(self) end,
    }
    for k, v in ipairs {
        'omelette_1',
        'city_1',
        'rich_1',
        'knife_1',
        'xray_1',
        'mad_world_1',
        'luxury_1',
        'non_perishable_1',
        'medusa_1',
        'double_nothing_1',
        'typecast_1',
        'inflation_1',
        'bram_poker_1',
        'fragile_1',
        'monolith_1',
        'blast_off_1',
        'five_card_1',
        'golden_needle_1',
        'cruelty_1',
        'jokerless_1',
    } do
        SMODS.Challenge:take_ownership(v, {
            unlocked = function(self)
                return G.PROFILES[G.SETTINGS.profile].challenges_unlocked and
                (G.PROFILES[G.SETTINGS.profile].challenges_unlocked >= k)
            end,
        })
    end

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Tag
    -------------------------------------------------------------------------------------------------

    SMODS.Tags = {}
    SMODS.Tag = SMODS.GameObject:extend {
        obj_table = SMODS.Tags,
        obj_buffer = {},
        required_params = {
            'key',
        },
        discovered = false,
        min_ante = nil,
        atlas = 'tags',
        class_prefix = 'tag',
        set = 'Tag',
        pos = { x = 0, y = 0 },
        config = {},
        get_obj = function(self, key) return G.P_TAGS[key] end,
        process_loc_text = function(self)
            SMODS.process_loc_text(G.localization.descriptions.Tag, self.key, self.loc_txt)
        end,
        inject = function(self)
            G.P_TAGS[self.key] = self
            SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self)
        end,
        generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
            local target = {
                type = 'descriptions',
                key = self.key,
                set = self.set,
                nodes = desc_nodes,
                vars =
                    specific_vars
            }
            local res = {}
            if self.loc_vars and type(self.loc_vars) == 'function' then
                -- card is a dead arg here
                res = self:loc_vars(info_queue)
                target.vars = res.vars or target.vars
                target.key = res.key or target.key
            end
            full_UI_table.name = localize { type = 'name', set = self.set, key = target.key or self.key, nodes = full_UI_table.name }
            if res.main_start then
                desc_nodes[#desc_nodes + 1] = res.main_start
            end
            localize(target)
            if res.main_end then
                desc_nodes[#desc_nodes + 1] = res.main_end
            end
        end
    }

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Sticker
    -------------------------------------------------------------------------------------------------

    SMODS.Stickers = {}
    SMODS.Sticker = SMODS.GameObject:extend {
        obj_table = SMODS.Stickers,
        obj_buffer = {},
        set = 'Sticker',
        required_params = {
            'key',
        },
        class_prefix = 'st',
        rate = 0.3,
        atlas = 'stickers',
        pos = { x = 0, y = 0 },
        colour = HEX 'FFFFFF',
        default_compat = true,
        compat_exceptions = {},
        sets = { Joker = true },
        needs_enable_flag = true,
        process_loc_text = function(self)
            SMODS.process_loc_text(G.localization.descriptions.Other, self.key, self.loc_txt, 'description')
            SMODS.process_loc_text(G.localization.misc.labels, self.key, self.loc_txt, 'label')
        end,
        inject = function() end,
        set_sticker = function(self, card, val)
            card.ability[self.key] = val
        end
    }

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.DollarRow
    -------------------------------------------------------------------------------------------------

    SMODS.DollarRows = {}
    SMODS.DollarRow = SMODS.GameObject:extend {
        obj_buffer = {},
        obj_table = {},
        set = 'Dollar Row',
        class_prefix = 'p',
        required_params = {
            'key'
        },
        config = {},
        above_dot_bar = false,
        symbol_config = { character = '$', color = G.C.MONEY, needs_localize = true },
        custom_message_config = { message = nil, color = nil, scale = nil },
        inject = function() end,
    }

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Enhancement
    -------------------------------------------------------------------------------------------------

    SMODS.Enhancement = SMODS.Center:extend {
        set = 'Enhanced',
        class_prefix = 'm',
        atlas = 'centers',
        pos = { x = 0, y = 0 },
        required_params = {
            'key',
            -- table with keys `name` and `text`
        },
        -- other fields:
        -- replace_base_card
        -- if true, don't draw base card sprite and don't give base card's chips
        -- no_suit
        -- if true, enhanced card has no suit
        -- no_rank
        -- if true, enhanced card has no rank
        -- overrides_base_rank
        -- Set to true if your enhancement overrides the base card's rank.
        -- This prevents rank generators like Familiar creating cards
        -- whose rank is overridden.
        -- any_suit
        -- if true, enhanced card is any suit
        -- always_scores
        -- if true, card always scores
        -- loc_subtract_extra_chips
        -- During tooltip generation, number of chips to subtract from displayed extra chips.
        -- Use if enhancement already displays its own chips.
        -- Future work: use ranks() and suits() for better control
        register = function(self)
            self.config = self.config or {}
            assert(not (self.no_suit and self.any_suit))
            if self.no_rank then self.overrides_base_rank = true end
            SMODS.Enhancement.super.register(self)
        end,
        -- Produces the description of the whole playing card
        -- (including chips from the rank of the card and permanent bonus chips).
        -- You will probably want to override this if your enhancement interacts with
        -- those parts of the base card.
        generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
            if specific_vars and specific_vars.nominal_chips and not self.replace_base_card then
                localize { type = 'other', key = 'card_chips', nodes = desc_nodes, vars = { specific_vars.nominal_chips } }
            end
            SMODS.Enhancement.super.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
            if specific_vars and specific_vars.bonus_chips then
                local remaining_bonus_chips = specific_vars.bonus_chips - (self.loc_subtract_extra_chips or 0)
                if remaining_bonus_chips > 0 then
                    localize { type = 'other', key = 'card_extra_chips', nodes = desc_nodes, vars = { specific_vars.bonus_chips - (self.loc_subtract_extra_chips or 0) } }
                end
            end
        end,
        -- other methods:
        -- calculate(self, context, effect)
    }
    -- Note: `name`, `effect`, and `label` all serve the same purpose as
    -- the name of the enhancement. In theory, `effect` serves to allow reusing
    -- similar effects (ex. the Sinful jokers). But Balatro just uses them all
    -- indiscriminately for enhancements.
    -- `name` and `effect` are technically different for Bonus and Mult
    -- cards but this never matters in practice; also `label` is a red herring,
    -- I can't even find a single use of `label`.

    -- It would be nice if the relevant functions for modding each class of object
    -- would be documented.
    -- For example, Card:set_ability sets the card's enhancement, which is not immediately
    -- obvious.

    -- local stone_card = SMODS.Enhancement:take_ownership('m_stone', {
    --     replace_base_card = true,
    --     no_suit = true,
    --     no_rank = true,
    --     always_scores = true,
    --     loc_txt = {
    --         name = "Stone Card",
    --         text = {
    --             "{C:chips}+#1#{} Chips",
    --             "no rank or suit"
    --         }
    --     },
    --     loc_vars = function(self)
    --         return {
    --             vars = { self.config.bonus }
    --         }
    --     end
    -- })
    -- stone_card.loc_subtract_extra_chips = stone_card.config.bonus

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Shader
    -------------------------------------------------------------------------------------------------

    SMODS.Shaders = {}
    SMODS.Shader = SMODS.GameObject:extend {
        obj_table = SMODS.Shaders,
        obj_buffer = {},
        required_params = {
            'key',
            'path',
        },
        set = 'Shader',
        inject = function(self)
            self.full_path = (self.mod and self.mod.path or SMODS.path) ..
                'assets/shaders/' .. self.path
            local file = NFS.read(self.full_path)
            love.filesystem.write(self.key .. "-temp.fs", file)
            G.SHADERS[self.key] = love.graphics.newShader(self.key .. "-temp.fs")
            love.filesystem.remove(self.key .. "-temp.fs")
            -- G.SHADERS[self.key] = love.graphics.newShader(self.full_path)
        end,
        process_loc_text = function() end
    }

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Edition
    -------------------------------------------------------------------------------------------------

    SMODS.Edition = SMODS.Center:extend {
        set = 'Edition',
        -- atlas only matters for displaying editions in the collection
        atlas = 'Joker',
        pos = { x = 0, y = 0 },
        class_prefix = 'e',
        discovered = false,
        unlocked = true,
        apply_to_float = false,
        in_shop = false,
        weight = 0,
        badge_colour = G.C.DARK_EDITION,
        -- default sound is foil sound
        sound = { sound = "foil1", per = 1.2, vol = 0.4 },
        required_params = {
            'key',
            'shader'
        },
        -- other fields:
        -- extra_cost

        -- TODO badge colours. need to check how Steamodded already does badge colors
        -- other methods:
        -- calculate(self)
        register = function(self)
            self.config = self.config or {}
            SMODS.Edition.super.register(self)
        end,
        process_loc_text = function(self)
            SMODS.process_loc_text(G.localization.misc.labels, self.key:sub(3), self.loc_txt, 'label')
            SMODS.Edition.super.process_loc_text(self)
        end,
        -- apply_modifier = true when G.GAME.edition_rate is to be applied
        get_weight = function(self, apply_modifier)
            return self.weight
        end
    }

    -- TODO also, this should probably be a utility method in core
    -- card_area = pass the card area
    -- edition = boolean value
    function SMODS.Edition:get_edition_cards(card_area, edition)
        local cards = {}
        for _, v in ipairs(card_area.cards) do
            if (not v.edition and edition) or (v.edition and not edition) then
                table.insert(cards, v)
            end
        end
        return cards
    end

    SMODS.Edition:take_ownership('foil', {
        shader = 'foil',
        config = setmetatable({ chips = 50 }, {
            __index = function(t, k)
                if k == 'extra' then return t.chips end
                return rawget(t, k)
            end,
            __newindex = function(t, k, v)
                if k == 'extra' then
                    t.chips = v; return
                end
                rawset(t, k, v)
            end,
        }),
        sound = { sound = "foil1", per = 1.2, vol = 0.4 },
        weight = 20,
        extra_cost = 2,
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self)
            return { vars = { self.config.chips } }
        end
    })
    SMODS.Edition:take_ownership('holo', {
        shader = 'holo',
        config = setmetatable({ mult = 10 }, {
            __index = function(t, k)
                if k == 'extra' then return t.mult end
                return rawget(t, k)
            end,
            __newindex = function(t, k, v)
                if k == 'extra' then
                    t.mult = v; return
                end
                rawset(t, k, v)
            end,
        }),
        sound = { sound = "holo1", per = 1.2 * 1.58, vol = 0.4 },
        weight = 14,
        extra_cost = 3,
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self)
            return { vars = { self.config.mult } }
        end
    })
    SMODS.Edition:take_ownership('polychrome', {
        shader = 'polychrome',
        config = setmetatable({ x_mult = 1.5 }, {
            __index = function(t, k)
                if k == 'extra' then return t.x_mult end
                return rawget(t, k)
            end,
            __newindex = function(t, k, v)
                if k == 'extra' then
                    t.x_mult = v; return
                end
                rawset(t, k, v)
            end,
        }),
        sound = { sound = "polychrome1", per = 1.2, vol = 0.7 },
        weight = 3,
        extra_cost = 5,
        get_weight = function(self)
            return (G.GAME.edition_rate - 1) * G.P_CENTERS["e_negative"].weight + G.GAME.edition_rate * self.weight
        end,
        loc_vars = function(self)
            return { vars = { self.config.x_mult } }
        end
    })
    SMODS.Edition:take_ownership('negative', {
        shader = 'negative',
        config = setmetatable({ card_limit = 1 }, {
            __index = function(t, k)
                if k == 'extra' then return t.card_limit end
                return rawget(t, k)
            end,
            __newindex = function(t, k, v)
                if k == 'extra' then
                    t.card_limit = v; return
                end
                rawset(t, k, v)
            end,
        }),
        sound = { sound = "negative", per = 1.5, vol = 0.4 },
        weight = 3,
        extra_cost = 5,
        get_weight = function(self)
            return self.weight
        end,
        loc_vars = function(self)
            return { vars = { self.config.card_limit } }
        end,
    })

    -------------------------------------------------------------------------------------------------
    ----- API CODE GameObject.Palette
    -------------------------------------------------------------------------------------------------

    SMODS.local_palettes = {}
    SMODS.Palettes = { Types = {} }
    SMODS.Palette = SMODS.GameObject:extend {
        obj_table = SMODS.local_palettes,
        obj_buffer = {},
        required_params = {
            'key',
            'old_colours',
            'new_colours',
            'type',
            'name'
        },
        set = 'Palette',
        class_prefix = 'pal',
        inject = function(self)
            if not G.P_CENTER_POOLS[self.type] and self.type ~= "Suits" then return end
            if not SMODS.Palettes[self.type] then
                table.insert(SMODS.Palettes.Types, self.type)
                SMODS.Palettes[self.type] = { names = {} }
                if self.name ~= "Default" then SMODS.Palette:create_default(self.type) end
                G.SETTINGS.selected_colours[self.type] = G.SETTINGS.selected_colours[self.type] or
                SMODS.Palettes[self.type]["Default"]
            end
            if SMODS.Palettes[self.type][self.name] then
                G.FUNCS.update_atlas(self.type)
                return
            end
            table.insert(SMODS.Palettes[self.type].names, self.name)
            SMODS.Palettes[self.type][self.name] = {
                name = self.name,
                order = #SMODS.Palettes[self.type].names,
                old_colours = {},
                new_colours = {}
            }
            if self.old_colours then
                for i = 1, #self.old_colours do
                    SMODS.Palettes[self.type][self.name].old_colours[i] = type(self.old_colours[i]) == "string" and
                    HEX(self.old_colours[i]) or self.old_colours[i]
                    SMODS.Palettes[self.type][self.name].new_colours[i] = type(self.new_colours[i]) == "string" and
                    HEX(self.new_colours[i]) or self.new_colours[i]
                end
            end
            if not G.SETTINGS.selected_colours[self.type] then
                G.SETTINGS.selected_colours[self.type] = SMODS.Palettes[self.type][self.name]
            end

            SMODS.Palette:create_atlas(self.type, self.name)
            G.FUNCS.update_atlas(self.type)
        end
    }

    function SMODS.Palette:create_default(type)
        table.insert(SMODS.Palettes[type].names, "Default")
        SMODS.Palettes[type]["Default"] = {
            name = "Default",
            old_colours = {},
            new_colours = {},
            order = 1
        }
        SMODS.Palette:create_atlas(type, "Default")
    end

    function SMODS.Palette:create_atlas(type, name)
        local atlas_keys = {}
        if type == "Suits" then
            atlas_keys = { "cards_1", "ui_1" }
        else
            for _, v in pairs(G.P_CENTER_POOLS[type]) do
                atlas_keys[v.atlas or type] = v.atlas or type
            end
        end
        G.PALETTE.NEW = SMODS.Palettes[type][name]
        for _, v in pairs(atlas_keys) do
            G.ASSET_ATLAS[v][name] = { image_data = G.ASSET_ATLAS[v].image_data:clone() }
            G.ASSET_ATLAS[v][name].image_data:mapPixel(G.FUNCS.recolour_image)
            G.ASSET_ATLAS[v][name].image = love.graphics.newImage(G.ASSET_ATLAS[v][name].image_data,
                { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })
        end
    end

    function SMODS.Palette:create_colours(type, base_colour, alternate_colour)
        if SMODS.ConsumableTypes[type].generate_colours then
            return SMODS.ConsumableTypes[type]:generate_colours(HEX_HSL(base_colour),
                alternate_colour and HEX_HSL(alternate_colour))
        end
        return { HEX(base_colour) }
    end

    for k, v in pairs(G.P_CENTER_POOLS.Tarot) do
        SMODS.Consumable:take_ownership(v.key, { atlas = "Tarot", prefix_config = { atlas = false } })
    end
    for _, v in pairs(G.P_CENTER_POOLS.Planet) do
        SMODS.Consumable:take_ownership(v.key, { atlas = "Planet", prefix_config = { atlas = false } })
    end
    for _, v in pairs(G.P_CENTER_POOLS.Spectral) do
        SMODS.Consumable:take_ownership(v.key, { atlas = "Spectral", prefix_config = { atlas = false } })
    end
    SMODS.Atlas({
        key = "Planet",
        path = "resources/textures/" .. G.SETTINGS.GRAPHICS.texture_scaling .. "x/Tarots.png",
        px = 71,
        py = 95,
        inject = function(self)
            self.image_data = love.image.newImageData(self.path)
            self.image = love.graphics.newImage(self.image_data,
                { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })
            G[self.atlas_table][self.key_noloc or self.key] = self
        end
    })
    SMODS.Atlas({
        key = "Spectral",
        path = "resources/textures/" .. G.SETTINGS.GRAPHICS.texture_scaling .. "x/Tarots.png",
        px = 71,
        py = 95,
        inject = function(self)
            self.image_data = love.image.newImageData(self.path)
            self.image = love.graphics.newImage(self.image_data,
                { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })
            G[self.atlas_table][self.key_noloc or self.key] = self
        end
    })
    -- Default palettes defined for base game consumable types
    SMODS.Palette({
        key = "tarot_default",
        old_colours = {},
        new_colours = {},
        type = "Tarot",
        name = "Default"
    })
    SMODS.Palette({
        key = "planet_default",
        old_colours = {},
        new_colours = {},
        type = "Planet",
        name = "Default"
    })
    SMODS.Palette({
        key = "spectral_default",
        old_colours = {},
        new_colours = {},
        type = "Spectral",
        name = "Default"
    })
    SMODS.Palette({
        key = "base_cards",
        old_colours = { "235955", "3c4368", "f06b3f", "f03464" },
        new_colours = { "235955", "3c4368", "f06b3f", "f03464" },
        type = "Suits",
        name = "Default"
    })
    SMODS.Palette({
        key = "high_contrast_cards",
        old_colours = { "235955", "3c4368", "f06b3f", "f03464" },
        new_colours = { "008ee6", "3c4368", "e29000", "f83b2f" },
        type = "Suits",
        name = "High Contrast"
    })

    -------------------------------------------------------------------------------------------------
    ------- API CODE GameObject.Keybind
    -------------------------------------------------------------------------------------------------
    SMODS.Keybinds = {}
    SMODS.Keybind = SMODS.GameObject:extend {
        obj_table = SMODS.Keybinds,
        obj_buffer = {},

        -- key_pressed = 'x',
        held_keys = {}, -- other key(s) that need to be held
        -- action = function(controller)
        --     print("Keybind pressed")
        -- end,

        -- TODO : option to specify if keybind activates on hold, press or release

        required_params = {
            'key',
            'key_pressed',
            'action',
        },
        set = 'Keybind',
        class_prefix = 'keybind',

        inject = function(_) end
    }

    
    -------------------------------------------------------------------------------------------------
    ----- INTERNAL API CODE GameObject._Loc_Post
    -------------------------------------------------------------------------------------------------

    SMODS._Loc_Post = SMODS.GameObject:extend {
        obj_table = {},
        obj_buffer = {},
        silent = true,
        register = function() error('INTERNAL CLASS, DO NOT CALL') end,
        inject_class = function()
            for _, mod in ipairs(SMODS.mod_list) do
                SMODS.handle_loc_file(mod.path)
            end
        end
    }
end

--- STEAMODDED CORE
--- MODULE DEBUG

function initializeSocketConnection()
    local socket = require("socket")
    client = socket.connect("localhost", 12345)
    if not client then
        print("Failed to connect to the debug server")
    end
end

-- message, logger in this order to preserve backward compatibility
function sendTraceMessage(message, logger)
	sendMessageToConsole("TRACE", logger, message)
end

function sendDebugMessage(message, logger)
    sendMessageToConsole("DEBUG", logger, message)
end

function sendInfoMessage(message, logger)
	-- space in info string to align the logs in console
    sendMessageToConsole("INFO ", logger, message)
end

function sendWarnMessage(message, logger)
	-- space in warn string to align the logs in console
	sendMessageToConsole("WARN ", logger, message)
end

function sendErrorMessage(message, logger)
    sendMessageToConsole("ERROR", logger, message)
end

function sendFatalMessage(message, logger)
    sendMessageToConsole("FATAL", logger, message)
end

function sendMessageToConsole(level, logger, message)
    level = level or "DEBUG"
    logger = logger or "DefaultLogger"
    message = message or "Default log message"
    date = os.date('%Y-%m-%d %H:%M:%S')
    print(date .. " :: " .. level .. " :: " .. logger .. " :: " .. message)
    if client then
        -- naive way to separate the logs if the console receive multiple logs at the same time
        client:send(date .. " :: " .. level .. " :: " .. logger .. " :: " .. message .. "ENDOFLOG")
    end
end

initializeSocketConnection()

-- Use the function to send messages
sendDebugMessage("Steamodded Debug Socket started !", "DebugConsole")

----------------------------------------------
------------MOD DEBUG SOCKET END--------------

SMODS.compat_0_9_8 = {}
SMODS.compat_0_9_8.load_done = false

function SMODS.compat_0_9_8.load()
    if SMODS.compat_0_9_8.load_done then
        return
    end

    function SMODS.compat_0_9_8.delay_register(cls, self)
        if self.delay_register then
            self.delay_register = nil
            return
        end
        cls.super.register(self)
    end

    function SMODS.compat_0_9_8.joker_loc_vars(self, info_queue, card)
        local vars, main_end
        if self.loc_def and type(self.loc_def) == 'function' then
            vars, main_end = self.loc_def(card, info_queue)
        end
        if self.tooltip and type(self.tooltip) == 'function' then
            self.tooltip(self, info_queue)
        end
        if vars then
            return {
                vars = vars,
                main_end = main_end
            }
        else
            return {}
        end
    end
    -- Applies to Tarot, Planet, Spectral and Voucher
    function SMODS.compat_0_9_8.tarot_loc_vars(self, info_queue, card)
        local vars, main_end
        if self.loc_def and type(self.loc_def) == 'function' then
            vars, main_end = self.loc_def(self, info_queue)
        end
        if self.tooltip and type(self.tooltip) == 'function' then
            self.tooltip(self, info_queue)
        end
        if vars then
            return {
                vars = vars,
                main_end = main_end
            }
        else
            return {}
        end
    end

    SMODS.compat_0_9_8.init_queue = {}
    SMODS.INIT = setmetatable({}, {
        __newindex = function(t, k, v)
            SMODS.compat_0_9_8.init_queue[k] = v
            rawset(t, k, v)
        end
    })
    function SMODS.findModByID(id)
        return SMODS.Mods[id]
    end
    function SMODS.end_calculate_context(c)
        return c.joker_main
    end
    function SMODS.LOAD_LOC()
        init_localization()
    end

    SMODS.SOUND_SOURCES = SMODS.Sounds
    function register_sound(name, path, filename)
        SMODS.Sound {
            key = name,
            path = filename,
        }
    end
    function modded_play_sound(sound_code, stop_previous_instance, volume, pitch)
        return SMODS.Sound.play(nil, pitch, volume, stop_previous_instance, sound_code)
    end

    SMODS.Card = {
        SUITS = SMODS.Suits,
        RANKS = SMODS.Ranks,
        SUIT_LIST = SMODS.Suit.obj_buffer,
        RANK_LIST = SMODS.Rank.obj_buffer,
    }

    SMODS.compat_0_9_8.Deck_new = SMODS.Back:extend {
        register = function(self)
            SMODS.compat_0_9_8.delay_register(SMODS.compat_0_9_8.Deck_new, self)
        end,
        __index = function(t, k)
            if k == 'slug' then return t.key
            elseif k == 'spritePos' then return t.pos
            end
            return getmetatable(t)[k]
        end,
        __newindex = function(t, k, v)
            if k == 'slug' then t.key = v; return
            elseif k == 'spritePos' then t.pos = v; return
            end
            rawset(t, k, v)
        end,
    }
    SMODS.Deck = {}
    function SMODS.Deck.new(self, name, slug, config, spritePos, loc_txt, unlocked, discovered)
        return SMODS.compat_0_9_8.Deck_new {
            name = name,
            key = slug,
            config = config,
            pos = spritePos,
            loc_txt = loc_txt,
            unlocked = unlocked,
            discovered = discovered,
            atlas = config and config.atlas,
            delay_register = true
        }
    end
    SMODS.Decks = SMODS.Centers

    SMODS.Sprites = {}
    SMODS.compat_0_9_8.Sprite_new = SMODS.Atlas:extend {
        register = function(self)
            if self.delay_register then
                self.delay_register = nil
                return
            end
            if self.registered then
                sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
                return
            end
            SMODS.compat_0_9_8.Sprite_new.super.register(self)
            table.insert(SMODS.Sprites, self)
        end,
        __index = function(t, k)
            if k == 'name' then return t.key
            end
            return getmetatable(t)[k]
        end,
        __newindex = function(t, k, v)
            if k == 'name' then t.key = v; return
            end
            rawset(t, k, v)
        end,
    }
    SMODS.Sprite = {}
    function SMODS.Sprite.new(self, name, top_lpath, path, px, py, type, frames)
        local atlas_table
        if type == 'animation_atli' then
            atlas_table = 'ANIMATION_ATLAS'
        else
            atlas_table = 'ASSET_ATLAS'
        end
        return SMODS.compat_0_9_8.Sprite_new {
            key = name,
            path = path,
            atlas_table = atlas_table,
            px = px,
            py = py,
            frames = frames,
            delay_register = true
        }
    end

    SMODS.compat_0_9_8.Joker_new = SMODS.Joker:extend {
        loc_vars = SMODS.compat_0_9_8.joker_loc_vars,
        register = function(self)
            SMODS.compat_0_9_8.delay_register(SMODS.compat_0_9_8.Joker_new, self)
        end,
        __index = function(t, k)
            if k == 'slug' then return t.key
            elseif k == 'atlas' and SMODS.Atlases[t.key] then return t.key
            elseif k == 'spritePos' then return t.pos
            end
            return getmetatable(t)[k]
        end,
        __newindex = function(t, k, v)
            if k == 'slug' then t.key = v; return
            elseif k == 'spritePos' then t.pos = v; return
            end
            if k == 'calculate' or k == 'set_ability' or k == 'set_badges' or k == 'update' then
                local v_ref = v
                v = function(self, ...)
                    return v_ref(...)
                end
            end
            rawset(t, k, v)
        end,
    }
    function SMODS.Joker.new(self, name, slug, config, spritePos, loc_txt, rarity, cost, unlocked, discovered,
                             blueprint_compat, eternal_compat, effect, atlas, soul_pos)
        local x = SMODS.compat_0_9_8.Joker_new {
            name = name,
            key = slug,
            config = config,
            pos = spritePos,
            loc_txt = loc_txt,
            rarity = rarity,
            cost = cost,
            unlocked = unlocked,
            discovered = discovered,
            blueprint_compat = blueprint_compat,
            eternal_compat = eternal_compat,
            effect = effect,
            atlas = atlas,
            soul_pos = soul_pos,
            delay_register = true
        }
        return x
    end
    SMODS.Jokers = SMODS.Centers

    function SMODS.compat_0_9_8.extend_consumable_class(SMODS_cls)
        local cls
        cls = SMODS_cls:extend {
            loc_vars = SMODS.compat_0_9_8.tarot_loc_vars,
            register = function(self)
                SMODS.compat_0_9_8.delay_register(cls, self)
            end,
            __index = function(t, k)
                if k == 'slug' then
                    return t.key
                elseif k == 'atlas' and SMODS.Atlases[t.key] then
                    return t.key
                end
                return getmetatable(t)[k]
            end,
            __newindex = function(t, k, v)
                if k == 'slug' then
                    t.key = v; return
                elseif k == 'spritePos' then
                    t.pos = v; return
                end
                if k == 'set_badges' or k == 'use' or k == 'can_use' or k == 'update' then
                    local v_ref = v
                    v = function(self, ...)
                        return v_ref(...)
                    end
                end
                rawset(t, k, v)
            end
        }
        return cls
    end

    SMODS.compat_0_9_8.Tarot_new = SMODS.compat_0_9_8.extend_consumable_class(SMODS.Tarot)
    function SMODS.Tarot.new(self, name, slug, config, pos, loc_txt, cost, cost_mult, effect, consumeable, discovered,
                             atlas)
        return SMODS.compat_0_9_8.Tarot_new {
            name = name,
            key = slug,
            config = config,
            pos = pos,
            loc_txt = loc_txt,
            cost = cost,
            cost_mult = cost_mult,
            effect = effect,
            consumeable = consumeable,
            discovered = discovered,
            atlas = atlas,
            delay_register = true
        }
    end
    SMODS.Tarots = SMODS.Centers

    SMODS.compat_0_9_8.Planet_new = SMODS.compat_0_9_8.extend_consumable_class(SMODS.Planet)
    function SMODS.Planet.new(self, name, slug, config, pos, loc_txt, cost, cost_mult, effect, freq, consumeable,
                              discovered, atlas)
        return SMODS.compat_0_9_8.Planet_new {
            name = name,
            key = slug,
            config = config,
            pos = pos,
            loc_txt = loc_txt,
            cost = cost,
            cost_mult = cost_mult,
            effect = effect,
            freq = freq,
            consumeable = consumeable,
            discovered = discovered,
            atlas = atlas,
            delay_register = true
        }
    end
    SMODS.Planets = SMODS.Centers

    SMODS.compat_0_9_8.Spectral_new = SMODS.compat_0_9_8.extend_consumable_class(SMODS.Spectral)
    function SMODS.Spectral.new(self, name, slug, config, pos, loc_txt, cost, consumeable, discovered, atlas)
        return SMODS.compat_0_9_8.Spectral_new {
            name = name,
            key = slug,
            config = config,
            pos = pos,
            loc_txt = loc_txt,
            cost = cost,
            consumeable = consumeable,
            discovered = discovered,
            atlas = atlas,
            delay_register = true
        }
    end
    SMODS.Spectrals = SMODS.Centers

    SMODS.compat_0_9_8.Seal_new = SMODS.Seal:extend {
        class_prefix = false,
        register = function(self)
            if self.delay_register then
                self.delay_register = nil
                return
            end
            if self.registered then
                sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
                return
            end
            if self:check_dependencies() and not self.obj_table[self.label] then
                self.obj_table[self.label] = self
                self.obj_buffer[#self.obj_buffer + 1] = self.label
                self.registered = true
            end
        end,
        __index = function(t, k)
            if k == 'name' then return t.key
            end
            return getmetatable(t)[k]
        end,
        __newindex = function(t, k, v)
            if k == 'name' then t.key = v; return
            end
            rawset(t, k, v)
        end,
    }
    function SMODS.Seal.new(self, name, label, full_name, pos, loc_txt, atlas, discovered, color)
        return SMODS.compat_0_9_8.Seal_new {
            key = name,
            label = label,
            full_name = full_name,
            pos = pos,
            loc_txt = {
                description = loc_txt,
                label = full_name
            },
            atlas = atlas,
            discovered = discovered,
            colour = color,
            delay_register = true
        }
    end

    SMODS.compat_0_9_8.Voucher_new = SMODS.Voucher:extend {
        loc_vars = SMODS.compat_0_9_8.tarot_loc_vars,
        register = function(self)
            SMODS.compat_0_9_8.delay_register(SMODS.compat_0_9_8.Voucher_new, self)
        end,
        __index = function(t, k)
            if k == 'slug' then return t.key
            elseif k == 'atlas' and SMODS.Atlases[t.key] then return t.key
            end
            return getmetatable(t)[k]
        end,
        __newindex = function(t, k, v)
            if k == 'slug' then t.key = v; return
            end
            if k == 'update' then
                local v_ref = v
                v = function(self, ...)
                    return v_ref(...)
                end
            elseif k == 'redeem' then
                local v_ref = v
                v = function(center, card)
                    local center_table = {
                        name = center and center.name or card and card.ability.name,
                        extra = center and center.config.extra or card and card.ability.extra
                    }
                    return v_ref(center_table)
                end
            end
            rawset(t, k, v)
        end
    }
    function SMODS.Voucher.new(self, name, slug, config, pos, loc_txt, cost, unlocked, discovered, available, requires,
                               atlas)
        return SMODS.compat_0_9_8.Voucher_new {
            name = name,
            key = slug,
            config = config,
            pos = pos,
            loc_txt = loc_txt,
            cost = cost,
            unlocked = unlocked,
            discovered = discovered,
            available = available,
            requires = requires,
            atlas = atlas,
            delay_register = true
        }
    end
    SMODS.Vouchers = SMODS.Centers

    SMODS.compat_0_9_8.Blind_new = SMODS.Blind:extend {
        register = function(self)
            SMODS.compat_0_9_8.delay_register(SMODS.compat_0_9_8.Blind_new, self)
        end,
        __index = function(t, k)
            if k == 'slug' then return t.key
            end
            return getmetatable(t)[k]
        end,
        __newindex = function(t, k, v)
            if k == 'slug' then t.key = v; return
            end
            if k == 'set_blind'
            or k == 'disable'
            or k == 'defeat'
            or k == 'debuff_card'
            or k == 'stay_flipped'
            or k == 'drawn_to_hand'
            or k == 'debuff_hand'
            or k == 'modify_hand'
            or k == 'press_play'
            or k == 'get_loc_debuff_text' then
                local v_ref = v
                v = function(self, ...)
                    return v_ref(G.GAME.blind, ...)
                end
            end
            rawset(t, k, v)
        end
    }
    function SMODS.Blind.new(self, name, slug, loc_txt, dollars, mult, vars, debuff, pos, boss, boss_colour, defeated,
                             atlas)
        return SMODS.compat_0_9_8.Blind_new {
            name = name,
            key = slug,
            loc_txt = loc_txt,
            dollars = dollars,
            mult = mult,
            loc_vars = {
                vars = vars,
            },
            debuff = debuff,
            pos = pos,
            boss = boss,
            boss_colour = boss_colour,
            defeated = defeated,
            atlas = atlas,
            delay_register = true
        }
    end

    SMODS.compat_0_9_8.loc_proxies = setmetatable({}, {__mode = 'k'})
    -- Indexing a table `t` that has this metatable instead indexes `t.capture_table`.
    -- Handles nested indices by instead indexing `t.capture_table` with the
    -- concatenation of all indices, separated by dots.
    SMODS.compat_0_9_8.loc_proxy_mt = {
        __index = function(t, k)
            if rawget(t, 'stop_capture') then
                return t.orig_t[k]
            end
            local new_idx_str = t.idx_str .. "." .. k
            -- first check capture_table
            if t.capture_table[new_idx_str] ~= nil then
                return t.capture_table[new_idx_str]
            end
            -- then fall back to orig_t
            local orig_v = t.orig_t[k]
            if type(orig_v) ~= 'table' then
                -- reached a non-table value, stop proxying
                return orig_v
            end
            local ret = setmetatable({
                -- concatenation of all indexes, starting from G.localization
                -- separated by dots and preceded by a dot
                idx_str = new_idx_str,
                -- table we would be indexing
                orig_t = orig_v,
                capture_table = t.capture_table,
            }, SMODS.compat_0_9_8.loc_proxy_mt)
            SMODS.compat_0_9_8.loc_proxies[ret] = true
            return ret
        end,
        __newindex = function(t, k, v)
            if rawget(t, 'stop_capture') then
                t.orig_t[k] = v; return
            end
            local new_idx_str = t.idx_str .. "." .. k
            t.capture_table[new_idx_str] = v
        end
    }
    -- Drop-in replacement for G.localization. Captures changes in `capture_table`
    function SMODS.compat_0_9_8.loc_proxy(capture_table)
        local ret = setmetatable({
            idx_str = '',
            orig_t = G.localization,
            capture_table = capture_table,
        }, SMODS.compat_0_9_8.loc_proxy_mt)
        SMODS.compat_0_9_8.loc_proxies[ret] = true
        return ret
    end
    function SMODS.compat_0_9_8.stop_loc_proxies()
        collectgarbage()
        for proxy, _ in pairs(SMODS.compat_0_9_8.loc_proxies) do
            rawset(proxy, 'stop_capture', true)
            SMODS.compat_0_9_8.loc_proxies[proxy] = nil
        end
    end

    SMODS.compat_0_9_8.load_done = true
end

function SMODS.compat_0_9_8.with_compat(func)
    SMODS.compat_0_9_8.load()
    local localization_ref = G.localization
    init_localization_ref = init_localization
    local captured_loc = {}
    G.localization = SMODS.compat_0_9_8.loc_proxy(captured_loc)
    function init_localization()
        G.localization = localization_ref
        init_localization_ref()
        G.localization = SMODS.compat_0_9_8.loc_proxy(captured_loc)
    end
    func()
    G.localization = localization_ref
    init_localization = init_localization_ref
    SMODS.compat_0_9_8.stop_loc_proxies()
    function SMODS.current_mod.process_loc_text()
        for idx_str, v in pairs(captured_loc) do
            local t = G
            local k = 'localization'
            for cur_k in idx_str:gmatch("[^%.]+") do
                t, k = t[k], cur_k
            end
            t[k] = v
        end
    end
end

--- STEAMODDED CORE
--- MODULE MODLOADER

-- Attempt to require nativefs
local nfs_success, nativefs = pcall(require, "nativefs")
local lovely_success, lovely = pcall(require, "lovely")

local lovely_mod_dir
local library_load_fail = false
if lovely_success then
    lovely_mod_dir = lovely.mod_dir:gsub("/$", "")
else
    sendErrorMessage("Error loading lovely library!", 'Loader')
    library_load_fail = true
end
if nfs_success then
    NFS = nativefs
    -- make lovely_mod_dir an absolute path.
    -- respects symlink/.. combos
    NFS.setWorkingDirectory(lovely_mod_dir)
    lovely_mod_dir = NFS.getWorkingDirectory()
    -- make sure NFS behaves the same as love.filesystem
    NFS.setWorkingDirectory(love.filesystem.getSaveDirectory())
else
    sendWarnMessage("Error loading nativefs library!", 'Loader')
    library_load_fail = true
    NFS = love.filesystem
    if (lovely_mod_dir):sub(1, 1) ~= '/' then
        -- make lovely_mod_dir an absolute path
        lovely_mod_dir = love.filesystem.getWorkingDirectory()..'/'..lovely_mod_dir
    end
    lovely_mod_dir = lovely_mod_dir
        :gsub("%f[^/].%f[/]", "")
        :gsub("[^/]+/..%f[/]", "")
        :gsub("/+", "/")
        :gsub("/$", "")
end
if library_load_fail then
    sendDebugMessage(("Libraries can be loaded from \n%s or %s"):format(
        love.filesystem.getSaveDirectory(),
        love.filesystem.getSourceBaseDirectory()
    ))
end
function set_mods_dir()
    if not lovely_success then
        sendWarnMessage("Lovely not loaded, setting SMODS.MODS_DIR to 'Mods'")
        SMODS.MODS_DIR = "Mods"
        return
    end
    local love_dirs = {
        love.filesystem.getSaveDirectory(),
        love.filesystem.getSourceBaseDirectory()
    }
    for _, love_dir in ipairs(love_dirs) do
        if lovely_mod_dir:sub(1, #love_dir) == love_dir then
            -- relative path from love_dir
            SMODS.MODS_DIR = lovely_mod_dir:sub(#love_dir+2)
            if nfs_success then
                -- make sure NFS behaves the same as love.filesystem.
                -- not perfect: NFS won't read from both getSaveDirectory()
                -- and getSourceBaseDirectory()
                NFS.setWorkingDirectory(love_dir)
            end
            return
        end
    end
    if nfs_success then
        -- allow arbitrary MODS_DIR
        SMODS.MODS_DIR = lovely_mod_dir
        return
    end
    SMODS.MODS_DIR = "Mods"
    sendWarnMessage(
        "nativefs not loaded and lovely --mod-dir was not accessible by love2D!\n"
        ..("possible love2D dirs: %s,\nlovely mod dir: %s\n"):format(inspect(love_dirs), lovely_mod_dir)
        .."setting Steamodded mod directory to 'Mods'"
    )
end
set_mods_dir()

function loadMods(modsDirectory)
    SMODS.Mods = {}
    SMODS.mod_priorities = {}
    SMODS.mod_list = {}
    local header_components = {
        name          = { pattern = '%-%-%- MOD_NAME: ([^\n]+)\n', required = true },
        id            = { pattern = '%-%-%- MOD_ID: ([^ \n]+)\n', required = true },
        author        = { pattern = '%-%-%- MOD_AUTHOR: %[(.-)%]\n', required = true, parse_array = true },
        description   = { pattern = '%-%-%- MOD_DESCRIPTION: (.-)\n', required = true },
        priority      = { pattern = '%-%-%- PRIORITY: (%-?%d+)\n', handle = function(x) return x and x + 0 or 0 end },
        badge_colour  = { pattern = '%-%-%- BADGE_COLO[U]?R: (%x-)\n', handle = function(x) return HEX(x or '666666FF') end },
        badge_text_colour   = { pattern = '%-%-%- BADGE_TEXT_COLO[U]?R: (%x-)\n', handle = function(x) return HEX(x or 'FFFFFF') end },
        display_name  = { pattern = '%-%-%- DISPLAY_NAME: (.-)\n' },
        dependencies  = {
            pattern = '%-%-%- DEPENDENCIES: %[(.-)%]\n',
            parse_array = true,
            handle = function(x)
                local t = {}
                for _, v in ipairs(x) do
                    table.insert(t, {
                        id = v:match '(.-)[<>]' or v,
                        v_geq = v:match '>=([^<>]+)',
                        v_leq = v:match '<=([^<>]+)',
                    })
                end
                return t
            end,
        },
        conflicts     = {
            pattern = '%-%-%- CONFLICTS: %[(.-)%]\n',
            parse_array = true,
            handle = function(x)
                local t = {}
                for _, v in ipairs(x) do
                    table.insert(t, {
                        id = v:match '(.-)[<>]',
                        v_geq = v:match '>=([^<>]+)',
                        v_leq = v:match '<=([^<>]+)',
                    })
                end
                return t
            end
        },
        prefix        = { pattern = '%-%-%- PREFIX: (.-)\n' },
        version       = { pattern = '%-%-%- VERSION: (.-)\n', handle = function(x) return x or '0.0.0' end },
        l_version_geq = {
            pattern = '%-%-%- LOADER_VERSION_GEQ: (.-)\n',
            handle = function(x)
                return x and x:gsub('%-STEAMODDED', '')
            end
        },
        l_version_leq = {
            pattern = '%-%-%- LOADER_VERSION_LEQ: (.-)\n',
            handle = function(x)
                return x and x:gsub('%-STEAMODDED', '')
            end
        },
        outdated      = { pattern = { 'SMODS%.INIT', 'SMODS%.Deck' } },
        dump_loc      = { pattern = { '%-%-%- DUMP_LOCALIZATION\n'}}
    }
    
    local used_prefixes = {}

    -- Function to process each directory (including subdirectories) with depth tracking
    local function processDirectory(directory, depth)
        if depth > 3 then
            return -- Stop processing if the depth is greater than 3
        end

        for _, filename in ipairs(NFS.getDirectoryItems(directory)) do
            local file_path = directory .. "/" .. filename

            -- Check if the current file is a directory
            local file_type = NFS.getInfo(file_path).type
            if file_type == 'directory' or file_type == 'symlink' then
                -- If it's a directory and depth is within limit, recursively process it
                processDirectory(file_path, depth + 1)
            elseif filename:lower():match("%.lua$") then -- Check if the file is a .lua file
                if depth == 1 then
                    sendWarnMessage(('Found lone Lua file %s in Mods directory :: Please place the files for each mod in its own subdirectory.'):format(filename))
                end
                local file_content = NFS.read(file_path)

                -- Convert CRLF in LF
                file_content = file_content:gsub("\r\n", "\n")

                -- Check the header lines using string.match
                local headerLine = file_content:match("^(.-)\n")
                if headerLine == "--- STEAMODDED HEADER" then
                    boot_print_stage('Processing Mod File: ' .. filename)
                    local mod = {}
                    local sane = true
                    for k, v in pairs(header_components) do
                        local component = nil
                        if type(v.pattern) == "table" then
                            for _, pattern in ipairs(v.pattern) do
                                component = file_content:match(pattern) or component
                                if component then break end
                            end
                        else
                            component = file_content:match(v.pattern)
                        end
                        if v.required and not component then
                            sane = false
                            sendWarnMessage(string.format('Mod file %s is missing required header component: %s',
                                filename, k))
                            break
                        end
                        if v.parse_array then
                            local list = {}
                            component = component or ''
                            for val in string.gmatch(component, "([^,]+)") do
                                table.insert(list, val:match("^%s*(.-)%s*$")) -- Trim spaces
                            end
                            component = list
                        end
                        if v.handle and type(v.handle) == 'function' then
                            component = v.handle(component)
                        end
                        mod[k] = component
                    end
                    if NFS.getInfo(directory..'/.lovelyignore') then
                        mod.disabled = true
                    end
                    if SMODS.Mods[mod.id] then
                        sane = false
                        sendWarnMessage("Duplicate Mod ID: " .. mod.id, 'Loader')
                    end
                
                    if mod.outdated then
                        mod.prefix_config = { key = { mod = false }, atlas = false }
                    else
                        mod.prefix = mod.prefix or (mod.id or ''):lower():sub(1, 4)
                    end
                    if mod.prefix and used_prefixes[mod.prefix] then
                        sane = false
                        sendWarnMessage(('Duplicate Mod prefix %s used by %s, %s'):format(mod.prefix, mod.id, used_prefixes[mod.prefix]))
                    end

                    if sane then
                        boot_print_stage('Saving Mod Info: ' .. mod.id)
                        mod.path = directory .. '/'
                        mod.main_file = filename
                        mod.display_name = mod.display_name or mod.name
                        if mod.prefix then
                            used_prefixes[mod.prefix] = mod.id
                        end
                        mod.optional_dependencies = {}
                        if mod.dump_loc then
                            SMODS.dump_loc = {
                                path = mod.path,
                            }
                        end
                        SMODS.Mods[mod.id] = mod
                        SMODS.mod_priorities[mod.priority] = SMODS.mod_priorities[mod.priority] or {}
                        table.insert(SMODS.mod_priorities[mod.priority], mod)
                    end
                elseif headerLine == '--- STEAMODDED CORE' then
                    -- save top-level directory of Steamodded installation
                    SMODS.path = SMODS.path or directory:match('^(.+/)')
                else
                    sendTraceMessage("Skipping non-Lua file or invalid header: " .. filename, 'Loader')
                end
            end
        end
    end

    -- Start processing with the initial directory at depth 1
    processDirectory(modsDirectory, 1)

    -- sort by priority
    local keyset = {}
    for k, _ in pairs(SMODS.mod_priorities) do
        keyset[#keyset + 1] = k
    end
    table.sort(keyset)

    local function check_dependencies(mod, seen)
        if not (mod.can_load == nil) then return mod.can_load end
        seen = seen or {}
        local can_load = true
        if seen[mod.id] then return true end
        seen[mod.id] = true
        local load_issues = {
            dependencies = {},
            conflicts = {},
        }
        for _, v in ipairs(mod.conflicts or {}) do
            -- block load even if the conflict is also blocked
            if
                SMODS.Mods[v.id] and
                (not v.v_leq or SMODS.Mods[v.id].version <= v.v_leq) and
                (not v.v_geq or SMODS.Mods[v.id].version >= v.v_geq)
            then
                can_load = false
                table.insert(load_issues.conflicts, v.id..(v.v_leq and '<='..v.v_leq or '')..(v.v_geq and '>='..v.v_geq or ''))
            end
        end
        for _, v in ipairs(mod.dependencies or {}) do
            -- recursively check dependencies of dependencies to make sure they are actually fulfilled
            if
                not SMODS.Mods[v.id] or
                not check_dependencies(SMODS.Mods[v.id], seen) or
                (v.v_leq and SMODS.Mods[v.id].version > v.v_leq) or
                (v.v_geq and SMODS.Mods[v.id].version < v.v_geq)
            then
                can_load = false
                table.insert(load_issues.dependencies,
                    v.id .. (v.v_geq and '>=' .. v.v_geq or '') .. (v.v_leq and '<=' .. v.v_leq or ''))
            end
        end
        if mod.outdated then
            load_issues.outdated = true
        end
        if mod.disabled then
            can_load = false
            load_issues.disabled = true
        end
        local loader_version = MODDED_VERSION:gsub('%-STEAMODDED', '')
        if
            (mod.l_version_geq and loader_version < mod.l_version_geq) or
            (mod.l_version_leq and loader_version > mod.l_version_geq)
        then
            can_load = false
            load_issues.version_mismatch = ''..(mod.l_version_geq and '>='..mod.l_version_geq or '')..(mod.l_version_leq and '<='..mod.l_version_leq or '')
        end
        if not can_load then
            mod.load_issues = load_issues
            return false
        end
        for _, v in ipairs(mod.dependencies) do
            SMODS.Mods[v.id].can_load = true
        end
        return true
    end

    -- load the mod files
    for _, priority in ipairs(keyset) do
        table.sort(SMODS.mod_priorities[priority],
            function(mod_a, mod_b)
                return mod_a.id < mod_b.id
            end)
        for _, mod in ipairs(SMODS.mod_priorities[priority]) do
            mod.can_load = check_dependencies(mod)
            SMODS.mod_list[#SMODS.mod_list + 1] = mod -- keep mod list in prioritized load order
            if mod.can_load then
                boot_print_stage('Loading Mod: ' .. mod.id)
                SMODS.current_mod = mod
                if mod.outdated then
                    SMODS.compat_0_9_8.with_compat(function()
                        mod.config = {}
                        assert(load(NFS.read(mod.path..mod.main_file), ('=[SMODS %s "%s"]'):format(mod.id, mod.main_file)))()
                        for k, v in pairs(SMODS.compat_0_9_8.init_queue) do
                            v()
                            SMODS.compat_0_9_8.init_queue[k] = nil
                        end
                    end)
                else
                    local config_path = mod.path..'config.lua'
                    if NFS.getInfo(config_path) then
                        mod.config = assert(load(NFS.read(config_path), ('=[SMODS %s "config.lua"]'):format(mod.id)))()
                    else
                        mod.config = {}
                    end
                    assert(load(NFS.read(mod.path..mod.main_file), ('=[SMODS %s "%s"]'):format(mod.id, mod.main_file)))()
                end
                SMODS.current_mod = nil
            else
                boot_print_stage('Failed to load Mod: ' .. mod.id)
                sendWarnMessage(string.format("Mod %s was unable to load: %s%s%s", mod.id,
                    mod.load_issues.outdated and
                    'Outdated: Steamodded versions 0.9.8 and below are no longer supported!\n' or '',
                    next(mod.load_issues.dependencies) and
                    ('Missing Dependencies: ' .. inspect(mod.load_issues.dependencies) .. '\n') or '',
                    next(mod.load_issues.conflicts) and
                    ('Unresolved Conflicts: ' .. inspect(mod.load_issues.conflicts) .. '\n') or ''
                ))
            end
        end
    end
    -- compat after loading mods
    if SMODS.compat_0_9_8.load_done then
        -- Invasive change to Card:generate_UIBox_ability_table()
        local Card_generate_UIBox_ability_table_ref = Card.generate_UIBox_ability_table
        function Card:generate_UIBox_ability_table(...)
            SMODS.compat_0_9_8.generate_UIBox_ability_table_card = self
            local ret = Card_generate_UIBox_ability_table_ref(self, ...)
            SMODS.compat_0_9_8.generate_UIBox_ability_table_card = nil
            return ret
        end
    end
end

function SMODS.injectItems()
    -- Set .key for vanilla undiscovered, locked objects
    for k, v in pairs(G) do
        if type(k) == 'string' and (k:sub(-12, -1) == 'undiscovered' or k:sub(-6, -1) == 'locked') then
            v.key = k
        end
    end
    SMODS.injectObjects(SMODS.GameObject)
    if SMODS.dump_loc then
        boot_print_stage('Dumping Localization')
        SMODS.create_loc_dump()
    end
    boot_print_stage('Initializing Localization')
    init_localization()
    SMODS.SAVE_UNLOCKS()
    table.sort(G.P_CENTER_POOLS["Back"], function (a, b) return (a.order - (a.unlocked and 100 or 0)) < (b.order - (b.unlocked and 100 or 0)) end)
    for _, t in ipairs{
        G.P_CENTERS,
        G.P_BLINDS,
        G.P_TAGS,
        G.P_SEALS,
    } do
        for k, v in pairs(t) do
            assert(v._discovered_unlocked_overwritten)
        end
    end
end

local function initializeModUIFunctions()
    for id, modInfo in pairs(SMODS.mod_list) do
        boot_print_stage("Initializing Mod UI: " .. modInfo.id)
        G.FUNCS["openModUI_" .. modInfo.id] = function(arg_736_0)
            G.ACTIVE_MOD_UI = modInfo
            G.FUNCS.overlay_menu({
                definition = create_UIBox_mods(arg_736_0)
            })
        end
    end
end

function initSteamodded()
    initGlobals()
    boot_print_stage("Loading APIs")
    loadAPIs()
    boot_print_stage("Loading Mods")
    loadMods(SMODS.MODS_DIR)
    initializeModUIFunctions()
    boot_print_stage("Injecting Items")
    SMODS.injectItems()
    SMODS.booted = true
end

-- re-inject on reload
local init_item_prototypes_ref = Game.init_item_prototypes
function Game:init_item_prototypes()
    init_item_prototypes_ref(self)
    if SMODS.booted then
        SMODS.injectItems()
    end
end

SMODS.booted = false
function boot_print_stage(stage)
    if not SMODS.booted then
        boot_timer(nil, "STEAMODDED - " .. stage, 0.95)
    end
end

function boot_timer(_label, _next, progress)
    progress = progress or 0
    G.LOADING = G.LOADING or {
        font = love.graphics.setNewFont("resources/fonts/m6x11plus.ttf", 20),
        love.graphics.dis
    }
    local realw, realh = love.window.getMode()
    love.graphics.setCanvas()
    love.graphics.push()
    love.graphics.setShader()
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.setColor(0.6, 0.8, 0.9, 1)
    if progress > 0 then love.graphics.rectangle('fill', realw / 2 - 150, realh / 2 - 15, progress * 300, 30, 5) end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line', realw / 2 - 150, realh / 2 - 15, 300, 30, 5)
    love.graphics.print("LOADING: " .. _next, realw / 2 - 150, realh / 2 + 40)
    love.graphics.pop()
    love.graphics.present()

    G.ARGS.bt = G.ARGS.bt or love.timer.getTime()
    G.ARGS.bt = love.timer.getTime()
end

function SMODS.load_file(path, id)
    if not path or path == "" then
        error("No path was provided to load.")
    end
    local mod
    if not id then
        if not SMODS.current_mod then
            error("No ID was provided! Usage without an ID is only available when file is first loaded.")
        end
        mod = SMODS.current_mod
    else 
        mod = SMODS.Mods[id]
    end
    if not mod then
        error("Mod not found. Ensure you are passing the correct ID.")
    end 
    local file_path = mod.path .. path
    local file_content, err = NFS.read(file_path)
    if not file_content then return  nil, "Error reading file '" .. path .. "' for mod with ID '" .. mod.id .. "': " .. err end
    local chunk, err = load(file_content, "=[SMODS " .. mod.id .. ' "' .. path .. '"]')
    if not chunk then return nil, "Error processing file '" .. path .. "' for mod with ID '" .. mod.id .. "': " .. err end
    return chunk
end

----------------------------------------------
------------MOD LOADER END--------------------

local lovely = require("lovely")
local nativefs = require("nativefs")


Talisman = {config_file = {disable_anims = true, break_infinity = "bignumber", score_opt_id = 2}}
if nativefs.read(lovely.mod_dir.."/Talisman/config.lua") then
    Talisman.config_file = STR_UNPACK(nativefs.read(lovely.mod_dir.."/Talisman/config.lua"))

    if Talisman.config_file.break_infinity and type(Talisman.config_file.break_infinity) ~= 'string' then
      Talisman.config_file.break_infinity = "bignumber"
    end
end

if not SpectralPack then
  SpectralPack = {}
  local ct = create_tabs
  function create_tabs(args)
      if args and args.tab_h == 7.05 then
          args.tabs[#args.tabs+1] = {
              label = "Spectral Pack",
              tab_definition_function = function() return {
                  n = G.UIT.ROOT,
                  config = {
                      emboss = 0.05,
                      minh = 6,
                      r = 0.1,
                      minw = 10,
                      align = "cm",
                      padding = 0.2,
                      colour = G.C.BLACK
                  },
                  nodes = SpectralPack
              } end
          }
      end
      return ct(args)
  end
end
SpectralPack[#SpectralPack+1] = UIBox_button{ label = {"Talisman"}, button = "talismanMenu", colour = G.C.MONEY, minw = 5, minh = 0.7, scale = 0.6}
G.FUNCS.talismanMenu = function(e)
  local tabs = create_tabs({
      snap_to_nav = true,
      tabs = {
          {
              label = "Talisman",
              chosen = true,
              tab_definition_function = function()
                tal_nodes = {{n=G.UIT.R, config={align = "cm"}, nodes={
                  {n=G.UIT.O, config={object = DynaText({string = "Select features to enable:", colours = {G.C.WHITE}, shadow = true, scale = 0.4})}},
                }},create_toggle({label = "Disable Scoring Animations", ref_table = Talisman.config_file, ref_value = "disable_anims",
                callback = function(_set_toggle)
	                nativefs.write(lovely.mod_dir .. "/Talisman/config.lua", STR_PACK(Talisman.config_file))
                end}),
                create_option_cycle({
                  label = "Score Limit (requires game restart)",
                  scale = 0.8,
                  w = 6,
                  options = {"Vanilla (e308)", "BigNum (ee308)", "OmegaNum (e10##1000)"},
                  opt_callback = 'talisman_upd_score_opt',
                  current_option = Talisman.config_file.score_opt_id,
                })}
                return {
                n = G.UIT.ROOT,
                config = {
                    emboss = 0.05,
                    minh = 6,
                    r = 0.1,
                    minw = 10,
                    align = "cm",
                    padding = 0.2,
                    colour = G.C.BLACK
                },
                nodes = tal_nodes
            }
              end
          },
      }})
  G.FUNCS.overlay_menu{
          definition = create_UIBox_generic_options({
              back_func = "options",
              contents = {tabs}
          }),
      config = {offset = {x=0,y=10}}
  }
end
G.FUNCS.talisman_upd_score_opt = function(e)
  Talisman.config_file.score_opt_id = e.to_key
  local score_opts = {"", "bignumber", "omeganum"}
  Talisman.config_file.break_infinity = score_opts[e.to_key]
  nativefs.write(lovely.mod_dir .. "/Talisman/config.lua", STR_PACK(Talisman.config_file))
end
if Talisman.config_file.break_infinity then
  Big, err = nativefs.load(lovely.mod_dir.."/Talisman/big-num/"..Talisman.config_file.break_infinity..".lua")
  if not err then Big = Big() else Big = nil end
  Notations = nativefs.load(lovely.mod_dir.."/Talisman/big-num/notations.lua")()
  -- We call this after init_game_object to leave room for mods that add more poker hands
  Talisman.igo = function(obj)
      for _, v in pairs(obj.hands) do
          v.chips = to_big(v.chips)
          v.mult = to_big(v.mult)
      end
      return obj
  end

  local nf = number_format
  function number_format(num, e_switch_point)
      if type(num) == 'table' then
          num = to_big(num)
          G.E_SWITCH_POINT = G.E_SWITCH_POINT or 100000000000
          if num < to_big(e_switch_point or G.E_SWITCH_POINT) then
              return nf(num:to_number(), e_switch_point)
          else
            return Notations.Balatro:format(num, 3)
          end
      else return nf(num, e_switch_point) end
  end

  local mf = math.floor
  function math.floor(x)
      if type(x) == 'table' then return x:floor() end
      return mf(x)
  end

  local l10 = math.log10
  function math.log10(x)
      if type(x) == 'table' then return l10(math.min(x:to_number(),1e300)) end--x:log10() end
      return l10(x)
  end

  local lg = math.log
  function math.log(x, y)
      if not y then y = 2.718281828459045 end
      if type(x) == 'table' then return lg(math.min(x:to_number(),1e300),y) end --x:log(y) end
      return lg(x,y)
  end

  -- There's too much to override here so we just fully replace this function
  -- Note that any ante scaling tweaks will need to manually changed...
  local gba = get_blind_amount
  function get_blind_amount(ante)
    if type(to_big(1)) == 'number' then return gba(ante) end
      local k = to_big(0.75)
      if not G.GAME.modifiers.scaling or G.GAME.modifiers.scaling == 1 then 
        local amounts = {
          to_big(300),  to_big(800), to_big(2000),  to_big(5000),  to_big(11000),  to_big(20000),   to_big(35000),  to_big(50000)
        }
        if ante < 1 then return to_big(100) end
        if ante <= 8 then return amounts[ante] end
        local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
        local amount = a*(b+(k*c)^d)^c
        if (amount:lt(R.MAX_SAFE_INTEGER)) then
          local exponent = to_big(10)^(math.floor(amount:log10() - to_big(1))):to_number()
          amount = math.floor(amount / exponent):to_number() * exponent
        end
        amount:normalize()
        return amount
      elseif G.GAME.modifiers.scaling == 2 then 
        local amounts = {
          to_big(300),  to_big(900), to_big(2600),  to_big(8000), to_big(20000),  to_big(36000),  to_big(60000),  to_big(100000)
          --300,  900, 2400,  7000,  18000,  32000,  56000,  90000
        }
        if ante < 1 then return to_big(100) end
        if ante <= 8 then return amounts[ante] end
        local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
        local amount = a*(b+(k*c)^d)^c
        if (amount:lt(R.MAX_SAFE_INTEGER)) then
          local exponent = to_big(10)^(math.floor(amount:log10() - to_big(1))):to_number()
          amount = math.floor(amount / exponent):to_number() * exponent
        end
        amount:normalize()
        return amount
      elseif G.GAME.modifiers.scaling == 3 then 
        local amounts = {
          to_big(300),  to_big(1000), to_big(3200),  to_big(9000),  to_big(25000),  to_big(60000),  to_big(110000),  to_big(200000)
          --300,  1000, 3000,  8000,  22000,  50000,  90000,  180000
        }
        if ante < 1 then return to_big(100) end
        if ante <= 8 then return amounts[ante] end
        local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
        local amount = a*(b+(k*c)^d)^c
        if (amount:lt(R.MAX_SAFE_INTEGER)) then
          local exponent = to_big(10)^(math.floor(amount:log10() - to_big(1))):to_number()
          amount = math.floor(amount / exponent):to_number() * exponent
        end
        amount:normalize()
        return amount
      end
    end

  function check_and_set_high_score(score, amt)
    if G.GAME.round_scores[score] and to_big(math.floor(amt)) > to_big(G.GAME.round_scores[score].amt) then
      G.GAME.round_scores[score].amt = to_big(math.floor(amt))
    end
    if  G.GAME.seeded  then return end
    --[[if G.PROFILES[G.SETTINGS.profile].high_scores[score] and math.floor(amt) > G.PROFILES[G.SETTINGS.profile].high_scores[score].amt then
      if G.GAME.round_scores[score] then G.GAME.round_scores[score].high_score = true end
      G.PROFILES[G.SETTINGS.profile].high_scores[score].amt = math.floor(amt)
      G:save_settings()
    end--]] --going to hold off on modifying this until proper save loading exists
  end

  local sn = scale_number
  function scale_number(number, scale, max)
    if not Big then return sn(number, scale, max) end
    scale = to_big(scale)
    G.E_SWITCH_POINT = G.E_SWITCH_POINT or 100000000000
    if not number or not is_number(number) then return scale end
    if not max then max = 10000 end
    if to_big(number).e and to_big(number).e == 10^1000 then
      scale = scale*math.floor(math.log(max*10, 10))/7
    end
    if to_big(number) >= to_big(G.E_SWITCH_POINT) then
      if (to_big(to_big(number):log10()) <= to_big(999)) then
        scale = scale*math.floor(math.log(max*10, 10))/math.floor(math.log(1000000*10, 10))
      else
        scale = scale*math.floor(math.log(max*10, 10))/math.floor(math.max(7,string.len(number_format(number))-1))
      end
    elseif to_big(number) >= to_big(max) then
      scale = scale*math.floor(math.log(max*10, 10))/math.floor(math.log(number*10, 10))
    end
    return math.min(3, scale:to_number())
  end

  local tsj = G.FUNCS.text_super_juice
  function G.FUNCS.text_super_juice(e, _amount)
    if _amount > 2 then _amount = 2 end
    return tsj(e, _amount)
  end

  local max = math.max
  --don't return a Big unless we have to - it causes nativefs to break
  function math.max(x, y)
    if type(x) == 'table' or type(y) == 'table' then
    x = to_big(x)
    y = to_big(y)
    if (x > y) then
      return x
    else
      return y
    end
    else return max(x,y) end
  end

  local min = math.min
  function math.min(x, y)
    if type(x) == 'table' or type(y) == 'table' then
    x = to_big(x)
    y = to_big(y)
    if (x < y) then
      return x
    else
      return y
    end
    else return min(x,y) end
  end

  local sqrt = math.sqrt
  function math.sqrt(x)
    if type(x) == 'table' then
      if getmetatable(x) == BigMeta then return x:sqrt() end
      if getmetatable(x) == OmegaMeta then return x:pow(0.5) end
    end
    return sqrt(x)
  end
end

function is_number(x)
  if type(x) == 'number' then return true end
  if type(x) == 'table' and ((x.e and x.m) or (x.array and x.sign)) then return true end
  return false
end

function to_big(x, y)
  if Big and Big.m then
    return Big:new(x,y)
  elseif Big and Big.array then
    local result = Big:create(x)
    result.sign = y or result.sign or x.sign or 1
    return result
  elseif is_number(x) then
    return x * 10^(y or 0)
  else
    if ((#x>=2) and ((x[2]>=2) or (x[2]==1) and (x[1]>308))) then
      return 1e309
    end
    if (x[2]==1) then
      return math.pow(10,x[1])
    end
    return x[1]*(y or 1);
  end
end

--patch to remove animations
local cest = card_eval_status_text
function card_eval_status_text(a,b,c,d,e,f)
    if not Talisman.config_file.disable_anims then cest(a,b,c,d,e,f) end
end
local jc = juice_card
function juice_card(x)
    if not Talisman.config_file.disable_anims then jc(x) end
end
function tal_uht(config, vals)
    local col = G.C.GREEN
    if vals.chips and G.GAME.current_round.current_hand.chips ~= vals.chips then
        local delta = (is_number(vals.chips) and is_number(G.GAME.current_round.current_hand.chips)) and (vals.chips - G.GAME.current_round.current_hand.chips) or 0
        if to_big(delta) < to_big(0) then delta = number_format(delta); col = G.C.RED
        elseif to_big(delta) > to_big(0) then delta = '+'..number_format(delta)
        else delta = number_format(delta)
        end
        if type(vals.chips) == 'string' then delta = vals.chips end
        G.GAME.current_round.current_hand.chips = vals.chips
        if G.hand_text_area.chips.config.object then
          G.hand_text_area.chips:update(0)
        end
    end
    if vals.mult and G.GAME.current_round.current_hand.mult ~= vals.mult then
        local delta = (is_number(vals.mult) and is_number(G.GAME.current_round.current_hand.mult))and (vals.mult - G.GAME.current_round.current_hand.mult) or 0
        if to_big(delta) < to_big(0) then delta = number_format(delta); col = G.C.RED
        elseif to_big(delta) > to_big(0) then delta = '+'..number_format(delta)
        else delta = number_format(delta)
        end
        if type(vals.mult) == 'string' then delta = vals.mult end
        G.GAME.current_round.current_hand.mult = vals.mult
        if G.hand_text_area.mult.config.object then
          G.hand_text_area.mult:update(0)
        end
    end
    if vals.handname and G.GAME.current_round.current_hand.handname ~= vals.handname then
        G.GAME.current_round.current_hand.handname = vals.handname
    end
    if vals.chip_total then G.GAME.current_round.current_hand.chip_total = vals.chip_total;G.hand_text_area.chip_total.config.object:pulse(0.5) end
    if vals.level and G.GAME.current_round.current_hand.hand_level ~= ' '..localize('k_lvl')..tostring(vals.level) then
        if vals.level == '' then
            G.GAME.current_round.current_hand.hand_level = vals.level
        else
            G.GAME.current_round.current_hand.hand_level = ' '..localize('k_lvl')..tostring(vals.level)
            if type(vals.level) == 'number' then 
                G.hand_text_area.hand_level.config.colour = G.C.HAND_LEVELS[math.min(vals.level, 7)]
            else
                G.hand_text_area.hand_level.config.colour = G.C.HAND_LEVELS[1]
            end
        end
    end
    return true
end
local uht = update_hand_text
function update_hand_text(config, vals)
    if Talisman.config_file.disable_anims then
        if G.latest_uht then
          local chips = G.latest_uht.vals.chips
          local mult = G.latest_uht.vals.mult
          if not vals.chips then vals.chips = chips end
          if not vals.mult then vals.mult = mult end
        end
        G.latest_uht = {config = config, vals = vals}
    else uht(config, vals)
    end
end
local upd = Game.update
function Game:update(dt)
    upd(self, dt)
    if G.latest_uht and G.latest_uht.config and G.latest_uht.vals then
        tal_uht(G.latest_uht.config, G.latest_uht.vals)
        G.latest_uht = nil
    end
    if Talisman.dollar_update then
      G.HUD:get_UIE_by_ID('dollar_text_UI').config.object:update()
      G.HUD:recalculate()
      Talisman.dollar_update = false
    end
end

--wrap everything in calculating contexts so we can do more things with it
Talisman.calculating_joker = false
Talisman.calculating_score = false
Talisman.calculating_card = false
Talisman.dollar_update = false
local ccj = Card.calculate_joker
function Card:calculate_joker(context)
  Talisman.calculating_joker = true
  local ret = ccj(self, context)
  Talisman.calculating_joker = false
  return ret
end
local cuc = Card.use_consumable
function Card:use_consumable(x,y)
  Talisman.calculating_score = true
  local ret = cuc(self, x,y)
  Talisman.calculating_score = false
  return ret
end
local gfep = G.FUNCS.evaluate_play
G.FUNCS.evaluate_play = function(e)
  Talisman.calculating_score = true
  local ret = gfep(e)
  Talisman.calculating_score = false
  return ret
end
--[[local ec = eval_card
function eval_card()
  Talisman.calculating_card = true
  local ret = ec()
  Talisman.calculating_card = false
  return ret
end--]]
local sm = Card.start_materialize
function Card:start_materialize(a,b,c)
  if Talisman.config_file.disable_anims and (Talisman.calculating_joker or Talisman.calculating_score or Talisman.calculating_card) then return end
  return sm(self,a,b,c)
end
local sd = Card.start_dissolve
function Card:start_dissolve(a,b,c,d)
  if Talisman.config_file.disable_anims and (Talisman.calculating_joker or Talisman.calculating_score or Talisman.calculating_card) then self:remove() return end
  return sd(self,a,b,c,d)
end
local ss = Card.set_seal
function Card:set_seal(a,b,immediate)
  return ss(self,a,b,Talisman.config_file.disable_anims and (Talisman.calculating_joker or Talisman.calculating_score or Talisman.calculating_card) or immediate)
end

--Easing fixes
--Changed this to always work; it's less pretty but fine for held in hand things
local edo = ease_dollars
function ease_dollars(mod, instant)
  if Talisman.config_file.disable_anims then--and (Talisman.calculating_joker or Talisman.calculating_score or Talisman.calculating_card) then
    mod = mod or 0
    if mod < 0 then inc_career_stat('c_dollars_earned', mod) end
    G.GAME.dollars = G.GAME.dollars + mod
    Talisman.dollar_update = true
  else return edo(mod, instant) end
end

local su = G.start_up
function G:start_up()
  su(self)
  function STR_UNPACK(str)
    local chunk, err = loadstring(str)
    if chunk then
      setfenv(chunk, {Big = Big, BigMeta = BigMeta, OmegaMeta = OmegaMeta, to_big = to_big})  -- Use an empty environment to prevent access to potentially harmful functions
      local success, result = pcall(chunk)
      if success then
      return result
      else
      print("Error unpacking string: " .. result)
      return nil
      end
    else
      print("Error loading string: " .. err)
      return nil
    end
    end
end

--Skip round animation things
local gfer = G.FUNCS.evaluate_round
function G.FUNCS.evaluate_round()
    if Talisman.config_file.disable_anims then
      if to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) then
          add_round_eval_row({dollars = G.GAME.blind.dollars, name='blind1', pitch = 0.95})
      else
          add_round_eval_row({dollars = 0, name='blind1', pitch = 0.95, saved = true})
      end
      local arer = add_round_eval_row
      add_round_eval_row = function() return end
      local dollars = gfer()
      add_round_eval_row = arer
      add_round_eval_row({name = 'bottom', dollars = Talisman.dollars})
    else
        return gfer()
    end
end

--some debugging functions
--[[local callstep=0
function printCallerInfo()
  -- Get debug info for the caller of the function that called printCallerInfo
  local info = debug.getinfo(3, "Sl")
  callstep = callstep+1
  if info then
      print("["..callstep.."] "..(info.short_src or "???")..":"..(info.currentline or "unknown"))
  else
      print("Caller information not available")
  end
end
local emae = EventManager.add_event
function EventManager:add_event(x,y,z)
  printCallerInfo()
  return emae(self,x,y,z)
end--]]
