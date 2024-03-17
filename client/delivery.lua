local QBCore = exports['qb-core']:GetCoreObject()

local client = true
local status = false
local delivery = 0

local function PacketSell2(deliveryItem)
    QBCore.Functions.Progressbar("packetsell", Lang:t("progress.packetselling"), Config.ProgressbarTime, false, true, { 
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
        }, {
        animDict = "timetable@jimmy@doorknock@",
        anim = "knockdoor_idle",
        flags = 49,
    }, {}, {}, function() -- Done
        TriggerServerEvent("ant-itjob:server:packetsell", deliveryItem)
        TriggerEvent("ant-itjob:client:packetsell", deliveryItem)
        map = true
        ClearPedTasksImmediately(ped)
    end, function() -- Cancel
        -- Cancel
    end)
end

RegisterNetEvent("ant-itjob:client:startdelivery")
AddEventHandler("ant-itjob:client:startdelivery", function(deliveryItem)
    if client then 
        if delivery == 0 then
            TriggerEvent("ant-itjob:client:packetsell", deliveryItem)
            if Config.GiveVehicle then
                TriggerEvent("ant-itjob:SpawnDeliveryVeh")
            end
        else
            QBCore.Functions.Notify(Lang:t("notify.ondelivery"), "error")
        end
    else
        QBCore.Functions.Notify(Lang:t("notify.realy"), "error")
    end
end)

RegisterNetEvent("ant-itjob:client:packetsell")
AddEventHandler("ant-itjob:client:packetsell", function(deliveryItem)
    if client then
        if delivery < 3 then
            local random = math.random(1, #Config.DeliveryCoords)
            QBCore.Functions.Notify(Lang:t("notify.neworder"), "primary")
            local deliveryCoords = Config.DeliveryCoords[random]
            SetNewWaypoint(deliveryCoords["x"], deliveryCoords["y"])

            -- Add blip to delivery coords
            local blip = AddBlipForCoord(deliveryCoords["x"], deliveryCoords["y"], deliveryCoords["z"])
            SetBlipSprite(blip, 1) -- Choose the sprite for the blip (1 is standard)
            SetBlipDisplay(blip, 4) -- Display as a standard blip on the map and minimap
            SetBlipColour(blip, 5) -- Choose the color of the blip (5 is yellow)
            SetBlipScale(blip, 0.8) -- Set the scale of the blip

            local showingText = true -- Flag to control text visibility
            while showingText do
                local ped = PlayerPedId()
                local plycoords = GetEntityCoords(ped)
                local distance = #(plycoords - vector3(deliveryCoords["x"], deliveryCoords["y"], deliveryCoords["z"]))
                Citizen.Wait(1)
                if distance < 1.0 and client then
                    QBCore.Functions.DrawText3D(deliveryCoords["x"], deliveryCoords["y"], deliveryCoords["z"], Lang:t("qbmenu.deliver"))
                    if IsControlJustPressed(1, 38) then
                        QBCore.Functions.TriggerCallback('ant-itjob:itemcheck', function(data)
                            if data then
                                PacketSell2(deliveryItem) -- Sell the item if it exists
                                showingText = false
                                RemoveBlip(blip)
                                delivery = delivery + 1 -- Increment delivery count
                            else
                                QBCore.Functions.Notify(Lang:t("notify.needitem"), "error")
                            end
                        end, deliveryItem)
                    end
                end
            end
        else
            client = true
            status = false
            delivery = 0
            QBCore.Functions.Notify("You've reached the maximum number of deliveries.", "error")
        end
    end
end)

RegisterNetEvent("ant-itjob:SpawnDeliveryVeh", function() 
local coords = Config.CarSpawnCoord
QBCore.Functions.SpawnVehicle(Config.DeliveryVeh, function(veh)
    SetVehicleNumberPlateText(veh, Config.VehPlate)
    SetEntityHeading(veh, coords.w)
    exports[Config.Fuel]:SetFuel(veh, 100.0)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
    SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end)