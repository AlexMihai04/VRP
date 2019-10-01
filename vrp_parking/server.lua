local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")

vRPclient = Tunnel.getInterface("vRP","vrp_parking")
vRP = Proxy.getInterface("vRP")
vRPnc = Proxy.getInterface("vRP_newcoin")
vRPbm = Proxy.getInterface("vrp_basic_menu")

MySQL.createCommand("vRP/parking_table","ALTER TABLE vrp_users ADD IF NOT EXISTS position_x FLOAT DEFAULT 0, ADD IF NOT EXISTS position_y FLOAT DEFAULT 0, ADD IF NOT EXISTS position_z FLOAT DEFAULT 0, ADD IF NOT EXISTS heading FLOAT DEFAULT 0")

MySQL.createCommand("vRP/parcheaza", "UPDATE vrp_user_vehicles SET heading = @heading, position_x = @position_x, position_y = @position_y, position_z = @position_z WHERE vehicle_plate = @vehicle_plate")
MySQL.createCommand("vRP/impound", "UPDATE vrp_user_vehicles SET impound = @impound WHERE vehicle_plate = @vehicle_plate")
MySQL.createCommand("vRP/upgrades","SELECT upgrades FROM vrp_user_vehicles WHERE vehicle_plate = @vehicle_plate AND upgrades IS NOT NULL")
MySQL.createCommand("vRP/select_pos", "SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id")
MySQL.createCommand("vRP/verificamasina", "SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle_plate = @vehicle_plate")
MySQL.createCommand("vRP/sell_veh","UPDATE vrp_user_vehicles SET user_id = @user_id WHERE vehicle_plate = @vehicle_plate")

MySQL.execute("vRP/parking_table")

RegisterServerEvent('mesajasdasdasd')
AddEventHandler('mesajasdasdasd', function(numar)
  if numar == 0 then
    TriggerClientEvent('chatMessage', -1, "^0[ ^2Parking ^0] In 20 de secunde o sa fie sterse si respawnate masinile")
  else
    TriggerClientEvent('chatMessage', -1, "^0[ ^2Parking ^0] Toate masinile au fost sterse si respawnate")
  end
end)

RegisterServerEvent('delcarsnotused')
AddEventHandler('delcarsnotused', function(plate)
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  if plate ~= nil then
    MySQL.query("vRP/select_pos", {user_id = user_id}, function(result, affected)
        for i,v in pairs(result) do
          if result[i].position_x ~= 0 and result[i].position_y ~= 0 and result[i].position_z ~= 0 and result[i].heading ~= 0 and plate == result[i].vehicle_plate then
            print("Masina " .. result[i].vehicle .. " ".. result[i].vehicle_plate .. " lui " .. user_id .. " s-a spawnat la x = " .. result[i].position_x .. " y = " .. result[i].position_y .. " z = " .. result[i].position_z .. " h = " .. result[i].heading)
            TriggerClientEvent('spawnVehicle', player, result[i].vehicle, result[i].position_x, result[i].position_y, result[i].position_z, result[i].heading, result[i].vehicle_plate)
          end
        end
    end)
  end
end)

RegisterCommand("vehicles", function(source, args)
  local user_id = vRP.getUserId({source})
  if vRP.hasGroup({user_id,"superadminss"}) or vRP.hasGroup({user_id,"scripterss"}) then
    MySQL.query("vRP/select_pos", {user_id = user_id}, function(result, affected)
      for i,v in pairs(result) do
        if result[i].position_x ~= 0 and result[i].position_y ~= 0 and result[i].position_z ~= 0 and result[i].heading ~= 0 then
          if result[i].impound ~= 1 then
            --print("Masina " .. result[i].vehicle .. " ".. result[i].vehicle_plate .. " lui " .. user_id .. " s-a spawnat la x = " .. result[i].position_x .. " y = " .. result[i].position_y .. " z = " .. result[i].position_z .. " h = " .. result[i].heading)
            TriggerClientEvent('spawnVehicle', source, result[i].vehicle, result[i].position_x, result[i].position_y, result[i].position_z, result[i].heading, result[i].vehicle_plate)
            --print(result[i].position_x,result[i].position_y,result[i].position_z)
          end
        else
          --print("Masina " .. result[i].vehicle .. " ".. result[i].vehicle_plate .. " lui " .. user_id .. " s-a spawnat la x = " .. result[i].position_x .. " y = " .. result[i].position_y .. " z = " .. result[i].position_z .. " h = " .. result[i].heading)
          TriggerClientEvent('spawnVehicle', source, result[i].vehicle, -56.3146, -1117.06, 25.6109, 184.069, result[i].vehicle_plate)
        end
      end
    end)
  end
end)


