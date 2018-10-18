local roundTimeSecs = -1

hook.Add("HUDPaint", "roundTimerUI", function() 
    local minutes = math.floor(roundTimeSecs / 60)
    local seconds = roundTimeSecs - (minutes * 60)
    if(minutes < 10) then minutes = "0" .. minutes end
    if(seconds < 10) then seconds = "0" .. seconds end

    if(roundTimeSecs > 0) then
        draw.DrawText(minutes .. ":" .. seconds, "CloseCaption_Normal", ScrW() * 0.5, 10, Color(255,255,255,255), 1)
    end
end)

timer.Create('minusSeconds', 1, 0, function() roundTimeSecs = roundTimeSecs - 1  end)

net.Receive(ERoundEvents.R_STARTED, function(len) 
    roundTimeSecs = TimeEachRound
end)

net.Receive(ERoundEvents.R_ENDED, function(len)
    roundTimeSecs = -1
end)

net.Receive(ERoundEvents.R_WARNING, function(len, ply) 
    local type = net.ReadInt(3)
    if type == 3 then  surface.PlaySound("3_minutes_remain.wav") 
    elseif type == 2 then  surface.PlaySound("2_minutes_remain.wav")
    elseif type == 1 then  surface.PlaySound("1_minute_remains.wav")
    end
end)
