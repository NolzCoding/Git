local module = {}

module.RarityColors = {
    Common = Color3.fromRGB(196, 196, 196),
    Uncommon = Color3.fromRGB(136, 255, 68),
    Rare = Color3.fromRGB(53, 124, 255),
    Epic = Color3.fromRGB(220, 45, 255),
    Legendary = Color3.fromRGB(255, 164, 45),
}

module.Abilities = {
    ["Jump"] = {
        Name = "Jump",
        Cooldown = 5,
        Description = "Jump",
        Rarity = "Common",
        Price = 0,
        PriceType = "Cash",
        Product = 0,
        Type = "Parent",
        Image = "rbxassetid://118755245115123",
    },
    ["Invisibility"] = {
        Name = "Invisibility",
        Cooldown = 30,
        Description = "Invisibility",
        Rarity = "Legendary",
        Price = 0,
        PriceType = "Cash",
        Product = 0,
        Type = "Parent",
        Image = "rbxassetid://122904175455570",
    },
    ["Speed"] = {
        Name = "Speed",
        Cooldown = 30,
        Description = "Speed",
        Rarity = "Uncommon",
        Price = 0,
        PriceType = "Cash",
        Product = 0,
        Type = "Parent",
        Image = "rbxassetid://130407257711627",
    }
}

return module