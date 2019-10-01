----------------------------------------------------------------------
--				   SCRIPT MADE BY ALEXMIHAI04						--
--				     SCRIPT NAME : VRP_LEVEL						--
--			  DO NOT TRY TO SELL OR REPOST THIS SCRIPT				--
----------------------------------------------------------------------


MySQL = module("vrp_mysql", "MySQL")
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPlvl = {}

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_level")


------------------------------------------------------------------------------------------------------------------------------------SQL CODE
MySQL.createCommand("vRP/tabel_level","ALTER TABLE vrp_users ADD level INTEGER DEFAULT 1, ADD experience INTEGER DEFAULT 0")

MySQL.createCommand("vRP/xpup","UPDATE vrp_users SET experience=experience+1 WHERE id=@id")
MySQL.createCommand("vRP/levelup","UPDATE vrp_users SET level=level+1 WHERE id=@id")
MySQL.createCommand("vRP/setxp","UPDATE vrp_users SET experience=@experience WHERE id=@id")
MySQL.createCommand("vRP/setlvl","UPDATE vrp_users SET level=@level WHERE id=@id")
MySQL.createCommand("vRP/givexp","UPDATE vrp_users SET experience=experience+@experience WHERE id=@id")
MySQL.createCommand("vRP/givelvl","UPDATE vrp_users SET level=level+@level WHERE id=@id")
MySQL.createCommand("vRP/get_table","SELECT * FROM vrp_users WHERE id=@id")

--MySQL.execute("vRP/tabel_level")
------------------------------------------------------------------------------------------------------------------------------------PAYDAY XP
RegisterServerEvent('paydayxp')
AddEventHandler('paydayxp', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})

	if user_id ~= nil then
		MySQL.execute("vRP/xpup", {id = user_id})

		MySQL.query("vRP/get_table", {id = user_id}, function(rows,affected)
			level = rows[1].level
			experience = rows[1].experience
			local bonus = level*100	--VALOARE BONUS

			TriggerClientEvent("levelup", player, bonus, level)
			--VERIFICA CE LEVEL ARE PENTRU A PRIMI BANI BONUS
			if level > 3 then
				vRPclient.notify(source,{"~w~[~g~LEVEL~w~] You have level ~g~[~w~"..level.."~g~] ~w~and you got a bonus of ~g~[~w~ "..bonus.." $~g~]~w~ at the salary!"})
				vRP.giveBankMoney({user_id,bonus})
			end
		end)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------LEVEL UP
function levelup(player)
	local user_id = vRP.getUserId({player})

	if user_id ~= nil then
		MySQL.query("vRP/get_table", {id = user_id}, function(rows,affected)
			lvl = rows[1].level
			xp = rows[1].experience
			nevoiexp = lvl*2
			cost = lvl*100 + 5000



			if xp >= nevoiexp then
				if vRP.tryPayment({user_id,cost}) then
					experienta = xp - nevoiexp
					MySQL.query("vRP/levelup", {id = user_id})
					MySQL.query("vRP/setxp", {experience = experienta, id = user_id})
					vRPclient.notify(player, {"~w~[~g~LEVEL~w~] Congratulations, you upgraded to level : ~g~"..(lvl+1)})
				else
					vRPclient.notify(player, {"~w~[~g~LEVEL~w~] You don't have enough money to level up"})
				end
			else
				vRPclient.notify(player, {"~w~[~g~LEVEL~w~] You don't have enough xp to level up"})
			end
		end)
	end
end
------------------------------------------------------------------------------------------------------------------------------------GIVE XP
function givexp(user_id,value)
	if user_id ~= nil then
		MySQL.execute("vRP/givexp", {experience = value, id = user_id})
	end
end

local function menu_givexp(player,choice)
	vRP.prompt({player, "USER ID : ", "", function(player, user_id)
		user_id = tonumber(user_id)
		local target = vRP.getUserSource({user_id})
		if target ~= nil then
			vRP.prompt({player, "Number : ", "", function(player, xp)
				xp = tonumber(xp)
				if xp > 0 then
					givexp(user_id,xp)
					vRPclient.notify(player, {"~w~[~g~LEVEL~w~] You gave ~g~"..GetPlayerName(target).."~w~, ~g~"..xp.." ~g~XP~w~!"})
					vRPclient.notify(target, {"~w~[~g~LEVEL~w~] ~g~"..GetPlayerName(player).."~w~ gave you ~g~"..xp.." XP~w~!"})
				else
					vRP.notify(player, {"~w~[~g~LEVEL~w~] Invalid value"})
				end
			end})
		else
			vRPclient.notify(player, {"~w~[~g~LEVEL~w~] Offline!"})
		end
	end})
