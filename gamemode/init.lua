resource.AddFile("blue_team_scores.wav")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("roundsystem/cl_rounds.lua")
AddCSLuaFile("roundsystem/sh_rounds.lua")
AddCSLuaFile("sh_util.lua")

include( "shared.lua" )

include( "roundsystem/sh_rounds.lua")
include( "roundsystem/sv_rounds.lua" )

RunConsoleCommand("sv_minrate", "3000")
RunConsoleCommand("sv_maxrate", "25000")
RunConsoleCommand("sv_minupdaterate", "33")
RunConsoleCommand("sv_maxupdaterate", "67")
RunConsoleCommand("sv_mincmdrate", "33")
RunConsoleCommand("sv_maxcmdrate", "67")

local mapData
function GM:PlayerSay(ply, text, teamChat)
    print(ply:GetName())
    return text
end

function GM:PlayerSpawn(ply) 
    print("Changing model!")
    ply:SetModel( "models/player/model18.mdl" )
end

function SendMessageToAllPlayers(text) 
    for k, ply in pairs(player.GetAll()) do
        ply:ChatPrint(text)
    end
end 

hook.Add(ERoundEvents.R_STARTED, "roundStarted", function()
    SendMessageToAllPlayers("Round has started!")
end)

hook.Add(ERoundEvents.R_ENDED, "roundEnded", function()
    SendMessageToAllPlayers("Round has ended!")
end)

function SpawnFlag(ply, type) 
    local redFlag = ents.Create("ctfflag");
    if(IsValid(redFlag) == false) then return end
    redFlag:SetPos(ply:EyePos() + (ply:GetAimVector() * 64))
    redFlag:SetVar("TEAM", type)
    redFlag:Spawn()
end

concommand.Add("spawnFlag", function(ply, cmd, args) 
    if table.getn(args) <= 0 then return end
    SpawnFlag(ply, string.lower(args[1]))
end)

concommand.Add("startRound", function(ply, cmd, args) 
    RoundManager:StartRound()
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

function EnsureFolderExists() 
    if file.Exists("hl2ctf", "DATA") == false then
        file.CreateDir("hl2ctf")
    end
end

function EnsureFileExists()
    if file.Exists("hl2ctf/mapdata.txt", "DATA") == false then file.Write("hl2ctf/mapdata.txt", "{}") end
end


EnsureFolderExists()
EnsureFileExists()

mapData = util.JSONToTable(file.Read("hl2ctf/mapdata.txt", "DATA"))

RoundManager:Init()
