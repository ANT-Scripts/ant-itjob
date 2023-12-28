local QBCore = exports['qb-core']:GetCoreObject()
CanStart = true
Ongoing = false
Fixed = false

Citizen.CreateThread(function()
    ItCompJob = AddBlipForCoord(Config.BlipLocation.x, Config.BlipLocation.y, Config.BlipLocation.z)
    SetBlipSprite (ItCompJob, 606)
    SetBlipDisplay(ItCompJob, 4)
    SetBlipScale  (ItCompJob, 0.8)
    SetBlipAsShortRange(ItCompJob, true)
    SetBlipColour(ItCompJob, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.BlipName)
    EndTextCommandSetBlipName(ItCompJob)
end)

Citizen.CreateThread(function()
    HashKey = RequestModel(GetHashKey(Config.TaskPed))
    while not HasModelLoaded(GetHashKey(Config.TaskPed)) do
        Wait(1)
    end
    local npc = CreatePed(4, Config.TaskPedHash, Config.TaskPedLocation.x, Config.TaskPedLocation.y, Config.TaskPedLocation.z, Config.TaskPedHeading, false, true)
    SetEntityHeading(npc, Config.TaskPedHeading)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
end)

Citizen.CreateThread(function()
    if Config.Target == "qb-target" then
        exports['qb-target']:AddTargetModel(Config.TaskPed, {
            options = {
                {
                    event = 'ant-itjob:takejob',
                    icon = 'far fa-clipboard',
                    label = Lang:t('label.reqjob')
                },
                {
                    event = 'ant-itjob:finishjob',
                    icon = 'far fa-clipboard',
                    label = Lang:t('label.finishjob')
                }
            },
            distance = 2.5,
        })
    end
end)

