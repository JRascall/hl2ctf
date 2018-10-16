resource.AddFile("blue_team_scores.wav")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include( "shared.lua" )

include( "roundsystem/sh_rounds.lua")
include( "roundsystem/sv_rounds.lua" )

function GM:PlayerSay(ply, text, teamChat)
    print(ply:GetName())
    return text
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
