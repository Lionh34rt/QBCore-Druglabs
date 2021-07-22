QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

-- Code

local washing = false
local timer = 0
local collect = false
local washer = 0

local InsideLaundrette = false
local ClosestLaundrette = 0

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function SetClosestLaundrette()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for id, laundrette in pairs(Config.Locations["laundrette"]) do
        if current ~= nil then
            if(Vdist(pos, Config.Locations["laundrette"][id].coords.x, Config.Locations["laundrette"][id].coords.y, Config.Locations["laundrette"][id].coords.z, true) < dist)then
                current = id
                dist = Vdist(pos, Config.Locations["laundrette"][id].coords.x, Config.Locations["laundrette"][id].coords.y, Config.Locations["laundrette"][id].coords.z, true)
            end
        else
            dist = Vdist(pos, Config.Locations["laundrette"][id].coords.x, Config.Locations["laundrette"][id].coords.y, Config.Locations["laundrette"][id].coords.z, true)
            current = id
        end
    end
    ClosestLaundrette = current
end

Citizen.CreateThread(function()
    Wait(500)
    QBCore.Functions.TriggerCallback('qb-laundrette:server:GetData', function(data)
        Config.CurrentLaundrette = data.CurrentLaundrette
    end)

    while true do
        SetClosestLaundrette()
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    Config.CurrentLaundrette = math.random(1, #Config.Locations["laundrette"])

    while true do
        local inRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        -- Exit distance check
        if InsideLaundrette then
            if(Vdist(pos, Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z, true) < 20)then
                inRange = true
                if(Vdist(pos, Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z, true) < 1)then
                    DrawText3Ds(Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z, '~g~E~w~ - Leave Laundrette')
                    if IsControlJustPressed(0, Keys["E"]) then
                        ExitLaundrette()
                    end
                end
            end
        end
        if not inRange then
            Citizen.Wait(1000)
        end
        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function(amt)
	while true do 
		Citizen.Wait(5000)
        while InsideLaundrette do
            Citizen.Wait(1)
            local inRange = false
            local pos = GetEntityCoords(PlayerPedId())
            local ped = PlayerPedId()

            DrawMarker(markerConfig.markerType, washLocations.pOne.x, washLocations.pOne.y, washLocations.pOne.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.5, 0.15, 255, 55, 15, 255, false, false, false, true, false, false, false)

            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, washLocations.pOne.x, washLocations.pOne.y, washLocations.pOne.z, true) < 0.5 then
                inRange = true
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, washLocations.pOne.x, washLocations.pOne.y, washLocations.pOne.z, true) < 0.5 then      
                    if not washing and not collect then      
                        DrawText3Ds(washLocations.pOne.x, washLocations.pOne.y, washLocations.pOne.z, "~g~E~w~ - Start Washer")
                            if IsControlJustReleased(1, Keys['E']) then
                                WashAnimation()
                                QBCore.Functions.Progressbar("bills_wash", "putting inked bills into the washer...", math.random(5000, 10000), false, true, {
                                    disableMovement = true,
                                    disableCarMovement = false,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                animDict = "mp_car_bomb",
                                anim = "car_bomb_mechanic",
                                flags = 16,
                            }, {}, {}, function() -- Done
                                TriggerServerEvent('qb-laundrette:server:checkInv', amt)
                                    StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                    washer = 1

                        
                                end, function()
                                    QBCore.Functions.Notify("Cancelled..", "error")
                                end)                        
                            end
                            
                        end
                end
            end

            DrawMarker(markerConfig.markerType, washLocations.pTwo.x, washLocations.pTwo.y, washLocations.pTwo.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.5, 0.15, 255, 55, 15, 255, false, false, false, true, false, false, false)

            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, washLocations.pTwo.x, washLocations.pTwo.y, washLocations.pTwo.z, true) < 0.5 then
                inRange = true
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, washLocations.pTwo.x, washLocations.pTwo.y, washLocations.pTwo.z, true) < 0.5 then      
                    if not washing and not collect then      
                        DrawText3Ds(washLocations.pTwo.x, washLocations.pTwo.y, washLocations.pTwo.z, "~g~E~w~ - Start Washer")
                            if IsControlJustReleased(1, Keys['E']) then
                                WashAnimation()
                                QBCore.Functions.Progressbar("bills_wash", "putting inked bills into the washer...", math.random(5000, 10000), false, true, {
                                    disableMovement = true,
                                    disableCarMovement = false,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                animDict = "mp_car_bomb",
                                anim = "car_bomb_mechanic",
                                flags = 16,
                            }, {}, {}, function() -- Done
                                TriggerServerEvent('qb-laundrette:server:checkInv', amt)
                                    StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                    washer = 2

                        
                                end, function()
                                    QBCore.Functions.Notify("Canceled..", "error")
                                end)                        
                            end
                            
                        end
                end
            end

            DrawMarker(markerConfig.markerType, washLocations.pThree.x, washLocations.pThree.y, washLocations.pThree.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.5, 0.15, 255, 55, 15, 255, false, false, false, true, false, false, false)

            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, washLocations.pThree.x, washLocations.pThree.y, washLocations.pThree.z, true) < 0.5 then
                inRange = true
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, washLocations.pThree.x, washLocations.pThree.y, washLocations.pThree.z, true) < 0.5 then      
                    if not washing and not collect then      
                        DrawText3Ds(washLocations.pThree.x, washLocations.pThree.y, washLocations.pThree.z, "~g~E~w~ - Start Washer")
                            if IsControlJustReleased(1, Keys['E']) then
                                WashAnimation()
                                QBCore.Functions.Progressbar("bills_wash", "putting inked bills into the washer...", math.random(5000, 10000), false, true, {
                                    disableMovement = true,
                                    disableCarMovement = false,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                animDict = "mp_car_bomb",
                                anim = "car_bomb_mechanic",
                                flags = 16,
                                }, {}, {}, function() -- Done
                                    TriggerServerEvent('qb-laundrette:server:checkInv', amt)
                                    StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                    washer = 3

                        
                                end, function()
                                    QBCore.Functions.Notify("Cancelled..", "error")
                                end)                        
                            end
                            
                        end     
                end
            end	
    
            
            DrawMarker(markerConfig.markerType, washLocations.pFour.x, washLocations.pFour.y, washLocations.pFour.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.5, 0.15, 255, 55, 15, 255, false, false, false, true, false, false, false)

            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, washLocations.pFour.x, washLocations.pFour.y, washLocations.pFour.z, true) < 0.5 then
                inRange = true
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, washLocations.pFour.x, washLocations.pFour.y, washLocations.pFour.z, true) < 0.5 then      
                    if not washing and not collect then      
                        DrawText3Ds(washLocations.pFour.x, washLocations.pFour.y, washLocations.pFour.z, "~g~E~w~ - Start Washer")
                            if IsControlJustReleased(1, Keys['E']) then
                                WashAnimation()
                                QBCore.Functions.Progressbar("bills_wash", "putting inked bills into the washer...", math.random(5000, 10000), false, true, {
                                    disableMovement = true,
                                    disableCarMovement = false,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                animDict = "mp_car_bomb",
                                anim = "car_bomb_mechanic",
                                flags = 16,
                                }, {}, {}, function() -- Done
                                    TriggerServerEvent('qb-laundrette:server:checkInv', amt)
                                    StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                    washer = 4    
                                end, function()
                                    QBCore.Functions.Notify("Cancelled..", "error")
                                end)                        
                            end
                    end
                end
            end
        end
    end 
