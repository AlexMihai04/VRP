incircle = false 
waiting = false

local coordonateasdasdasd = {
    {453.45645141602,-1017.5786132813,28.456174850464,"police.vehicle",1},			--POLITIE
	{361.22589111328,-610.32293701172,28.724630355835,"emergency.vehicle",2},		--EMS
	{-1049.7834472656,-220.29864501954,37.940998077392,"jandarm.vehicle",3},		--JANDARMERIE
	{125.00332641602,-720.39385986328,33.133235931396,"sri.vehicle",4},		--SRI
	{69.852645874023,117.0472946167,79.126907348633,"ups.vehicle",5},
	{-1515.287109375,-933.03759765625,10.027912139893,"pizza.vehicle",6},
	{-229.5894317627,-2646.134765625,6.0002965927124,"repair.vehicle",7},
	{907.38049316406,-175.86546325684,74.130157470703,"uber.vehicle",8},
	{222.68756103516,222.95631408691,105.41331481934,"bankdriver.vehicle",9},
	{768.86297607422,-1410.4896240234,26.502605438232,"trash.vehicle",10},
	{-319.82263183594,-942.8408203125,31.080617904663,"medical.vehicle",11},
	{351.53665161133,-588.73052978516,74.165641784668,"emergency.vehicle",12},
}

RegisterNUICallback('spawnvehsdf', function(data, cb)
	TriggerServerEvent('vRP:spawnvehplamea', data.masina)
	waiting = true
	closeGui()
	cb('ok')
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

-- Open Gui and Focus NUI
function openGui()
	SetNuiFocus(true, true)
	SendNUIMessage({openNUI = true})
end
  
  -- Close Gui and disable NUI
function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({openNUI = false})
end

function garage_DisplayText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function openGui3()
	SetNuiFocus(true, true)
	SendNUIMessage({openNUI3 = true})
end

function openGui4()
	SetNuiFocus(true, true)
	SendNUIMessage({openNUI4 = true})
end

function openGui5()
	SetNuiFocus(true, true)
	SendNUIMessage({openNUI5 = true})
end

function openGui6()
	SetNuiFocus(true, true)
	SendNUIMessage({openNUI6 = true})
end

function openGui7()
	SetNuiFocus(true, true)
	SendNUIMessage({openNUI7 = true})
end

function openGui8()
	SetNuiFocus(true, true)
	SendNUIMessage({openNUI8 = true})
end

function openGui9()
	SetNuiFocus(true, true)
	SendNUIMessage({openNUI9 = true})
end

function openGui10()
	SetNuiFocus(true, true)
	SendNUIMessage({openNUI10 = true})
end

function openGui11()
	SetNuiFocus(true, true)
	SendNUIMessage({openNUI11 = true})
end

function openGui12()
	SetNuiFocus(true, true)
	SendNUIMessage({openNUI12 = true})
end

function openGui13()
	SetNuiFocus(true, true)
	SendNUIMessage({openNUI13 = true})
end

local fontId

Citizen.CreateThread(function()
	RegisterFontFile('lemonmilk')
	fontId = RegisterFontId('Lemon Milk')
end)

function garage1(x,y,z, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*130
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.2*scale, 0.5*scale)
        SetTextFont(fontId)
        SetTextProportional(1)
    SetTextColour( 100, 200, 200, 255 )
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
      World3dToScreen2d(x,y,z, 0) --Added Here
        DrawText(_x,_y)
    end
end


Citizen.CreateThread(function()
	while true do
		local jucator = GetPlayerPed(-1)
        local pos = GetEntityCoords(jucator, true)
		for _,v in pairs(coordonateasdasdasd) do
			x = v[1]
            y = v[2]
            z = v[3]
            if(Vdist(pos.x, pos.y, pos.z, x, y, z) < 20.0)then
				DrawMarker(27, x,y,z-1, 0, 0, 0, 0, 0, 0, 1.0,1.0,0.5, 255,255,255, 200, 0, 0, 2, 0, 0, 0, 0)
				Draw3DText(x,y,z, "Garaj", 1.5)
			end
			if (Vdist(pos.x, pos.y, pos.z, x, y, z) < 2) then
				if (incircle == false) then
					garage_DisplayText("Apasa ~INPUT_CONTEXT~ pentru a deschide Garajul~w~!")
					if IsControlJustPressed(1, 51) then
						TriggerServerEvent('areperms', v[4],v[5])
					end
				end
				incircle = true
			else 
				if (Vdist(pos.x, pos.y, pos.z, x, y, z) > 2) then
					incircle = false
				end
			end
		end
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('aregrad')
AddEventHandler('aregrad', function(numar)
    callgarage(numar)
end)

function callgarage(numar)
	if (IsInVehicle()) then
		TriggerEvent('inmasina')
	else
		if garageOpen then
			closeGui()
			garageOpen = false
		else
		if numar == 1 then
			openGui()
		elseif numar == 2 then
			openGui3()
		elseif numar == 3 then
			openGui4()
		elseif numar == 4 then
			openGui5()
		elseif numar == 5 then
			openGui6()
		elseif numar == 6 then
			openGui7()
		elseif numar == 7 then
			openGui8()
		elseif numar == 8 then
			openGui9()
		elseif numar == 9 then
			openGui10()
		elseif numar == 10 then
			openGui11()
		elseif numar == 11 then
			openGui12()
		elseif numar == 12 then
			openGui13()
		end
		garageOpen = true
		end
	end
end

function IsInVehicle()
	local ply = GetPlayerPed(-1)
	if IsPedSittingInAnyVehicle(ply) then
	  return true
	else
	  return false
	end
end  

RegisterNetEvent('spawnVehiclegarage')
AddEventHandler('spawnVehiclegarage', function(masina)
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        notify('Nu poti face asta cat timp esti intr-o masina!')
    else
        spawnVeh(masina)
    end
end)

function spawnVeh(model)

    local myPed = GetPlayerPed(-1)
    local player = PlayerId()
    local vehicle = GetHashKey(model)
    
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
        Wait(1)
    end
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local spawned_car = CreateVehicle(vehicle, coords, GetEntityHeading(myPed), true, false)
    SetVehicleOnGroundProperly(spawned_car)
    SetVehicleNumberPlateText(spawned_car, "FACTION")
    SetModelAsNoLongerNeeded(vehicle)
    SetPedIntoVehicle(myPed,spawned_car,-1)
    Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(spawned_car))

end

local fontId

Citizen.CreateThread(function()
	RegisterFontFile('lemonmilk')
	fontId = RegisterFontId('Lemon Milk')
end)

function Draw3DText(x,y,z, text,scl) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(fontId)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end