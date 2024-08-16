return {
    dictionary = {
        ['en-us'] = {
            copied = 'Copied!',
            nothing = 'Nothing',
            chips = 'Chips',
            loop = 'Loop!',
            chance = 'Chance',
            word_and = 'and',
            debuffed = 'Debuffed!',
            pew = 'Pew!',
            mysterious_tarot = 'Tarot?',
            most_played_rank = '(most played rank)',
            least_played_hand = '(least played hand)',
            blade = '(1.5X blind score)',
            exceeded_score = 'Exceeded the limit!',
            temporary_extra_chips = {['text'] = {[1] = '{C:chips}+#1#{} extra chips this round'}}
        },
        ['fr'] = {
            nothing = 'Rien'
        }
    },

    -- Editions

    glitter_edition = {
        ['en-us'] = {
            ['name'] = 'Glitter',
            ['label'] = 'Glitter',
            ['text'] = {
                [1] = '{X:chips,C:white}X#1#{} Chips'
            }
        }
    },
    fluorescent_edition = {
        ['en-us'] = {
            ['name'] = 'Fluorescent',
            ['label'] = 'Fluorescent',
            ['text'] = {
                [1] = 'Cannot be flipped, debuffed',
                [2] = 'or forced to be selected'
            }
        }
    },
    balavirussquare_edition = {
        ['en-us'] = {
            ['name'] = 'Balavirus [Square]',
            ['label'] = 'Balavirus [Square]',
            ['text'] = {
                [1] = 'Better than Balavirus',
            }
        }
    },
    shinygalvanized_edition = {
        ['en-us'] = {
            ['name'] = 'Galvanized (Shiny)',
            ['label'] = 'Galvanized (Shiny)',
            ['text'] = {
                [1] = '{C:blue}+100 000{} chips, {X:red,C:white}X9{} mult',
            }
        }
    },
    burnt_edition = {
        ['en-us'] = {
            ['name'] = 'Burnt',
            ['label'] = 'Burnt',
            ['text'] = {
                [1] = '{X:blue,C:white}X0.5{} chips, {X:red,C:white}X2{} mult',
            }
        }
    }
}