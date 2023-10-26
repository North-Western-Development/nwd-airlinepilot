local FO = (Config.Framework.Type == "QBCore" and exports["qb-core"]:GetCoreObject() or exports["es_extended"]:getSharedObject())

Generic = {
    Server = {
        Framework = {
            AddMoney = function(player, mtype, amount, reason)
                if Config.Framework.Type == "QBCore" then
                    player.Functions.AddMoney(
                        mtype,
                        amount,
                        reason
                    )
                else
                    player.addAccountMoney(mtype, amount)
                end
            end,
            GetPlayer = function(src)
                if Config.Framework.Type == "QBCore" then
                    return FO.GetPlayer(src)
                else
                    return FO.GetPlayerFromId(src)
                end
            end,
            RemoveMoney = function(player, mtype, amount, reason)
                if Config.Framework.Type == "QBCore" then
                    player.Functions.RemoveMoney(
                        mtype,
                        amount,
                        reason
                    )
                else
                    player.removeAccountMoney(mtype, amount)
                end
            end
        }
    },
    Client = {
        Framework = {
            GetPlayerData = function()
                if Config.Framework.Type == "QBCore" then
                    return FO.Functions.GetPlayerData()
                else
                    return FO.GetPlayerData()
                end
            end,
            OpenMenu = function(type, namespace, name, data, OnSelect, cancel)
                FO.UI.Menu.Open(type, namespace, name, data, OnSelect, cancel)
            end
        },
        SpawnVehicle = function(model, cb, coords, isnetworked)
            local ped = PlayerPedId()
            if coords then
                coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
            else
                coords = GetEntityCoords(ped)
            end
            local isnetworked = isnetworked or true
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(10)
            end
            local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, isnetworked, false)
            local netid = NetworkGetNetworkIdFromEntity(veh)
            SetVehicleHasBeenOwnedByPlayer(veh, true)
            SetNetworkIdCanMigrate(netid, true)
            SetVehicleNeedsToBeHotwired(veh, false)
            SetVehRadioStation(veh, 'OFF')
            SetModelAsNoLongerNeeded(model)
            if cb then
                cb(veh)
            end
        end,
        GetPlate = function(vehicle)
            if vehicle == 0 then return end
            return GetVehicleNumberPlateText(vehicle)
        end,
        ShowNotify = function(message, ntype)
            if Config.Framework.Type == "QBCore" then
                FO.Functions.Notify(message, ntype)
            else
                FO.ShowNotification(message, ntype, 3000)
            end
        end,
        DeleteVehicle = function(vehicle)
            SetEntityAsMissionEntity(vehicle, true, true)
            DeleteVehicle(vehicle)
        end
    }
}