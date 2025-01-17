local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local MarketplaceService = game:GetService("MarketplaceService")
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local RobuxController = Knit.CreateController {
    Name = "RobuxController"
}

function RobuxController:KnitStart()

    self.NotificationController = Knit.GetController("NotificationController")

    local purschased = function(player, product)
        game.SoundService:PlayLocalSound(game.SoundService.Cheering)
        self.NotificationController:TextNImage({
            Text = "Thank you for your purchase!",
            Image = Icons.Emojis.Mewing,
            Color = Color3.fromRGB(0, 255, 0),
            Time = 5,
        })

    end

    local failed = function(player, product)
        game.SoundService:PlayLocalSound(game.SoundService.sigma)
        self.NotificationController:TextNImage({
            Text = "I'm not crying, ur crying",
            Image = Icons.Emojis.LoudlyCrying,
            Color = Color3.fromRGB(255, 47, 47),
            Time = 5,
        })
    end

    MarketplaceService.PromptProductPurchaseFinished:Connect(function(a0: number, a1: number, a2: boolean)

        if a2 then
            local player = game.Players:GetPlayerByUserId(a1)
            purschased(player, a1)
        else
            local player = game.Players:GetPlayerByUserId(a1)
            failed(player, a1)
        end

    end)

end


function RobuxController:KnitInit()

end

return RobuxController