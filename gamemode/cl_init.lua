include( "shared.lua" )
include( "sh_util.lua" )

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
    elseif string.find(text, "/spawnFlag") ~= nil then
        local args = split(text, " ")
        
        net.Start("spawnFlag")
        net.WriteString(args[2])
        net.SendToServer()
    end
end