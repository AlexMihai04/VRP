
RegisterNetEvent('get_benzina')
AddEventHandler('get_benzina', function(benzina)
end)

function onScreen(content,x,y)
        SetTextFont(4)
        SetTextProportional(0)
        SetTextScale(0.5, 0.5)
        SetTextEntry("STRING")
        AddTextComponentString(content)
        DrawText(x+0.005, y-0.058)
        DrawRect(x+0.05, y-0.01, 0.100, 0.093,0,0,0,100)
        DrawRect(x, y-0.01, 0.0025, 0.094,255,30,30,255)
end

function round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

function lock()
  if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
    if IsControlJustPressed(1,303) then
      veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
      local locked = GetVehicleDoorLockStatus(veh) >= 2
      if locked then -- unlock
        SetVehicleDoorsLockedForAllPlayers(veh, false)
        SetVehicleDoorsLocked(veh,1)
        SetVehicleDoorsLockedForPlayer(veh, PlayerId(), false)
        TriggerEvent("pNotify:SendNotification", {text = "Ai descuiat masina!", type = "success", timeout = 1400, layout = "bottomRight"})
      else -- lock
        SetVehicleDoorsLocked(veh,2)
        SetVehicleDoorsLockedForAllPlayers(veh, true)
        TriggerEvent("pNotify:SendNotification", {text = "Ai incuiat masina!", type = "success", timeout = 1400, layout = "bottomRight"})
      end
    end
  else 
    if IsControlJustPressed(1,303) then
      veh =  GetVehiclePedIsIn(GetPlayerPed(-1), true)
      
      local locked = GetVehicleDoorLockStatus(veh) >= 2
      if locked then -- unlock
        SetVehicleDoorsLockedForAllPlayers(veh, false)
        SetVehicleDoorsLocked(veh,1)
        SetVehicleDoorsLockedForPlayer(veh, PlayerId(), false)
        TriggerEvent("pNotify:SendNotification", {text = "Ai descuiat masina!", type = "success", timeout = 1400, layout = "bottomRight"})
      else -- lock
        SetVehicleDoorsLocked(veh,2)
        SetVehicleDoorsLockedForAllPlayers(veh, true)
        TriggerEvent("pNotify:SendNotification", {text = "Ai incuiat masina!", type = "success", timeout = 1400, layout = "bottomRight"})
      end
    end
  end
end

Citizen.CreateThread(function()
  while true do
        Citizen.Wait(0)
        player = GetPlayerPed(-1)
        lock()
        if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
            local spd = round(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))*3.78)
            plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
            local fuel    = math.ceil(round(GetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 1))
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            if GetVehicleDoorLockStatus(veh) >= 2 then
                status = "Locked"
            else
                status = "Unlocked"
            end
            if fuel < 1 then
              tfuel = "0 Liters"
            else
              tfuel = fuel.." Liters"
            end
            onScreen("~r~Speed ~w~"..spd.." KM/H \n".."~r~Status ~w~"..status.."\n~r~Fluid ~w~"..tostring(tfuel), 0.9,0.8)
        end
    end
end)

function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)
  end