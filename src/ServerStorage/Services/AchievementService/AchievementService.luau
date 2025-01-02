local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)


local AchievementService = Knit.CreateService {
    Name = "AchievementService",
    Client = {}
}

function AchievementService:KnitInit()

end

function AchievementService:KnitStart()
    self.DataService = Knit.GetService("DataService")
end

function AchievementService:PerformedAction(player : Player, actionName : string, amount : number)

    local data = self.DataService:GetData(player)

    if data.Achievements.Actions[actionName] then
        data.Achievements.Actions[actionName] += amount
    else
        data.Achievements.Actions[actionName] = amount
    end

    self.DataService:SetData(player, "Achievements", data.Achievements)

end

return AchievementService