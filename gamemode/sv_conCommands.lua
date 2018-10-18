concommand.Add("spawnFlag", function(ply, cmd, args) 
    if table.getn(args) <= 0 then return end
    SpawnFlag(string.lower(args[1], ply:EyePos() + (ply:GetAimVector() * 64)))
end)

concommand.Add("startRound", function(ply, cmd, args) 
    RoundManager:StartRound()
end)

concommand.Add("endRound", function(ply, cmd, args)
    RoundManager:EndRound()
end)

concommand.Add("flagSpawn", function(ply, cmd, args)
    if table.getn(args) <= 0 then return end
    
    if mapData == nil then 
        mapData = {}
    end

    local found = false
    for k, v in pairs(mapData) do
        if(k == game.GetMap()) then found = true break end
    end

    if found == false then 
        mapData[game.GetMap()] = {
            red = {},
            blue = {},
        }
    end

    mapData[game.GetMap()][args[1]] = ply:GetPos()

    file.Write("hl2ctf/mapdata.txt", util.TableToJSON(mapData, true))
    print("writing to mapdata.txt")
end)