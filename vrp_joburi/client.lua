incircle = false 
waiting = false

local coordonateasdasdasd = {
	{-1065.4376220703,-1162.3707275391,1.1585967540741,"Ofiter","ig_claypain",0x9D0087A8,570.77}        --ILLEGAL
}

Citizen.CreateThread(function()
    for i,v in pairs(coordonateasdasdasd) do
        if v[8] ~= nil then
            local blip = AddBlipForCoord(v[1],v[2],v[3])
            SetBlipSprite(blip, v[8])
            SetBlipScale(blip, 1.2)
            SetBlipColour(blip, 2)
            SetBlipAsShortRange(blip, true)
            
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("~g~[ ~w~JOB : "..v[4].." ~g~]")
            EndTextCommandSetBlipName(blip)
        end
	end
end)

 Citizen.CreateThread(function()
    while true do
        for _,v in pairs(coordonateasdasdasd) do
            RequestModel(GetHashKey(v[5]))
            while not HasModelLoaded(GetHashKey(v[5])) do
            Wait(1)
            end
        
            --[[RequestAnimDict("mini@strip_club@idles@bouncer@base")
            while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
            Wait(1)
            end--]]

            local ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
            SetEntityHeading(ped, v[7])
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
        end
        Citizen.Wait(300000)
    end
end)

RegisterNUICallback('angajeaza', function(data, cb)
	TriggerServerEvent('angajeaza', data.jobulica)
	waiting = true
	closeGui()
	cb('ok')
end)

RegisterNUICallback('demisioneaza', function(data, cb)
	TriggerServerEvent('demisioneaza', data.jobulica)
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
function openGui(job)
	SetNuiFocus(true, true)
	SendNUIMessage({openNUI = true})
	SendNUIMessage({jobes = job})
end
  
  -- Close Gui and disable NUI
function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({openNUI = false})
end

function job_display(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
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
				Draw3DText(v[1],v[2],v[3]+0.10, "~g~[ ~w~Hai la mine sa devii un : "..v[4].." ~g~]", 0.05, 0.05)
                Draw3DText(v[1],v[2],v[3]+0.25, "~g~[ ~w~Salut frate , vrei sa faci bani seriosi ? ~g~]", 0.05, 0.05)
			end
			if (Vdist(pos.x, pos.y, pos.z, x, y, z) < 2) then
				Draw3DText(pos.x, pos.y, pos.z-1.0, "~g~[ ~w~Apasa ~g~E ~g~]", 0.05, 0.05)
				if IsControlJustPressed(1, 51) then
					openGui(v[4])
				end
			end
		end
		Citizen.Wait(0)
	end
end)

function Draw3DText(x,y,z,textInput,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov   
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(1)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
end