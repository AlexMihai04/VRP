masini = {}

RegisterNetEvent('parking_client')
AddEventHandler('parking_client', function()

  local ped = GetPlayerPed(-1)
  local veh = GetVehiclePedIsIn(ped,false)


  local coords = GetEntityCoords(veh)
  local heading = GetEntityHeading(veh)

  local veh_plate = GetVehicleNumberPlateText(veh)
  TriggerServerEvent('parking', veh_plate,heading,coords.x,coords.y,coords.z)
end)

RegisterNetEvent('parking_clientrepair')
AddEventHandler('parking_clientrepair', function()

  local ped = GetPlayerPed(-1)
  local veh = GetVehiclePedIsIn(ped,false)


  local coords = GetEntityCoords(veh)
  local heading = GetEntityHeading(veh)

  local veh_plate = GetVehicleNumberPlateText(veh)
  TriggerServerEvent('parkingrepair', veh_plate,heading,coords.x,coords.y,coords.z)
end)

RegisterNetEvent('spawnVehicle')
AddEventHandler('spawnVehicle', function(name, x, y, z, heading, vehicle_plate)
	Citizen.CreateThread(function()
    local mhash = GetHashKey(name)

	
		RequestModel(mhash)

    local i = 0
    while not HasModelLoaded(mhash) and i < 10000 do
      Citizen.Wait(10)
      i = i+1
	end

    if HasModelLoaded(mhash) then
      	local nveh = CreateVehicle(mhash, x, y, z+0.5, heading, true, true)
		local blip = AddBlipForEntity(nveh)
		table.insert( masini, nveh )	--table
		SetBlipSprite(blip, 326)
		SetBlipAsShortRange(blip, true)
		SetBlipColour(blip,39)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Personal Vehicle ["..name.."]")
		EndTextCommandSetBlipName(blip)
		print(x.. " " ..y.. " " ..z.. " " ..heading.. " " ..name.. " " ..vehicle_plate)
		SetVehicleOnGroundProperly(nveh)
		SetEntityInvincible(nveh,false)
		SetVehicleNumberPlateText(nveh, vehicle_plate)
		TriggerServerEvent("requestMods", nveh, vehicle_plate)
		Citizen.InvokeNative(0xAD738C3085FE7E11, nveh, true, true) -- set as mission entity
		SetVehicleHasBeenOwnedByPlayer(nveh,true)
		vehicle_migration = false
      	if not vehicle_migration then
			local nid = NetworkGetNetworkIdFromEntity(nveh)
			SetNetworkIdCanMigrate(nid,false)
		end
    end
	end)
end)


RegisterNetEvent('sellveh')
AddEventHandler('sellveh', function()
	local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	local hash = GetHashKey(GetPlayerPed(-1), false)
	TriggerServerEvent("sendsell", plate, vehicle, hash)
end)

RegisterNetEvent('sellvehbtc')
AddEventHandler('sellvehbtc', function()
	local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	local hash = GetHashKey(GetPlayerPed(-1), false)
	TriggerServerEvent("sendsellbtc", plate, vehicle, hash)
end)

RegisterNetEvent('portbagaj')
AddEventHandler('portbagaj', function()
	local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	TriggerServerEvent("portbagaj", plate)
end)


RegisterNetEvent("setMods")
AddEventHandler("setMods",function(veh, mods)
	local a = string.find(mods, ":")
	local ct = 0
	SetVehicleModKit(veh,0)
	while mods ~= nil do
		local b
		if a ~= nil then
			b = mods:sub(0,a-1)
			mods = mods:sub(a+1)
			a = string.find(mods, ":")
		else
			b = mods
			mods = nil
		end
		local u = string.find(b, ",")
		if ct == 0 then
			local u1 = b:sub(0,u-1)
			local u2 = b:sub(u+1)
			SetVehicleColours(veh,tonumber(u1),tonumber(u2))
		elseif ct == 1 then
			local u1 = b:sub(0,u-1)
			local u2 = b:sub(u+1)
			SetVehicleExtraColours(veh,tonumber(u1),tonumber(u2))
		elseif ct == 2 then
			local u1 = b:sub(0,u-1)
			local u2 = b:sub(u+1)
			local spl = string.find(u2, ",")
			local u3 = u2:sub(spl+1)
			u2 = u2:sub(0,spl-1)
			SetVehicleNeonLightsColour(veh,tonumber(u1),tonumber(u2),tonumber(u3))
		elseif ct == 3 then
			local bl = false
			if tostring(b) == "true" then bl = true end
			SetVehicleNeonLightEnabled(veh,0,bl)
			SetVehicleNeonLightEnabled(veh,1,bl)
			SetVehicleNeonLightEnabled(veh,2,bl)
			SetVehicleNeonLightEnabled(veh,3,bl)
		elseif ct == 4 then
			local u1 = b:sub(0,u-1)
			local u2 = b:sub(u+1)
			local spl = string.find(u2, ",")
			local u3 = u2:sub(spl+1)
			u2 = u2:sub(0,spl-1)
			SetVehicleTyreSmokeColor(veh,tonumber(u1),tonumber(u2),tonumber(u3))
		elseif ct == 5 then
			SetVehicleNumberPlateTextIndex(veh,tonumber(b))
		elseif ct == 6 then
			SetVehicleWindowTint(veh,tonumber(b))
		elseif ct == 7 then
			SetVehicleWheelType(veh,tonumber(b))
		elseif ct == 8 then
			local bl = false
			if tostring(b) == "true" then bl = true end
			SetVehicleTyresCanBurst(veh,bl)
		elseif ct == 9 then
			local c = string.find(b, ";")
			while b ~= nil do
				local d
				if c ~= nil then
					d = b:sub(0,c-1)
					b = b:sub(c+1)
					c = string.find(b, ";")
				else
					d = b
					b = nil
				end
				
				if d ~= nil then
					local u = string.find(d, ",")
					local u1 = d:sub(0,u-1)
					local u2 = d:sub(u+1)
					local spl = string.find(u2, ",")
					local u3 = u2:sub(spl+1)
					u2 = u2:sub(0,spl-1)
					local bl = false
					if tostring(u3) == "true" then bl = true end
					if tonumber(u1) == 18 or tonumber(u1) == 22  or tonumber(u1) == 20 then
						ToggleVehicleMod(veh,tonumber(u1),bl)
						SetVehicleMod(veh,tonumber(u1),tonumber(u2),bl)
					else
						SetVehicleMod(veh,tonumber(u1),tonumber(u2),bl)
					end
				end
			end
		end
		ct = ct+1
	end
end)


checkTime = 30 --Minutes
deleteTime = 20 --Seconds

local enumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

local function getEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end
    
		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, enumerator)
    
		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next
  
		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function getVehicles()
	return getEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function RepeatDelete()
	Wait(checkTime * 60000)
	SetTimeout(deleteTime * 1000, function()
		for i,v in pairs(masini) do
			if ( DoesEntityExist( v ) ) then 
				if((GetPedInVehicleSeat(v, -1)) == false) or ((GetPedInVehicleSeat(v, -1)) == nil) or ((GetPedInVehicleSeat(v, -1)) == 0) then
					local placuteasd = GetVehicleNumberPlateText(v)
					DeleteVehicle(v)
					TriggerServerEvent("delcarsnotused", placuteasd)
				end
			end
		end
	end)
	RepeatDelete()
end

Citizen.CreateThread(function()
	RepeatDelete()
end)