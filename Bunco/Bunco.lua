--- STEAMODDED HEADER
--- MOD_NAME: Bunco
--- MOD_ID: Bunco
--- MOD_AUTHOR: [Firch, RENREN, Peas, minichibis, J.D., Guwahavel, Ciirulean, ejwu]
--- MOD_DESCRIPTION: Mod aiming for vanilla style, a lot of new Jokers, Blinds, other stuff and Exotic Suits system!
--- VERSION: 5.0

-- ToDo:
-- (done) Fix Crop Circles always showing Fleurons
-- (done) Check how to add custom entries to the localization (for card messages like linocut's one)
-- (done) Cassette proper coordinates
-- (done) Polychrome desc on roy g biv
-- (?) Debuff registration plate level with shader if possible
-- (done) Nan morgan or make zero shapiro count letter rank cards
-- Unlocks
-- Check whats up with joker knight
-- (done) Add purist config
-- (skip: waiting for steamodded) Card sizes
-- (done) Magenta dagger wobble?
-- (?) Disable Bierdeckel upgrade message on win
-- (done) Global variable for glitter
-- (done) Config for double lovers
-- Fix suit colors
-- (done) Talisman support
-- (done) Make tags use global values of editions (+ loc vars for it)
-- (1/2) Make editioned consumables and replace their info_queue (to check: common events.lua)
-- (done) Fix bulwark stray pixels
-- (done) Add config to the consumable editions
-- (done) Remove debuff when fluorescent edition is applied to a debuffed card
-- (done) Make tarot badges use localization
-- (done) Pawn and linocut fake suit and rank
-- (done) Check eternal food compat
-- Reset metallurgist-like bonuses when you lose
-- (done) Fix the mask giving spectrum hands when they're invisible
-- Make so enhancement-related Jokers do not appear unless player has respective enhancements

global_bunco = global_bunco or {loc = {}, vars = {}}
local bunco = SMODS.current_mod
local filesystem = NFS or love.filesystem

local loc = filesystem.load(bunco.path..'localization.lua')()

-- Editions

SMODS.Shader({key = 'glitter', path = 'glitter.fs'})
SMODS.Sound({key = 'glitter', path = 'glitter.ogg'})

SMODS.Edition{
    key = 'glitter', loc_txt = loc.glitter_edition,

    config = {Xchips = 1.3},
    loc_vars = function(self, info_queue)
        return {vars = {self.config.Xchips}}
    end,

    sound = {sound = 'bunc_glitter', per = 1.2, vol = 0.4},
    in_shop = true,
    weight = 9,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,

    shader = 'glitter'
}

SMODS.Shader({key = 'balavirussquare', path = 'balavirussquare.fs'})
SMODS.Sound({key = 'balavirussquare', path = 'glitter.ogg'})

SMODS.Edition{
    key = 'balavirussquare', loc_txt = loc.balavirussquare_edition,

    sound = {sound = 'bunc_balavirussquare', per = 1.2, vol = 0.4},
    in_shop = false,
    weight = 0,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,

    shader = 'balavirussquare'
}

SMODS.Shader({key = 'fluorescent', path = 'fluorescent.fs'})
SMODS.Sound({key = 'fluorescent', path = 'fluorescent.ogg'})

SMODS.Edition{
    key = 'fluorescent', loc_txt = loc.fluorescent_edition,

    sound = {sound = 'bunc_fluorescent', per = 1.2, vol = 0.4},
    in_shop = true,
    weight = 18,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,

    shader = 'fluorescent'
}

SMODS.Shader({key = 'shinygalvanized', path = 'shinygalvanized.fs'})
SMODS.Sound({key = 'shinygalvanized', path = 'fluorescent.ogg'})

SMODS.Edition{
    key = 'shinygalvanized', loc_txt = loc.shinygalvanized_edition,

    sound = {sound = 'bunc_shinygalvanized', per = 1.2, vol = 0.4},
    in_shop = false,
    weight = 0,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,

    shader = 'shinygalvanized'
}

SMODS.Shader({key = 'burnt', path = 'burnt.fs'})
SMODS.Sound({key = 'burnt', path = 'fluorescent.ogg'})

SMODS.Edition{
    key = 'burnt', loc_txt = loc.burnt_edition,

    sound = {sound = 'bunc_burnt', per = 1.2, vol = 0.4},
    in_shop = true,
    weight = 8,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,

    shader = 'burnt'
}