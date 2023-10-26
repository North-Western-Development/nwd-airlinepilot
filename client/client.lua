local job = ''
local near = {}
local currentFlight = nil
local blips = nil
local selectedPlane = nil
local inFlight = false

Citizen.CreateThread(function()
    AddTextEntry("clock_in", "Press ~INPUT_PICKUP~ to begin work")
    AddTextEntry("pull_closer", "Pull closer to park")
    AddTextEntry("stop_to_park", "Come to a stop to park")
    AddTextEntry("park", "Press ~INPUT_PICKUP~ to park")
    while true do
        Citizen.Wait(500)
        local PlayerData = Generic.Client.Framework.GetPlayerData()
        if PlayerData ~= nil and PlayerData.job ~= nil then
            if Config.UseJobTypeInstead and Config.Framework.Type == "QBCore" then
                job = PlayerData.job.type
            else
                job = PlayerData.job.name
            end
        end
    end
end)

local function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
    local nearbyEntities = {}
    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        local playerPed = PlayerPedId()
        coords = GetEntityCoords(playerPed)
    end
    for k, entity in pairs(entities) do
        local distance = #(coords - GetEntityCoords(entity))
        if distance <= maxDistance then
            nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
        end
    end
    return nearbyEntities
end

local function GetVehiclesInArea(coords, maxDistance) -- Vehicle inspection in designated area
    return EnumerateEntitiesWithinDistance(GetGamePool('CVehicle'), false, coords, maxDistance)
end

local function IsSpawnPointClear(coords, maxDistance) -- Check the spawn point to see if it's empty or not:
    return #GetVehiclesInArea(coords, maxDistance) == 0
end

Citizen.CreateThread(function()
    while true do
        local sleep = 3000
        near = nil
        if (job == Config.JobType and Config.UseJobTypeInstead) or
            (job == Config.JobName and not Config.UseJobTypeInstead) then
            local playerCoords = GetEntityCoords(PlayerPedId())
            sleep = 500
            if blips == nil then
                blips = {}
            end
            for k, _ in pairs(Config.Locations.WorkCheckIns) do
                if k ~= 'perico' or Config.EnablePerico then
                    if blips[k] == nil then
                        blips[k] = {}
                    end
                    for l, t in pairs(Config.Locations.WorkCheckIns[k]) do
                        if blips[k][l] == nil then
                            blips[k][l] = AddBlipForCoord(t.x, t.y, t.z)
                            SetBlipSprite(blips[k][l], 90)
                            SetBlipDisplay(blips[k][l], 2)
                            SetBlipScale(blips[k][l], 1.0)
                            SetBlipColour(blips[k][l], 32)
                            SetBlipAsShortRange(blips[k][l], true)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString("Airport Pilot Check-in")
                            EndTextCommandSetBlipName(blips[k][l])
                        end
                        if GetDistanceBetweenCoords(playerCoords, t, true) <= 1.2 and Config.PressE then
                            near = {
                                name = k,
                                location = t
                            }
                            DisplayHelpTextThisFrame("clock_in", false)
                            if IsControlJustPressed(0, 38) then
                                if Config.Framework.Type == "QBCore" then
                                    exports['qb-menu']:openMenu({{
                                        header = "Job Menu",
                                        isMenuHeader = true
                                    }, {
                                        header = "Start Flight",
                                        txt = "Start a money earning flight",
                                        params = {
                                            event = "nwd-airlinepilot:client:startFlight",
                                            args = {
                                                name = near.name
                                            }
                                        }
                                    }})
                                else
                                    Generic.Client.Framework.OpenMenu('default', GetCurrentResourceName(), "Job Menu", {
                                        {
                                            label = "Start Flight",
                                            name = "Start"
                                        },
                                        {
                                            label = "Cancel",
                                            name = "Cancel"
                                        }
                                    }, function(data, menu)
                                        if data.current.name == "Start" then
                                            TriggerEvent("nwd-airlinepilot:client:startFlight", {name = near.name})
                                            menu.close()
                                        end

                                        if data.current.name == "Cancel" then
                                            menu.close()
                                        end
                                    end, function(data, menu)
                                        menu.close()
                                    end)
                                end
                            end
                            sleep = 1
                        elseif GetDistanceBetweenCoords(playerCoords, t, true) <= 1.2 then
                            near = {
                                name = k,
                                location = t
                            }
                        end
                    end
                end
            end
        elseif blips ~= nil then
            for _, v in pairs(blips) do
                for _, k in ipairs(blips[v]) do
                    RemoveBlip(k)
                end
            end
            blips = {}
        end
        Citizen.Wait(sleep)
    end
end)

