local supressor_choices = {}
supressor_choices["Echipeaza"] = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if vRP.tryGetInventoryItem(user_id,"supressor",1) then
      TriggerClientEvent('alex:supp', player)
    end
  end
end}

local flash_choices = {}
flash_choices["Echipeaza"] = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if vRP.tryGetInventoryItem(user_id,"flash",1) then
      TriggerClientEvent('alex:flashlight', player)
    end
  end
end}

local yusuf_choices = {}
yusuf_choices["Echipeaza"] = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if vRP.tryGetInventoryItem(user_id,"yusuf",1) then
      TriggerClientEvent('alex:yusuf', player)
    end
  end
end}

items["supressor"] = {"Suppressor Arma","",function(args) return supressor_choices end,0.1}
items["flash"] = {"Flashlight Arma","",function(args) return flash_choices end,0.1}
items["yusuf"] = {"Paint Arma","",function(args) return yusuf_choices end,0.1}