local Skins = {}
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children, OnEvent = Fusion.Children, Fusion.OnEvent
local peek = Fusion.peek
local computed = Fusion.Computed
local forKeys = Fusion.ForKeys
local forPairs = Fusion.ForPairs
local forValues = Fusion.ForValues
local new = Fusion.New
local Card = require(script.Parent.Parent.Parent.Components.UI.Card)
local Window = require(script.Parent.Parent.Parent.Components.UI.Window)
local DefaultButton = require(script.Parent.Parent.Parent.Components.Buttons.DefaultButton)
local ViewportFrame = require(script.Parent.Parent.Parent.Components.UI.ViewportFrame)
local Sticker = require(script.Parent.Parent.Parent.Components.UI.Sticker)
local TextLabelWithStroke = require(script.Parent.Parent.Parent.Components.Text.TextLabelWithStroke)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local Section = require(script.Parent.Parent.Parent.Components.UI.Section)
local SkinsInfo = require(ReplicatedStorage.Source.Shared.Skins)
function Skins:Start() -- knit start

end

local skinsInShop = {
    Baby = {
        "Nerd",
        "Adventure Baby",
        "Batman",
        "Scary Noob Baby",
        "Baby Chicken",
        "Baby Shark",
        "Emo Baby",
        "Emo Girl",
        "Player196",
    },
    Parent = {
        "Bald Santa",
        "Mom",
        "Yo Mama",
        "Crazy Babysitter",
        "Squid Game",
        "Squid Game Doll"
    }
}

local function orderSkins()

    local orderedSkins = {}

    for skinType, skins in pairs(skinsInShop) do
        orderedSkins[skinType] = {}
        for _, skinName in ipairs(skins) do
            local skinData = SkinsInfo.Skins[skinType][skinName]
            table.insert(orderedSkins[skinType], {
                Name = skinName,
                Price = skinData.Price,
                Product = skinData.Product
            })
        end

        table.sort(orderedSkins[skinType], function(a, b)

            if a.Product ~= 0 and b.Product == 0 then
                return true
            elseif a.Product == 0 and b.Product ~= 0 then
                return false
            end

            if a.Product ~= 0 and b.Product ~= 0 then
                return a.Product > b.Product
            end

            return a.Price > b.Price
        end)



    end

    local orderedList = {
        Baby = {},
        Parent = {},
    }

    for skinType, skins in pairs(orderedSkins) do
        for _, skin in ipairs(skins) do
            table.insert(orderedList[skinType], skin.Name)
        end
    end

    return orderedList

end

local order = orderSkins()

print(order)

skinsInShop.Baby = order.Baby
skinsInShop.Parent = order.Parent

function skin (scope, props : {
    RarityColor : Color3,
    SkinName : string,
    Clicked : () -> (),
    Equipped : boolean,
    Amount : number,
    TypeOfSkin : "Baby" | "Parent",
})

    return scope:New "Frame" {
        Size = UDim2.fromScale(0.1, 0.1),
        BackgroundTransparency = 1,
        [Children] = {

            scope : New "ImageButton" {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Image = "rbxassetid://85650865183366",
                ImageColor3 = props.RarityColor,
                ClipsDescendants = true,
                [Children] = {

                    scope:New "ImageLabel" {
                        Image = SkinsInfo.Skins[props.TypeOfSkin][props.SkinName].Image,
                        Size = UDim2.fromScale(1.2, 1.2),
                        Position = UDim2.fromScale(0.5, 0.65),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                    },

                    scope : New "UIAspectRatioConstraint" {
                        AspectRatio = 1,
                    },

                },

                [OnEvent("MouseButton1Click")] = function()
                    props.Clicked()
                end,

            },

            scope : New "ImageLabel" {
                Image = Icons.CheckMark64,
                Size = UDim2.fromScale(0.2, 0.2),
                Position = UDim2.fromScale(0.1, 0.1),
                BackgroundTransparency = 1,
                Visible = props.Equipped,
            },

            scope : New "UIAspectRatioConstraint" {
                AspectRatio = 1,
            },

            TextLabelWithStroke(scope, {
                Text = props.Amount .. "x",
                Size = UDim2.fromScale(0.2, 0.2),
                Position = UDim2.fromScale(0.8, 0.8),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                StrokeColor3 = props.RarityColor,
                Thickness = 2,
                ZIndex = 1,
            })

        }

    }

