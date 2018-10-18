include( "shared.lua" )
include( "sh_util.lua" )

include( "roundsystem/sh_rounds.lua" )
include( "roundsystem/cl_rounds.lua")

function GM:ChatText( playerindex, playername, text, filter )
    if(filter == "joinleave" ) then return true end
end

function GM:OnPlayerChat(ply, text, teamChat, isDead)
    
end

net.Receive(CTFNetEvents.FlagCaptured, function() 
    local teamName = net.ReadString()
    if teamName == "red" then surface.PlaySound("red_flag_taken.wav")
    elseif teamName == "blue" then surface.PlaySound("blue_flag_taken.wav") end
end)

net.Receive(CTFNetEvents.FlagScored, function(len, ply) 
    local teamName = net.ReadString()
    if teamName == "red" then surface.PlaySound("red_team_scores.wav")
    elseif teamName == "blue" then surface.PlaySound("blue_team_scores.wav") end
end)