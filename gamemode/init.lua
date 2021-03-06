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

function GM:PlayerDeath(ply, weapon, attacker)
    print("Death!")
    OnPlayerDeath(ply)
end

function OnPlayerDeath(ply) 
    local hasFlag = ply:GetNWBool("HasFlag")
    if hasFlag == true then
        local teamID = ply:Team()
        local team = string.lower(team.GetName(teamID))
        if team == "blue" then 
            SpawnFlag("red", ply:GetPos())
            SendMessageToAllPlayers("red" .. " flag dropped")
        elseif team == "red" then 
            SpawnFlag("blue", ply:GetPos())
            SendMessageToAllPlayers("blue" .. " flag dropped")
        end
    end
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

    SendMessageToAllPlayers("Round will start shortly")
    timer.Simple(30, function()
        RoundManager:StartRound()
    end)
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
        local teamName = string.lower(team.GetName(teamId))
        net.Start(CTFNetEvents.FlagScored)
        net.WriteString(teamName)
        net.Broadcast()
        ply:SetNWBool("HasFlag", false)

        SendMessageToAllPlayers(ply:GetName() .. " has scored a point for the " .. teamName .. " team")
        team.SetScore(teamId, team.GetScore(teamId) + 1)

        if teamName == "blue" then 
            SpawnFlag("red", mapSpawns["red"])
        elseif teamName == "red" then 
            SpawnFlag("blue", mapSpawns["blue"])
        end
    end
end)

function SpawnFlag(type, pos) 
    local flag = ents.Create("ctfflag");
    if(IsValid(flag) == false) then return end
    flag:SetPos(pos + Vector(12, 12, 12))
    flag:SetVar("TEAM", type)
    flag:Spawn()
end


EnsureFolderExists()
EnsureFileExists()

mapData = util.JSONToTable(file.Read("hl2ctf/mapdata.txt", "DATA"))
mapSpawns = mapData[game.GetMap()]
RoundManager:Init()
