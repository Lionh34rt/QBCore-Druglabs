QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

-- Code

local InsideCokelab = false
local ClosestCokelab = 0
local CurrentTask = 1
local CarryPackage = nil

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

function SetClosestCokelab()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for id, cokelab in pairs(Config.Locations["laboratories"]) do
        if current ~= nil then
            if(Vdist(pos, Config.Locations["laboratories"][id].coords.x, Config.Locations["laboratories"][id].coords.y, Config.Locations["laboratories"][id].coords.z, true) < dist)then
                current = id
                dist = Vdist(pos, Config.Locations["laboratories"][id].coords.x, Config.Locations["laboratories"][id].coords.y, Config.Locations["laboratories"][id].coords.z, true)
            end
        else
            dist = Vdist(pos, Config.Locations["laboratories"][id].coords.x, Config.Locations["laboratories"][id].coords.y, Config.Locations["laboratories"][id].coords.z, true)
            current = id
        end
    end
    ClosestCokelab = current
end

Citizen.CreateThread(function()
    Wait(500)
    QBCore.Functions.TriggerCallback('qb-cokelab:server:GetData', function(data)
        Config.CurrentLab = data.CurrentLab
    end)

    CurrentTask = GetCurrentTask()

    --print('Current Task: '..CurrentTask)

    while true do
        SetClosestCokelab()
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    Config.CurrentLab = math.random(1, #Config.Locations["laboratories"])

    while true do
        local inRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        -- Exit distance check
        if InsideCokelab then
            if(Vdist(pos, Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z, true) < 20)then
                inRange = true
                if(Vdist(pos, Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z, true) < 1)then
                    DrawText3Ds(Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z, '~g~E~w~ - Leave Cokelab')
                    if IsControlJustPressed(0, Keys["E"]) then
                        ExitCokelab()
                        TriggerServerEvent("qb-log:server:CreateLog", "keylabs", "Exit Coke lab", "white", "**"..GetPlayerName(PlayerId()).."** has exited the cokelab.")
                    end
                end
            end
        end

        if InsideCokelab then
            if InsideCokelab then
                if CurrentTask < 3 then
                    if Config.Tasks[CurrentTask].ingredients.current < Config.Tasks[CurrentTask].ingredients.needed then
                        if not Config.Ingredients["lab"].taken or CarryPackage ~= nil then
                            if(Vdist(pos, Config.Ingredients["lab"].coords.x, Config.Ingredients["lab"].coords.y, Config.Ingredients["lab"].coords.z, true) < 20)then
                                inRange = true
                                DrawMarker(2, Config.Ingredients["lab"].coords.x, Config.Ingredients["lab"].coords.y, Config.Ingredients["lab"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 222, 11, 11, 155, false, false, false, true, false, false, false)
                                if(Vdist(pos, Config.Ingredients["lab"].coords.x, Config.Ingredients["lab"].coords.y, Config.Ingredients["lab"].coords.z, true) < 1)then
                                    if CarryPackage == nil then
                                        DrawText3Ds(Config.Ingredients["lab"].coords.x, Config.Ingredients["lab"].coords.y, Config.Ingredients["lab"].coords.z, '~g~E~w~ - Grab ingredients')
                                        if IsControlJustPressed(0, Keys["E"]) then
                                            TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
                                            QBCore.Functions.Progressbar("pickup_reycle_package", "Grabbing ingredients..", 5000, false, true, {}, {}, {}, {}, function() -- Done
                                                ClearPedTasks(PlayerPedId())
                                                TakeIngredients()
												
                                            end)
                                        end
                                    else
                                        DrawText3Ds(Config.Ingredients["lab"].coords.x, Config.Ingredients["lab"].coords.y, Config.Ingredients["lab"].coords.z, '~g~E~w~ - Put away ingredients')
                                        if IsControlJustPressed(0, Keys["E"]) then
                                            DropIngredients()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if InsideCokelab then
                if CurrentTask ~= 0 then
                    if(Vdist(pos, Config.Tasks[CurrentTask].coords.x, Config.Tasks[CurrentTask].coords.y, Config.Tasks[CurrentTask].coords.z, true) < 20)then
                        inRange = true
                        DrawMarker(2, Config.Tasks[CurrentTask].coords.x,  Config.Tasks[CurrentTask].coords.y,  Config.Tasks[CurrentTask].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 222, 11, 11, 155, false, false, false, true, false, false, false)
                        if(Vdist(pos, Config.Tasks[CurrentTask].coords.x, Config.Tasks[CurrentTask].coords.y, Config.Tasks[CurrentTask].coords.z, true) < 1)then
                            DrawText3Ds(Config.Tasks[CurrentTask].coords.x, Config.Tasks[CurrentTask].coords.y, Config.Tasks[CurrentTask].coords.z, Config.Tasks[CurrentTask].label)
                            DrawText3Ds(Config.Tasks[CurrentTask].coords.x, Config.Tasks[CurrentTask].coords.y, Config.Tasks[CurrentTask].coords.z - 0.2, Config.Tasks[CurrentTask].ingredients.current..'/'..Config.Tasks[CurrentTask].ingredients.needed..' Ingredients')
                            if Config.Tasks[CurrentTask].ingredients.current == Config.Tasks[CurrentTask].ingredients.needed then
                                if not Config.Tasks[CurrentTask].started then
                                    if not Config.Tasks[CurrentTask].done then
                                        DrawText3Ds(Config.Tasks[CurrentTask].coords.x, Config.Tasks[CurrentTask].coords.y, Config.Tasks[CurrentTask].coords.z - 0.4, '[E] Start Process')
                                        if IsControlJustPressed(0, Keys["E"]) then
                                            StartMachine(CurrentTask)
                                            TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
                                            QBCore.Functions.Progressbar("fullcut_cycle_v6_cokecutter", "Processing..", 12000, false, true, {}, {}, {}, {}, function() -- Done
                                                ClearPedTasks(PlayerPedId())
                                            end)
                                        end
                                    else -- alle ingredienten zitten erin
                                        if CurrentTask == 2 then
                                        DrawText3Ds(Config.Tasks[CurrentTask].coords.x, Config.Tasks[CurrentTask].coords.y, Config.Tasks[CurrentTask].coords.z - 0.4, '[E] Grab Coke Bricks')
                                            if IsControlJustPressed(0, Keys["E"]) then
                                                TriggerServerEvent('qb-cokelab:server:getItem')
                                                FinishMachine(CurrentTask)	
                                            end
                                        else
                                            FinishMachine(CurrentTask)	
                                        end
                                    end
                                else
                                    DrawText3Ds(Config.Tasks[CurrentTask].coords.x, Config.Tasks[CurrentTask].coords.y, Config.Tasks[CurrentTask].coords.z - 0.4, 'Done in '..Config.Tasks[CurrentTask].timeremaining..'s')
                                end
                            else
                                if CurrentTask < 3 then
                                    if CarryPackage ~= nil then
                                        if Config.Tasks[CurrentTask].ingredients.current < Config.Tasks[CurrentTask].ingredients.needed then
                                            DrawText3Ds(Config.Tasks[CurrentTask].coords.x, Config.Tasks[CurrentTask].coords.y, Config.Tasks[CurrentTask].coords.z + 0.2, '[E] Place ingredients')
                                            if IsControlJustPressed(0, Keys["E"]) then
                                                DropIngredients()
                                                Config.Tasks[CurrentTask].ingredients.current = Config.Tasks[CurrentTask].ingredients.current + 1
                                            end
                                        end
                                    end
                                end
                            end
                        end
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

function StartMachine(k)
    Citizen.CreateThread(function()
        Config.Tasks[k].started = true
        -- emote

        while Config.Tasks[k].timeremaining > 0 do
            Config.Tasks[k].timeremaining = Config.Tasks[k].timeremaining - 1
            Citizen.Wait(1000)
        end
        -- stop emote

        Config.Tasks[k].started = false
        Config.Tasks[k].done = true
    end)
end

function FinishMachine(k)
    Config.Tasks[k].done = false
    Config.Tasks[k].timeremaining = Config.Tasks[k].duration
    Config.Tasks[k].ingredients.current = 0
    QBCore.Functions.Notify('Step Complete.', 'success')

    if CurrentTask == #Config.Tasks then
        --print('Current task: '..CurrentTask)
        --print('next task')
        if CurrentTask == 2 then
            CurrentTask = 1
            --print('Current task: '..CurrentTask)
        else
            CurrentTask = CurrentTask + 1
            --print('Current task: '..CurrentTask)
        end
        Config.CooldownActive = false
    else
        --print('Current task: '..CurrentTask)
        --print('next task')
        if CurrentTask == 2 then
            CurrentTask = 1
            --print('Current task: '..CurrentTask)
        else
            CurrentTask = CurrentTask + 1
            --print('Current task: '..CurrentTask)
        end
    end
end

RegisterNetEvent('qb-cokelab:client:UseLabKey')
AddEventHandler('qb-cokelab:client:UseLabKey', function(cokekey)
    if ClosestCokelab == Config.CurrentLab then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        local dist = Vdist(pos, Config.Locations["laboratories"][ClosestCokelab].coords.x, Config.Locations["laboratories"][ClosestCokelab].coords.y, Config.Locations["laboratories"][ClosestCokelab].coords.z, true)
        if dist < 1 then
            if cokekey == ClosestCokelab then
                EnterCokelab()
                TriggerServerEvent("qb-log:server:CreateLog", "keylabs", "Enter Coke lab", "white", "**"..GetPlayerName(PlayerId()).."** has entered the cokelab.")
            else
                QBCore.Functions.Notify('This isn\'t the right key..', 'error')
            end
        end
    end
end)

function EnterCokelab()
    local ped = PlayerPedId()

    OpenDoorAnimation()
    InsideCokelab = true
    Citizen.Wait(500)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    SetEntityCoords(ped, Config.Locations["exit"].coords.x, Config.Locations["exit"].coords.y, Config.Locations["exit"].coords.z - 0.98)
    SetEntityHeading(ped, Config.Locations["exit"].coords.h)
    Citizen.Wait(1000)
    DoScreenFadeIn(250)
end

function ExitCokelab()
    local ped = PlayerPedId()
    local dict = "mp_heists@keypad@"
    local anim = "idle_a"
    local flag = 0
    local keypad = {
        coords = {x = 1088.72, y = -3187.84, z = -38.99, h = 359.8, r = 1.0}, 
    }

    CurrentTask = GetCurrentTask()

    OpenDoorAnimation()
    Citizen.Wait(500)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    SetEntityCoords(ped, Config.Locations["laboratories"][Config.CurrentLab].coords.x, Config.Locations["laboratories"][Config.CurrentLab].coords.y, Config.Locations["laboratories"][Config.CurrentLab].coords.z - 0.98)
    SetEntityHeading(ped, Config.Locations["laboratories"][Config.CurrentLab].coords.h)
    InsideCokelab = false
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

function GetCurrentTask()
    local currenttask = nil
    for k, v in pairs(Config.Tasks) do
        if not v.completed then
            currenttask = k
            break
        end
    end
    return CurrentTask
end

function TakeIngredients()
    local pos = GetEntityCoords(PlayerPedId(), true)
    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
        Citizen.Wait(7)
    end
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("prop_cs_cardbox_01")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)
    CarryPackage = object
end

function DropIngredients()
    ClearPedTasks(PlayerPedId())
    DetachEntity(CarryPackage, true, true)
    DeleteObject(CarryPackage)
    CarryPackage = nil
end