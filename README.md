# Description Lionh34rt#4305
Keybased lab scripts based on the original qb-moneywash and qb-methlab.
After updating my keylabs scripts I decided to upload my outdated scripts
Uses the bob74_ipl interiors (I don't know what happened to the methlab interior while making the preview, that was a first one)
Timers and ingredients needed are customizable. Obviously for the preview I made everything very short.
-> Feel free to change as much as you want to these scripts and some credits are appreciated =)

I don't plan to maintain this repository

# Installation
Create the necessary items (weed brick, coke brick, meth package, meth, and all the keys, ...) in your shared.lua
Add the resources to your FiveM server and start them.

# Shared.lua
```
--LabKeys
["methkey"]     = {["name"] = "methkey",      ["label"] = "methkey",      ["weight"] = 0,     ["type"] = "item",      ["image"] = "methkey.png",    ["unique"] = true,      ["useable"] = true,     ["shouldClose"] = false,      ["combinable"] = nil,     ["description"] = "Meth Lab Access key!"},
["weedkey"]     = {["name"] = "weedkey",      ["label"] = "weedkey",      ["weight"] = 0,     ["type"] = "item",      ["image"] = "weedkey.png",    ["unique"] = true,      ["useable"] = true,     ["shouldClose"] = false,      ["combinable"] = nil,     ["description"] = "Weed Lab Access key!"},
["mwkey"]       = {["name"] = "mwkey",        ["label"] = "mwkey",        ["weight"] = 0,     ["type"] = "item",      ["image"] = "mwkey.png",      ["unique"] = true,      ["useable"] = true,     ["shouldClose"] = false,      ["combinable"] = nil,     ["description"] = "Laundrette Access key!"},
["cokekey"]     = {["name"] = "cokekey",      ["label"] = "cokekey",      ["weight"] = 0,     ["type"] = "item",      ["image"] = "cokekey.png",    ["unique"] = true,      ["useable"] = true,     ["shouldClose"] = false,      ["combinable"] = nil,     ["description"] = "Coke Lab Access key!"},
-- drugs
['coke_brick']      = {['name'] = 'coke_brick',     ['label'] = 'Coke Brick',     ['weight'] = 2000,      ['type'] = 'item',      ['image'] = 'coke_brick.png',     ['unique'] = true,      ['useable'] = false,      ['shouldClose'] = true,     ['combinable'] = nil,     ['description'] = 'Heavy package of cocaine, mostly used for deals and takes a lot of space'},
['weed_brick']      = {['name'] = 'weed_brick',     ['label'] = 'Weed Brick',     ['weight'] = 1000,      ['type'] = 'item',      ['image'] = 'weed_brick.png',     ['unique'] = false,     ['useable'] = false,      ['shouldClose'] = true,     ['combinable'] = nil,     ['description'] = '1KG Weed Brick to sell to large customers.'},
['meth_package']    = {['name'] = 'meth_package',   ['label'] = 'Meth Package',   ['weight'] = 1000,      ['type'] = 'item',      ['image'] = 'meth_package.png',   ['unique'] = false,     ['useable'] = false,      ['shouldClose'] = true,     ['combinable'] = nil,     ['description'] = 'Large package of Meth'},
```

# Preview
https://streamable.com/ve170x

# Interested in other custom scripts for Qbus base?
Discord Invite link: https://discord.gg/AWyTUEnGeN
