local module = {}
local Icons = require(game:GetService("ReplicatedStorage").Source.Shared.Icons)
local Skins = require(game:GetService("ReplicatedStorage").Source.Shared.Skins)
local Abilities = require(game:GetService("ReplicatedStorage").Source.Shared.Abilities)

module.RarityColors = {
    Common = Color3.fromRGB(196, 196, 196),
    Uncommon = Color3.fromRGB(136, 255, 68),
    Rare = Color3.fromRGB(53, 124, 255),
    Epic = Color3.fromRGB(220, 45, 255),
    Legendary = Color3.fromRGB(255, 164, 45),
    Exotic = Color3.fromRGB(255, 45, 45),
    Cosmos = Color3.fromRGB(36, 36, 36),
}

export type PassLevel = {
    Name : string,
    Image : string,
    RequiredEXP : number,
    RewardType : string,
    Args : {
        any
    },
    Rarity : "Common" | "Uncommon" | "Rare" | "Epic" | "Legendary",
}

module.FreePassS1 = {

    {
        Name = "+100",
        Image = Icons.BabyBucks,
        RequiredEXP = 0,
        RewardType = "Cash",
        Args = {
            100
        },
        Rarity = "Common"
    },
    {
        Name = "",
        Image = "",
        RequiredEXP = 100,
        RewardType = "",
        Args = {
            200
        },
        Rarity = "Common"
    },

    {
        Name = "",
        Image = "",
        RequiredEXP = 100,
        RewardType = "",
        Args = {
            200
        },
        Rarity = "Common"
    },

    {
        Name = "1x Jump",
        Image = Icons.Rocket,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Jump", 1
        },
        Rarity = "Common"
    },

    {
        Name = "",
        Image = "",
        RequiredEXP = 100,
        RewardType = "",
        Args = {
            200
        },
        Rarity = "Common"
    },

    {
        Name = "",
        Image = "",
        RequiredEXP = 100,
        RewardType = "",
        Args = {
            200
        },
        Rarity = "Common"
    },

    {
        Name = "2x Jump",
        Image = Icons.Rocket,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Jump", 2
        },
        Rarity = "Uncommon"
    },

    {
        Name = "",
        Image = "",
        RequiredEXP = 100,
        RewardType = "",
        Args = {
            200
        },
        Rarity = "Common"
    },
    {
        Name = "x3 Speed",
        Image = Icons.YellowLightning,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Speed", 3
        },
        Rarity = "Epic"
    },
    {
        Name = "",
        Image = "",
        RequiredEXP = 100,
        RewardType = "",
        Args = {
            200
        },
        Rarity = "Common"
    },
    {
        Name = "",
        Image = "",
        RequiredEXP = 100,
        RewardType = "",
        Args = {
            200
        },
        Rarity = "Common"
    },
    {
        Name = "x2 Jump",
        Image = Icons.Rocket,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Jump", 2
        },
        Rarity = "Uncommon"
    },
    {
        Name = "",
        Image = "",
        RequiredEXP = 100,
        RewardType = "",
        Args = {
            200
        },
        Rarity = "Common"
    },
    {
        Name = "",
        Image = "",
        RequiredEXP = 100,
        RewardType = "",
        Args = {
            200
        },
        Rarity = "Common"
    },
    {
        Name = "Baby Shark",
        Image = Skins.Skins.Baby["Baby Shark"].Image,
        RequiredEXP = 100,
        RewardType = "Skin",
        Args = {
            "Baby", "Baby Shark"
        },
        Rarity = "Epic"
    },
    {
        Name = "",
        Image = "",
        RequiredEXP = 100,
        RewardType = "",
        Args = {
            200
        },
        Rarity = "Common"
    },
    {
        Name = "x1 Invisibility",
        Image = Abilities.Abilities.Invisibility.Image,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Invisibility", 1
        },
        Rarity = "Legendary"
    },
    {
        Name = "",
        Image = "",
        RequiredEXP = 100,
        RewardType = "",
        Args = {
            200
        },
        Rarity = "Common"
    },
    {
        Name = "",
        Image = "",
        RequiredEXP = 100,
        RewardType = "",
        Args = {
            200
        },
        Rarity = "Common"
    },
    {
        Name = "x3 Speed",
        Image = Icons.YellowLightning,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Speed", 3
        },
        Rarity = "Epic"
    },
    {
        Name = "Sigma",
        Image = Skins.Skins.Baby["Sigma"].Image,
        RequiredEXP = 50,
        RewardType = "Skin",
        Args = {
            "Baby", "Sigma"
        },
        Rarity = "Cosmos"
    },


} :: {PassLevel}