end)

RegisterNetEvent('qb-laundrette:client:washTimer')
AddEventHandler('qb-laundrette:client:washTimer', function()
        Citizen.Wait(0)
        local pos = GetEntityCoords(PlayerPedId())
        local ped = PlayerPedId()
        local inRange = false

        while washing do
            if washer == 1 then
                washCoordX = washLocations.pOne.x
                washCoordY = washLocations.pOne.y
                washCoordZ = washLocations.pOne.z
            elseif washer == 2 then
                washCoordX = washLocations.pTwo.x
                washCoordY = washLocations.pTwo.y
                washCoordZ = washLocations.pTwo.z
            elseif washer == 3 then
                washCoordX = washLocations.pThree.x
                washCoordY = washLocations.pThree.y
                washCoordZ = washLocations.pThree.z
            elseif washer == 4 then
                washCoordX = washLocations.pFour.x
                washCoordY = washLocations.pFour.y
                washCoordZ = washLocations.pFour.z
            end
            Citizen.Wait(0)
            DrawText3Ds(washCoordX, washCoordY, washCoordZ, "Time left on washer: " .. timer .. ' seconds.')               
        end
end)

function collectMoney(amt)

    Citizen.CreateThread(function()

    while collect do
        if washer == 1 then
            collectCoordX = washLocations.pOne.x
            collectCoordY = washLocations.pOne.y
            collectCoordZ = washLocations.pOne.z
        elseif washer == 2 then
            collectCoordX = washLocations.pTwo.x
            collectCoordY = washLocations.pTwo.y
            collectCoordZ = washLocations.pTwo.z
        elseif washer == 3 then
            collectCoordX = washLocations.pThree.x
            collectCoordY = washLocations.pThree.y
            collectCoordZ = washLocations.pThree.z
        elseif washer == 4 then
            collectCoordX = washLocations.pFour.x
            collectCoordY = washLocations.pFour.y
            collectCoordZ = washLocations.pFour.z
        end

        local inRange = false
        local pos = GetEntityCoords(PlayerPedId())
        local ped = PlayerPedId()
    
        Citizen.Wait(0)
        DrawText3Ds(collectCoordX, collectCoordY, collectCoordZ, "~g~E~w~ - Collect Clean Money")

        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, collectCoordX,collectCoordY, collectCoordZ, true) < 0.5 then
            inRange = true
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, collectCoordX,collectCoordY, collectCoordZ, true) < 0.5 then      
                        if IsControlJustReleased(1, Keys['E']) and inRange then
                            WashAnimation()
                            QBCore.Functions.Progressbar("bills_collect", "collecting clean bills from washer...", math.random(10000, 60000), false, true, {
                                disableMovement = true,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                            animDict = "mp_car_bomb",
                            anim = "car_bomb_mechanic",
                            flags = 16,
                            }, {}, {}, function() -- Done
                                TriggerServerEvent('qb-laundrette:server:giveMoney', amt)
                                TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                collect = false                        
                            end, function()
                                QBCore.Functions.Notify("Cancelled..", "error")
                            end) 

                    end                   
                end
            end            
        end
    end)
