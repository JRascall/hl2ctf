--Server Round Manager
resource.AddFile("3_minutes_remain.wav")
resource.AddFile("2_minutes_remain.wav")
resource.AddFile("1_minute_remains.wav")

util.AddNetworkString(ERoundEvents.R_STARTED)
util.AddNetworkString(ERoundEvents.R_ENDED)
util.AddNetworkString(ERoundEvents.R_WARNING)

RoundManager = {
    InRound = false,
    InWarmUp = false,
    Time = -1,
    ThreeMinWanringSent = false,
    TwoMinWarningSent = false,
    OneMinWarningSent = false,
}

function RoundManager:Init() 
    print("Round Manager Init")
    hook.Add("PlayerInitialSpawn", "RoundManager_PlayerInitalSpawn",  function(ply) RoundManager:PlayerInitalSpawn(ply) end)
end

function RoundManager:StartRound()
    if RoundManager.InRound == true then return end
    RoundManager.InRound = true
    RoundManager.Time = TimeEachRound
    hook.Run(ERoundEvents.R_STARTED)
    net.Start(ERoundEvents.R_STARTED)
    net.Broadcast()

    if mapSpawns ~= nil then
        local bluePos = mapSpawns["blue"]
        local redPos = mapSpawns["red"]
    
        SpawnFlag("blue", bluePos)
        SpawnFlag("red", redPos)
    end
end

function RoundManager:EndRound()
    hook.Run(ERoundEvents.R_ENDED)
    net.Start(ERoundEvents.R_ENDED)
    net.Broadcast()

    for k, v in pairs(ents.FindByClass("ctfflag")) do
        v:Remove()
    end

    RoundManager.InRound = false
end

function RoundManager:PlayerInitalSpawn(ply)
    print("Player Spawned! - Round Timer!")
end

hook.Add("Think", "roundTimer", function()
    if RoundManager.Time > 0 and RoundManager.InRound == true then
        RoundManager.Time = RoundManager.Time - FrameTime()
        --Play round warnings!
        if math.Round(RoundManager.Time) == (3 * 60) and RoundManager.ThreeMinWanringSent == false then
            net.Start(ERoundEvents.R_WARNING)
            net.WriteInt(3, 3)
            net.Broadcast()
            RoundManager.ThreeMinWanringSent = true
        elseif math.Round(RoundManager.Time) == (2 * 60) and RoundManager.TwoMinWarningSent == false then
            net.Start(ERoundEvents.R_WARNING)
            net.WriteInt(2, 3)
            net.Broadcast()
            RoundManager.TwoMinWarningSent = true
        elseif math.Round(RoundManager.Time) == (1 * 60) and RoundManager.OneMinWarningSent == false then
            net.Start(ERoundEvents.R_WARNING)
            net.WriteInt(1, 3)
            net.Broadcast()
            RoundManager.OneMinWarningSent = true;
        end
    elseif RoundManager.Time <= 0 and RoundManager.InRound == true then
        RoundManager:EndRound()
    end
end)
