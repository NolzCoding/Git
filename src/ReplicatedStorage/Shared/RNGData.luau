local Skins = require(script.Parent.Skins)
local Abilities = require(script.Parent.Abilities)

local module = {}

local function _addSkinWithChance(skin, chance)
    local clone = table.clone(skin)
    clone.Chance = chance
    return clone
end

module.RNGTable = {
    ["Skin Crate"] = {
        _addSkinWithChance(Skins.Skins.Baby["Baby Chicken"], 0.3),
        _addSkinWithChance(Skins.Skins.Baby["Baby Shark"], 0.3),
        _addSkinWithChance(Skins.Skins.Baby["Scary Noob Baby"], 0.2),
        _addSkinWithChance(Skins.Skins.Parent["Mom"], 0.2),
    },

    ["Epic Skin Crate"] = {
        _addSkinWithChance(Skins.Skins.Baby["Batman"], 0.27),
        _addSkinWithChance(Skins.Skins.Baby["Adventure Baby"], 0.25),
        _addSkinWithChance(Skins.Skins.Baby["Emo Baby"], 0.15),
        _addSkinWithChance(Skins.Skins.Baby["Emo Girl"], 0.15),
        _addSkinWithChance(Skins.Skins.Parent["Bald Santa"], 0.1),
        _addSkinWithChance(Skins.Skins.Parent["Crazy Babysitter"], 0.08),
    },

    ["Ability Crate"] = {
        _addSkinWithChance(Abilities.Abilities.Jump, 0.5),
        _addSkinWithChance(Abilities.Abilities.Speed, 0.3),
        _addSkinWithChance(Abilities.Abilities.Invisibility, 0.2),
    },

}

module.RNGTableTypes = {
    ["Skin Crate"] = "Skin",
    ["Ability Crate"] = "Ability",
    ["Epic Skin Crate"] = "Skin",
}

module.RNGTableProductsIds = {
    ["Skin Crate"] = {
        [1] = 2689666148,
        [3] = 2689667076,
        [10] = 2689667404,
    },
    ["Epic Skin Crate"] = {
        [1] = 2689668257,
        [3] = 2689668970,
        [10] = 2689669692,
    },
    ["Ability Crate"] = {
        [1] = 2689671243,
        [3] = 2689672250,
        [10] = 2689672655,
    }
}

--[[local rollTable = {
    {
        Name = "Item 1",
        Rarity = "Common",
        Image = Icons.OrganHeart,
        Chance = 0.5,
    },
    {
        Name = "Item 2",
        Rarity = "Uncommon",
        Image = Icons.Rocket,
        Chance = 0.3,
    },
    {
        Name = "Item 3",
        Rarity = "Rare",
        Image = Icons.EmptyHeart,
        Chance = 0.15,
    },
    {
        Name = "Item 4",
        Rarity = "Epic",
        Image = "rbxassetid://127092089997800",
        Chance = 0.04,
    },
    {
        Name = "Item 5",
        Rarity = "Legendary",
        Image = "rbxassetid://127092089997800",
        Chance = 0.01,
    },
}
]]
return module