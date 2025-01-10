


local module = {}


module.Maps = {
    {
        Name = "House",
        Image = "rbxassetid://131669270740763",
    },
    {
        Name = "The Office",
        Image = "rbxassetid://107553320442603",
    }
}

module.ItemSpawns = {

    ["House"] = {
        Drawer = {
            Battery = {
                Max = 1,
                Min = 1,
                Chance = 0.1,
            },
            Soap = {
                Max = 1,
                Min = 1,
                Chance = 0.2,
            },

            Lighter = {
                Max = 1,
                Min = 1,
                Chance = 0.1,
            },

            Taser = {
                Max = 1,
                Min = 1,
                Chance = 0.01,
            },

        },

        TVCabinets = {

            Battery = {
                Max = 1,
                Min = 1,
                Chance = 0.5,
            },

            Lighter = {
                Max = 1,
                Min = 1,
                Chance = 0.2,
            },


        },

        KnifeHanger = {

            Knife = {
                Max = 1,
                Min = 1,
                Chance = 1,
            },

        },

        KitchenCabinet = {

            Fork = {
                Max = 1,
                Min = 1,
                Chance = 0.5,
            },

            Medicine = {
                Max = 1,
                Min = 1,
                Chance = 0.3,
            },

            Basement_Key = {
                Max = 1,
                Min = 1,
                Chance = 0.05,
            },
        },

    },

    ["The Office"] = {

        Drawer = {
            Battery = {
                Max = 1,
                Min = 1,
                Chance = 0.1,
            },


            Soap = {
                Max = 1,
                Min = 1,
                Chance = 0.2,
            },

            Lighter = {
                Max = 1,
                Min = 1,
                Chance = 0.1,
            },

            Taser = {
                Max = 1,
                Min = 1,
                Chance = 1,
            },

        },

        TVCabinets = {
            Battery = {
                Max = 1,
                Min = 1,
                Chance = 0.5,
            },

            Lighter = {
                Max = 1,
                Min = 1,
                Chance = 0.2,
            },


        },

        KnifeHanger = {

            Knife = {
                Max = 1,
                Min = 1,
                Chance = 1,
            },

        },

        KitchenCabinet = {

            Fork = {
                Max = 1,
                Min = 1,
                Chance = 0.5,
            },

            Medicine = {
                Max = 1,
                Min = 1,
                Chance = 0.3,
            },

            Basement_Key = {
                Max = 1,
                Min = 1,
                Chance = 0.05,
            },
        },

    },

}

return module
