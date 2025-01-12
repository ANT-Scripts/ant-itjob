local QBCore = exports['qb-core']:GetCoreObject()
CanStart = true
Ongoing = false
Fixed = false

Citizen.CreateThread(function()
    ItCompJob = AddBlipForCoord(Config.BlipLocation)
    SetBlipSprite (ItCompJob, 606)
    SetBlipDisplay(ItCompJob, 4)
    SetBlipScale  (ItCompJob, 0.8)
    SetBlipAsShortRange(ItCompJob, true)
    SetBlipColour(ItCompJob, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.BlipName2)
    EndTextCommandSetBlipName(ItCompJob)
end)

Citizen.CreateThread(function()
    ItCompJob = AddBlipForCoord(Config.BlipLocation3)
    SetBlipSprite (ItCompJob, 606)
    SetBlipDisplay(ItCompJob, 4)
    SetBlipScale  (ItCompJob, 0.8)
    SetBlipAsShortRange(ItCompJob, true)
    SetBlipColour(ItCompJob, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.BlipName3)
    EndTextCommandSetBlipName(ItCompJob)
end)

local function CreateShopPED()
    QBCore.Functions.LoadModel(Config.ShopPed)
    local ped = CreatePed(0, Config.ShopPed, Config.ShopLocation.x, Config.ShopLocation.y, Config.ShopLocation.z, Config.ShopLocation.w, false, false)
    while not DoesEntityExist(ped) do Wait(1) end
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanPlayAmbientAnims(ped, true)
    TaskStartScenarioInPlace(ped, Config.ShopPedScenario, 0, true)
    TriggerEvent('ant-itjob:client:shopTarget', ped)
    return ped
end

RegisterNetEvent('ant-itjob:client:shopTarget', function(ped)
    exports['qb-target']:AddTargetEntity(ped, {
    	options = {
    		{
    			icon = 'far fa-clipboard',
    			label = Lang:t('label.shop'),
                action = function()
                    if Config.RequireJob then
                        local PlayerData = QBCore.Functions.GetPlayerData()
                        local job = PlayerData.job.name
                        if job == Config.Job then
                            TriggerEvent('ant-itjob:openshop')
                        else
                            QBCore.Functions.Notify(Lang:t('notify.nojob'), 'error')
                        end
                    else
                        TriggerEvent('ant-itjob:openshop')
                    end
                end
    		}
    	},
    	distance = 2.5,
    })
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    CreateShopPED()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if Config.Debug then
        CreateShopPED()
    end
end)

Citizen.CreateThread(function()
    hashKey = RequestModel(GetHashKey(Config.TaskPed))
    while not HasModelLoaded(GetHashKey(Config.TaskPed)) do
        Wait(1)
    end
    local npc = CreatePed(4, Config.TaskPedHash, Config.TaskPedLocation, false, true)
    SetEntityHeading(npc, Config.TaskPedHeading)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
end)

Citizen.CreateThread(function()
    exports['qb-target']:AddTargetModel(Config.TaskPed, {
    	options = {
    		{
    			icon = 'far fa-clipboard',
    			label = Lang:t('label.reqjob'),
                action = function()
                    if Config.RequireJob then
                        local PlayerData = QBCore.Functions.GetPlayerData()
                        local job = PlayerData.job.name
                        if job == Config.Job then
                            TriggerEvent('ant-itjob:takejob')
                        else
                            QBCore.Functions.Notify(Lang:t('notify.nojob'), 'error')
                        end
                    else
                        TriggerEvent('ant-itjob:takejob')
                    end
                end
    		},
            {
                icon = 'far fa-clipboard',
                label = Lang:t('label.finishjob'),
                action = function()
                    if Config.RequireJob then
                        local PlayerData = QBCore.Functions.GetPlayerData()
                        local job = PlayerData.job.name
                        if job == Config.Job then
                            TriggerEvent('ant-itjob:finishjob')
                        else
                            QBCore.Functions.Notify(Lang:t('notify.nojob'), 'error')
                        end
                    else
                        TriggerEvent('ant-itjob:finishjob')
                    end
                end
            },
            {
                icon = 'far fa-clipboard',
                label = Lang:t('label.startdelivery'),
                action = function()
                    if Config.RequireJob then
                        local PlayerData = QBCore.Functions.GetPlayerData()
                        local job = PlayerData.job.name
                        if job == Config.Job then
                            TriggerEvent('ant-itjob:startdelivery')
                        else
                            QBCore.Functions.Notify(Lang:t('notify.nojob'), 'error')
                        end
                    else
                        TriggerEvent('ant-itjob:startdelivery')
                    end
                end
            }
    	},
    	distance = 2.5,
    })
end)

