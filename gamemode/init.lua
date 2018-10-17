resource.AddFile("blue_team_scores.wav")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("roundsystem/cl_rounds.lua")
AddCSLuaFile("roundsystem/sh_rounds.lua")
AddCSLuaFile("sh_util.lua")

include( "shared.lua" )

include( "roundsystem/sh_rounds.lua")
include( "roundsystem/sv_rounds.lua" )


util.AddNetworkString("spawnFlag")

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

RoundManager:Init()

function SpawnFlag(ply, type) 
    local redFlag = ents.Create("ctfflag");
    if(IsValid(redFlag) == false) then return end
    redFlag:SetPos(ply:EyePos() + (ply:GetAimVector() * 64))
    redFlag:SetVar("TEAM", type)
    redFlag:Spawn()
end

net.Receive("spawnFlag", function(len, ply) 
    local team = net.ReadString()
    print("NET SPAWN FLAG: " .. team)
    SpawnFlag(ply, team)
end)