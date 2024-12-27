local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local MarketplaceService = game:GetService("MarketplaceService")
local AbilitiesInfo = require(ReplicatedStorage.Source.Shared.Abilities)
local AbilitiesService = Knit.CreateService({
    Name = "AbilitiesService";
    Client = {
    }

})


function AbilitiesService:KnitInit()



end

function AbilitiesService:KnitStart()

    self.DataService = Knit.GetService("DataService")
    self.NotificationService = Knit.GetService("NotificationService")


end

function AbilitiesService:EquipAbility(player : Player, abilityName : string)

    local data = self.DataService:GetData(player)
    local abilityData = AbilitiesInfo.Abilities[abilityName] :: AbilitiesInfo.Ability

    if not data.Abilities.OwnedAbilities[abilityName] then
        return
    end

    local LastSwitched = data.Abilities.LastSwitched

    local nextSwitch = LastSwitched + 1
    if nextSwitch > data.Abilities.MaxAbilities then
        nextSwitch = 1
    end

    data.Abilities.LastSwitched = nextSwitch

    data.Abilities.CurrentAbilities[nextSwitch] = abilityName

    self.DataService:SetData(player, "Abilities", data.Abilities)

    self.NotificationService:NotifyPlayer("TextNImage", {
        Text = "Equipped " .. abilityName,
        Image = abilityData.Image,
        Color = Color3.fromRGB(115, 255, 21),
        Time = 5,
    }, player)

end

function AbilitiesService:UnequipAbility(player : Player, abilityName : string)

    local data = self.DataService:GetData(player)
    local abilityData = AbilitiesInfo.Abilities[abilityName] :: AbilitiesInfo.Ability

    local abilityIndex = table.find(data.Abilities.CurrentAbilities, abilityName)
    if not abilityIndex then
        return
    end

    data.Abilities.CurrentAbilities[abilityIndex] = ""

    self.DataService:SetData(player, "Abilities", data.Abilities)

    self.NotificationService:NotifyPlayer("TextNImage", {
        Text = "Unequipped " .. abilityName,
        Image = abilityData.Image,
        Color = Color3.fromRGB(115, 255, 21),
        Time = 5,
    }, player)

end

function AbilitiesService.Client:EquipAbility(player : Player, abilityName : string)

    self.Server:EquipAbility(player, abilityName)

end

function AbilitiesService.Client:UnequipAbility(player : Player, abilityName : string)

    self.Server:UnequipAbility(player, abilityName)

end

function AbilitiesService.Client:BuyAbility(player : Player, abilityName : string)

    local data = self.Server.DataService:GetData(player)
    local abilityData = AbilitiesInfo.Abilities[abilityName] :: AbilitiesInfo.Ability

    if abilityData.Product ~= 0 then
        MarketplaceService:PromptProductPurchase(player, abilityData.Product)
        return
    end

    if data.Cash < abilityData.Price then

        self.Server.NotificationService:NotifyPlayer("TextNImage", {
            Text = "Not enough cash",
            Image = "",
            Color = Color3.fromRGB(255, 0, 0),
            Time = 5,
        }, player)

        return
    end

    data.Cash = data.Cash - abilityData.Price

    data.Abilities.OwnedAbilities[abilityName] = (data.Abilities.OwnedAbilities[abilityName] or 0) + 1

    self.Server.DataService:SetData(player, "Abilities", data.Abilities)
    self.Server.DataService:SetData(player, "Cash", data.Cash)

    self.Server:EquipAbility(player, abilityName)

end

return AbilitiesService