RegisterServerEvent("requestMods")
AddEventHandler("requestMods", function(nveh,vehicle_plate)

  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  if vehicle_plate ~= nil then
    MySQL.query("vRP/upgrades", {vehicle_plate = vehicle_plate}, function(rows, affected)
      if #rows > 0 then
        TriggerClientEvent("setMods", player, nveh, rows[1].upgrades)
      end
    end)
  end
end)

function park(player,choice)
  TriggerClientEvent('parking_client', player)
end

RegisterServerEvent('parking')
AddEventHandler('parking', function(vehicle_plate,heading,position_x,position_y,position_z)
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  local plate = vehicle_plate
  if plate ~= nil then
    MySQL.query("vRP/verificamasina", {user_id = user_id, vehicle_plate = plate}, function(rows,affected)
      if #rows > 0 then
          MySQL.execute("vRP/parcheaza", {heading = heading, position_x = position_x, position_y = position_y, position_z = position_z, vehicle_plate = plate})
          vRPclient.notify(player, {"~w~[PARKING~w~] Ai parcat masina cu succes !"})
      else
        vRPclient.notify(player, {"~w~[PARKING~w~] Nu detii aceasta masina !"})
      end
    end)
  end
end)

function parkrepair(player,choice)
  TriggerClientEvent('parking_clientrepair', player)
end

RegisterServerEvent('parkingrepair')
AddEventHandler('parkingrepair', function(plate,heading,position_x,position_y,position_z)
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  local plate = vehicle_plate
  if plate ~= nil then
    MySQL.execute("vRP/parcheaza", {heading = heading, position_x = position_x, position_y = position_y, position_z = position_z, vehicle_plate = plate})
    vRPclient.notify(player, {"~w~[PARKING~w~] Ai parcat masina cu succes !"})
  end
end)

function sell(player,choice)
  TriggerClientEvent("sellveh", player)
end

RegisterServerEvent('sendsell')
AddEventHandler('sendsell', function(vehicle_plate,vehicle)
  local user_idd = vRP.getUserId({source})
  local player = vRP.getUserSource({user_idd})
  local plate = vehicle_plate
  if plate ~= nil then
    MySQL.query("vRP/verificamasina", {user_id = user_idd, vehicle_plate = plate}, function(rows,affected)
      if #rows > 0 then
        vRP.prompt({player, "USER ID : ", "", function(player, user_id)
          user_id = tonumber(user_id)
          local target = vRP.getUserSource({user_id})
          if target ~= nil then
            vRP.prompt({player, "CU CAT : ", "", function(player, amount)
              suma = tonumber(amount)
              if suma >= 0 then
                vRP.request({target,GetPlayerName(player).." vrea sa iti vanda masina in care el este acum cu : " ..suma.."$ , accepti ?", 10, function(target,ok)
                  if ok then
                    local money = tonumber(vRP.getMoney({user_id}))
                    if money >= suma then
                      vRP.tryPayment({user_id,suma})
                      vRP.giveMoney({user_idd,suma})
                      vRPclient.notify(player, {"~w~[PARKING~w~] Ai vandut masina cu succes !"})
                      vRPclient.notify(target, {"~w~[PARKING~w~] A cumparat masina cu succes !"})
                      MySQL.execute("vRP/sell_veh", {user_id = user_id, vehicle_plate = vehicle_plate})
                    else
                      vRPclient.notify(target, {"~w~[PARKING~w~] Nu ai suficienti bani pentru a plati masina !"})
                    end
                  else
                    vRPclient.notify(player, {"~w~[PARKING~w~] A refuzat cererea !"})
                    vRPclient.notify(target, {"~w~[PARKING~w~] Ai refuzat cererea !"})
                  end
                end})
              end
            end})
          else
            vRPclient.notify(player, {"~w~[PARKING~w~] Jucatorul nu este pe server !"})
          end
        end})
      end
    end)
  end
end)

