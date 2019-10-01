--- Script based on Sighmir's vrp_id_display
vRPiconalex = {}
Tunnel.bindInterface("vrp_namesicon",vRPiconalex)

local players = {}
local names = {}
local lname = {}
local groups = {}
local imagini = {}
local isadmin = {}

function vRPiconalex.insertUser(user_id,source,nume,group,esteadmin,developer)
    players[user_id] = nil
    groups[user_id] = nil
    lname[user_id] = nil
    players[user_id] = GetPlayerFromServerId(source)
    lname[user_id] = nume
    groups[user_id] = group
end

function vRPiconalex.modificagroup(user_id,source,group)
	groups[user_id] = group
end

function vRPiconalex.removeUser(user_id)
    players[user_id] = nil
end

function Draw3DText(x,y,z, text) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*0.6
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

Citizen.CreateThread(function()
    while true do
        for i=0,99 do N_0x31698aa80e0223f8(i)
        end

        for k,v in pairs(players) do
            local ped = GetPlayerPed(v)
            local ply = GetPlayerPed(-1)

			if ((ped ~= ply) or config.self) then
				local x1, y1, z1 = table.unpack(GetEntityCoords(ply, true))
				local x2, y2, z2 = table.unpack(GetEntityCoords(ped, true))
				local distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))

				if ((distance < config.range)) then
                    local group = groups[k]
                    local user = lname[k]
                    local text = k
                    if NetworkIsPlayerTalking(v) then
                        z2 = z2+0.05
                        icon = "speakers"
                        lnx,lnz= 0.09,0.14
                        DrawImage3D(icon, icon, x2, y2, z2+1.00, lnx,lnz, 0.0, 255, 255, 255, 255)
                    else
                        if (group == "Mecanic") then
                            icon = "mecs"
                            lnx,lnz= 0.09,0.14
                        elseif (group == "Medic") then
                            icon = "medics"
                            lnx,lnz= 0.09,0.14
                        elseif (group == "Dealer de droguri") then
                            icon = "iarba"
                            lnx,lnz= 0.06,0.14
                        elseif (group == "Dealer de arme") then
                            icon = "arma"
                            lnx,lnz= 0.16,0.14
                        elseif (group == "Hacker") then
                            icon = "hacker"
                            lnx,lnz= 0.08,0.16
                        elseif (group == "Taximetrist") then
                            icon = "taxis"
                            lnx,lnz= 0.09,0.14
                        elseif (group == "Sofer la banca") then
                            icon = "bank"
                            lnx,lnz= 0.09,0.14
                        elseif (group == "Pizza Hut") then
                            icon = "hut"
                            lnx,lnz= 0.18,0.23
                        elseif (group == "Fan Courier") then
                            icon = "courierfan"
                            lnx,lnz= 0.11,0.18
                        elseif (group == "Transport Medical") then
                            icon = "pastila"
                            lnx,lnz= 0.08,0.13
                        elseif (group == "Gunoier") then
                            icon = "gunoi"
                            lnx,lnz= 0.12,0.17
                        elseif (group == "Civil") then --Mod
                            icon = ""
                        end
                        if group=="superadminss" or group=="scripterss" or group=="adminss" or group=="moderatorss" or group=="helperss" or group=="superadminss" or group=="scripterss" or group=="adminss" or group=="moderatorss" or group=="helperss" and not NetworkIsPlayerTalking(v) then
                            if k==2 then
                                lnx,lnz= 0.15,0.15
                                z2 = z2+0.05
                                Draw3DText(x2, y2, z2+0.93, "~r~DEVELOPER ~r~(~w~"..k.."~r~)")
                                DrawImage3D("staffs", "staffs", x2, y2, z2+1.05, lnx,lnz, 0.0, 255, 255, 255, 255)
                            else
                                lnx,lnz= 0.10,0.15
                                z2 = z2+0.05
                                Draw3DText(x2, y2, z2+0.93, "~r~STAFF ~r~(~w~"..k.."~r~)")
                                DrawImage3D("staffs", "staffs", x2, y2, z2+1.05, lnx,lnz, 0.0, 255, 255, 255, 255)
                            end
                        else
                            if icon == "medics" and not NetworkIsPlayerTalking(v) then
                                DrawImage3D(icon, icon, x2, y2, z2+1.03, lnx,lnz, 0.0, 255, 255, 255, 255)
                                Draw3DText(x2, y2, z2+0.93, "~r~(~w~"..group.."~r~) (~w~"..k.."~r~)")
                            elseif icon == "medics" and not NetworkIsPlayerTalking(v) then
                                DrawImage3D(icon, icon, x2, y2, z2+1.03, lnx,lnz, 0.0, 255, 255, 255, 255)
                                Draw3DText(x2, y2, z2+0.93, "~r~(~w~"..group.."~r~) (~w~"..k.."~r~)")
                            elseif icon == "iarba" and not NetworkIsPlayerTalking(v) then
                                DrawImage3D(icon, icon, x2, y2, z2+1.03, lnx,lnz, 0.0, 255, 255, 255, 255)
                                Draw3DText(x2, y2, z2+0.93, "~r~(~w~"..group.."~r~) (~w~"..k.."~r~)")
                            elseif icon == "hacker" and not NetworkIsPlayerTalking(v) then
                                DrawImage3D(icon, icon, x2, y2, z2+1.06, lnx,lnz, 0.0, 255, 255, 255, 255)
                                Draw3DText(x2, y2, z2+0.93, "~r~(~w~"..group.."~r~) (~w~"..k.."~r~)")
                            elseif icon == "bank" and not NetworkIsPlayerTalking(v) then
                                DrawImage3D(icon, icon, x2, y2, z2+1.06, lnx,lnz, 0.0, 255, 255, 255, 255)
                                Draw3DText(x2, y2, z2+0.93, "~r~(~w~"..group.."~r~) (~w~"..k.."~r~)")
                            elseif icon == "gunoi" and not NetworkIsPlayerTalking(v)  then
                                DrawImage3D(icon, icon, x2, y2, z2+1.09, lnx,lnz, 0.0, 255, 255, 255, 255)
                                Draw3DText(x2, y2, z2+0.93, "~r~(~w~"..group.."~r~) (~w~"..k.."~r~)")
                            elseif icon ~= "" and not NetworkIsPlayerTalking(v)  then
                                --DrawImage3D(icon, icon, x2, y2, z2+1.03, lnx,lnz, 0.0, 255, 255, 255, 255)
                                Draw3DText(x2, y2, z2+0.93, "~r~(~w~"..group.."~r~) (~w~"..k.."~r~)")
                            else
                                Draw3DText(x2, y2, z2+0.93, "~r~(~w~"..group.."~r~) (~w~"..k.."~r~)")
                            end
                        end
                    end
				end  
			end
        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerServerEvent('reuploadgrade')
    end
end)

function DrawImage3D(name1, name2, x, y, z, width, height, rot, r, g, b, alpha) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, true)
	
    if onScreen then
		local width = (1/dist)*width
		local height = (1/dist)*height
		local fov = (1/GetGameplayCamFov())*100
		local width = width*fov
		local height = height*fov
		DrawSprite(name1, name2, _x, _y, width, height, rot, r, g, b, alpha)
	end
end