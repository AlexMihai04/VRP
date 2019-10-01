local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")

vRPclient = Tunnel.getInterface("vRP","vrp_blood")

vRP = Proxy.getInterface("vRP")

MySQL.createCommand("vRP/vezinivelsange","SELECT * FROM vrp_users WHERE id = @id")
MySQL.createCommand("vRP/setsange","UPDATE vrp_users SET sange = sange - @sange WHERE id = @id")
MySQL.createCommand("vRP/upsange","UPDATE vrp_users SET sange = sange + @sange WHERE id = @id")

--[[UNCOMMENT WHAT YOU NEED]]

--MySQL.createCommand("vRP/sange_colums","ALTER TABLE vrp_users ADD IF NOT EXISTS sange INT(11) DEFAULT 100")		--[[WINDOWS]]
--MySQL.createCommand("vRP/sange_colums","ALTER TABLE vrp_users ADD sange INT(11) DEFAULT 100")		--[[LINUX : RUN THE SERVER , AFTER YOU RUN IT , COMMENT THE EXECUTE]]
MySQL.execute("vRP/sange_colums")

local function build_menu(source)
	local x, y, z = 241.19776916504,-1373.9774169922,39.534343719482
	local x2, y2, z2 = 246.83427429199,-1378.1258544922,39.53434753418
	local function menu_enter(source,area)
		local user_id = vRP.getUserId({source})
    	if user_id ~= nil then
			recoltare = {name="HOSPITAL DONATE BLOOD",css={top="75px",header_color="rgba(0,200,0,0.75)"}}
			MySQL.query("vRP/vezinivelsange", {id = user_id}, function(rows, affected)
				if #rows > 0 then
					for i, v in pairs(rows) do
						local sange = v.sange
						recoltare["Donate blood"] = {function(player, choice)
							if sange ~= 0 then
								TriggerClientEvent('racolaresange', player, sange)
								vRP.closeMenu({source,recoltare})
							else
								vRPclient.notify(source,{"[ ~g~Blood ~w~] You do not have enough blood to donate in your body !"})
							end
						end, "Donate <font color = 'red'>blood</font>"}
						recoltare["Per liter : 45$ / 1 ML"] = {nothinghere,""}
						recoltare["Blood level : "..sange.." ML"] = {nothinghere,""}
					end
					vRP.openMenu({source,recoltare})
				end
			end)
		end
	end
	local function menu_leave(source,area)
		local user_id = vRP.getUserId({source})
		vRP.closeMenu({source})
	end

	local function menu_enter2(source,area)
		local user_id = vRP.getUserId({source})
    	if user_id ~= nil then
			magazin = {name="BLOOD FARMACY",css={top="75px",header_color="rgba(0,200,0,0.75)"}}
			MySQL.query("vRP/vezinivelsange", {id = user_id}, function(rows, affected)
				if #rows > 0 then
					for i, v in pairs(rows) do
						local sange = v.sange
						magazin["Drink Vitamins"] = {function(player, choice)
							if vRP.tryPayment({user_id,500}) then
								TriggerClientEvent('oprirehalucinatie', player)
								vRP.closeMenu({source})
							else
								vRPclient.notify(source,{"[ ~g~Blood ~w~] You do not have enough money to regenerate 10 ML !"})
								vRP.closeMenu({source})
							end
						end, "Drink <font color = 'red'>vitamins</font> to regenerate <font color = 'red'>10 ML</font> of blood in the body<br>Cost : <font color = 'red'>500$</font>"}
					end
					vRP.openMenu({source,magazin})
				end
			end)
		end
	end

	vRP.setArea({source,"vRP:Sange",x,y,z,2,1.5,menu_enter,menu_leave})
	vRP.setArea({source,"vRP:Bandaje",x2,y2,z2,2,1.5,menu_enter2,menu_leave})
end
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	if first_spawn then
		build_menu(source)
	end
end)

RegisterServerEvent('nivsangeafter')
AddEventHandler('nivsangeafter', function(nivelsange)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	local bani = nivelsange * 45
	MySQL.execute("vRP/setsange", {id = user_id, sange = nivelsange})
	vRPclient.notify(source,{"[ ~g~Sange ~w~] The harvest of sanga is over !"})
	vRP.giveBankMoney({user_id,tonumber(bani)})
	MySQL.query("vRP/vezinivelsange", {id = user_id}, function(rows, affected)
		if #rows > 0 then
			for i, v in pairs(rows) do
				if v.sange <= 10 then
					local sansa = math.random(1,2)
					if sansa == 2 then
						vRPclient.varyHealth(player,{-90})
					end
				end
			end
			vRP.openMenu({source,recoltare})
		end
	end)
end)

RegisterServerEvent('up1')
AddEventHandler('up1', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	MySQL.query("vRP/vezinivelsange", {id = user_id}, function(rows, affected)
		if #rows > 0 then
			for i, v in pairs(rows) do
				if v.sange < 100 then
					MySQL.execute("vRP/upsange", {id = user_id, sange = 1})
				end
			end
		end
	end)
end)