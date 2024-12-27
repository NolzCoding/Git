local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local AwardService = Knit.CreateService({
    Name = "AwardService",
    Client = {

    }

})

function AwardService:KnitInit()

end

function AwardService:KnitStart()

    self.DataService = Knit.GetService("DataService")
    self.NotificationService = Knit.GetService("NotificationService")

    self.AwardHandlers = {}

    self.AwardHandlers["Cash"] = function(player : Player, amount : number)
        local data = self.DataService:GetData(player)

        data.Cash = data.Cash + amount

        self.NotificationService:NotifyPlayer("TextNImage", {
            Text = "You got " .. amount .. " Cash!",
            Image = Icons.BabyBucks,
            Color = Color3.fromRGB(115, 255, 21),
            Time = 5,
        }, player)

        self.DataService:SetData(player, "Cash", data.Cash)
    end

end



function AwardService:GiveAward(player : Player, awardName : string, ...)

    local handler = self.AwardHandlers[awardName]

    if not handler then
        warn("No handler for award: " .. awardName)
        return
    end

    handler(player, ...)

end

return AwardService