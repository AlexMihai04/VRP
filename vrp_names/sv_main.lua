local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")
ALEXiconclient = Tunnel.getInterface("vrp_namesicon","vrp_namesicon")
vRPclient = Tunnel.getInterface("vRP","vrp_namesicon")
vRP = Proxy.getInterface("vRP")

factions = {
	{"Mecanic", "Mecanic"},
	{"ems","Medic"},
	{"Dealer de droguri","Dealer de droguri"},
	{"Dealer de arme","Dealer de arme"},
	{"Hacker","Hacker"},
	{"Taximetrist","Taximetrist"},
	{"Sofer la banca","Sofer la banca"},
	{"Pizza Hut","Pizza Hut"},
	{"Fan Courier","Fan Courier"},
	{"Transport Medical","Transport Medical"},
	{"Gunoier","Gunoier"},
}

grade = {
	{"superadminss", "superadminss"},
	{"scripterss","scripterss"},
	{"adminss","adminss"},
	{"moderatorss","moderatorss"},
	{"helperss","helperss"}
}

local function update_name(player, user_id, source)
	MySQL.query("vRP/get_table", {id = tonumber(user_id)}, function(rows,affected)
		vRP.getUserIdentity({user_id, function(identity)
			group = "Civil"
			local nume = GetPlayerName(player)
			for i, v in pairs(factions) do
				theGroup = tostring(v[1])
				theName = tostring(v[2])
				if(vRP.hasGroup({user_id, theGroup}))then
					group = theName
				end
			end
			for i, v in pairs(grade) do
				if(vRP.hasGroup({user_id, v[1]}))then
					group = v[1]
				end
			end
			ALEXiconclient.insertUser(player,{user_id,source,identity.firstname .. ' ' .. identity.name,group})
		end})
	end)
end

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn) 
	local users = vRP.getUsers({})
	for k,v in pairs(users) do
		update_name(source,k,v)
		update_name(v,user_id,source)
	end
end)

AddEventHandler("vRP:playerLeave",function(user_id, source)
	local users = vRP.getUsers({})
	for k,v in pairs(users) do
		ALEXiconclient.removeUser(v,{user_id})
	end
end)

RegisterServerEvent('reuploadgrade')
AddEventHandler('reuploadgrade', function(sansa)
	local users = vRP.getUsers({})
	local user_id = vRP.getUserId({source})
	for k,v in pairs(users) do
		update_name(source,k,v)
		update_name(v,user_id,source)
	end
end)