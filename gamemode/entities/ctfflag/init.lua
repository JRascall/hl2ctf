resource.AddFile("red_flag_taken.wav")
resource.AddFile("blue_flag_taken.wav")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString(FlagNetEvents.FlagCaptured)

function ENT:Initialize()
    self:SetModel("models/items/item_item_crate.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_FLY)
    self:SetSolid(SOLID_VPHYSICS)
    self.TEAM = self:GetVar("TEAM")
    if (self.TEAM == "red") then
        self:SetColor(Color(255, 0, 0, 0))
    elseif (self.TEAM == "blue") then
        self:SetColor(Color(0, 0, 255, 0))
    end
    self:SetTrigger(true)
end

function ENT:StartTouch(entity)
    if (entity:IsPlayer()) then
        local teamId = entity:Team()
        local plyTeamName = string.lower(team.GetName(teamId))
        if (plyTeamName == "blue" and self.TEAM == "red" or plyTeamName == "red" and self.TEAM == "blue") then
            net.Start(FlagNetEvents.FlagCaptured)
            net.WriteString(self.TEAM)
            for k, v in pairs(player.GetAll()) do
                net.Send(v)
                v:ChatPrint(entity:GetName() .. " has taken the " .. self.TEAM .. " flag")
            end
            self:Remove()
        end
    end
end