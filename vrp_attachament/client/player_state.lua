
-- periodic player state update

local state_ready = false

AddEventHandler("playerSpawned",function() -- delay state recording
  state_ready = false
  
  Citizen.CreateThread(function()
    Citizen.Wait(30000)
    state_ready = true
  end)
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(30000)

    if IsPlayerPlaying(PlayerId()) and state_ready then
      local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
      vRPserver.updatePos({x,y,z})
      vRPserver.updateHealth({tvRP.getHealth()})
      vRPserver.updateWeapons({tvRP.getWeapons()})
      vRPserver.updateCustomization({tvRP.getCustomization()})
    end
  end
end)

-- WEAPONS

-- def
local weapon_types = {
  {"WEAPON_KNIFE"},
  {"WEAPON_STUNGUN"},
  {"WEAPON_FLASHLIGHT"},
  {"WEAPON_NIGHTSTICK"},
  {"WEAPON_HAMMER"},
  {"WEAPON_BAT"},
  {"WEAPON_GOLFCLUB"},
  {"WEAPON_CROWBAR"},
  {"WEAPON_PISTOL","COMPONENT_AT_PI_SUPP_02","COMPONENT_AT_PI_FLSH","COMPONENT_PISTOL_VARMOD_LUXE"},
  {"WEAPON_COMBATPISTOL","COMPONENT_AT_PI_SUPP","COMPONENT_AT_PI_FLSH","COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER"},
  {"WEAPON_APPISTOL","COMPONENT_AT_PI_SUPP","COMPONENT_AT_PI_FLSH","COMPONENT_APPISTOL_VARMOD_LUXE"},
  {"WEAPON_PISTOL50","COMPONENT_AT_AR_SUPP_02","COMPONENT_AT_PI_FLSH","COMPONENT_PISTOL50_VARMOD_LUXE"},
  {"WEAPON_MICROSMG","COMPONENT_AT_AR_SUPP_02","COMPONENT_AT_PI_FLSH","COMPONENT_MICROSMG_VARMOD_LUXE"},
  {"WEAPON_SMG","COMPONENT_AT_PI_SUPP","COMPONENT_AT_AR_FLSH","COMPONENT_SMG_VARMOD_LUXE"},
  {"WEAPON_ASSAULTSMG","COMPONENT_AT_AR_SUPP_02","COMPONENT_AT_AR_FLSH","COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER"},
  {"WEAPON_ASSAULTRIFLE","COMPONENT_AT_AR_SUPP_02","COMPONENT_AT_AR_FLSH","COMPONENT_ASSAULTRIFLE_VARMOD_LUXE"},
  {"WEAPON_CARBINERIFLE","COMPONENT_AT_AR_SUPP","COMPONENT_AT_AR_FLSH","COMPONENT_CARBINERIFLE_VARMOD_LUXE"},
  {"WEAPON_ADVANCEDRIFLE","COMPONENT_AT_AR_SUPP","COMPONENT_AT_AR_FLSH","COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE"},
  {"WEAPON_MG"},
  {"WEAPON_COMBATMG"},
  {"WEAPON_PUMPSHOTGUN","COMPONENT_AT_SR_SUPP","COMPONENT_AT_AR_FLSH","COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER"},
  {"WEAPON_SAWNOFFSHOTGUN"},
  {"WEAPON_ASSAULTSHOTGUN","COMPONENT_AT_AR_SUPP","COMPONENT_AT_AR_FLSH"},
  {"WEAPON_BULLPUPSHOTGUN","COMPONENT_AT_AR_SUPP_02","COMPONENT_AT_AR_FLSH"},
  {"WEAPON_STUNGUN"},
  {"WEAPON_SNIPERRIFLE","COMPONENT_AT_AR_SUPP_02"},
  {"WEAPON_HEAVYSNIPER"},
  {"WEAPON_REMOTESNIPER"},
  {"WEAPON_GRENADELAUNCHER"},
  {"WEAPON_GRENADELAUNCHER_SMOKE"},
  {"WEAPON_RPG"},
  {"WEAPON_PASSENGER_ROCKET"},
  {"WEAPON_AIRSTRIKE_ROCKET"},
  {"WEAPON_STINGER"},
  {"WEAPON_MINIGUN"},
  {"WEAPON_GRENADE"},
  {"WEAPON_STICKYBOMB"},
  {"WEAPON_SMOKEGRENADE"},
  {"WEAPON_BZGAS"},
  {"WEAPON_MOLOTOV"},
  {"WEAPON_FIREEXTINGUISHER"},
  {"WEAPON_PETROLCAN"},
  {"WEAPON_DIGISCANNER"},
  {"WEAPON_BRIEFCASE"},
  {"WEAPON_BRIEFCASE_02"},
  {"WEAPON_BALL"},
  {"WEAPON_FLARE"}
}

