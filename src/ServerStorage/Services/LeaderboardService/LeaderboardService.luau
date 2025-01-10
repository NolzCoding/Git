local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)


local LeaderboardService = Knit.CreateService{Name = "LeaderboardService", Client = { },}

function LeaderboardService:KnitStart()
    self.DataService = Knit.GetService("DataService")

    task.spawn(function()
        while true do
            task.spawn(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    self:UpdateLeaderboard(player)
                end
            end)
            task.wait(5)
        end
    end)

end

function LeaderboardService:UpdateLeaderboard(player : Player)

    local leaderstats = player:FindFirstChild("leaderstats")

    if not leaderstats then
        leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player
    end

    local wins = leaderstats:FindFirstChild("Wins")

    if not wins then
        wins = Instance.new("IntValue")
        wins.Name = "Wins"
        wins.Parent = leaderstats
    end

    local data = self.DataService:GetData(player)
    wins.Value = data.Wins or 0

end



return LeaderboardService