module.PremiumPassS1 = {

    {
        Name = "Baby Ninja",
        Image = Skins.Skins.Baby["Baby Ninja"].Image,
        RequiredEXP = 50,
        RewardType = "Skin",
        Args = {
            "Baby", "Baby Ninja"
        },
        Rarity = "Epic"
    },
    {
        Name = "+200",
        Image = Icons.BabyBucks,
        RequiredEXP = 100,
        RewardType = "Cash",
        Args = {
            500
        },
        Rarity = "Uncommon"
    },
    {
        Name = "x3 Jump",
        Image = Icons.Rocket,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Jump", 3
        },
        Rarity = "Rare"
    },

    {
        Name = "x3 Speed",
        Image = Icons.YellowLightning,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Speed", 3
        },
        Rarity = "Epic"
    },

    {
        Name = "+200",
        Image = Icons.BabyBucks,
        RequiredEXP = 100,
        RewardType = "Cash",
        Args = {
            400
        },
        Rarity = "Uncommon"
    },

    {
        Name = "x1 Jump",
        Image = Icons.Rocket,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Jump", 1
        },
        Rarity = "Common"
    },

    {
        Name = "x1 Invisibility",
        Image = Abilities.Abilities.Invisibility.Image,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Invisibility", 1
        },
        Rarity = "Legendary"
    },

    {
        Name = "+150",
        Image = Icons.BabyBucks,
        RequiredEXP = 100,
        RewardType = "Cash",
        Args = {
            600
        },
        Rarity = "Uncommon"
    },

    {
        Name = "x1 Invisibility",
        Image = Abilities.Abilities.Invisibility.Image,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Invisibility", 1
        },
        Rarity = "Legendary"
    },

    {
        Name = "Squid Game",
        Image = Skins.Skins.Parent["Squid Game"].Image,
        RequiredEXP = 50,
        RewardType = "Skin",
        Args = {
            "Parent", "Squid Game"
        },
        Rarity = "Exotic"
    },

    {
        Name = "+150",
        Image = Icons.BabyBucks,
        RequiredEXP = 100,
        RewardType = "Cash",
        Args = {
            500
        },
        Rarity = "Common"
    },

    {
        Name = "x2 Jump",
        Image = Icons.Rocket,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Jump", 2
        },
        Rarity = "Uncommon"
    },

    {
        Name = "x3 Speed",
        Image = Icons.YellowLightning,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Speed", 3
        },
        Rarity = "Epic"
    },

    {
        Name = "+150",
        Image = Icons.BabyBucks,
        RequiredEXP = 100,
        RewardType = "Cash",
        Args = {
            600
        },
        Rarity = "Common"
    },

    {
        Name = "+500",
        Image = Icons.BabyBucks,
        RequiredEXP = 100,
        RewardType = "Cash",
        Args = {
            1000
        },
        Rarity = "Rare"
    },

    {
        Name = "Adventure Baby",
        Image = Skins.Skins.Baby["Adventure Baby"].Image,
        RequiredEXP = 50,
        RewardType = "Skin",
        Args = {
            "Baby", "Squid Game"
        },
        Rarity = "Epic"
    },

    {
        Name = "x3 Invisibility",
        Image = Abilities.Abilities.Invisibility.Image,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Invisibility", 1
        },
        Rarity = "Exotic"
    },

    {
        Name = "x5 Jump",
        Image = Icons.Rocket,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Jump", 5
        },
        Rarity = "Epic"
    },

    {
        Name = "Yo Mama",
        Image = Skins.Skins.Parent["Yo Mama"].Image,
        RequiredEXP = 50,
        RewardType = "Skin",
        Args = {
            "Parent", "Yo Mama"
        },
        Rarity = "Exotic"
    },

    {
        Name = "x3 Jump",
        Image = Icons.Rocket,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Jump", 3
        },
        Rarity = "Uncommon"
    },

    {
        Name = "x3 Speed",
        Image = Icons.YellowLightning,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Speed", 3
        },
        Rarity = "Epic"
    },

    {
        Name = "x5 Speed",
        Image = Icons.YellowLightning,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Speed", 3
        },
        Rarity = "Legendary"
    },

    {
        Name = "x3 Invisibility",
        Image = Abilities.Abilities.Invisibility.Image,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Invisibility", 1
        },
        Rarity = "Exotic"
    },

    {
        Name = "x10 Speed",
        Image = Icons.YellowLightning,
        RequiredEXP = 150,
        RewardType = "Ability",
        Args = {
            "Speed", 3
        },
        Rarity = "Exotic"
    },

    {
        Name = "KAREN",
        Image = Skins.Skins.Parent["Karen"].Image,
        RequiredEXP = 150,
        RewardType = "Skin",
        Args = {
            "Parent", "Karen"
        },
        Rarity = "Cosmos"
    },




} :: {PassLevel}

-- levels should be same

module.EXP = {
}

for i = 1, 25 do
    module.EXP[i] = i * 25 + i*i
end

for _, pass in ipairs(module.FreePassS1) do
    pass.RequiredEXP = module.EXP[_]
end

for _, pass in ipairs(module.PremiumPassS1) do
    pass.RequiredEXP = module.EXP[_]
end



return module