RegisterNetEvent('ant-itjob:takejob')
AddEventHandler('ant-itjob:takejob', function()
    if CanStart then
        CanStart = false
        Ongoing = true
        local randomIndex = math.random(1, #Config.Items)
        BrokenPart = Config.Items[randomIndex] -- Assign s to a random item from Config.Items
        if Config.Debug then print(BrokenPart) end
        CheckedParts = {} -- Clear the existing table
        for _, item in ipairs(Config.Items) do
            CheckedParts[item] = false -- Set each item to false
        end
        SetTimeout(2000, function()
            TriggerEvent('ant-itjob:getrandomhouseloc')
        end)
    else
        QBCore.Functions.Notify(Lang:t('notify.jobinprogress'), 'error')
    end
end)

RegisterNetEvent('ant-itjob:finishjob')
AddEventHandler('ant-itjob:finishjob', function()
    if Ongoing == true then
        if Fixed == true then
            TriggerEvent('ant-itjob:withdraw')
        else
            QBCore.Functions.Notify(Lang:t('notify.notfinish'), 'error')
        end
    else
        QBCore.Functions.Notify(Lang:t('notify.needtostartjob'), 'error')
    end
end)

RegisterNetEvent("ant-itjob:getrandomhouseloc")
AddEventHandler("ant-itjob:getrandomhouseloc", function()
    local missionTarget = Config.Locations[math.random(#Config.Locations)]
    TriggerEvent("ant-itjob:createblipandroute", missionTarget)
end)

RegisterNetEvent("ant-itjob:createblipandroute")
AddEventHandler("ant-itjob:createblipandroute", function(missionTarget)
    QBCore.Functions.Notify(Lang:t("notify.recivedlocation"), "success")
    targetBlip = AddBlipForCoord(missionTarget.location.x, missionTarget.location.y, missionTarget.location.z)
    SetBlipSprite(targetBlip, 374)
    SetBlipColour(targetBlip, 1)
    SetBlipAlpha(targetBlip, 90)
    SetBlipScale(targetBlip, 0.5)
    SetBlipRoute(targetBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.BlipName)
    EndTextCommandSetBlipName(targetBlip)
end)

RegisterNetEvent("ant-itjob:goinside")
AddEventHandler("ant-itjob:goinside", function(missionTarget)
    local missionTarget = Config.Locations[#Config.Locations]
    if Ongoing == true then
        SetEntityCoords(PlayerPedId(), missionTarget.inside.x, missionTarget.inside.y, missionTarget.inside.z)
        TriggerEvent("ant-itjob:createpc", missionTarget)
    else
        QBCore.Functions.Notify(Lang:t('notify.needtostartjob'), 'error')
    end
end)

RegisterNetEvent("ant-itjob:gooutside")
AddEventHandler("ant-itjob:gooutside", function(missionTarget)
    local missionTarget = Config.Locations[#Config.Locations]
    if Ongoing == true then
        SetEntityCoords(PlayerPedId(), missionTarget.location.x, missionTarget.location.y, missionTarget.location.z)
    else
        QBCore.Functions.Notify(Lang:t('notify.needtostartjob'), 'error')
    end
end)

Citizen.CreateThread(function()
    local missionTarget = Config.Locations[#Config.Locations]

    for i,v in ipairs(missionTarget.comp) do

        exports['qb-target']:AddCircleZone('CheckPC', vector3(v.x, v.y, v.z), 0.5,{
            name = 'CheckPC',
            debugPoly = false, 
            useZ=true
        }, {
            options = {
                {
                    label = Lang:t("label.checkpc"),
                    icon = 'fa-solid fa-hand-holding',
                    action = function()
                        if Config.RequireJob then
                            local PlayerData = QBCore.Functions.GetPlayerData()
                            local job = PlayerData.job.name
                            if job == Config.Job then
                                openfixmenu()
                            else
                                QBCore.Functions.Notify(Lang:t('notify.nojob'), 'error')
                            end
                        else
                            openfixmenu()
                        end
                    end
                }
            },
            distance = 2.0
        })
    end
end)

Citizen.CreateThread(function()
    local missionTarget = Config.Locations[#Config.Locations]

    exports['qb-target']:AddCircleZone('Entry', vector3(missionTarget.location.x, missionTarget.location.y, missionTarget.location.z), 0.8,{
        name = 'Entry',
        debugPoly = false, 
        useZ=true
    }, {
        options = {
            {
                label = Lang:t("label.entry"),
                icon = 'fa-solid fa-hand-holding',
                action = function()
                    if Config.RequireJob then
                        local PlayerData = QBCore.Functions.GetPlayerData()
                        local job = PlayerData.job.name
                        if job == Config.Job then
                            TriggerEvent('ant-itjob:goinside')
                        else
                            QBCore.Functions.Notify(Lang:t('notify.nojob'), 'error')
                        end
                    else
                        TriggerEvent('ant-itjob:goinside')
                    end
                end
            },
        },
        distance = 2.0
    })
end)

Citizen.CreateThread(function()
    local missionTarget = Config.Locations[#Config.Locations]
    
    exports['qb-target']:AddCircleZone('Exit', vector3(missionTarget.inside.x, missionTarget.inside.y, missionTarget.inside.z), 0.8,{
        name = 'Exit',
        debugPoly = false, 
        useZ=true
    }, {
        options = {
            {
                label = Lang:t("label.exit"),
                icon = 'fa-solid fa-hand-holding', 
                action = function()
                    if Config.RequireJob then
                        local PlayerData = QBCore.Functions.GetPlayerData()
                        local job = PlayerData.job.name
                        if job == Config.Job then
                            TriggerEvent('ant-itjob:gooutside')
                        else
                            QBCore.Functions.Notify(Lang:t('notify.nojob'), 'error')
                        end
                    else
                        TriggerEvent('ant-itjob:gooutside')
                    end
                end
            },
        },
        distance = 2.0
    })
end)

RegisterNetEvent('ant-itjob:startdelivery', function(data)
    local deliveryItem = Config.Items[math.random(1, #Config.Items)]
    lib.registerContext({
        id = 'startdelivery',
        title = 'Delivery Instructions',
        options = {
            {
                title = string.format("Delivery Item: %s", QBCore.Shared.Items[deliveryItem].label),
                description = string.format('Deliver the %s to the location on your GPS to get paid.', QBCore.Shared.Items[deliveryItem].label),
                icon = "nui://" .. Config.InventoryImage .. QBCore.Shared.Items[deliveryItem].image,
                disabled = true
            },
            {
                title = 'Confirm',
                description = 'Accept the Delivery Instructions and obtain your vehicle.',
                icon = 'fa-solid fa-truck',
                onSelect = function()
                    TriggerEvent('ant-itjob:client:startdelivery', deliveryItem)
                end,
                arrow = true
            }
        }
    })
    lib.showContext('startdelivery')
end)

RegisterNetEvent('ant-itjob:FixMenu', function()
    local menuOptions = {
        id = 'fixMenu',
        title = 'Computer Diagnostics',
        options = {}
    }
    for _, item in ipairs(Config.Items) do
        table.insert(menuOptions.options, {
            title = Lang:t("qbmenu.check" .. item),
            icon = 'fa-solid fa-magnifying-glass',
            image = "nui://"..Config.InventoryImage..QBCore.Shared.Items[item].image,
            onSelect = function()
                TriggerEvent('ant-itjob:checkpart', item)
            end,
            arrow = true
        })
    end
    lib.registerContext(menuOptions)
    lib.showContext('fixMenu')
end)

RegisterNetEvent('ant-itjob:checkpart')
AddEventHandler('ant-itjob:checkpart', function(part)
    if CheckedParts[part] == false then
        QBCore.Functions.TriggerCallback('ant-itjob:server:hasitem', function(HasItem)
            if HasItem then
                QBCore.Functions.Progressbar("checkpart", Lang:t("progress.checkingpart"), 10000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "mini@repair",
                    anim = "fixing_a_ped",
                    flags = 8,
                }, {}, {}, function() -- Done
                    if BrokenPart == part then
                        TriggerEvent('ant-itjob:ImBroken', part)
                    else
                        QBCore.Functions.Notify(Lang:t('notify.imnotbroken'))
                        CheckedParts[part] = true
                    end
                end, function() -- Cancel
                    QBCore.Functions.Notify("Cancelled", "error")
                end)                
            else
                QBCore.Functions.Notify(Lang:t('notify.donthaveitem'), 'error')
            end
        end, Config.RepairItem)
    else
        QBCore.Functions.Notify(Lang:t('notify.alreadychecked'), 'error')
    end
end)

RegisterNetEvent('ant-itjob:ImBroken', function(part)
    lib.registerContext({
        id = 'ImBrokenMenu',
        title = 'Broken Part',
        options = {
            {
                title = string.format("%s", Lang:t("qbmenu.imbroken")),
                disabled = true
            },
            {
                title = 'Fix Broken Part',
                description = 'Satisfy the customer by fixing the broken part.',
                icon = 'fa-solid fa-toolbox',
                onSelect = function()
                    TriggerEvent('ant-itjob:replace', part)
                end,
                arrow = true
            }
        }
    })
    lib.showContext('ImBrokenMenu')
end)

RegisterNetEvent('ant-itjob:withdraw', function(data)
    lib.registerContext({
        id = 'withdraw',
        title = 'Withdraw Money',
        options = {
            {
                title = Lang:t("qbmenu.wdmoney"),
                description = '',
                icon = 'fa-solid fa-money-bill',
                onSelect = function()
                    TriggerEvent('ant-itjob:cashbank')
                end,
                arrow = true
            }
        }
    })
    lib.showContext('withdraw')
end)

RegisterNetEvent('ant-itjob:cashbank', function(data)
    lib.registerContext({
        id = 'withdraw',
        title = 'Withdraw Money',
        options = {
            {
                title = Lang:t("qbmenu.cash"),
                description = '',
                icon = 'fa-solid fa-money-bill',
                onSelect = function()
                    TriggerEvent('ant-itjob:finishjob2')
                    CanStart = true
                end,
                arrow = true
            },
            {
                title = Lang:t("qbmenu.bank"),
                description = '',
                icon = 'fa-solid fa-money-bill',
                onSelect = function()
                    TriggerEvent('ant-itjob:finishjob3')
                    CanStart = true
                end,
                arrow = true
            }
        }
    })
    lib.showContext('withdraw')
end)

RegisterNetEvent('ant-itjob:finishjob2')
AddEventHandler('ant-itjob:finishjob2', function()
    TriggerServerEvent('ant-itjob:server:givemoney', Config.Payout)
    CanStart = true
    Ongoing = false
    Fixed = false
end)

RegisterNetEvent('ant-itjob:finishjob3')
AddEventHandler('ant-itjob:finishjob3', function()
    TriggerServerEvent('ant-itjob:server:givemoney2', Config.Payout)
    CanStart = true
    Ongoing = false
    Fixed = false
end)

RegisterNetEvent('ant-itjob:replace')
AddEventHandler('ant-itjob:replace', function(part)
    QBCore.Functions.TriggerCallback('ant-itjob:server:hasitem', function(HasItem)
        if HasItem then
            QBCore.Functions.Progressbar("pickup", Lang:t("progress.replacingpart"), 20000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mini@repair",
                anim = "fixing_a_ped",
                flags = 8,
            }, {}, {}, function() -- Done
                print(part)
                TriggerServerEvent('ant-itjob:server:takeitem', part, 1)
                TriggerServerEvent('ant-itjob:server:fixedPCLog', part)
                TriggerEvent('ant-itjob:fixedpc')
                Fixed = true
                RemoveBlip(targetBlip)
            end, function() -- Cancel
                QBCore.Functions.Notify("Cancelled Part Replacement", "error")
            end)
        else
            QBCore.Functions.Notify(Lang:t('notify.donthaveitem'), 'error')
        end
    end, part)
end)

RegisterNetEvent('ant-itjob:fixedpc')
AddEventHandler('ant-itjob:fixedpc', function()
    if Config.Phone == "qb-phone" then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender =  Lang:t("mail.sender"),
            subject = Lang:t("mail.subject"),
            message = Lang:t("mail.message"),
            button = {
            }
        })
    elseif Config.Phone == "gks-phone" then
        TriggerServerEvent('gksphone:NewMail', {
            sender =  Lang:t("mail.sender"),
            subject = Lang:t("mail.subject"),
            message = Lang:t("mail.message")
        })
    elseif Config.Phone == "qs-phone" then
        TriggerServerEvent('qs-smartphone:server:sendNewMail', {
            sender =  Lang:t("mail.sender"),
            subject = Lang:t("mail.subject"),
            message = Lang:t("mail.message"),
            button = {
            }
        })
    elseif Config.Phone == "notify" then
        QBCore.Functions.Notify(Lang:t("mail.message"), 'info')
    end
end)

function openfixmenu()
    if Fixed == true then
        QBCore.Functions.Notify(Lang:t('notify.alreadyfixed'), 'error')
    else
        TriggerEvent('ant-itjob:FixMenu')
    end
end

RegisterNetEvent('ant-itjob:openshop')
AddEventHandler('ant-itjob:openshop', function()
    TriggerServerEvent('inventory:server:OpenInventory', 'shop', 'components', Config.PcParts)
end)
