GM.Name = "HL2 Capture The Flag"
GM.Author = "JRascall"
GM.Email = "N/A"
GM.WebSite = "N/A"


team.SetUp(0, "Red", Color(255, 0, 0), true)
team.SetUp(1, "Blue", Color(0, 0, 255), true)

function GM:Initailize() 
	print( "Game mode loaded!" )
end

function GM:PlayerConnect( name, ip )
	print( name .. " has joined the game." )
end

function GM:PlayerInitialSpawn( ply ) 
    local teamIdx = team.BestAutoJoinTeam()
    local team = team.GetAllTeams()[teamIdx]
    ply:SetTeam(teamIdx)

    for k, v in pairs(player.GetAll()) do
        v:ChatPrint(ply:GetName() .. " has joined the " .. team.Name ..  " team")
    end
end 