function tvRP.getWeaponTypes()
  return weapon_types
end

function tvRP.getWeapons()
  local player = GetPlayerPed(-1)

  local ammo_types = {} -- remember ammo type to not duplicate ammo amount

  local weapons = {}
  for k,v in pairs(weapon_types) do
    local hash = GetHashKey(v[1])
    if HasPedGotWeapon(player,hash) then
      local weapon = {}
      weapons[v[1]] = weapon

      local atype = Citizen.InvokeNative(0x7FEAD38B326B9F74, player, hash)
      if ammo_types[atype] == nil then
        ammo_types[atype] = true
        weapon.ammo = GetAmmoInPedWeapon(player,hash)
      else
        weapon.ammo = 0
      end
      if v[2] ~= nil then
        if HasPedGotWeaponComponent(player,hash, GetHashKey(tostring(v[2]))) == 1 then
          weapon.supressor = tostring(v[2])
        else
          weapon.supressor = "nu"
        end
      end
      if v[3] ~= nil then
        if HasPedGotWeaponComponent(player,hash, GetHashKey(tostring(v[3]))) == 1 then
          weapon.flash = tostring(v[3])
        else
          weapon.flash = "nu"
        end
      end
      if v[4] ~= nil then
        if HasPedGotWeaponComponent(player,hash, GetHashKey(tostring(v[4]))) == 1 then
          weapon.yusuf = tostring(v[4])
        else
          weapon.yusuf = "nu"
        end
      end
    end
  end

  return weapons
end

function tvRP.giveWeapons(weapons,clear_before)
  local player = GetPlayerPed(-1)

  -- give weapons to player

  if clear_before then
    RemoveAllPedWeapons(player,true)
  end

  for k,weapon in pairs(weapons) do
    local hash = GetHashKey(k)
    local ammo = weapon.ammo or 0
    GiveWeaponToPed(player, hash, ammo, false)
    if weapon.supressor ~= "nu" and weapon.supressor ~= nil then
      GiveWeaponComponentToPed(GetPlayerPed(-1), hash, GetHashKey(weapon.supressor))
    end
    if weapon.flash ~= "nu" and weapon.flash ~= nil then
      GiveWeaponComponentToPed(GetPlayerPed(-1), hash, GetHashKey(weapon.flash))
    end
    if weapon.yusuf ~= "nu" and weapon.yusuf ~= nil then
      GiveWeaponComponentToPed(GetPlayerPed(-1), hash, GetHashKey(weapon.yusuf))
    end
  end
end

--[[
function tvRP.dropWeapon()
  SetPedDropsWeapon(GetPlayerPed(-1))
end
--]]

-- PLAYER CUSTOMIZATION

-- parse part key (a ped part or a prop part)
-- return is_proppart, index
local function parse_part(key)
  if type(key) == "string" and string.sub(key,1,1) == "p" then
    return true,tonumber(string.sub(key,2))
  else
    return false,tonumber(key)
  end
end

function tvRP.getDrawables(part)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1),index)
  else
    return GetNumberOfPedDrawableVariations(GetPlayerPed(-1),index)
  end
end

function tvRP.getDrawableTextures(part,drawable)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropTextureVariations(GetPlayerPed(-1),index,drawable)
  else
    return GetNumberOfPedTextureVariations(GetPlayerPed(-1),index,drawable)
  end
end

function tvRP.getCustomization()
  local ped = GetPlayerPed(-1)

  local custom = {}

  custom.modelhash = GetEntityModel(ped)

  -- ped parts
  for i=0,20 do -- index limit to 20
    custom[i] = {GetPedDrawableVariation(ped,i), GetPedTextureVariation(ped,i), GetPedPaletteVariation(ped,i)}
  end

  -- props
  for i=0,10 do -- index limit to 10
    custom["p"..i] = {GetPedPropIndex(ped,i), math.max(GetPedPropTextureIndex(ped,i),0)}
  end

  return custom
end

