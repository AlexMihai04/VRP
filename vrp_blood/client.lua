
local fontId
local sange = false
local sangulic = false

local coordonate = {
    {241.08163452148,-1373.2062988281,38.534343719482,530.77,"s_m_m_doctor_01"},
    {246.83427429199,-1378.1258544922,38.53434753418,470.77,"s_m_m_doctor_01"}
}

Citizen.CreateThread(function()
    while true do
        for _,v in pairs(coordonate) do
            local model = RequestModel(GetHashKey(v[5]))
            while not HasModelLoaded(GetHashKey(v[5])) do
                Wait(1)
            end

            local ped =  CreatePed(4, model,v[1],v[2],v[3], 3374176, false, true)
            SetEntityHeading(ped, v[4])
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
        end
        Citizen.Wait(300000) --[[UNCOMMENT IF YOU ARE USING HG_ANTICHEAT]]
    end
end)

Citizen.CreateThread(function()
    while true do
        local jucator = GetPlayerPed(-1)
        local pos = GetEntityCoords(jucator, true)
        for _,v in pairs(coordonate) do
            x = v[1]
            y = v[2]
            z = v[3]
            if(Vdist(pos.x, pos.y, pos.z, x, y, z) < 20.0)then
                if v[1] == 241.08163452148 then
                    Draw3DText(v[1],v[2],v[3]+0.10, "~g~[ ~w~Hospital ~g~]", 0.05, 0.05)
                    Draw3DText(v[1],v[2],v[3], "~g~[ ~w~Hello , do you want to donate blood ? ~g~]", 0.05, 0.05)
                    Draw3DText(v[1],v[2],v[3]-0.10, "~g~[ ~w~Be carefull , if you blood is under 10 ML , you can die ~g~]", 0.03, 0.03)
                elseif v[1] == 246.83427429199 then
                    Draw3DText(v[1],v[2],v[3], "~g~[ ~w~Pharmacy ~g~]", 0.05, 0.05)
                end
            end
        end
        Citizen.Wait(0)
    end
end)

function playScreenEffect(name)
    StartScreenEffect(name, 0, true)
end
  
  -- stop a screen effect
  -- name, see https://wiki.fivem.net/wiki/Screen_Effects
function stopScreenEffect(name)
    StopScreenEffect(name)
end
  
  -- MOVEMENT CLIPSET
function playMovement(clipset,blur,drunk,fade,clear)
--request anim
RequestAnimSet(clipset)
while not HasAnimSetLoaded(clipset) do
    Citizen.Wait(0)
end
-- fade out
if fade then
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
end
-- clear tasks
if clear then
    ClearPedTasksImmediately(GetPlayerPed(-1))
end
-- set timecycle
SetTimecycleModifier("spectator5")
-- set blur
if blur then 
    SetPedMotionBlur(GetPlayerPed(-1), true) 
end
-- set movement
SetPedMovementClipset(GetPlayerPed(-1), clipset, true)
-- set drunk
if drunk then
    SetPedIsDrunk(GetPlayerPed(-1), true)
end
-- fade in
if fade then
    DoScreenFadeIn(1000)
end

end
  
function resetMovement(fade)
-- fade
if fade then
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
end
-- reset all
ClearTimecycleModifier()
ResetScenarioTypesEnabled()
ResetPedMovementClipset(GetPlayerPed(-1), 0)
SetPedIsDrunk(GetPlayerPed(-1), false)
SetPedMotionBlur(GetPlayerPed(-1), false)
end



--[[Citizen.CreateThread(function()
    while true do
        local jucator = GetPlayerPed(-1)
        local pos = GetEntityCoords(jucator, true)
        if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 241.19776916504,-1373.9774169922,39.534343719482) < 35.5) or (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 246.83427429199,-1378.1258544922,39.53434753418) < 35.5) then
            Draw3DText(241.19776916504,-1373.9774169922,39.534343719482-1.37, "~g~[ ~w~Spital ~g~]", 0.05, 0.05)
            Draw3DText(241.19776916504,-1373.9774169922,39.534343719482-1.5, "~g~[ ~w~Buna ziua , doriti sa donati sange ? ~g~]", 0.05, 0.05)
            Draw3DText(241.19776916504,-1373.9774169922,39.534343719482-1.63, "~g~[ ~w~Aveti grija , daca va scade nivelul de sange sub 10ML puteti muri ~g~]", 0.03, 0.03)
            Draw3DText(246.14643859863,-1378.4116210938,39.53434753418-1.77, "~g~[ ~w~Farmacie ~g~]", 0.05, 0.05)
        end
        Citizen.Wait(0)
    end
end)-]]


Citizen.CreateThread(function()
    local blip = AddBlipForCoord(249.50639343262,-1375.0694580078,39.534378051758)
    SetBlipSprite(blip, 147)
    SetBlipScale(blip, 1.2)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("~g~[ ~w~Recoltare sange ~g~]")
    EndTextCommandSetBlipName(blip)
end)

--[De adaugat animatie + sa vad de ce nu salveaza db]
RegisterNetEvent('racolaresange')
AddEventHandler('racolaresange', function(sangeavut)
    sange = true
    local nivsange = 0
    while sange do
        Citizen.Wait(0)
        local jucator = GetPlayerPed(-1)
        local pos = GetEntityCoords(jucator, true)
        nivsange = nivsange + 0.1
        Draw3DText(pos.x,pos.y,pos.z-1.7, "~g~[ ~w~Blood harvested : "..math.floor(nivsange).." ML~g~]\n~g~[ ~w~Press ~g~E ~w~to stop harvesting ~g~]", 0.05, 0.05)
        if math.floor(nivsange) == sangeavut then
            TriggerServerEvent('nivsangeafter', math.floor(nivsange))
            Citizen.Wait(3000)
  		    playMovement("MOVE_M@DRUNK@SLIGHTLYDRUNK",true,true,false,false)
  		    playScreenEffect("DMT_flight")
            nivsange = 0
            sange = false
        elseif IsControlJustPressed(1, 38) then
            TriggerServerEvent('nivsangeafter', math.floor(nivsange))
            TriggerServerEvent('textsange')
            Citizen.Wait(10000)
  		      playMovement("MOVE_M@DRUNK@SLIGHTLYDRUNK",true,true,false,false)
  		      playScreenEffect("DMT_flight")
            nivsange = 0
            sange = false
        end
    end
end)

Citizen.CreateThread(function()
    while not sange do
        Citizen.Wait(60000)
        TriggerServerEvent('up1')
    end
end)

RegisterNetEvent('oprirehalucinatie')
AddEventHandler('oprirehalucinatie', function()
    stopScreenEffect("DMT_flight")
    resetMovement(false)
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end 

function Draw3DText(x,y,z,textInput,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov   
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
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