function sellbtc(player,choice)
  TriggerClientEvent("sellvehbtc", player)
end

RegisterServerEvent('sendsellbtc')
AddEventHandler('sendsellbtc', function(vehicle_plate,vehicle)
  local user_idd = vRP.getUserId({source})
  local player = vRP.getUserSource({user_idd})
  local plate = vehicle_plate
  if vehicle_plate ~= nil then
    MySQL.query("vRP/verificamasina", {user_id = user_idd, vehicle_plate = plate}, function(rows,affected)
      if #rows > 0 then
        vRP.prompt({player, "USER ID : ", "", function(player, user_id)
          user_id = tonumber(user_id)
          local target = vRP.getUserSource({user_id})
          if target ~= nil then
            vRP.prompt({player, "CU CAT : ", "", function(player, amount)
              suma = tonumber(amount)
              if suma > 0 then
                vRP.request({target,GetPlayerName(player).." vrea sa iti vanda masina in care el este acum cu : " ..suma.." BitCoin , accepti ?", 10, function(target,ok)
                  if ok then
                    local money = tonumber(vRPnc.getCoins({user_id}))
                    if money >= suma then
                      vRPnc.giveCoins({user_idd, suma})
                      vRPnc.takeCoins({user_id, suma})
                      vRPclient.notify(player, {"~w~[PARKING~w~] Ai vandut masina cu succes pentru "..suma.." BitCoin ~w~!"})
                      vRPclient.notify(target, {"~w~[PARKING~w~] A cumparat masina cu succes pentru : "..suma.." BitCoin ~w~!"})
                      MySQL.execute("vRP/sell_veh", {user_id = user_id, vehicle_plate = vehicle_plate})
                    else
                      vRPclient.notify(target, {"~w~[PARKING~w~] Nu ai suficienti BitCoin pentru a plati masina !"})
                    end
                  else
                    vRPclient.notify(player, {"~w~[PARKING~w~] A refuzat cererea !"})
                    vRPclient.notify(target, {"~w~[PARKING~w~] Ai refuzat cererea !"})
                  end
                end})
              end
            end})
          else
            vRPclient.notify(player, {"~w~[PARKING~w~] Jucatorul nu este pe server !"})
          end
        end})
      end
    end)
  end
end)

local function ch_repair(player,choice)
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    -- anim and repair
    if vRP.tryGetInventoryItem({user_id,"repairkit",1,true}) then
      vRPclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
      SetTimeout(15000, function()
        vRPclient.fixeNearestVehicle({player,{7}})
        vRPclient.stopAnim({player,{false}})
      end)
    end
  end
end

RegisterCommand("portbagaj", function(source, args)
  TriggerClientEvent('portbagaj', source)
end)

function portbagaj(player,choice)
  TriggerClientEvent('portbagaj', player)
end

function locatiimas(player,choice)
  TriggerClientEvent('blipsmasini', player)
end


RegisterServerEvent('portbagaj')
AddEventHandler('portbagaj', function(vehicle_plate)
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  local plate = vehicle_plate
  if vehicle_plate ~= nil then
    MySQL.query("vRP/verificamasina", {user_id = user_id, vehicle_plate = plate}, function(rows,affected)
      if #rows > 0 then
        strng = vehicle_plate:gsub("%s+", "")
        vRP.openChest({player, "u"..user_id.."veh_"..string.lower(strng),200})
      end
    end)
  end
end)