AddEventHandler("nwd-airlinepilot:client:clockInMenu", function()
    if Config.Framework.Type == "QBCore" then
        exports['qb-menu']:openMenu({{
            header = "Job Menu",
            isMenuHeader = true
        }, {
            header = "Start Flight",
            txt = "Start a money earning flight",
            params = {
                event = "nwd-airlinepilot:client:startFlight",
                args = {
                    name = near.name
                }
            }
        }})
    else
        Generic.Client.Framework.OpenMenu('default', GetCurrentResourceName(), "Job Menu", {
            {
                label = "Start Flight",
                name = "Start"
            },
            {
                label = "Cancel",
                name = "Cancel"
            }
        }, function(data, menu)
            if data.current.name == "Start" then
                TriggerEvent("nwd-airlinepilot:client:startFlight", {name = near.name})
                menu.close()
            end

            if data.current.name == "Cancel" then
                menu.close()
            end
        end, function(data, menu)
            menu.close()
        end)
    end
end)

RegisterCommand("-airlinepilotjob", function()
end)

local function removeFirst(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then
            return table.remove(tbl, i)
        end
    end
end

RegisterNetEvent("nwd-airlinepilot:client:startFlight", function(data)
    local SpawnPoint = nil
    local gate = nil
    if #Config.Locations.PlaneGates[data.name] > 1 then
        gate = Config.Locations.PlaneGates[data.name][math.random(0, #Config.Locations.PlaneGates - 1)]
        SpawnPoint = gate.gate
    else
        gate = Config.Locations.PlaneGates[data.name][0]
        SpawnPoint = gate.gate
    end
    if SpawnPoint then
        local coords = vector3(SpawnPoint.x, SpawnPoint.y, SpawnPoint.z)
        local CanSpawn = IsSpawnPointClear(coords, 2.0)
        local name = data.name
        if CanSpawn then
            if currentFlight ~= nil and currentFlight.blips ~= nil then
                for l, _ in pairs(currentFlight.blips) do
                    RemoveBlip(currentFlight.blips[l])
                end
            end
            currentFlight = {}
            local plane = nil
            if #Config.PlaneModels > 1 then
                plane = math.random(#Config.PlaneModels)
            else
                plane = 1
            end
            currentFlight.plane = plane
            selectedPlane = Config.PlaneModels[plane].MaxPassengers
            Generic.Client.SpawnVehicle(Config.PlaneModels[plane].ModelName, function(veh)
                print("Spawn")
                SetVehicleNumberPlateText(veh, "PILOT" .. tostring(math.random(1000, 9999)))
                exports[Config.FuelScript]:SetFuel(veh, 100.0)
                if Config.Framework.Type == "QBCore" then
                    exports['qb-menu']:closeMenu()
                end
                SetEntityHeading(veh, SpawnPoint.w)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", Generic.Client.GetPlate(veh))
                Citizen.Wait(750)
                SetVehicleEngineOn(veh, true, true)
                local numPass = math.random(selectedPlane)
                local npcs = {}
                SetVehicleDoorOpen(veh, Config.PlaneModels[plane].passengerDoor, false, false)
                currentFlight.numPass = numPass
                currentFlight.veh = veh
                for i = 1, numPass do
                    local Gender = math.random(1, #Config.NpcSkins)
                    local PedSkin = math.random(1, #Config.NpcSkins[Gender])
                    local model = GetHashKey(Config.NpcSkins[Gender][PedSkin])
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end
                    npcs[i] = CreatePed(3, model, gate.passengerSpawn.x, gate.passengerSpawn.y,
                        gate.passengerSpawn.z - 0.98, gate.passengerSpawn.w, false, true)
                    Citizen.Wait(200)
                    ClearPedTasksImmediately(npcs[i])
                    Citizen.Wait(300)
                    FreezeEntityPosition(npcs[i], false)
                    local seat
                    if Config.PlaneModels[plane].allowCoPilotSeat then
                        seat = i
                    else
                        seat = i + 1
                    end
                    print(seat)
                    TaskEnterVehicle(npcs[i], veh, -1, seat, 1.0, 8, 0)
                    Citizen.Wait(2000)
                end
                while GetVehicleNumberOfPassengers(veh) < numPass do
                    Citizen.Wait(0)
                    for i = 1, numPass do
                        local seat
                        if Config.PlaneModels[plane].allowCoPilotSeat then
                            seat = i
                        else
                            seat = i + 1
                        end
                        TaskEnterVehicle(npcs[i], veh, -1, seat, 1.0, 8, 0)
                    end
                end
                local destination = nil
                local destName = nil
                if Config.EnablePerico then
                    local destinations = {'lsia', 'perico', 'sandy', 'grapeseed'}
                    removeFirst(destinations, name)
                    destName = destinations[math.random(#destinations)]
                    local destAirportRunways = Config.Locations.Runways[destName]
                    if #destAirportRunways > 1 then
                        destination = destAirportRunways[math.random(#destAirportRunways)]
                    else
                        destination = destAirportRunways[0]
                    end
                else
                    local destinations = {'lsia', 'sandy', 'grapeseed'}
                    removeFirst(destinations, name)
                    destName = destinations[math.random(#destinations)]
                    local destAirportRunways = Config.Locations.Runways[destName]
                    if #destAirportRunways > 1 then
                        destination = destAirportRunways[math.random(#destAirportRunways)]
                    else
                        destination = destAirportRunways[0]
                    end
                end
                SetVehicleDoorShut(veh, Config.PlaneModels[plane].passengerDoor, false)
                currentFlight.npcs = npcs
                SetNewWaypoint(destination.x, destination.y)

                currentFlight.blips = {}
                for l, d in pairs(Config.Locations.PlaneGates[destName]) do
                    currentFlight.blips[l] = AddBlipForCoord(d.gate.x, d.gate.y, d.gate.z)
                    SetBlipSprite(currentFlight.blips[l], 38)
                    SetBlipDisplay(currentFlight.blips[l], 2)
                    SetBlipScale(currentFlight.blips[l], 0.75)
                    SetBlipColour(currentFlight.blips[l], 7)
                    SetBlipAsShortRange(currentFlight.blips[l], true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Destination Gate")
                    EndTextCommandSetBlipName(currentFlight.blips[l])
                end

                inFlight = true
                while inFlight do
                    local sleep = 1500
                    near = nil
                    local playerCoords = GetEntityCoords(PlayerPedId())
                    sleep = 500
                    if GetVehicleEngineHealth(veh) < 100 then
                        inFlight = false
                        currentFlight = {}
                        Generic.Client.ShowNotify("Flight failed, aircraft crashed!", "error")

                        for l, _ in pairs(currentFlight.blips) do
                            RemoveBlip(currentFlight.blips[l])
                        end

                        if Config.FineForCrash then
                            TriggerServerEvent("nwd-airlinepilot:server:planeCrash")
                        end
                        break
                    end
                    for _, t in pairs(Config.Locations.PlaneGates[destName]) do
                        if GetDistanceBetweenCoords(playerCoords, t.gate, true) <= 10 and Config.PressE and
                            GetDistanceBetweenCoords(playerCoords, t.gate, true) > 4 then
                            DisplayHelpTextThisFrame("pull_closer", false)
                            sleep = 1
                        elseif GetDistanceBetweenCoords(playerCoords, t.gate, true) <= 4 and Config.PressE and
                            GetEntitySpeed(veh) > 0.01 then
                            DisplayHelpTextThisFrame("stop_to_park", false)
                            sleep = 1
                        elseif GetDistanceBetweenCoords(playerCoords, t.gate, true) <= 4 and Config.PressE and
                            GetEntitySpeed(veh) < 0.01 then
                            DisplayHelpTextThisFrame("park", false)
                            sleep = 1
                            if IsControlJustPressed(0, 38) then
                                FreezeEntityPosition(veh, true)
                                for l, _ in pairs(currentFlight.blips) do
                                    RemoveBlip(currentFlight.blips[l])
                                end
                                SetVehicleDoorOpen(veh, Config.PlaneModels[plane].passengerDoor, false, false)
                                for _, v in pairs(currentFlight.npcs) do
                                    ClearPedTasksImmediately(v)
                                    TaskLeaveVehicle(v, veh, 256)
                                    SetEntityAsMissionEntity(v, false, true)
                                    SetEntityAsNoLongerNeeded(v)
                                    SetTimeout(60000, function()
                                        DeletePed(v)
                                    end)
                                    Citizen.Wait(2000)
                                end
                                while GetVehicleNumberOfPassengers(veh) > 0 do
                                    Citizen.Wait(0)
                                end
                                TaskLeaveVehicle(PlayerPedId(), veh, 0)
                                Citizen.Wait(3000)
                                inFlight = false
                                currentFlight = nil
                                Generic.Client.DeleteVehicle(veh)
                                selectedPlane = nil
                                TriggerServerEvent("nwd-airlinepilot:server:payFlight", numPass)
                            end
                        end
                    end
                    Citizen.Wait(sleep)
                end
            end, coords, true)
        else
            Generic.Client.ShowNotify("No gates currently clear", "error")
        end
    else
        Generic.Client.ShowNotify("An unknown error occurred", 'error')
        return
    end
end)

AddEventHandler("nwd-airlinepilot:client:ParkAtGate", function()
    if inFlight then
        FreezeEntityPosition(currentFlight.veh, true)
        for l, _ in pairs(currentFlight.blips) do
            RemoveBlip(currentFlight.blips[l])
        end
        SetVehicleDoorOpen(currentFlight.veh, Config.PlaneModels[currentFlight.plane].passengerDoor, false, false)
        for _, v in pairs(currentFlight.npcs) do
            ClearPedTasksImmediately(v)
            TaskLeaveVehicle(v, cirrentFlight.veh, 256)
            SetEntityAsMissionEntity(v, false, true)
            SetEntityAsNoLongerNeeded(v)
            SetTimeout(60000, function()
                DeletePed(v)
            end)
            Citizen.Wait(2000)
        end
        while GetVehicleNumberOfPassengers(currentFlight.veh) > 0 do
            Citizen.Wait(0)
        end
        TaskLeaveVehicle(PlayerPedId(), currentFlight.veh, 0)
        Citizen.Wait(3000)
        inFlight = false
        currentFlight = nil
        Generic.Client.DeleteVehicle(currentFlight.veh)
        selectedPlane = nil
        TriggerServerEvent("nwd-airlinepilot:server:payFlight", currentFlight.numPass)
    end
end)
