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
        },
        ["Crazy Babysitter"] = {
            Name = "Crazy Babysitter",
            Description = "Crazy Babysitter",
            Rarity = "Epic",
            Price = 0,
            Type = "Parent",
            PriceType = "Cash",
            Product = 0,
            Image = "rbxassetid://139776782383788",
        },
        ["Bald Santa"] = {
            Name = "Bald Santa",
            Description = "Bald Santa",
            Rarity = "Rare",
            Price = 0,
            Type = "Parent",
            PriceType = "Cash",
            Product = 0,
            Image = "rbxassetid://113135426792521",
        },
        ["Mom"] = {
            Name = "Mom",
            Description = "Mom",
            Rarity = "Common",
            Price = 0,
            Type = "Parent",
            PriceType = "Cash",
            Product = 0,
            Image = "rbxassetid://108872037085753",
        },
        ["Yo Mama"] = {
            Name = "Yo Mama",
            Description = "Yo Mama",
            Rarity = "Legendary",
            Price = 0,
            Type = "Parent",
            PriceType = "Cash",
            Product = 0,
            Image = "rbxassetid://106628402209458",
        },

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
            Image = "rbxassetid://92725509023611",
        },

        ["Baby Shark"] = {
            Name = "Baby Shark",
            Type = "Baby",
            Description = "Litteraly you lmao",
            Rarity = "Common",
            Price = 500,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://135983993891195",
        },

        ["Baby Chicken"] = {
            Name = "Baby Chicken",
            Type = "Baby",
            Description = "Litteraly you lmao",
            Rarity = "Common",
            Price = 500,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://112358190717616",
        },

        ["Scary Noob Baby"] = {
            Name = "Scary Noob Baby",
            Type = "Baby",
            Description = "Scary Noob Baby",
            Rarity = "Uncommon",
            Price = 750,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://83273303239269",
        },

        ["Batman"] = {
            Name = "Batman",
            Type = "Baby",
            Description = "Batman",
            Rarity = "Rare",
            Price = 1000,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://133536449934766",
        },

        ["Adventure Baby"] = {
            Name = "Adventure Baby",
            Type = "Baby",
            Description = "Adventure Baby",
            Rarity = "Epic",
            Price = 2000,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://126099632237321",
        },

        ["Nerd"] = {
            Name = "Nerd",
            Type = "Baby",
            Description = "Litteraly you lmao",
            Rarity = "Legendary",
            Price = 199,
            Product = 2688415605,
            PriceType = "Cash",
            Image = "rbxassetid://94459533670867",
        },

        ["Emo Baby"] = {
            Name = "Emo Baby",
            Type = "Baby",
            Description = "Litteraly you lmao",
            Rarity = "Epic",
            Price = 5000,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://136217569373398",
        },

        ["Emo Girl"] = {
            Name = "Emo Girl",
            Type = "Baby",
            Description = "Litteraly you lmao",
            Rarity = "Legendary",
            Price = 8000,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://86324623174272",
        },

    }
} :: {
    Parent : {[string] : Skin},
    Baby : {[string] : Skin},
}

return module