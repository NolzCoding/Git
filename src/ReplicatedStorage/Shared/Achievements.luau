local module = {}
local Icons = require(script.Parent.Icons)
module.RewardImages = {
    Cash = Icons.BabyBucks,
    Crate = Icons.GiftBoxes.Green.Large,
}

module.Rewards = {
    ["Beginner Baby"] = {
        Title = "Beginner Baby",
        Description = "Deal 50 damage to yourself",
        Exp = 20,
        Action = "Damage",
        Amount = 50,
        RewardType = "Cash",
        Props = {
            Amount = 100
        }
    },

    ["Novice Baby"] = {
        Title = "Novice Baby",
        Description = "Deal 150 damage to yourself",
        Action = "Damage",
        Exp = 20,
        Amount = 150,
        RewardType = "Cash",
        Props = {
            Amount = 250
        }
    },

    ["Cool Baby"] = {
        Title = "Cool Baby",
        Description = "Deal 400 damage to yourself",
        Action = "Damage",
        Amount = 400,
        Exp = 20,
        RewardType = "Cash",
        Props = {
            Amount = 500
        }
    },

    ["100IQ Baby"] = {
        Title = "100IQ Baby",
        Description = "Deal 800 damage to yourself",
        Action = "Damage",
        Amount = 800,
        Exp = 25,

        RewardType = "Crate",
        Props = {
            Amount = 1,
            Name = "Skin Crate"
        }
    },

    ["200IQ Baby"] = {
        Title = "200IQ Baby",
        Description = "Deal 1500 damage to yourself",
        Action = "Damage",
        Amount = 1500,
        Exp = 50,
        RewardType = "Cash",
        Props = {
            Amount = 2000
        }
    },

    ["Turn on the oven"] = {
        Title = "You're cooking",
        Description = "Turn on the oven once",
        Action = "TurnOnOven",
        Amount = 1,
        Exp = 25,
        RewardType = "Crate",
        Props = {
            Amount = 1,
            Name = "Skin Crate"
        }
    },

    ["Chef"] = {
        Title = "You're a chef",
        Description = "Turn on the oven 5 times",
        Action = "TurnOnOven",
        Exp = 25,
        Amount = 5,
        RewardType = "Crate",
        Props = {
            Amount = 1,
            Name = "Skin Crate"
        }
    },

    ["Charged UP"] = {
        Title = "Charged UP",
        Exp = 25,
        Description = "Eat battery 5 times",
        Action = "Battery",
        Amount = 5,
        RewardType = "Cash",
        Props = {
            Amount = 200
        }
    },

    ["SUPER Charged UP"] = {
        Title = "SUPER Charged UP",
        Description = "Eat battery 20 times",
        Exp = 50,
        Action = "Battery",
        Amount = 20,
        RewardType = "Cash",
        Props = {
            Amount = 500
        }
    },

    ["MEGA Charged UP"] = {
        Title = "MEGA Charged UP",
        Description = "Eat battery 50 times",
        Action = "Battery",
        Exp = 100,
        Amount = 50,
        RewardType = "Cash",
        Props = {
            Amount = 1200
        }
    },


    ["Pickuper Noob"] = {
        Title = "Pickuper Noob",
        Description = "Pickup baby once",
        Action = "BabyPickup",
        Amount = 1,
        Exp = 25,
        RewardType = "Crate",
        Props = {
            Amount = 1,
            Name = "Ability Crate"
        }
    },

    ["Bath Baby"] = {
        Title = "Bath Baby",
        Description = "Turn on the bath once",
        Action = "Bath",
        Exp = 25,
        Amount = 1,
        RewardType = "Crate",
        Props = {
            Amount = 1,
            Name = "Ability Crate"
        }
    },

    ["Baby Gamer"] = {
        Title = "Baby Gamer",
        Description = "Play 1 game",
        Action = "Game",
        Exp = 25,
        Amount = 1,
        RewardType = "Crate",
        Props = {
            Amount = 1,
            Name = "Ability Crate"
        }
    },

    ["Sigma Gamer"] = {
        Title = "Sigma Gamer",
        Description = "Play 3 game",
        Action = "Game",
        Exp = 50,
        Amount = 3,
        RewardType = "Cash",
        Props = {
            Amount = 200
        }
    },

    ["SIGMA SIGMA Gamer"] = {
        Title = "SIGMA SIGMA Gamer",
        Description = "Play 10 game",
        Action = "Game",
        Exp = 100,
        Amount = 10,
        RewardType = "Cash",
        Props = {
            Amount = 500
        }
    }


}



return module