end

RegisterNetEvent('qb-laundrette:client:startTimer')
AddEventHandler('qb-laundrette:client:startTimer', function(amt)

    washing = true
    timer = math.ceil(0.005 * amt)
    if timer <= 60 then
        timer = 3
    end
    TriggerEvent('qb-laundrette:client:washTimer')

        while washing do
            timer = timer - 1
            if timer <= 0 then
                washing = false
                collect = true
                QBCore.Functions.Notify('Your clean bills are ready to be collected.', 'success', 50000)

                collectMoney(amt)
            end
            Citizen.Wait(1000)
        end
end)

RegisterNetEvent('qb-laundrette:client:UseLaundretteKey')
AddEventHandler('qb-laundrette:client:UseLaundretteKey', function(mwkey)
    if ClosestLaundrette == Config.CurrentLaundrette then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        local dist = Vdist(pos, Config.Locations["laundrette"][ClosestLaundrette].coords.x, Config.Locations["laundrette"][ClosestLaundrette].coords.y, Config.Locations["laundrette"][ClosestLaundrette].coords.z, true)
        if dist < 1 then
            if mwkey == ClosestLaundrette then
                EnterLaundrette()
            else
                QBCore.Functions.Notify('This isn\'t the right key..', 'error')
            end
        end
    end
end)

function EnterLaundrette()
    local ped = PlayerPedId()

    OpenDoorAnimation()
    InsideLaundrette = true
    Citizen.Wait(500)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    SetEntityCoords(ped, Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z - 0.98)
    SetEntityHeading(ped, Config.Locations["exit"].coords.h)
    Citizen.Wait(1000)
    DoScreenFadeIn(250)
end

function ExitLaundrette()
    local ped = PlayerPedId()
    local dict = "mp_heists@keypad@"
    local anim = "idle_a"
    local flag = 0
    local keypad = {
        coords = {x = 895.96, y = -3245.798, z = -98.24, h = 265.75, r = 1.0},
    }
    OpenDoorAnimation()
    Citizen.Wait(500)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    SetEntityCoords(ped, Config.Locations["laundrette"][Config.CurrentLaundrette].coords.x, Config.Locations["laundrette"][Config.CurrentLaundrette].coords.y, Config.Locations["laundrette"][Config.CurrentLaundrette].coords.z - 0.98)
    SetEntityHeading(ped, Config.Locations["laundrette"][Config.CurrentLaundrette].coords.h)
    InsideLaundrette = false
    Citizen.Wait(1000)
    DoScreenFadeIn(250)
end

function LoadAnimationDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function OpenDoorAnimation()
    local ped = PlayerPedId()
    LoadAnimationDict("anim@heists@keycard@") 
    TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    Citizen.Wait(400)
    ClearPedTasks(ped)
end

function noSpace(str)
    local normalisedString = string.gsub(str, "%s+", "")
    return normalisedString
end

function WashAnimation()
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    Citizen.CreateThread(function()
        while washing do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
        end
    end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Barley.MaleNoHandshoes[armIndex] ~= nil and Barley.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Barley.FemaleNoHandshoes[armIndex] ~= nil and Barley.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

