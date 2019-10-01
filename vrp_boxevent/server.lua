local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")

vRPclient = Tunnel.getInterface("vRP","vrp_eventbox")
vRPPclient = Tunnel.getInterface("vRP_parking","vrp_eventbox")
vRP = Proxy.getInterface("vRP")

local locatiievents = {
    {1061.9614257813,-2951.4096679688,5.9008255004883,false},
    {812.61340332031,-1076.1916503906,28.538547515869,false},
    {820.52716064453,-1070.7542724609,28.234506607056,false},
    {758.08654785156,-946.55157470703,25.632585525513,false},
    {-508.40213012695,-1008.8754272461,23.550500869751,false},
    {-360.8967590332,-238.27592468262,36.080066680908,false},
    {-174.70886230469,180.42166137695,77.646156311035,false},
    {-224.7568359375,315.69729614258,92.273765563965,false},
    {-235.17207336426,307.64572143555,92.166343688965,false},
    {64.696868896484,-373.84326171875,39.921421051025,false},
    {45.608734130859,-367.82843017578,39.921443939209,false},
    {10.425572395325,-388.60678100586,39.361618041992,false},
    {1544.1171875,-2154.1806640625,77.558067321777,false},
    {2689.2944335938,1492.986328125,24.571765899658,false},
    {1543.6811523438,6613.4853515625,2.5106070041656,false},
    {-3292.0935058594,967.48510742188,8.291522026062,false},
    {1744.7496337891,3260.3725585938,41.341148376465,false}
}

vRP.defInventoryItem({"scrap", "Scrap", "Sell to scrap merchant !", function(args)
	local choices = {}
	
	choices["Useless"] = {function(player,choice,mod)
		vRPclient.notify(player,{"Sell to merchant"})
	end}

	return choices
end, 0.1})

RegisterServerEvent('event:sansa')
AddEventHandler('event:sansa', function(sansa)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    if sansa == 3 then
        local numar = math.random(1,3)
        vRP.giveInventoryItem({user_id,"scrap",numar,false})
        vRPclient.notify(player,{"You found 1 scrap"})
    else
        vRPclient.notify(player,{"You found nothing"})
    end
end)

RegisterServerEvent('vinde')
AddEventHandler('vinde', function()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    local umeras = vRP.getInventoryItemAmount({nuser_id,"scrap"})
    if vRP.tryGetInventoryItem({user_id,"scrap",tonumber(umeras),false}) then
        vRPclient.notify(player,{"You sold 1 scrap for 300"})
        vRP.giveMoney({user_id,tonumber(300*umeras)})
    else
        vRPclient.notify(player,{"You don't have enough scrap"})
    end
end)

RegisterServerEvent('verifica')
AddEventHandler('verifica', function(x,y,z,statement)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    for i,v in pairs(locatiievents) do
        if v[1] == x and v[2] == y and v[3] == z and v[4] ~= statement then
            v[4] = statement
            TriggerClientEvent('modifica', -1, v[1],v[2],v[3],v[4])
        end
    end
end)

RegisterServerEvent('modifica')
AddEventHandler('modifica', function(x,y,z,statement)
    for i,v in pairs(locatiievents) do
        if v[1] == x and v[2] == y and v[3] == z and v[4] ~= statement then
            v[4] = false
        end
    end
end)

