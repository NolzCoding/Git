local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)
local CalculateLevels = require(ReplicatedStorage.Source.Shared.CalculateLevels)
local LevelService = Knit.CreateService {
    Name = "LevelService";
    Client = {
        LevelUp = Knit.CreateSignal()
    }
}

function LevelService:KnitInit()

    self.PlayerGotExperience = Signal.new()

end

function LevelService:KnitStart()

    self.DataService = Knit.GetService("DataService")
    self.NotificationService = Knit.GetService("NotificationService")


end

function LevelService:CheckForLevelUp(player : Player)

    local data = self.DataService:GetData(player)

    local Levels = data.Levels

    local experience = Levels.Experience
    local level = Levels.Level

    local newLevelExp = CalculateLevels:GetNextLevelExperience(level)

    if experience >= newLevelExp then

        local remaining = experience - newLevelExp

        Levels.Level += 1
        Levels.Experience = remaining

        self.Client.LevelUp:Fire(player, Levels.Level)

    end

end


function LevelService:AwardExperience(player : Player, amount : number, notify : boolean, notifyText : string?)

    local data = self.DataService:GetData(player)

    local Levels = data.Levels

    local experience = Levels.Experience
    local level = Levels.Level

    Levels.Experience += amount

    if notify then
        self.NotificationService:NotifyPlayer("TextNImage", {
            Text = "+" .. amount .. " exp " .. (notifyText or ""),
            Image = "",
            Color = Color3.fromRGB(21, 76, 255),
            Time = 5,
        }, player)
    end

    self.DataService:SetData(player, "Levels" , Levels)

    self.PlayerGotExperience:Fire(player, amount)

    self:CheckForLevelUp(player)

end

return LevelService
