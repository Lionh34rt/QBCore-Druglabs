local QBCore = exports['qb-core']:GetCoreObject()

-- Code


Citizen.CreateThread(function()
    Config.CurrentLab = math.random(1, #Config.Locations["laboratories"])
    --print('Weedlab entry has been set to location: '..Config.CurrentLab)
end)

QBCore.Functions.CreateCallback('qb-weedlab:server:GetData', function(source, cb)
    local LabData = {
        CurrentLab = Config.CurrentLab
    }
    cb(LabData)
end)

QBCore.Functions.CreateUseableItem("weedkey", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    local LabKey = item.info.lab ~= nil and item.info.lab or 1

    TriggerClientEvent('qb-weedlab:client:UseLabKey', source, LabKey)
end)

function GenerateRandomWeedLab()
    local Lab = math.random(1, #Config.Locations["laboratories"])
    return Lab
end

local ItemTable = {
    "weed_brick",
    
}

RegisterServerEvent("qb-weedlab:server:getItem")
AddEventHandler("qb-weedlab:server:getItem", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = math.random(1, 3)
    Player.Functions.AddItem("weed_brick", amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_brick"], 'add')
    Citizen.Wait(500)
    local Luck = math.random(1, 10)
    local Odd = math.random(1, 10)
    if Luck == Odd then
        local random = math.random(1, 2)
        Player.Functions.AddItem("weed_brick", random)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_brick"], 'add')
    end
end)