end
------------------------------------------------------------------------------------------------------------------------------------TAKE XP
function takexp(user_id,value)
	local player = vRP.getUserSource({user_id})
	if user_id ~= nil then
		MySQL.query("vRP/givexp", {experience = (0-value), id = user_id})
		vRPclient.notify(player, {"~w~[~g~LEVEL~w~] ~w~Now you have : ~g~ "..value.."~w~!"})
	end
end

local function menu_takexp(player,choice)
	vRP.prompt({player, "USER ID : ", "", function(player, user_id)
		user_id = tonumber(user_id)
		local target = vRP.getUserSource({user_id})
		if target ~= nil then
			vRP.prompt({player, "NUMAR : ", "", function(player, xp)
				xp = tonumber(xp)
				if xp > 0 then
					takexp(user_id,xp)
					vRPclient.notify(player, {"~w~[~g~LEVEL~w~] You took from :? ~g~"..GetPlayerName(target).."~w~, ~g~"..xp.." ~g~XP~w~!"})
					vRPclient.notify(target, {"~w~[~g~LEVEL~w~] ~g~"..GetPlayerName(player).."~w~ took from you ~g~"..xp.." XP~w~!"})
				else
					vRP.notify(player, {"~w~[~g~LEVEL~w~] Invalid!"})
				end
			end})
		else
			vRPclient.notify(player, {"~w~[~g~LEVEL~w~] Offline!"})
		end
	end})
end
------------------------------------------------------------------------------------------------------------------------------------SET LEVEL
function setlevel(user_id,value)
	local player = vRP.getUserSource({user_id})
	if user_id ~= nil then
		MySQL.execute("vRP/setlvl", {level = value, id = user_id})
		vRPclient.notify(player, {"~w~[~g~LEVEL~w~] ~w~Now you have ~g~ "..value.."~w~!"})
	end
end

local function menu_setlevel(player,choice)
	vRP.prompt({player, "USER ID : ", "", function(player, user_id)
		user_id = tonumber(user_id)
		local target = vRP.getUserSource({user_id})
		if target ~= nil then
			vRP.prompt({player, "Number : ", "", function(player, level)
				level = tonumber(level)
				if level > 0 then
					setlevel(user_id,level)
					vRPclient.notify(player, {"~w~[~g~LEVEL~w~] You set ~g~"..GetPlayerName(target).."~w~ level at : ~g~"..level.." ~g~level~w~!"})
					vRPclient.notify(target, {"~w~[~g~LEVEL~w~] ~g~"..GetPlayerName(player).."~w~ setted your level at :  ~g~"..level.." level~w~!"})
				else
					vRP.notify(player, {"~w~[~g~LEVEL~w~] Invalid!"})
				end
			end})
		else
			vRPclient.notify(player, {"~w~[~g~LEVEL~w~] Offline!"})
		end
	end})
end
-----------------------------------------------------------------------------------------------------------------------------------PAY
function givelvl(user_id,value)
	if user_id ~= nil then
		MySQL.execute("vRP/givelvl", {level = value, id = user_id})
	end
end
------------------------------------------------------------------------------------------------------------------------------------MENIU XP NORMAL
local function xpmenu(player,choice)
	local id = vRP.getUserId({player})
	MySQL.query("vRP/get_table", {id = id}, function(rows,affected)
		lvl = rows[1].level
		xp = rows[1].experience
		cost = lvl*1000 + 5000
		nevoiexp = lvl*2
		vRP.buildMenu({"LEVEL", {player = player}, function(menu)
			menu.name = "LEVEL"
			menu.css={top="75px",header_color="rgba(0,200,0,0.75)"}
			menu.onclose = function(player) vRP.closeMenu({player}) end
			menu["LEVEL UP"] = {levelup, ""}
			menu["INFO"] = {levelup, ""}
		vRP.openMenu({player,menu})
		end})
	end)
end
------------------------------------------------------------------------------------------------------------------------------------MENIU XP ADMIN
local function leveladmin(player,choice)
	vRP.buildMenu({"Admin level", {player = player}, function(menu)
			menu.name = "Admin level"
			menu.css={top="75px",header_color="rgba(0,200,0,0.75)"}
			menu.onclose = function(player) vRP.closeMenu({player}) end
			menu["Give XP"] = {menu_givexp, ""}
			menu["Confiscate xp"] = {menu_takexp, ""}
			menu["Set level"] = {menu_setlevel,""}
		vRP.openMenu({player,menu})
	end})
end


vRP.registerMenuBuilder({"main", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		local choices = {}
		choices["LEVEL Player"] = {xpmenu, ""}
		if(vRP.hasPermission({user_id, "level.admin"}))then		--MENIU XP ADMIN
			choices["LEVEL ADMIN"] = {leveladmin, ""}
		end
	    add(choices)
    end
end})