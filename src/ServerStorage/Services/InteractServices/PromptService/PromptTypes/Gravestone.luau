local Gravestone = {}
local Players = game:GetService("Players")


local MarketplaceService = game:GetService("MarketplaceService")
function Gravestone:Init()

end

function Gravestone:Triggered(prompt : ProximityPrompt, player : Player)


    local gravestone = prompt.Parent :: BasePart

    local plrid = gravestone:GetAttribute("PlayerID") :: number
    local playergravestone = Players:GetPlayerByUserId(plrid)

    player:SetAttribute("Gravestone", plrid)


    MarketplaceService:PromptProductPurchase(player, 2695617898)

end

return Gravestone