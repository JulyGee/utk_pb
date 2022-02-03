local QBCore = exports['qb-core']:GetCoreObject()
local info = {stage = 0, style = nil, locked = false}
local blackoutstatus = false
local blackoutdur = 600 -- Duration of blackout in seconds
local cooldown = 3600 -- duration for hitting powerplant again



RegisterServerEvent("utk_pb:updateUTK")
RegisterServerEvent("utk_pb:removeItem")
RegisterServerEvent("utk_pb:lock")
RegisterServerEvent("utk_pb:handlePlayers")
RegisterServerEvent("utk_pb:blackout")
RegisterServerEvent("utk_pb:checkblackout")


QBCore.Functions.CreateCallback("utk_pb:GetData", function(source, cb)
    cb(info)
end)
QBCore.Functions.CreateCallback("utk_pb:checkItem", function(source, cb, itemname)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local item = xPlayer.Functions.GetItemsByName(itemname)
	local count = 0
	
	if item ~= nil then
		for _ in pairs(item) do
			count = count + 1
		end
	else
		count = 0
	end
	
    if count >= 1 then
        cb(true)
    else
        cb(false)
    end
end)
AddEventHandler("utk_pb:updateUTK", function(table)
    local xPlayers = QBCore.Functions.GetPlayers()

    info = {stage = table.info.stage, style = table.info.style, locked = table.info.locked}
    for i = 1, #xPlayers, 1 do
        TriggerClientEvent("utk_pb:upUTK", xPlayers[i], table)
    end
end)
AddEventHandler("utk_pb:removeItem", function(item)
    local xPlayer = QBCore.Functions.GetPlayer(source)

    xPlayer.Functions.RemoveItem(item, 1)
end)
AddEventHandler("utk_pb:lock", function()
    local xPlayers = QBCore.Functions.GetPlayers()

    for i = 1, #xPlayers, 1 do
        if xPlayers[i] ~= source then
            TriggerClientEvent("utk_pb:lock_c", xPlayers[i])
        end
    end
end)
AddEventHandler("utk_pb:handlePlayers", function()
    local xPlayers = QBCore.Functions.GetPlayers()

    for i = 1, #xPlayers, 1 do
        TriggerClientEvent("utk_pb:handlePlayers_c", xPlayers[i])
    end
end)
AddEventHandler("utk_pb:checkblackout", function()
    if blackoutstatus == true then
        TriggerClientEvent('utk_pb:power', -1, true)
    end
end)
AddEventHandler('utk_pb:blackout', function(status)
    blackoutstatus = true

    TriggerClientEvent('utk_pb:power', -1, status)
    BlackoutTimer()
end)

function BlackoutTimer()
    local timer = blackoutdur
    repeat
        Citizen.Wait(1000)
        timer = timer - 1
    until timer == 0
    blackoutstatus = false
    local xPlayers = QBCore.Functions.GetPlayers()

    TriggerClientEvent('utk_pb:power', -1, false)
    Cooldown()
end
function Cooldown()
    local timer = cooldown
    repeat
        Citizen.Wait(1000)
        timer = timer - 1
    until timer == 0
    local xPlayers = QBCore.Functions.GetPlayers()
    info = {stage = 0, style = nil}

    for i = 1, #xPlayers, 1 do
        TriggerClientEvent("utk_pb:reset", xPlayers[i])
    end
end