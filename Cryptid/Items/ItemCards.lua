
local itemcard = {
    object_type = "ConsumableType",
    key = "Itemcard",
    primary_colour = HEX("E8EB95"),
    secondary_colour = HEX("E8EB95"),
    collection_rows = {4,4,4,4}, -- 4 pages for all code cards
    loc_txt = {
        collection = "Item Cards",
        name = "Item",
        label = "Item"
    },
    shop_rate = 1,
    default = 'c_cry_greenbeer',
    can_stack = true,
    can_divide = true
}
local itemcard_atlas = {
    object_type = "Atlas",
    key = "itemcardatlas",
    path = "itemcard_atlas.png",
    px = 71,
    py = 95
}
local greenbeer = {
    object_type = "Consumable",
    set = "Itemcard",
    name = "cry-Greenbeer",
    key = "greenbeer",
    pos = {x=0,y=0},
	config = {},
    loc_txt = {
        name = 'Green Beer',
        text = {
			"+1 temporary {C:blue}hand{}",
        }
    },
    cost = 2,
    atlas = "itemcardatlas",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1
    end
}
local goldenbeer = {
    object_type = "Consumable",
    set = "Itemcard",
    name = "cry-Goldenbeer",
    key = "goldenbeer",
    pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Golden Beer',
        text = {
			"{C:gold}+5${}",
        }
    },
    cost = 2,
    atlas = "itemcardatlas",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.dollars = G.GAME.dollars + 5
    end
}
local waterbottle = {
    object_type = "Consumable",
    set = "Itemcard",
    name = "cry-Waterbottle",
    key = "waterbottle",
    pos = {x=2,y=0},
	config = {},
    loc_txt = {
        name = 'Water Bottle',
        text = {
			"+1 temporary {C:red}discard{}",
        }
    },
    cost = 2,
    atlas = "itemcardatlas",
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + 1
    end
}

local item_cards = {itemcard, itemcard_atlas, greenbeer, goldenbeer, waterbottle}
return {name = "Item Cards",
        items = item_cards}
