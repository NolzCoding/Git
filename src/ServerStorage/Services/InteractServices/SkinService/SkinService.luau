local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local MarketplaceService = game:GetService("MarketplaceService")
local ServerStorage = game:GetService("ServerStorage")
local CharacterBaseServer = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local SkinInfo = require(ReplicatedStorage.Source.Shared.Skins)
local SkinService = Knit.CreateService({
    Name = "SkinService";
    Client = {
    }

})


function SkinService:KnitInit()



end

function SkinService:KnitStart()

    self.DataService = Knit.GetService("DataService")
    self.NotificationService = Knit.GetService("NotificationService")
    self.CharacterService = Knit.GetService("CharacterService")

end

function SkinService:EquipSkin(player : Player, skinName : string, skinType : string)

    local data = self.DataService:GetData(player)
    local skinData = SkinInfo.Skins[skinType][skinName] :: SkinInfo.Skin

    if not data.Skins[skinData.Type].OwnedSkins[skinName] then
        return
    end

    data.Skins[skinData.Type].CurrentSkin = skinName

    self.DataService:SetData(player, "Skins", data.Skins)

    self.NotificationService:NotifyPlayer("TextNImage", {
        Text = "Equipped " .. skinName,
        Image = skinData.Image,
        Color = Color3.fromRGB(115, 255, 21),
        Time = 5,
    }, player)


    if player:HasTag("InGame") then
        return
    end

    local character = self.CharacterService:GetCharacter(player) :: CharacterBaseServer.CharacterBaseServer
    character:NewMorph(ReplicatedStorage.Data.Skins:FindFirstChild(skinName))

end

function SkinService:UnequipSkin(player : Player, skinName : string, skinType : string)

    local data = self.DataService:GetData(player)
    local skinData = SkinInfo.Skins[skinType][skinName] :: SkinInfo.Skin
    data.Skins[skinData.Type].CurrentSkin = skinData.Type

    self.DataService:SetData(player, "Skins", data.Skins)

    self.NotificationService:NotifyPlayer("TextNImage", {
        Text = "Unequipped " .. skinName,
        Image = skinData.Image,
        Color = Color3.fromRGB(115, 255, 21),
        Time = 5,
    }, player)

end

function SkinService.Client:EquipSkin(player : Player, skinName : string, skinType : string)

    self.Server:EquipSkin(player, skinName, skinType)

end

function SkinService.Client:UnequipSkin(player : Player, skinName : string, skinType : string)

    self.Server:UnequipSkin(player, skinName, skinType)

end

function SkinService.Client:BuySkin(player : Player, skinName : string, skinType : string)

    local data = self.Server.DataService:GetData(player)
    local skinData = SkinInfo.Skins[skinType][skinName] :: SkinInfo.Skin

    if skinData.Product ~= 0 then
        MarketplaceService:PromptProductPurchase(player, skinData.Product)
        return
    end

    if data.Skins[skinType].OwnedSkins[skinName] then
        return
    end

    if data.Cash < skinData.Price then

        self.Server.NotificationService:NotifyPlayer("TextNImage", {
            Text = "Not enough cash",
            Image = "",
            Color = Color3.fromRGB(255, 0, 0),
            Time = 5,
        }, player)

        return
    end

    data.Cash = data.Cash - skinData.Price

    data.Skins[skinData.Type].OwnedSkins[skinName] = 1

    self.Server.DataService:SetData(player, "Skins", data.Skins)
    self.Server.DataService:SetData(player, "Cash", data.Cash)

    self.Server:EquipSkin(player, skinName, skinType)

end

return SkinService