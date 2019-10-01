local timmpdeasteptat = 1800000 --PAYDAY TIME IN MILISECONDS

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(timmpdeasteptat)
		TriggerServerEvent('paydayxp')
	end
end)

RegisterNetEvent("levelup")
AddEventHandler("levelup", function(bonus,level)
        Citizen.Wait(0)
            function Initialize(scaleform)
                local scaleform = RequestScaleformMovie(scaleform)
                while not HasScaleformMovieLoaded(scaleform) do
                    Citizen.Wait(0)
                end
                PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
                PushScaleformMovieFunctionParameterString("~g~PAYDAY | Level : "..level)
                PushScaleformMovieFunctionParameterString("~w~You got ~g~payday , ~g~bonus ~w~for level : ~g~"..bonus.."$~w~!")
                PopScaleformMovieFunctionVoid()
                PlaySoundFrontend(-1, "UNDER_THE_BRIDGE", "HUD_AWARDS", 1)
                Citizen.SetTimeout(15500, function()
                    PushScaleformMovieFunction(scaleform, "SHARD_ANIM_OUT")
                    PushScaleformMovieFunctionParameterInt(1)
                    PushScaleformMovieFunctionParameterFloat(0.33)
                    PopScaleformMovieFunctionVoid()
                    PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
                end)
                return scaleform
            end

            scaleform = Initialize("mp_big_message_freemode")

            while true do
                Citizen.Wait(0)
                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            end
end)