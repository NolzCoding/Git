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

    self.AwardHandlers["Crate"] = function(player : Player, crateName : string, amount : number)
        local data = self.DataService:GetData(player)

        data.Inventory.Crates[crateName] = (data.Inventory.Crates[crateName] or 0) + (amount or 1)

        self.NotificationService:NotifyPlayer("TextNImage", {
            Text = "+".. (amount or 1) .. " " .. crateName,
            --Image = Icons.Crate,
            Color = Color3.fromRGB(115, 255, 21),
            Time = 5,
        }, player)

        self.DataService:SetData(player, "Inventory", data.Inventory)
    end

    self.AwardHandlers["Ability"] = function(player : Player, abilityName, amount : number)

        local data = self.DataService:GetData(player)
        local Abilities = data.Abilities.OwnedAbilities

        Abilities[abilityName] = Abilities[abilityName] or 0
        Abilities[abilityName] = Abilities[abilityName] + amount

        self.NotificationService:NotifyPlayer("TextNImage", {
            Text = "+" .. amount .. " " .. abilityName .. " Ability!",
            Color = Color3.fromRGB(115, 255, 21),
            Time = 5,
        }, player)

        self.DataService:SetData(player, "Abilities", data.Abilities)

    end

    self.AwardHandlers["Skin"] = function(player : Player, skinType : string, skinName : string)
        local data = self.DataService:GetData(player)
        local Skins = data.Skins
        local SkinCatagory = Skins[skinType]
        local OwnedSkins = SkinCatagory.OwnedSkins

        OwnedSkins[skinName] = OwnedSkins[skinName] or 1

        self.NotificationService:NotifyPlayer("TextNImage", {
            Text = "+" .. skinName .. "!",
            Color = Color3.fromRGB(115, 255, 21),
            Time = 5,
        }, player)

        self.DataService:SetData(player, "Skins", Skins)

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