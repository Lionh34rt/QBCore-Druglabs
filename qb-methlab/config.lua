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
            coords = {x = 926.59, y = -1560.26, z = 30.74, h = 94.5, r = 1.0},
        },
    },
    ["exit"] = {
        coords = {x = 997.01, y = -3200.65, z = -36.4, h = 275.5, r = 1.0}, 
    },
}

Config.Tasks = {
    [1] = {
        label = "Nube Furnace",
        completed = false,
        started = false,
        ingredients = {
            current = 3,
            needed = 4,
        },
        coords = {x = 1002.92, y = -3200.0, z = -39.0, h = 124.5, r = 1.0},
        timeremaining = 12,
        duration = 12,
        done = false,
    },
    [2] = {
        label = "Thermoskite",
        completed = false,
        started = false,
        ingredients = {
            current = 3,
            needed = 4,
        },
        coords = {x = 1010.78, y = -3196.7, z = -38.9, h = 181.9, r = 1.0},
        timeremaining = 12,
        duration = 12,
        done = false,
    },
}

Config.Ingredients = {
    ["lab"] = {
        coords = {x = 998.11, y = -3200.27, z = -39.0, h = 85.5, r = 1.0},
        taken = false,
    }
}