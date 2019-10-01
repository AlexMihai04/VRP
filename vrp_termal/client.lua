--[[					SCRIPT MADE BY : ALEXMIHAI04						--]]
--[[					GOOD LUCK HAVE FUN									--]]

RegisterNetEvent('termali')
AddEventHandler('termali', function(nimicnuface)
	if nimicnuface then
		SetNightvision(true)
		SetSeethrough(true)
	  else
		SetNightvision(false)
		SetSeethrough(false)
	  end
end)