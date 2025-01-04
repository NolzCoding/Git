local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local AchievementInfo = require(ReplicatedStorage.Source.Shared.Achievements)
local AchievementService = Knit.CreateService {
    Name = "AchievementService",
    Client = {}
}

function AchievementService:KnitInit()

    self.Handlers = {}
    self.AwardService = Knit.GetService("AwardService")

end

function AchievementService:KnitStart()
    self.DataService = Knit.GetService("DataService")
    self.NotificationService = Knit.GetService("NotificationService")

    self.Handlers["Cash"] = function(player : Player, props : {Amount : number})
        local data = self.DataService:GetData(player)
        data.Cash += props.Amount
        self.DataService:SetData(player, "Cash", data.Cash)

        self.NotificationService:NotifyPlayer("TextNImage", {
            Text = "+" .. props.Amount .. "",
            Image = Icons.BabyBucks,
            Time = 5,
            Color = Color3.fromRGB(172, 255, 37)
        }, player)

    end

    self.Handlers["Crate"] = function(player : Player, props : {Amount : number, Name : string})

        self.AwardService:GiveAward(player, "Crate", props.Name, props.Amount)

    end

end


function AchievementService:PerformedAction(player : Player, actionName : string, amount : number)
    print("Performed action", player, actionName, amount)
    local data = self.DataService:GetData(player)

    if data.Achievements.Actions[actionName] then
        data.Achievements.Actions[actionName] += amount
    else
        data.Achievements.Actions[actionName] = amount
    end

    self.DataService:SetData(player, "Achievements", data.Achievements)

end


function AchievementService:Claim(player : Player, achievementName : string)
    local data = self.DataService:GetData(player)

    if data.Achievements.Claimed[achievementName] then
        return
    end

    local achievement = AchievementInfo.Rewards[achievementName]

    if not achievement then
        return
    end


    local actionAmount = data.Achievements.Actions[achievement.Action]
    local canClaim = actionAmount >= achievement.Amount

    if not canClaim then return end

    data.Achievements.Claimed[achievementName] = true
    self.DataService:SetData(player, "Achievements", data.Achievements)

    self.Handlers[achievement.RewardType](player, achievement.Props)

end

function AchievementService.Client:Claim(player, achievementName)

    return self.Server:Claim(player, achievementName)

end

return AchievementService