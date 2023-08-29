local QBCore = exports['qb-core']:GetCoreObject()
	
	
	
QBCore.Functions.CreateCallback('am_carheist:server:revisaritems', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName("weed_brick")
    if Item ~= nil then
	    if Item.amount >= 1 then
        cb(true)
		else
		TriggerClientEvent("QBCore:Notify", src, "Debes Tener 1 Llave.", "error")
	    end
    else
        cb(false)    
    end

end)

QBCore.Functions.CreateCallback('am_carheist:server:revisaritemsabrirauto', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName("advancedlockpick")
    if Item ~= nil then
	    if Item.amount >= 1 then
        cb(true)
		else
		TriggerClientEvent("QBCore:Notify", src, "Debes Tener un Lockpick.", "error")
	    end
    else
        cb(false)    
    end

end)


RegisterServerEvent('am_carheist:server:eliminarlockpick', function() 
    local src = source
    local Player  = QBCore.Functions.GetPlayer(src)

	Player.Functions.RemoveItem("advancedlockpick", 1)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["advancedlockpick"], 'remove')

end)


RegisterServerEvent('am_carheist:server:darrecompensa', function() 
    local src = source
    local Player  = QBCore.Functions.GetPlayer(src)
    local randomcash = math.random(4111, 12321)
	Player.Functions.AddItem("cash", randomcash)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["cash"], 'add')

end)
