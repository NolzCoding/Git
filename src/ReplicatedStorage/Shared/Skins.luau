local module = {}



module.RarityColors = {
    Common = Color3.fromRGB(196, 196, 196),
    Uncommon = Color3.fromRGB(136, 255, 68),
    Rare = Color3.fromRGB(53, 124, 255),
    Epic = Color3.fromRGB(220, 45, 255),
    Legendary = Color3.fromRGB(255, 164, 45),
    Exotic = Color3.fromRGB(255, 45, 45),
}

export type Skin = {
    Name : string,
    Description : string,
    Rarity : "Common" | "Uncommon" | "Rare" | "Epic" | "Legendary" | "Exotic",
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
            Price = 1000,
            Type = "Parent",
            PriceType = "Cash",
            Product = 0,
            Image = "rbxassetid://139776782383788",
        },
        ["Bald Santa"] = {
            Name = "Bald Santa",
            Description = "Bald Santa",
            Rarity = "Rare",
            Price = 500,
            Type = "Parent",
            PriceType = "Cash",
            Product = 0,
            Image = "rbxassetid://113135426792521",
        },
        ["Mom"] = {
            Name = "Mom",
            Description = "Mom",
            Rarity = "Common",
            Price = 200,
            Type = "Parent",
            PriceType = "Cash",
            Product = 0,
            Image = "rbxassetid://108872037085753",
        },

        ["Squid Game"] = {
            Name = "Squid Game",
            Description = "Squid Game",
            Rarity = "Rare",
            Price = 800,
            Type = "Parent",
            PriceType = "Cash",
            Product = 0,
            Image = "rbxassetid://83934968901584",
        },

        ["Squid Game Doll"] = {
            Name = "Squid Game Doll",
            Description = "Squid Game Doll",
            Rarity = "Epic",
            Price = 2000,
            Type = "Parent",
            PriceType = "Cash",
            Product = 0,
            Image = "rbxassetid://104127407893469",
        },

        ["Yo Mama"] = {
            Name = "Yo Mama",
            Description = "Yo Mama",
            Rarity = "Legendary",
            Price = 3000,
            Type = "Parent",
            PriceType = "Cash",
            Product = 0,
            Image = "rbxassetid://106628402209458",
        },

        ["Caseoh"] = {
            Name = "Caseoh",
            Description = "Caseoh",
            Rarity = "Legendary",
            Price = 5000,
            Type = "Parent",
            PriceType = "Cash",
            Product = 0,
            Image = "rbxassetid://105532765051447",
        },

        ["Karen"] = {
            Name = "Karen",
            Description = "Karen",
            Rarity = "Exotic",
            Price = 10000,
            Type = "Parent",
            PriceType = "Cash",
            Product = 0,
            Image = "rbxassetid://72661369678065",
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

        ["Baby Ninja"] = {
            Name = "Baby Ninja",
            Type = "Baby",
            Description = "Baby Ninja",
            Rarity = "Uncommon",
            Price = 750,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://117061821681900",
        },

        ["Cry Baby"] = {
            Name = "Cry Baby",
            Type = "Baby",
            Description = "Cry Baby",
            Rarity = "Uncommon",
            Price = 750,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://84616139118709",
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

        ["Player196"] = {
            Name = "Player196",
            Type = "Baby",
            Description = "Player196",
            Rarity = "Rare",
            Price = 1500,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://130833846819290",
        },

        ["Iron Baby"] = {
            Name = "Iron Baby",
            Type = "Baby",
            Description = "Iron Baby",
            Rarity = "Rare",
            Price = 1500,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://113291087067072",
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
            Price = 6000,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://86324623174272",
        },

        ["Sigma"] = {
            Name = "Sigma",
            Type = "Baby",
            Description = "Litteraly you lmao",
            Rarity = "Exotic",
            Price = 8000,
            Product = 0,
            PriceType = "Cash",
            Image = "rbxassetid://110129535404722",
        },

    }
} :: {
    Parent : {[string] : Skin},
    Baby : {[string] : Skin},
}

return module