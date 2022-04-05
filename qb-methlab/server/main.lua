local QBCore = exports['qb-core']:GetCoreObject()

-- Code


Citizen.CreateThread(function()
    Config.CurrentLab = math.random(1, #Config.Locations["laboratories"])
end)

QBCore.Functions.CreateCallback('qb-methlab:server:GetData', function(source, cb)
    local LabData = {
        CurrentLab = Config.CurrentLab
    }
    cb(LabData)
end)

QBCore.Functions.CreateUseableItem("methkey", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    local LabKey = item.info.lab ~= nil and item.info.lab or 1

    TriggerClientEvent('qb-methlab:client:UseLabKey', source, LabKey)
end)

function GenerateRandomMethLab()
    local Lab = math.random(1, #Config.Locations["laboratories"])
    return Lab
end

local ItemTable = {
    "meth_package",
    
}

RegisterServerEvent("qb-methlab:server:getItem")
AddEventHandler("qb-methlab:server:getItem", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = math.random(1, 3)
    Player.Functions.AddItem("meth_package", amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["meth_package"], 'add')
    Citizen.Wait(500)
    local Luck = math.random(1, 10)
    local Odd = math.random(1, 10)
    if Luck == Odd then
        local random = math.random(1, 2)
        Player.Functions.AddItem("meth_package", random)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["meth_package"], 'add')
    end
end)
