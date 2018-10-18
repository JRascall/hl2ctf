include('shared.lua')

function ENT:Draw() 
    self:DrawModel()

    local ang = self:GetAngles()
    ang:RotateAroundAxis(self:GetUp(), FrameTime() * 20)
    self:SetAngles(ang)
end

net.Receive(FlagNetEvents.FlagCaptured, function() 
    local teamName = net.ReadString()
    if teamName == "red" then surface.PlaySound("red_flag_taken.wav")
    elseif teamName == "blue" then surface.PlaySound("blue_flag_taken.wav") end
end)