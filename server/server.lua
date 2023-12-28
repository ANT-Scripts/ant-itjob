local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('ant-itjob:server:CanDiagnose', function(source, cb)
    local _source = source
    local Player = QBCore.Functions.GetPlayer(_source)
    local requiredItem = Config.RequiredItem
    local requirementsMet = true
    local item = Player.Functions.GetItemByName(requiredItem)
    if item == nil or item.amount < 1 then
        requirementsMet = false
    end
    cb(requirementsMet)
end)

QBCore.Functions.CreateCallback('ant-itjob:server:HasRepairItem', function(source, cb, part)
    local _source = source
    local Player = QBCore.Functions.GetPlayer(_source)
    local requiredItem = part
    local requirementsMet = true
    local item = Player.Functions.GetItemByName(requiredItem)
    if item == nil or item.amount < 1 then
        requirementsMet = false
    end
    cb(requirementsMet)
end)

RegisterServerEvent('ant-itjob:server:GiveItem', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item)
end)

RegisterServerEvent('ant-itjob:server:TakeItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
end)

RegisterServerEvent('ant-itjob:server:GiveMoney', function(amount)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', amount)
end)

RegisterServerEvent('ant-itjob:server:GiveMoney2', function(amount)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('bank', amount)
end)

QBCore.Functions.CreateCallback('ant-itjob:ItemCheck', function(source, cb, item)
	local xPlayer = QBCore.Functions.GetPlayer(source)
    local itemcount = xPlayer.Functions.GetItemByName(item)
	if itemcount ~= nil then
		cb(true)
	else
        cb(false)
	end
end)
