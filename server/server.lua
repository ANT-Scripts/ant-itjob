local QBCore = exports['qb-core']:GetCoreObject()

local DiscordWebhook = {
    url = Config.WebhookURL,
    name = Config.WebhookName,
}

function ITJobLog(data)
    PerformHttpRequest(DiscordWebhook.url, function() end, 'POST',
        json.encode({ username = DiscordWebhook.name, content = data }), { ['Content-Type'] = 'application/json' })
end

QBCore.Functions.CreateCallback('ant-itjob:server:hasitem', function(source, cb, item)
    local _source = source
    local Player = QBCore.Functions.GetPlayer(_source)
    local itemCheck = Player.Functions.GetItemByName(item)
    if itemCheck == nil then
        cb(false)
    else
        cb(true)
    end
end)

RegisterServerEvent('ant-itjob:server:giveitem', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddItem(item)
end)

RegisterServerEvent('ant-itjob:server:takeitem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "remove", amount)
end)

RegisterServerEvent('ant-itjob:server:givemoney', function(amount)
    local Player = QBCore.Functions.GetPlayer(source)
    local firstName = Player.PlayerData.charinfo.firstname
    local lastName = Player.PlayerData.charinfo.lastname
    local cid = Player.PlayerData.citizenid
    Player.Functions.AddMoney('cash', amount)
    local data = string.format("%s %s (%s) received `$%.0f CASH` from the IT Job", firstName, lastName, cid, amount)
    ITJobLog(data)
end)

RegisterServerEvent('ant-itjob:server:givemoney2', function(amount)
    local Player = QBCore.Functions.GetPlayer(source)
    local firstName = Player.PlayerData.charinfo.firstname
    local lastName = Player.PlayerData.charinfo.lastname
    local cid = Player.PlayerData.citizenid
    Player.Functions.AddMoney('bank', amount)
    local data = string.format("%s %s (%s) received `$%.0f BANK` from the IT Job", firstName, lastName, cid, amount)
    ITJobLog(data)
end)

RegisterServerEvent('ant-itjob:server:packetsell')
AddEventHandler('ant-itjob:server:packetsell', function(deliveryItem)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local smallbag = xPlayer.Functions.GetItemByName(deliveryItem)
    if smallbag ~= nil then
        local firstName = xPlayer.PlayerData.charinfo.firstname
        local lastName = xPlayer.PlayerData.charinfo.lastname
        local cid = xPlayer.PlayerData.citizenid
        xPlayer.Functions.RemoveItem(deliveryItem, 1)
        xPlayer.Functions.AddMoney('cash', Config.ItemPrice)
		TriggerClientEvent('QBCore:Notify', source, Lang:t("notify.deliverynotify") ..Config.ItemPrice, "primary", 5000)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[deliveryItem], "remove", 1)
        local data = string.format("%s %s (%s) delivered a(n) `%s` as part of the IT Job", firstName, lastName, cid, deliveryItem)
        ITJobLog(data)
	end
end)

QBCore.Functions.CreateCallback('ant-itjob:itemcheck', function(source, cb, item)
	local xPlayer = QBCore.Functions.GetPlayer(source)
    local itemcount = xPlayer.Functions.GetItemByName(item)
	if itemcount ~= nil then
		cb(true)
	else
        cb(false)
	end
end)
