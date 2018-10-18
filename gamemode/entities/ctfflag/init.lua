
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize()
    self:SetModel("models/items/item_item_crate.mdl")
    self:PhysicsInit(SOLID_NONE)
    self:SetMoveType(MOVETYPE_FLY)
    self:SetSolid(SOLID_NONE)
    --self:SetSolidFlags(FSOLID_TRIGGER)
    self:UseTriggerBounds(true, 1)
    self.TEAM = self:GetVar("TEAM")
    if (self.TEAM == "red") then
        self:SetColor(Color(255, 0, 0, 0))
    elseif (self.TEAM == "blue") then
        self:SetColor(Color(0, 0, 255, 0))
    end
    self:SetTrigger(true)
end

function ENT:StartTouch(entity)
    if entity:IsPlayer() then
        local teamId = entity:Team()
        local plyTeamName = string.lower(team.GetName(teamId))
        if (plyTeamName == "blue" and self.TEAM == "red" or plyTeamName == "red" and self.TEAM == "blue") then
            hook.Run("flagCaptured", entity, self.TEAM)
            self:Remove()
        elseif plyTeamName == "blue" and self.TEAM == "blue" or plyTeamName == "red" and self.TEAM == "red" then
            hook.Run("attemptingToScore", entity)
        end
    end
end

hook.Add("Think", "rotateFlags", function()
    local flags = ents.FindByClass("ctfflag")
    for k, v in pairs(flags) do
        v:SetAngles(v:GetAngles()+Angle(0,0.5,0))
    end
end)