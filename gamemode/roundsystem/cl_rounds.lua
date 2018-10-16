local roundTimeSecs = -1

hook.Add("HUDPaint", "roundTimerUI", function() 
    local minutes = math.floor(roundTimeSecs / 60)
    local seconds = roundTimeSecs - (minutes * 60)
    if(minutes < 10) then minutes = "0" .. minutes end
    if(seconds < 10) then seconds = "0" .. seconds end

    if(roundTimeSecs > 0) then
        draw.DrawText(minutes .. " : " .. seconds, "CloseCaption_Normal", ScrW() * 0.5, 10, Color(255,255,255,255), 1)
    end
end)

timer.Create('minusSeconds', 1, 0, function() roundTimeSecs = roundTimeSecs - 1  end)

net.Receive(ERoundEvents.R_STARTED, function(len) 
    print("NET MESSAGE - Round Started")
    roundTimeSecs = TimeEachRound
end)

net.Receive(ERoundEvents.R_ENDED, function(len)
    print("NET MESSAGE - Round Ended")
end)