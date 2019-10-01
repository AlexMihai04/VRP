local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_refferal")

MySQL = module("vrp_mysql", "MySQL")

MySQL.createCommand("vRP/ref_db","ALTER TABLE vrp_users ADD IF NOT EXISTS refferal INTEGER DEFAULT 0, ADD IF NOT EXISTS folositref INTEGER DEFAULT 0")

MySQL.createCommand("vRP/refferal","UPDATE vrp_users SET refferal = refferal + 1 WHERE id = @user_id")
MySQL.createCommand("vRP/setfolositref","UPDATE vrp_users SET folositref = 1 WHERE id = @user_id")
MySQL.createCommand("vRP/afolositref", "SELECT * FROM vrp_users WHERE id = @user_id AND folositref = 0")
MySQL.createCommand("vRP/getreferraldata", "SELECT * FROM vrp_users WHERE id = @user_id")
MySQL.createCommand("vRP/addmoneytoreffered", "UPDATE vrp_user_moneys SET bank = bank + @suma WHERE user_id = @user_id")


MySQL.execute("vRP/ref_db")

function refferal(player, choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        MySQL.query("vRP/afolositref", {user_id = user_id}, function(folosit, affected)
            print(#folosit)
            if #folosit == 1 then
                vRP.prompt({player, "Who you want to refferal ?", "", function(player, idceliref)
                    if idceliref ~= nil then
                        if tonumber(idceliref) ~= user_id then
                            local jucatorref = vRP.getUserSource({idceliref})
                            MySQL.execute("vRP/refferal", {user_id = idceliref})
                            MySQL.execute("vRP/setfolositref", {user_id = user_id})
                            vRPclient.notify(player,{"Congrats , you just reffered ~g~"..idceliref.."~w~ , for this you got : ~g~500$"})
                            vRP.giveMoney({user_id,500})
                            local userref = vRP.getUserSource({idceliref})
                            MySQL.execute("vRP/addmoneytoreffered", {suma = 500,user_id = math.floor(tonumber(idceliref))})
                            if userref ~= nil then
                                vRPclient.notify(userref,{user_id.." just reffered you , ~w~you got ~g~500$ ~w~for this !"})
                            end
                        else
                            vRPclient.notify(player,{"You can't reffer yourself"})
                        end
                    end
                end})
            else
                vRPclient.notify(player,{"You already reffered someone"})
            end
        end)
    end
end

RegisterCommand('testref', function(source, args, rawCommand)
    refferal(source,choice)
end)

vRP.registerMenuBuilder({"main", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		local choices = {}
		choices["Refferal"] = {refferal, "You help someone and you get : <font color='green'>$500</font>"}
	    add(choices)
    end
end})