end

function Skins:Build(scope : typeof(Fusion.scoped(Fusion)), open)

    local selectedCatagory = scope:Value("Baby")

    self.DataController = Knit.GetController("DataController")
    self.DataService = Knit.GetService("DataService")
    self.SkinService = Knit.GetService("SkinService")
    self.CharacterService = Knit.GetService("CharacterService")

    local ready, data = self.DataService.DataProperty:OnReady():await()
    print(data, "Recived")
    local skinsData = scope:Value(data.Skins)

    local babySkins = scope:Value(data.Skins.Baby.OwnedSkins)
    local parentSkins = scope:Value(data.Skins.Parent.OwnedSkins)

    self.DataController:OnDataChanged("Skins", function(data)
        skinsData:set(data)
        babySkins:set(data.Baby.OwnedSkins)
        parentSkins:set(data.Parent.OwnedSkins)

    end)

    local highlightedSkin = scope:Value(
        "None"
    )

    print("Data ready", data)

    local tobeReturned = Window(scope, {
		HeaderText = "Skins",
        Size = UDim2.fromScale(0.6, 0.6),
		Open = open,
        HeaderSize = UDim2.fromScale(0.3, 0.2),
        HeaderPosition = UDim2.fromScale(0.2, -0.05),
		Build = function(scope)
			return {

                DefaultButton(scope, {
                    Position = UDim2.fromScale(0, 0.25),
                    Size = UDim2.fromScale(0.2, 0.2),
                    Text = "Parent",
                    Visible = true,
                    ZIndex = 4,
                    ButtonUp = function()
                        selectedCatagory:set("Parent")
                    end,
                    ButtonDown = function()
                    end,
                }),

                DefaultButton(scope, {

                    Position = UDim2.fromScale(0, 0.5),
                    Size = UDim2.fromScale(0.2, 0.2),
                    Text = "Baby",
                    Visible = true,
                    ZIndex = 4,
                    ButtonUp = function()
                        print("Selected Baby")
                        selectedCatagory:set("Baby")
                    end,
                    ButtonDown = function()
                    end,
                }),

                scope:New "ImageLabel" {
                    ZIndex = 3,
                    Size = UDim2.fromScale(0.3, 0.8),
                    Position = UDim2.fromScale(0.8, 0.5),
                    BackgroundTransparency = 1,
                    Image = Icons.Frames.VerticalFrame,
                    AnchorPoint = Vector2.new(0.5, 0.5),

                    [Children] = {
                        scope:Computed(function(use, scope)

                            use(skinsData)

                            local highlightedSkinValue = use(highlightedSkin)
                            local skinData = SkinsInfo.Skins[peek(selectedCatagory)][highlightedSkinValue]

                            local ownsSkin = scope:Computed(function(use, scope)
                                local skins = use(skinsData)[peek(selectedCatagory)].OwnedSkins
                                return (skins[highlightedSkinValue] or 0) > 0
                            end)

                            local isEquipped = scope:Computed(function(use, scope)
                                return use(skinsData)[peek(selectedCatagory)].CurrentSkin == highlightedSkinValue
                            end)

                            if not skinData then
                                return
                            end

                            local rarityColor = SkinsInfo.RarityColors[skinData.Rarity]

                            return {

                                scope:New "ImageLabel" {
                                    Image = skinData.Image,
                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                    Size = UDim2.fromScale(0.8, 0.8),
                                    Position = UDim2.fromScale(0.5, 0.5),
                                    BackgroundTransparency = 1,
                                    [Children] = {
                                        scope:New "UIAspectRatioConstraint" {
                                            AspectRatio = 1,
                                        },
                                    },
                                },

                                scope : New "Frame" {
                                    Size = UDim2.fromScale(0.4, 0.1),
                                    Position = UDim2.fromScale(0.25, 0.1),
                                    BackgroundColor3 = rarityColor,
                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                    [Children] = {
                                        TextLabelWithStroke(scope, {
                                            Text = skinData.Rarity,
                                            Size = UDim2.fromScale(0.8, 0.8),
                                            Position = UDim2.fromScale(0.5, 0.5),
                                            AnchorPoint = Vector2.new(0.5, 0.5),
                                            TextColor3 = Color3.fromRGB(180, 180, 180),
                                            Thickness = 1,
                                        }),

                                        scope :New "UICorner" {
                                            CornerRadius = UDim.new(1, 0),
                                        },

                                    },
                                },

                                scope : New "Frame" {
                                    Size = UDim2.fromScale(0.4, 0.1),
                                    Position = UDim2.fromScale(0.75, 0.1),
                                    BackgroundColor3 = Color3.new(1.000000, 1.000000, 1.000000),
                                    BackgroundTransparency = 0.5,
                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                    [Children] = {
                                        TextLabelWithStroke(scope, {
                                            Text = skinData.Price,
                                            Size = UDim2.fromScale(0.8, 0.8),
                                            Position = UDim2.fromScale(0.5, 0.5),
                                            AnchorPoint = Vector2.new(0.5, 0.5),
                                            TextColor3 = Color3.fromRGB(255, 255, 255),
                                            StrokeColor = Color3.fromRGB(15, 15, 15),
                                            Thickness = 2,
                                        }),

                                        scope :New "UICorner" {
                                            CornerRadius = UDim.new(1, 0),
                                        },

                                        scope : New "ImageLabel" {
                                            Size = UDim2.fromScale(1.5, 1.5),
                                            Image = scope:Computed(function(use, scope)
                                                return (skinData.Product ~= 0) and Icons.Robux264 or Icons.BabyBucks
                                            end),
                                            AnchorPoint = Vector2.new(0.5, 0.5),
                                            Position = UDim2.fromScale(1.05, 0.5),
                                            Rotation = 30,
                                            BackgroundTransparency = 1,
                                            [Children] = {
                                                scope : New "UIAspectRatioConstraint" {
                                                    AspectRatio = 1,
                                                }
                                            }
                                        }

                                    },
                                },

                                DefaultButton(scope, {
                                    Text = "Unequip",
                                    Position = UDim2.fromScale(0.5, 0.8),
                                    BackgroundColor3 = Color3.fromRGB(255, 59, 59),
                                    ButtonDown = function()

                                    end,
                                    ButtonUp = function()
                                        self.SkinService:UnequipSkin(highlightedSkinValue, peek(selectedCatagory))
                                    end,
                                    Visible = isEquipped,
                                }),

                                DefaultButton(scope, {
                                    Visible = scope:Computed(function(use, scope)
                                        return use(ownsSkin) and not use(isEquipped)
                                    end),
                                    Text = "Equip",
                                    Position = UDim2.fromScale(0.5, 0.8),
                                    BackgroundColor3 = Color3.fromRGB(114, 255, 59),
                                    ButtonDown = function()

                                    end,
                                    ButtonUp = function()
                                        self.SkinService:EquipSkin(highlightedSkinValue, peek(selectedCatagory))
                                    end,
                                }),

                                DefaultButton(scope, {
                                    Visible = scope:Computed(function(use, scope)
                                        return not use(ownsSkin)
                                    end),
                                    Text = "Buy",
                                    Position = UDim2.fromScale(0.5, 0.8),
                                    BackgroundColor3 = Color3.fromRGB(59, 59, 255),
                                    ButtonDown = function()

                                    end,
                                    ButtonUp = function()
                                        self.SkinService:BuySkin(highlightedSkinValue, peek(selectedCatagory))

                                    end,

                                    Build = function(scope)

                                        return Sticker(scope, {
                                            Size = UDim2.fromScale(0.8, 1),
                                            Position = UDim2.fromScale(0.8, 1.2),
                                            Text = "Limited",
                                            Color = rarityColor,
                                            TextColor = Color3.fromRGB(255, 255, 255),
                                        })

                                    end

                                }),

                            }

                        end),
                    },

                },

				scope:New "ScrollingFrame" {
                    ZIndex = 3,
                    Visible = scope:Computed(function(use, scope)
                        return use(selectedCatagory) == "Baby"
                    end),
					Size = UDim2.new(0.65, 0, 0.8, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.33, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    CanvasSize = UDim2.new(0, 0, 4, 0),
                    [Children] = {

                        scope : New "UIListLayout" {

                        },

                        Section(scope, {
                            Name = "Owned Skins",
                            Build = function(scope)

                                return {
                                    scope:New "UIGridLayout" {
                                    CellSize = UDim2.fromOffset(100, 100),
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                    VerticalAlignment = Enum.VerticalAlignment.Top,
                                },

                                    forPairs(scope, babySkins, function(use, scope, key, value)

                                        local equipped = scope:Computed(function(use, scope)
                                            return use(skinsData).Baby.CurrentSkin == key
                                        end)

                                        local skinData = SkinsInfo.Skins.Baby[key]
                                        if not skinData then
                                            warn("Skin data not found for", key)
                                            return
                                        end
                                        local rarityColor = SkinsInfo.RarityColors[skinData.Rarity]

                                        return key, skin(scope, {
                                            RarityColor = rarityColor or Color3.fromRGB(255, 255, 255),
                                            SkinName = key,
                                            Clicked = function()
                                                highlightedSkin:set(key)
                                            end,
                                            TypeOfSkin = "Baby",
                                            Equipped = equipped,
                                            Amount = value,
                                        })

                                    end)
                                }

                            end
                        }),

                        Section(scope, {
                            Name = "Shop",
                            Build = function(scope)

                                return {
                                    scope:New "UIGridLayout" {
                                    CellSize = UDim2.fromOffset(100, 100),
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                    VerticalAlignment = Enum.VerticalAlignment.Top,
                                },

                                    forValues(scope, skinsInShop.Baby, function(use, scope, key)

                                        local equipped = scope:Computed(function(use, scope)
                                            return use(skinsData).Baby.CurrentSkin == key
                                        end)

                                        local skinData = SkinsInfo.Skins.Baby[key]
                                        local rarityColor = SkinsInfo.RarityColors[skinData.Rarity]

                                        return skin(scope, {
                                            RarityColor = rarityColor or Color3.fromRGB(255, 255, 255),
                                            SkinName = key,
                                            Clicked = function()
                                                highlightedSkin:set(key)
                                            end,
                                            TypeOfSkin = "Baby",
                                            Equipped = equipped,
                                            Amount = 0,
                                        })

                                    end)

                                }

                            end
                        })

                    }

                },

                scope:New "ScrollingFrame" {
                    ZIndex = 3,
                    Visible = scope:Computed(function(use, scope)
                        return use(selectedCatagory) == "Parent"
                    end),
					Size = UDim2.new(0.65, 0, 0.8, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.33, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    CanvasSize = UDim2.new(0, 0, 4, 0),
                    [Children] = {

                        scope : New "UIListLayout" {

                        },

                        Section(scope, {
                            Name = "Owned Skins",
                            Build = function(scope)

                                return {
                                    scope:New "UIGridLayout" {
                                    CellSize = UDim2.fromOffset(100, 100),
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                    VerticalAlignment = Enum.VerticalAlignment.Top,
                                },

                                    forPairs(scope, parentSkins, function(use, scope, key, value)

                                        local equipped = scope:Computed(function(use, scope)
                                            return use(skinsData).Parent.CurrentSkin == key
                                        end)

                                        local skinData = SkinsInfo.Skins.Parent[key]
                                        local rarityColor = SkinsInfo.RarityColors[skinData.Rarity]

                                        return key, skin(scope, {
                                            RarityColor = rarityColor or Color3.fromRGB(255, 255, 255),
                                            SkinName = key,
                                            Clicked = function()
                                                highlightedSkin:set(key)
                                            end,
                                            TypeOfSkin = "Parent",
                                            Equipped = equipped,
                                            Amount = value,
                                        })

                                    end)
                                }

                            end
                        }),

                        Section(scope, {
                            Name = "Shop",
                            Build = function(scope)

                                return {
                                    scope:New "UIGridLayout" {
                                    CellSize = UDim2.fromOffset(100, 100),
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                    VerticalAlignment = Enum.VerticalAlignment.Top,
                                },

                                    forValues(scope, skinsInShop.Parent, function(use, scope, key)

                                        local equipped = scope:Computed(function(use, scope)
                                            return use(skinsData).Parent.CurrentSkin == key
                                        end)

                                        local skinData = SkinsInfo.Skins.Parent[key]
                                        local rarityColor = SkinsInfo.RarityColors[skinData.Rarity]

                                        return skin(scope, {
                                            RarityColor = rarityColor or Color3.fromRGB(255, 255, 255),
                                            SkinName = key,
                                            Clicked = function()
                                                highlightedSkin:set(key)
                                            end,
                                            TypeOfSkin = "Parent",
                                            Equipped = equipped,
                                            Amount = 0,
                                        })

                                    end)

                                }

                            end
                        })

                    }

                },


			}
		end,
	})




    return tobeReturned

end

return Skins
