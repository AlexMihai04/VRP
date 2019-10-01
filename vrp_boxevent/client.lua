local locatiievent = {
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

local hd = 0
local event = true
local obj = 0,0,0,0
local text = false
local apasat = false
local pedx,pedy,pedz = 339.48501586914,-1226.8273925781,32.448863983154
local obiecte = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(playerPed)
        local x,y,z
        for i,v in pairs(locatiievent) do
            if Vdist(coords.x,coords.y,coords.z,v[1],v[2],v[3]) <= 15.0 then
                if not v[4] then
                    Draw3DText(v[1],v[2],v[3]+0.2,"~w~Box")       --TEXT
                else
                    Draw3DText(v[1],v[2],v[3]+0.2,"~w~LOOTED")       --TEXT
                end
                --DrawImage3D("pings", "pings", v[1],v[2],v[3]+0.5, 0.24,0.32, 0.0, 255, 255, 255, 255)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if event then
            text = true
            for i,v in pairs(locatiievent) do
                    local model = GetHashKey("prop_partsbox_01")
                    RequestModel(model)
                    while (not HasModelLoaded(model)) do
                        Wait(1)
                    end
                    obj = CreateObject("prop_partsbox_01", v[1],v[2],v[3]-1.0, true, true, true)
                    PlaceObjectOnGroundProperly(obj)
                    FreezeEntityPosition(obj,true)
                    SetEntityCollision(obj,true,true)
            end
            event = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local model = RequestModel(GetHashKey("a_m_o_acult_02"))
        while not HasModelLoaded(GetHashKey("a_m_o_acult_02")) do
            Wait(1)
        end

        local ped =  CreatePed(4, model,pedx,pedy,pedz-1.0, 3374176, false, true)
        SetEntityHeading(ped, 370.0)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioAtPosition(ped, "PROP_HUMAN_SEAT_BENCH", pedx,pedy-0.1,pedz-0.95, GetEntityHeading(ped), 0, 0, false)
        --Citizen.Wait(300000)          UNCOMMENT IF YOU USE HG_ANTICHEAT
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for i,v in pairs(locatiievent) do
            TriggerServerEvent('verifica', v[1],v[2],v[3],v[4])
        end
    end
end)

RegisterNetEvent('modifica')
AddEventHandler('modifica', function(x,y,z,statement)
  for i,v in pairs(locatiievent) do
    v[4] = statement 
  end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(playerPed)
        if Vdist(pedx,pedy,pedz,coords.x,coords.y,coords.z) <= 15.0 then
            Draw3DText(pedx,pedy,pedz+0.2,"~w~Merchant")       --TEXT
            --DrawImage3D("atm", "atm", pedx,pedy,pedz+0.4, 0.27,0.35, 0.0, 255, 255, 255, 255)
            if Vdist(pedx,pedy,pedz,coords.x,coords.y,coords.z) <= 2.3 then
                Draw3DText(coords.x,coords.y,coords.z+0.5,"~w~Press E")
                if IsControlJustPressed(1,51) then
                    TriggerServerEvent('vinde')
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)
    blip = AddBlipForCoord(pedx,pedy,pedz)
    SetBlipSprite(blip, 478)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 10)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Scrap Merchant")
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if text then
            if obj ~= 0 then
                local playerPed = GetPlayerPed(-1)
                local coords    = GetEntityCoords(playerPed)
                for i,v in pairs(locatiievent) do
                    if Vdist(coords.x,coords.y,coords.z,v[1],v[2],v[3]) <= 1.5 then
                        if not apasat and not v[4] then
                            if IsControlJustPressed(1,51) then
                                apasat = true
                                v[4] = true
                                TriggerServerEvent('modifica', v[1],v[2],v[3],false)
                                TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)              --ANIMATIE
                                Citizen.Wait(6000)
                                ClearPedTasks(PlayerPedId())            --CLEAR ANIMATIE
                                Citizen.Wait(3000)
                                text = false
                                calcsansa() 
                            end
                        end
                    end
                end
            end
        end
    end
end)

function calcsansa()
    local sansa = math.random(1,3)
    TriggerServerEvent('event:sansa', sansa)
end



function Draw3DText(x,y,z, text) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*1.0
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(1)
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