local function meniumasina(player,choice)
	vRP.buildMenu({"Vehicul", {player = player}, function(menu)
			menu.name = "Vehicul"
			menu.css={top="75px",header_color="rgba(0,200,0,0.75)"}
			menu.onclose = function(player) vRP.closeMenu({player}) end
      menu["Parcheaza masina"] = {park, "Parcheaza <font color='green'>masina</font> !"}
      menu["Vinde masina bani"] = {sell, "Vinde <font color='green'>masina</font> unui jucator <br>pentru o suma de <font color='yellow'>bani</font> "}
      menu["Vinde masina BitCoin"] = {sellbtc, "Vinde <font color='green'>masina</font> unui jucator <br>pentru o suma de <font color='yellow'>BitCoin</font>!"}
      menu["Portbagaj"] = {portbagaj, "Deschide portbagajul <font color='green'>masinii</font> tale!"}
      --menu["Locatii Vehicule Personale"] = {locatiimas, "Arata locatia <font color='green'>mainilor</font> tale personale !"}
    vRP.openMenu({player,menu})
	end})
end

local function meniurepair(player,choice)
	vRP.buildMenu({"Repair", {player = player}, function(menu)
			menu.name = "Repair"
			menu.css={top="75px",header_color="rgba(0,200,0,0.75)"}
			menu.onclose = function(player) vRP.closeMenu({player}) end
      menu["Parcheaza masina"] = {parkrepair, "Parcheaza <font color='green'>masina</font> prost lasata !"}
      menu["Repara masina"] = {ch_repair, "Vinde <font color='green'>masina</font> unui jucator <br>pentru o suma de <font color='yellow'>bani</font> "}
		vRP.openMenu({player,menu})
	end})
end

vRP.registerMenuBuilder({"main", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		local choices = {}
		choices["Vehicul"] = {meniumasina, "Deschide meniul pentru <font color='green'>masina</font> ta !<img src='https://i.imgur.com/NpLUhge.png' height='100' width='100' />"}
    if vRP.hasPermission({user_id, "vehicle.repair"}) then
      choices["Meniu Mecanic"] = {meniurepair, "<font color = 'yellow'>Mecanic </font>menu"}
    end  
    add(choices)
    end
end})

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
  local user_id = vRP.getUserId({source})

  if first_spawn then
    
    MySQL.query("vRP/select_pos", {user_id = user_id}, function(result, affected)
      for i,v in pairs(result) do
        if result[i].position_x ~= 0 and result[i].position_y ~= 0 and result[i].position_z ~= 0 and result[i].heading ~= 0 then
          if result[i].impound ~= 1 then
            --print("Masina " .. result[i].vehicle .. " ".. result[i].vehicle_plate .. " lui " .. user_id .. " s-a spawnat la x = " .. result[i].position_x .. " y = " .. result[i].position_y .. " z = " .. result[i].position_z .. " h = " .. result[i].heading)
            TriggerClientEvent('spawnVehicle', source, result[i].vehicle, result[i].position_x, result[i].position_y, result[i].position_z, result[i].heading, result[i].vehicle_plate)
            --print(result[i].position_x,result[i].position_y,result[i].position_z)
          end
        else
          --print("Masina " .. result[i].vehicle .. " ".. result[i].vehicle_plate .. " lui " .. user_id .. " s-a spawnat la x = " .. result[i].position_x .. " y = " .. result[i].position_y .. " z = " .. result[i].position_z .. " h = " .. result[i].heading)
          TriggerClientEvent('spawnVehicle', source, result[i].vehicle, -56.3146, -1117.06, 25.6109, 184.069, result[i].vehicle_plate)
        end
      end
    end)
  end
end)
