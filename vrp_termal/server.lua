--[[					SCRIPT MADE BY : ALEXMIHAI04						--]]
--[[					GOOD LUCK HAVE FUN									--]]


local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vRP_rcCar")

local stat = false

vRP.defInventoryItem({"termaliss", "Ochelari termali", "Poti sa vezi corpuri de caldura prin pereti !", function(args)
	local choices = {}
	
	choices["Foloseste"] = {function(player,choice,mod)
		local user_id = vRP.getUserId({player})
		if user_id ~= nil then
			if stat then
				stat = false
				TriggerClientEvent('termali', player, false)
				vRPclient.notify(player,{"Ai dezactivat ochelarii termali."})
				vRP.closeMenu({player})
			else
				stat = true
				TriggerClientEvent('termali', player, true)
				vRPclient.notify(player,{"Ai activat ochelarii termali."})
				vRP.closeMenu({player})
			end
		end
	end}

	return choices
end, 0.01})