RegisterNetEvent('ant-itjob:takejob')
AddEventHandler('ant-itjob:takejob', function()
    if CanStart then
        CanStart = false
        Ongoing = true
        SetTimeout(2000, function()
            TriggerEvent('ant-itjob:getrandomhouseloc')
        end)
    else
        QBCore.Functions.Notify(Lang:t('notify.jobinprogress'), 'error')
    end
    local randomIndex = math.random(1, #Config.Items)
    s = Config.Items[randomIndex]
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
    TriggerEvent("ant-itjob:createentry", missionTarget)
end)

RegisterNetEvent("ant-itjob:createblipandroute")
AddEventHandler("ant-itjob:createblipandroute", function(missionTarget)
    QBCore.Functions.Notify(Lang:t("notify.recivedlocation"), "success")
    TargetBlip = AddBlipForCoord(missionTarget.location.x, missionTarget.location.y, missionTarget.location.z)
    SetBlipSprite(TargetBlip, 374)
    SetBlipColour(TargetBlip, 1)
    SetBlipAlpha(TargetBlip, 90)
    SetBlipScale(TargetBlip, 0.5)
    SetBlipRoute(TargetBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.BlipName)
    EndTextCommandSetBlipName(TargetBlip)
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
        if Config.Target == "qb-target" then
            exports['qb-target']:AddCircleZone('CheckPC', vector3(v.x, v.y, v.z), 0.5,{
                name = 'Diagnose Computer',
                debugPoly = false, 
                useZ=true
            }, {
                options = {{
                    label = Lang:t("label.checkpc"),
                    icon = 'fa-solid fa-hand-holding',
                    action = function()
                        OpenFixMenu() 
                    end}},
                distance = 2.0
            })
        end
    end
end)

Citizen.CreateThread(function()
    local missionTarget = Config.Locations[#Config.Locations]
    if Config.Target == "qb-target" then
        exports['qb-target']:AddCircleZone('Entry', vector3(missionTarget.location.x, missionTarget.location.y, missionTarget.location.z), 0.8,{
            name = 'Enter House',
            debugPoly = false, 
            useZ=true
        }, {
            options = {
                {
                    label = Lang:t("label.entry"),
                    icon = 'fa-solid fa-hand-holding',
                    event = 'ant-itjob:goinside'
                },
            },
            distance = 2.0
        })
    end
end)

Citizen.CreateThread(function()
    local missionTarget = Config.Locations[#Config.Locations]
    if Config.Target == "qb-target" then
        exports['qb-target']:AddCircleZone('Exit', vector3(missionTarget.inside.x, missionTarget.inside.y, missionTarget.inside.z), 0.8,{
            name = 'Exit',
            debugPoly = false, 
            useZ=true
        }, {
            options = {
                {
                    label = Lang:t("label.exit"),
                    icon = 'fa-solid fa-hand-holding', 
                    event = 'ant-itjob:gooutside'
                },
            },
            distance = 2.0
        })
    end
end)

RegisterNetEvent('ant-itjob:startdelivery', function(data)
    if Config.Menu == "ox_lib" then
        lib.registerContext({
            id = 'DeliveryMenu',
            title = 'Delivery Instructions',
            options = {
            {
                title = "Delivery Item: "..QBCore.Shared.Items[Config.DeliveryItem].label,
                description = 'Deliver the '..QBCore.Shared.Items[Config.DeliveryItem].label..' to the location on your GPS to get paid.',
                icon = "nui://" .. Config.InventoryImage .. QBCore.Shared.Items[Config.DeliveryItem].image,
                disabled = true
            },
            {
                title = 'Confirm',
                description = 'Accept the Delivery Instructions and obtain your vehicle.',
                icon = 'fa-solid fa-truck',
                event = 'ant-itjob:client:startdelivery',
                arrow = true
            }
            }
        })
        lib.showContext('DeliveryMenu')
    end
end)

RegisterNetEvent('ant-itjob:FixMenu', function()
    if Config.Menu == "ox_lib" then

        local options = {}
        for _, item in pairs(Config.Items) do
            table.insert(options, {
                title = 'Diagnose ' .. QBCore.Shared.Items[item].label,
                icon = "nui://" .. Config.InventoryImage .. QBCore.Shared.Items[item].image,
                arrow = true,
                onSelect = function()
                    local p = promise.new()
                    QBCore.Functions.TriggerCallback('ant-itjob:server:CanDiagnose', function(allowed)
                        p:resolve(allowed)
                    end)
                    local pass = Citizen.Await(p)
                    if pass then
                        TriggerEvent('ant-itjob:checkpart', item)
                    else
                        QBCore.Functions.Notify("You don't have an IT Toolbox", 'error')
                    end
                end
            })
        end
        lib.registerContext({
            id = 'FixMenu',
            title = "Diagnose & Fix",
            options = options
        })
        lib.showContext('FixMenu')
    end
end)

RegisterNetEvent('ant-itjob:checkpart')
AddEventHandler('ant-itjob:checkpart', function(item)
    QBCore.Functions.Progressbar("pickup", Lang:t("progress.checkingpart"), Config.CheckPartDuration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    },{
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        flags = 8,
    })
    Citizen.Wait(Config.CheckPartDuration)
    if s == item then
        TriggerEvent('ant-itjob:ImBroken', item)
    else
        QBCore.Functions.Notify(Lang:t('notify.imnotbroken'))
    end
end)

RegisterNetEvent('ant-itjob:ImBroken', function(part)
    if Config.Menu == "ox_lib" then
        lib.registerContext({
            id = 'BrokenMenu',
            title = "Broken Part",
            options = {
                {
                    title = 'Replace Part',
                    arrow = true,
                    onSelect = function()
                        TriggerEvent('ant-itjob:replace', part)
                    end
                },
            }
        })
        lib.showContext('BrokenMenu')
    end
end)

RegisterNetEvent('ant-itjob:withdraw', function(data)
    exports['qb-menu']:openMenu({
        {
            header = Lang:t("qbmenu.avboptions"),
            isMenuHeader = true
        },
        {
            header = Lang:t("qbmenu.wdmoney"),
            params = {
                event = "ant-itjob:cashbank"
            }
        },
    })
end)

RegisterNetEvent('ant-itjob:cashbank', function(data)
    exports['qb-menu']:openMenu({
        {
            header = Lang:t("qbmenu.avboptions"),
            isMenuHeader = true
        },
        {
            header = Lang:t("qbmenu.cash"),
            params = {
                event = "ant-itjob:finishjob2",
                CanStart = true
            }
        },
        {
            header = Lang:t("qbmenu.bank"),
            params = {
                event = "ant-itjob:finishjob3",
                CanStart = true
            }
        },
    })
end)

RegisterNetEvent('ant-itjob:finishjob2')
AddEventHandler('ant-itjob:finishjob2', function()
    TriggerServerEvent('ant-itjob:server:GiveMoney', Config.JobPayout)
    CanStart = true
    Ongoing = false
    Fixed = false
end)

RegisterNetEvent('ant-itjob:finishjob3')
AddEventHandler('ant-itjob:finishjob3', function()
    TriggerServerEvent('ant-itjob:server:GiveMoney2', Config.JobPayout)
    CanStart = true
    Ongoing = false
    Fixed = false
end)

RegisterNetEvent('ant-itjob:replace')
AddEventHandler('ant-itjob:replace', function(part)
    if s == part then
        local p = promise.new()
                QBCore.Functions.TriggerCallback('ant-itjob:server:HasRepairItem', function(allowed)
                    p:resolve(allowed)
                end, part)
        local pass = Citizen.Await(p)
        if pass then
            QBCore.Functions.Progressbar("pickup", Lang:t("progress.replacingpart"), 20000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },{
                animDict = "mini@repair",
                anim = "fixing_a_ped",
                flags = 8,
                }
            )
            Citizen.Wait(500)
            TriggerServerEvent('ant-itjob:server:TakeItem', part, 1)
            if Config.Phone == "qb-phone" then
                TriggerServerEvent('qb-phone:server:sendNewMail', {
                    sender =  Lang:t("mail.sender"),
                    subject = Lang:t("mail.subject"),
                    message = Lang:t("mail.message"),
                    button = {
                    }
                })
            elseif Config.Phone == "none" then
                QBCore.Functions.Notify("Head back to collect your check.", "info")
            end
            Fixed = true
            RemoveBlip(TargetBlip)
        else
            QBCore.Functions.Notify("What will you replace it with?", "error")
        end
    end
end)

function OpenFixMenu()
    if Fixed == true then
        QBCore.Functions.Notify(Lang:t('notify.alreadyFixed'), 'error')
    else
        TriggerEvent('ant-itjob:FixMenu')
    end
end