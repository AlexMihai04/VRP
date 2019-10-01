MySQL = module("vrp_mysql", "MySQL")
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

Tunnel.bindInterface("vRP_garaje",vRPgb)
Proxy.addInterface("vRP_garaje",vRPgb)

vRPclient = Tunnel.getInterface("vRP","vRP_garaje")
vRPnc = Proxy.getInterface("vRP_garaje")


RegisterServerEvent('vRP:angajeaza')
AddEventHandler('vRP:angajeaza', function (job)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	local meserie = vRP.getUserGroupByType({user_id,"job"})
	if meserie=="Somer" or meserie==job or meserie == "" then
        if vRP.hasGroup({user_id,job}) then
            vRPclient.notifyPicture(player,{"CHAR_ALL_PLAYERS_CONF",1, "JOBS", false,"Deja detii acest job",})
        else
            vRP.addUserGroup({user_id,job})
            vRPclient.notifyPicture(player,{"CHAR_ALL_PLAYERS_CONF",1, "JOBS", false,"Felicitari ! Acum esti un : ~g~"..job,})
        end
    else
        vRPclient.notifyPicture(player,{"CHAR_ALL_PLAYERS_CONF",1, "JOBS", false,"Esti deja angajat ca si un : ~g~"..meserie,})
    end
end)

RegisterServerEvent('vRP:demisioneaza')
AddEventHandler('vRP:demisioneaza', function (job)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	local meserie = vRP.getUserGroupByType({user_id,"job"})
	if vRP.hasGroup({user_id,job}) then
		vRP.removeUserGroup({user_id,job})
		vRP.addUserGroup({user_id,"Somer"})
		vRPclient.notifyPicture(player,{"CHAR_ALL_PLAYERS_CONF",1, "JOBS", false,"Felicitari ! Tocmai ai demisionat de la : ~g~"..job,})
	else
		vRPclient.notifyPicture(player,{"CHAR_ALL_PLAYERS_CONF",1, "JOBS", false,"Nu detii acest job !",})
	end
end)