-- partial customization (only what is set is changed)
function tvRP.setCustomization(custom) -- indexed [drawable,texture,palette] components or props (p0...) plus .modelhash or .model
  local exit = TUNNEL_DELAYED() -- delay the return values

  Citizen.CreateThread(function() -- new thread
    if custom then
      local ped = GetPlayerPed(-1)
      local mhash = nil

      -- model
      if custom.modelhash ~= nil then
        mhash = custom.modelhash
      elseif custom.model ~= nil then
        mhash = GetHashKey(custom.model)
      end

      if mhash ~= nil then
        local i = 0
        while not HasModelLoaded(mhash) and i < 10000 do
          RequestModel(mhash)
          Citizen.Wait(10)
        end

        if HasModelLoaded(mhash) then
          -- changing player model remove weapons, so save it
          local weapons = tvRP.getWeapons()
          SetPlayerModel(PlayerId(), mhash)
          tvRP.giveWeapons(weapons,true)
          SetModelAsNoLongerNeeded(mhash)
        end
      end

      ped = GetPlayerPed(-1)

      -- parts
      for k,v in pairs(custom) do
        if k ~= "model" and k ~= "modelhash" then
          local isprop, index = parse_part(k)
          if isprop then
            if v[1] < 0 then
              ClearPedProp(ped,index)
            else
              SetPedPropIndex(ped,index,v[1],v[2],v[3] or 2)
            end
          else
            SetPedComponentVariation(ped,index,v[1],v[2],v[3] or 2)
          end
        end
      end
    end

    exit({})
  end)
end

-- fix invisible players by resetting customization every minutes
--[[
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(60000)
    if state_ready then
      local custom = tvRP.getCustomization()
      custom.model = nil
      custom.modelhash = nil
      tvRP.setCustomization(custom)
    end
  end
end)
--]]

RegisterNetEvent('alex:supp')
AddEventHandler('alex:supp', function()
    local ped = GetPlayerPed(-1)
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    if currentWeaponHash == GetHashKey("WEAPON_PISTOL") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL"), GetHashKey("component_at_pi_supp_02"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_PISTOL50") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_COMBATPISTOL") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_AT_PI_SUPP"))   
      
    elseif currentWeaponHash == GetHashKey("WEAPON_APPISTOL") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_APPISTOL"), GetHashKey("COMPONENT_AT_PI_SUPP"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYPISTOL") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_AT_PI_SUPP"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_VINTAGEPISTOL") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_VINTAGEPISTOL"), GetHashKey("COMPONENT_AT_PI_SUPP")) 
      
    elseif currentWeaponHash == GetHashKey("WEAPON_SMG") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_AT_PI_SUPP"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_MICROSMG") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_MICROSMG"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTSMG") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTSMG"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTRIFLE"), GetHashKey("COMPONENT_AT_AR_SUPP_02")) 
       
    elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_SUPP"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_ADVANCEDRIFLE") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ADVANCEDRIFLE"), GetHashKey("COMPONENT_AT_AR_SUPP"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_SPECIALCARBINE") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SPECIALCARBINE"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_BULLPUPRIFLE") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BULLPUPRIFLE"), GetHashKey("COMPONENT_AT_AR_SUPP"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTSHOTGUN") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTSHOTGUN"), GetHashKey("COMPONENT_AT_AR_SUPP"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYSHOTGUN") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HEAVYSHOTGUN"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_BULLPUPSHOTGUN") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BULLPUPSHOTGUN"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_PUMPSHOTGUN") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), GetHashKey("COMPONENT_AT_SR_SUPP"))
        
    elseif currentWeaponHash == GetHashKey("WEAPON_MARKSMANRIFLE") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_MARKSMANRIFLE"), GetHashKey("COMPONENT_AT_AR_SUPP"))  
      
    elseif currentWeaponHash == GetHashKey("WEAPON_SNIPERRIFLE") then
      GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SNIPERRIFLE"), GetHashKey("COMPONENT_AT_AR_SUPP_02"))
      	
    end
end)

