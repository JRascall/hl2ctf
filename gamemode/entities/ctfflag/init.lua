resource.AddFile("red_flag_taken.wav")
resource.AddFile("blue_flag_taken.wav")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString(FlagNetEvents.FlagCaptured)

function ENT:Initialize()
    self:SetModel("models/items/item_item_crate.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self.TEAM = self:GetVar("TEAM")
    if (self.TEAM == "Red") then
        self:SetColor(Color(255, 0, 0, 0))
    elseif (self.TEAM == "Blue") then
        self:SetColor(Color(0, 0, 255, 0))
    end
    self:SetTrigger(true)
end

function ENT:StartTouch(entity)
    if (entity:IsPlayer()) then
        local teamId = entity:Team()
        local plyTeamName = team.GetName(teamId)
        if (plyTeamName == "Blue" and self.TEAM == "Red" or plyTeamName == "Red" and self.TEAM == "Blue") then
            net.Start(FlagNetEvents.FlagCaptured)
            net.WriteString(self.TEAM)
            for k, v in pairs(player.GetAll()) do
                net.Send(v)
            end
            self:Remove()
        end
    end
end
