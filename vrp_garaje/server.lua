MySQL = module("vrp_mysql", "MySQL")
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

Tunnel.bindInterface("vRP_garaje",vRPgb)
Proxy.addInterface("vRP_garaje",vRPgb)

vRPclient = Tunnel.getInterface("vRP","vRP_garaje")
vRPnc = Proxy.getInterface("vRP_garaje")


RegisterServerEvent('vRP:spawnvehplamea')
AddEventHandler('vRP:spawnvehplamea', function (masina)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	TriggerClientEvent('spawnVehiclegarage', player, masina)
end)

RegisterServerEvent('areperms')
AddEventHandler('areperms', function (permisiune,numar)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.hasPermission({user_id,permisiune}) then
		TriggerClientEvent('aregrad', player, numar)
	else
		vRPclient.notify(player,{"Nu ai acces sa folosesti acest garaj"})
	end
end)