RegisterNetEvent('alex:flashlight')
AddEventHandler('alex:flashlight', function()
    local ped = GetPlayerPed(-1)
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    if currentWeaponHash == GetHashKey("WEAPON_PISTOL") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))  
         
    elseif currentWeaponHash == GetHashKey("WEAPON_PISTOL50") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_AT_PI_FLSH"))  
         
    elseif currentWeaponHash == GetHashKey("WEAPON_COMBATPISTOL") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))  
         
    elseif currentWeaponHash == GetHashKey("WEAPON_APPISTOL") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_APPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))  
         
    elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYPISTOL") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))  
         
    elseif currentWeaponHash == GetHashKey("WEAPON_SMG") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
         
    elseif currentWeaponHash == GetHashKey("WEAPON_MICROSMG") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_MICROSMG"), GetHashKey("COMPONENT_AT_PI_FLSH"))  
         
    elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTSMG") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTSMG"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
         
    elseif currentWeaponHash == GetHashKey("WEAPON_COMBATPDW") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_COMBATPDW"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
         
    elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTRIFLE"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
         
    elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
         
    elseif currentWeaponHash == GetHashKey("WEAPON_ADVANCEDRIFLE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ADVANCEDRIFLE"), GetHashKey("COMPONENT_AT_AR_FLSH"))  	
         
    elseif currentWeaponHash == GetHashKey("WEAPON_SPECIALCARBINE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SPECIALCARBINE"), GetHashKey("COMPONENT_AT_AR_FLSH"))  	
         
    elseif currentWeaponHash == GetHashKey("WEAPON_BULLPUPRIFLE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BULLPUPRIFLE"), GetHashKey("COMPONENT_AT_AR_FLSH"))  		
         
    elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTSHOTGUN") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTSHOTGUN"), GetHashKey("COMPONENT_AT_AR_FLSH"))  	  
         		
    elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYSHOTGUN") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HEAVYSHOTGUN"), GetHashKey("COMPONENT_AT_AR_FLSH"))  		
         
    elseif currentWeaponHash == GetHashKey("WEAPON_BULLPUPSHOTGUN") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BULLPUPSHOTGUN"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
           		 
    elseif currentWeaponHash == GetHashKey("WEAPON_PUMPSHOTGUN") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), GetHashKey("COMPONENT_AT_AR_FLSH"))  
           		
    elseif currentWeaponHash == GetHashKey("WEAPON_MARKSMANRIFLE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_MARKSMANRIFLE"), GetHashKey("COMPONENT_AT_AR_FLSH"))
           
    end
end)

RegisterNetEvent('alex:grip')
AddEventHandler('alex:grip', function()
    local ped = GetPlayerPed(-1)
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    if currentWeaponHash == GetHashKey("WEAPON_COMBATPDW") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_COMBATPDW"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))  
          
    elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTRIFLE"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))  
          
    elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))  
          
    elseif currentWeaponHash == GetHashKey("WEAPON_SPECIALCARBINE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SPECIALCARBINE"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))  
          
    elseif currentWeaponHash == GetHashKey("WEAPON_BULLPUPRIFLE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BULLPUPRIFLE"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))  
          
    elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTSHOTGUN") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTSHOTGUN"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))  
          
    elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYSHOTGUN") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HEAVYSHOTGUN"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))  
          
    elseif currentWeaponHash == GetHashKey("WEAPON_BULLPUPSHOTGUN") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_BULLPUPSHOTGUN"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))  
          
    elseif currentWeaponHash == GetHashKey("WEAPON_MARKSMANRIFLE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_MARKSMANRIFLE"), GetHashKey("COMPONENT_AT_AR_AFGRIP"))  
          
    end
end)

RegisterNetEvent('alex:yusuf')
AddEventHandler('alex:yusuf', function(duration)
    local ped = GetPlayerPed(-1)
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    if currentWeaponHash == GetHashKey("WEAPON_PISTOL") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL"), GetHashKey("COMPONENT_PISTOL_VARMOD_LUXE"))  
          
    elseif currentWeaponHash == GetHashKey("WEAPON_PISTOL50") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_PISTOL50_VARMOD_LUXE"))  
        
    elseif currentWeaponHash == GetHashKey("WEAPON_APPISTOL") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_APPISTOL"), GetHashKey("COMPONENT_APPISTOL_VARMOD_LUXE"))  
        
    elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYPISTOL") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_HEAVYPISTOL_VARMOD_LUXE"))  
        
    elseif currentWeaponHash == GetHashKey("WEAPON_SMG") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_SMG_VARMOD_LUXE"))  
        
    elseif currentWeaponHash == GetHashKey("WEAPON_MICROSMG") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_MICROSMG"), GetHashKey("COMPONENT_MICROSMG_VARMOD_LUXE"))  
        
    elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTRIFLE"), GetHashKey("COMPONENT_ASSAULTRIFLE_VARMOD_LUXE"))  		
        
    elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_CARBINERIFLE_VARMOD_LUXE"))    		
        
    elseif currentWeaponHash == GetHashKey("WEAPON_ADVANCEDRIFLE") then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ADVANCEDRIFLE"), GetHashKey("COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE"))  
        
    end
end)