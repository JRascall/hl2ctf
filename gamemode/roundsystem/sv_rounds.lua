--Server Round Manager
util.AddNetworkString(ERoundEvents.R_STARTED)
util.AddNetworkString(ERoundEvents.R_ENDED)
util.AddNetworkString(ERoundEvents.R_START)

RoundManager = {
    InRound = false,
    InWarmUp = false,
}

function RoundManager:Init() 
    print("Round Manager Init")
    hook.Add("PlayerInitialSpawn", "RoundManager_PlayerInitalSpawn", function(ply) RoundManager:PlayerInitalSpawn(ply) end)
end

function RoundManager:StartRound()
    Round = {}
    RoundManager.CurrentRound = Round
    timer.Simple(TimeEachRound, function() self:EndRound() end)
    hook.Run(ERoundEvents.R_STARTED)
    net.Start(ERoundEvents.R_STARTED)
    net.Broadcast()
end

function RoundManager:EndRound()
    hook.Run(ERoundEvents.R_ENDED)
    net.Start(ERoundEvents.R_ENDED)
    net.Broadcast()
end

function RoundManager:PlayerInitalSpawn(ply)
    print("Player Spawned! - Round Timer!")
    --if(self.InRound == false) then
    --    self:StartRound()
    --end
end

net.Receive(ERoundEvents.R_START, function(len) 
    RoundManager:StartRound()
end)

