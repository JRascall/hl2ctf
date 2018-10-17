include( "shared.lua" )
include( "sh_util.lua" )

include( "roundsystem/sh_rounds.lua" )
include( "roundsystem/cl_rounds.lua")

function GM:ChatText( playerindex, playername, text, filter )
    if(filter == "joinleave" ) then return true end
end

function GM:OnPlayerChat(ply, text, teamChat, isDead)
    
end