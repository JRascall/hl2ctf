resource.AddFile("blue_team_scores.wav")
resource.AddFile("red_team_scores.wav")
resource.AddFile("red_flag_taken.wav")
resource.AddFile("blue_flag_taken.wav")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("roundsystem/cl_rounds.lua")
AddCSLuaFile("roundsystem/sh_rounds.lua")
AddCSLuaFile("sh_util.lua")

include( "shared.lua" )
include("sh_util.lua")
include( "roundsystem/sh_rounds.lua")
include( "roundsystem/sv_rounds.lua" )
include("sv_conCommands.lua")

RunConsoleCommand("sv_minrate", "3000")
RunConsoleCommand("sv_maxrate", "25000")
RunConsoleCommand("sv_minupdaterate", "33")
RunConsoleCommand("sv_maxupdaterate", "67")
RunConsoleCommand("sv_mincmdrate", "33")
RunConsoleCommand("sv_maxcmdrate", "67")

util.AddNetworkString(CTFNetEvents.FlagCaptured) 
util.AddNetworkString(CTFNetEvents.FlagScored) 

local mapData

function GM:PlayerSpawn(ply) 
    ply:SetNWBool("HasFlag", false)
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

hook.Add("flagCaptured", "playerCapturedFlag", function(ply, team) 
    print("Flag Captured!")
    net.Start(CTFNetEvents.FlagCaptured)
    net.WriteString(team)
    ply:SetNWBool("HasFlag", true)
    for k, v in pairs(player.GetAll()) do
        net.Send(v)
        SendMessageToAllPlayers(ply:GetName() .. " has taken the " .. team .. " flag")
    end
end)

hook.Add("attemptingToScore", "playerAttemptingToScore", function(ply)
    local hasFlag = ply:GetNWBool("HasFlag")
    if hasFlag then
        local teamId = ply:Team()
        local team = string.lower(team.GetName(teamId))
        net.Start(CTFNetEvents.FlagScored)
        net.WriteString(team)
        net.Broadcast()
        ply:SetNWBool("HasFlag", false)

        SendMessageToAllPlayers(ply:GetName() .. " has scored a point for the " .. team .. " team")

        if team == "blue" then 
            SpawnFlag("red", mapSpawns["red"])
        elseif team == "red" then 
            SpawnFlag("blue", mapSpawns["blue"])
        end
    end
end)

function SpawnFlag(type, pos) 
    local flag = ents.Create("ctfflag");
    if(IsValid(flag) == false) then return end
    flag:SetPos(pos)
    flag:SetVar("TEAM", type)
    flag:Spawn()
end


EnsureFolderExists()
EnsureFileExists()

mapData = util.JSONToTable(file.Read("hl2ctf/mapdata.txt", "DATA"))
mapSpawns = mapData[game.GetMap()]
RoundManager:Init()
