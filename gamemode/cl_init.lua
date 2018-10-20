include( "shared.lua" )
include( "sh_util.lua" )

include( "roundsystem/sh_rounds.lua" )
include( "roundsystem/cl_rounds.lua")

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

function GM:ChatText( playerindex, playername, text, filter )
    if(filter == "joinleave" ) then return true end
end

function GM:OnPlayerChat(ply, text, teamChat, isDead)
    
end

local frame = vgui.Create("DFrame")
frame:SetSize(350, 300)
frame:Center()
frame:SetTitle("Score Board")
frame:SetVisible(false)

function GM:ScoreboardShow()
    frame:SetVisible(true)
end

function GM:ScoreboardHide()
    frame:SetVisible(false)
end

hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name) 
    if hide[name] then return false end
end)

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