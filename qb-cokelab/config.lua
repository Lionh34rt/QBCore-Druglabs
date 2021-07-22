Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = Config or {}

Config.MinZOffset = 30
Config.CurrentLab = 0
Config.CooldownActive = false

Config.Locations = {
    ["laboratories"] = {
        [1] = {
            coords = {x = 806.18, y = -2380.61, z = 29.09, h = 255.5, r = 1.0},
        },
    },
    ["exit"] = {
        coords = {x = 1088.68, y = -3187.87, z = -38.99, h = 275.5, r = 1.0}, 
    },
}

Config.Tasks = {
    [1] = {
        label = "Mix Chemicals",
        completed = false,
        started = false,
        ingredients = {
            current = 3,
            needed = 4,
        },
        coords = {x = 1090.51, y = -3196.6, z = -38.99, h = 3.98, r = 1.0},
        timeremaining = 12,
        duration = 12,
        done = false,
    },
    [2] = {
        label = "Make Coke Bricks",
        completed = false,
        started = false,
        ingredients = {
            current = 3,
            needed = 4,
        },
        coords = {x = 1101.24, y = -3198.8, z = -38.99, h = 179.68, r = 1.0},
        timeremaining = 12,
        duration = 12,
        done = false,
    },
}

Config.Ingredients = {
    ["lab"] = {
        coords = {x = 1090.35, y = -3199.157, z = -38.99, h = 179.07, r = 1.0},
        taken = false,
    }
}