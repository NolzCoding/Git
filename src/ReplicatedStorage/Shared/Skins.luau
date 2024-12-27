local module = {}



module.RarityColors = {
    Common = Color3.fromRGB(196, 196, 196),
    Uncommon = Color3.fromRGB(136, 255, 68),
    Rare = Color3.fromRGB(53, 124, 255),
    Epic = Color3.fromRGB(220, 45, 255),
    Legendary = Color3.fromRGB(255, 164, 45),
}

export type Skin = {
    Name : string,
    Description : string,
    Rarity : "Common" | "Uncommon" | "Rare" | "Epic" | "Legendary",
    Price : number,
    PriceType : "Cash" | "Robux",
    Product : number,
    Type : "Parent" | "Baby",
    Image : string,
}

module.Skins = {
    Parent = {

        ["Parent"] = {
            Name = "Parent",
            Description = "Parent",
            Rarity = "Common",
            Price = 0,
            Type = "Parent",
            PriceType = "Cash",
            Product = 0,
            Image = "rbxassetid://127092089997800",
        }

    },
    Baby = {

        ["Baby"] = {
            Name = "Baby",
            Type = "Baby",
            Description = "Baby",
            Rarity = "Common",
            Price = 0,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://80306701670551",
        },

        ["Scary Noob Baby"] = {
            Name = "Scary Noob Baby",
            Type = "Baby",
            Description = "Scary Noob Baby",
            Rarity = "Uncommon",
            Price = 100,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://83273303239269",
        },

        ["Batman"] = {
            Name = "Batman",
            Type = "Baby",
            Description = "Batman",
            Rarity = "Rare",
            Price = 200,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://133536449934766",
        },

        ["Adventure Baby"] = {
            Name = "Adventure Baby",
            Type = "Baby",
            Description = "Adventure Baby",
            Rarity = "Epic",
            Price = 300,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://126099632237321",
        },


    }
} :: {
    Parent : {[string] : Skin},
    Baby : {[string] : Skin},
}

return module