


local module = {}


module.Maps = {
    {
        Name = "House",
        Image = "rbxassetid://131669270740763",
    },
    {
        Name = "The Office",
        Image = "rbxassetid://106397944537475",
    }
}

module.ItemSpawns = {

    House = {
        Battery = {
            SpawnsIn = {
                Drawer = 10,
                TVCabinets = 5,
            },
        },

        Soap = {
            SpawnsIn = {
                Drawer = 6,
            },
        },

        Lighter = {
            SpawnsIn = {
                Drawer = 5,
                TVCabinets = 3,
            },
        },

        Taser = {
            SpawnsIn = {
                Drawer = 1,
            },
        },

        Knife = {
            SpawnsIn = {
                KnifeHanger = 1,
            },
        },

        Fork = {
            SpawnsIn = {
                KitchenCabinet = 5,
            },
        },

        Medicine = {
            SpawnsIn = {
                KitchenCabinet = 2,
                TVCabinets = 1,
            },
        },

        Basement_Key = {
            SpawnsIn = {
                KitchenCabinet = 1,
            },
        },

    },

    ["The Office"] = {
        Battery = {
            SpawnsIn = {
                Drawer = 15,
                TVCabinets = 3,
            },
        },

        Soap = {
            SpawnsIn = {
                Drawer = 8,
            },
        },

        Lighter = {
            SpawnsIn = {
                Drawer = 5,
                TVCabinets = 3,
            },
        },

        Taser = {
            SpawnsIn = {
                Drawer = 1,
            },
        },

        Knife = {
            SpawnsIn = {
                KnifeHanger = 1,
            },
        },

        Fork = {
            SpawnsIn = {
                KitchenCabinet = 5,
            },
        },

        Medicine = {
            SpawnsIn = {
                KitchenCabinet = 2,
                TVCabinets = 1,
            },
        },



    }

    --[[["House"] = {
        Drawer = {
            Battery = {
                Max = 1,
                Min = 1,
                Chance = 0.2,
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
                Chance = 0.25,
            },


            Soap = {
                Max = 1,
                Min = 1,
                Chance = 0.15,
            },

            Lighter = {
                Max = 1,
                Min = 1,
                Chance = 0.12,
            },

            Taser = {
                Max = 1,
                Min = 1,
                Chance = 0.025,
            },

        },

        TVCabinets = {
            Battery = {
                Max = 1,
                Min = 1,
                Chance = 1,
            },

            Lighter = {
                Max = 1,
                Min = 1,
                Chance = 0.5,
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

    },]]

}

return module
