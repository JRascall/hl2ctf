include( "shared.lua" )

include( "roundsystem/sh_rounds.lua" )
include( "roundsystem/cl_rounds.lua")

function GM:ChatText( playerindex, playername, text, filter )
    if(filter == "joinleave" ) then return true end
end

function GM:OnPlayerChat(ply, text, teamChat, isDead)
    print(text)
    if text == "/bluewin" then
        surface.PlaySound("blue_team_scores.wav")
    elseif text == "/startRound" then
        net.Start(ERoundEvents.R_START)
        net.SendToServer()
    end
end