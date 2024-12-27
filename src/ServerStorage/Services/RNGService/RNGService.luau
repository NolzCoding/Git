local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local RNGData = require(ReplicatedStorage.Source.Shared.RNGData)
local Skins = require(ReplicatedStorage.Source.Shared.Skins)
local RNGService = Knit.CreateService{
    Name = "RNGService",
    Client = {
    },

}

function RNGService:KnitStart()
    print("RNGService KnitStart")
    self.DataService = Knit.GetService("DataService")
    self.Handlers = {}


    self.Handlers["Skin"] = function(player : Player, skin : Skins.Skin)
        -- add skin to player
        local data = self.DataService:GetData(player)
        local skinAmount = data.Skins[skin.Type].OwnedSkins[skin.Name]
        print(skinAmount)
        data.Skins[skin.Type].OwnedSkins[skin.Name] = (skinAmount or 0) + 1

        self.DataService:SetData(player, "Skins" ,data.Skins)

    end

    self.Handlers["Ability"] = function(player : Player, ability : Abilities.Ability)
        -- add ability to player
        local data = self.DataService:GetData(player)
        local abilityAmount = data.Abilities.OwnedAbilities[ability.Name]
        data.Abilities.OwnedAbilities[ability.Name] = (abilityAmount or 0) + 1

        self.DataService:SetData(player, "Abilities", data.Abilities)
    end

end



function RNGService.Client:OpenCrate(player : Player, crateName : string)

    local crate = RNGData.RNGTable[crateName]

    local data = self.Server.DataService:GetData(player)

    if not crate then
        warn("Crate not found")
        return
    end

    if not data.Inventory.Crates[crateName] or data.Inventory.Crates[crateName] == 0 then
        return
    end

    local typeofAward = RNGData.RNGTableTypes[crateName]

    local totalChance = 0
    for _, skin in ipairs(crate) do
        totalChance += skin.Chance
    end

    local roll = math.random() * totalChance

    local total = 0
    local wonSkin = nil

    for _, skin in ipairs(crate) do
        total += skin.Chance
        if roll <= total then
            print("You got: ", skin.Name)
            wonSkin = skin
            break
        end
    end

    self.Server.Handlers[typeofAward](player, wonSkin)

    -- remove crate from player
    data.Inventory.Crates[crateName] = data.Inventory.Crates[crateName] - 1
    self.Server.DataService:SetData(player, "Inventory", data.Inventory)
    return wonSkin

end


return RNGService