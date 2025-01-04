local Abilities = {}
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
local AbilitiesInfo = require(ReplicatedStorage.Source.Shared.Abilities)
function Abilities:Start() -- knit start

end

local abilitiesInShop = {
    "Invisibility",
    "Speed",
    "Jump",
}

function abilityItem (scope, props : {
    RarityColor : Color3,
    Name : string,
    Clicked : () -> (),
    Equipped : boolean,
    Amount : number,
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
                        Image = AbilitiesInfo.Abilities[props.Name].Image,
                        Size = UDim2.fromScale(1, 1),
                        Position = UDim2.fromScale(0.5, 0.5),
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

function Abilities:Build(scope : typeof(Fusion.scoped(Fusion)), open)


    self.DataController = Knit.GetController("DataController")
    self.DataService = Knit.GetService("DataService")
    self.AbilitiesService = Knit.GetService("AbilitiesService")

    local ready, data = self.DataService.DataProperty:OnReady():await()
    print(data, "Recived")
    local abilitiesData = scope:Value(data.Abilities)
    local abilities = scope:Value(data.Abilities.OwnedAbilities)

    self.DataController:OnDataChanged("Abilities", function(data)
        abilitiesData:set(data)
        abilities:set(data.OwnedAbilities)
    end)

    local highlightedAbility = scope:Value(
        "None"
    )

    print("Data ready", data)

    local tobeReturned = Window(scope, {
		HeaderText = "Abilities",
        Size = UDim2.fromScale(0.6, 0.6),
		Open = open,
        HeaderSize = UDim2.fromScale(0.3, 0.2),
        HeaderPosition = UDim2.fromScale(0.2, -0.05),
		Build = function(scope)
			return {

                scope:New "ImageLabel" {
                    ZIndex = 3,
                    Size = UDim2.fromScale(0.3, 0.8),
                    Position = UDim2.fromScale(0.8, 0.5),
                    BackgroundTransparency = 1,
                    Image = Icons.Frames.VerticalFrame,
                    AnchorPoint = Vector2.new(0.5, 0.5),

                    [Children] = {
                        scope:Computed(function(use, scope)

                            use(abilities)

                            local highlightedAbilityValue = use(highlightedAbility)
                            local abilityData = AbilitiesInfo.Abilities[highlightedAbilityValue]

                            local ownsAbility = scope:Computed(function(use, scope)
                                local ownedAbilities = use(abilities)
                                return (ownedAbilities[highlightedAbilityValue] or 0) > 0
                            end)

                            local isEquipped = scope:Computed(function(use, scope)
                                local currentAbilities = use(abilitiesData).CurrentAbilities
                                return nil ~= table.find(currentAbilities, highlightedAbilityValue)
                            end)

                            if not abilityData then
                                return
                            end

                            local rarityColor = AbilitiesInfo.RarityColors[abilityData.Rarity]

                            return {

                                scope:New "ImageLabel" {
                                    Image = abilityData.Image,
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
                                            Text = abilityData.Rarity,
                                            Size = UDim2.fromScale(0.8, 0.8),
                                            Position = UDim2.fromScale(0.5, 0.5),
                                            AnchorPoint = Vector2.new(0.5, 0.5),
                                            TextColor3 = Color3.fromRGB(180, 180, 180),
                                            Thickness = 0,
                                        }),

                                        scope :New "UICorner" {
                                            CornerRadius = UDim.new(1, 0),
                                        }

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
                                            Text = abilityData.Price,
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
                                                return (abilityData.Product ~= 0) and Icons.Robux264 or Icons.BabyBucks
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
                                        self.AbilitiesService:UnequipAbility(highlightedAbilityValue)
                                    end,
                                    Visible = isEquipped,
                                }),

                                DefaultButton(scope, {
                                    Visible = scope:Computed(function(use, scope)
                                        return use(ownsAbility) and not use(isEquipped)
                                    end),
                                    Text = "Equip",
                                    Position = UDim2.fromScale(0.5, 0.8),
                                    BackgroundColor3 = Color3.fromRGB(114, 255, 59),
                                    ButtonDown = function()

                                    end,
                                    ButtonUp = function()
                                        self.AbilitiesService:EquipAbility(highlightedAbilityValue)
                                    end,
                                }),

                                DefaultButton(scope, {
                                    Visible = scope:Computed(function(use, scope)
                                        return true --not use(ownsAbility) and not use(isEquipped)
                                    end),
                                    Text = "Buy",
                                    Position = UDim2.fromScale(0.8, 0.9),
                                    Rotation = -25,
                                    BackgroundColor3 = Color3.fromRGB(59, 59, 255),
                                    ButtonDown = function()

                                    end,
                                    ButtonUp = function()
                                        self.AbilitiesService:BuyAbility(highlightedAbilityValue)
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
                    Visible = true,
					Size = UDim2.new(0.65, 0, 0.8, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.33, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    CanvasSize = UDim2.new(0, 0, 4, 0),
                    [Children] = {

                        scope : New "UIListLayout" {

                        },

                        Section(scope, {
                            Name = "Owned Abilities",
                            Build = function(scope)

                                return {
                                    scope:New "UIGridLayout" {
                                    CellSize = UDim2.fromOffset(100, 100),
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                    VerticalAlignment = Enum.VerticalAlignment.Top,
                                },

                                    forPairs(scope, abilities, function(use, scope, key, value)

                                        if value == 0 then
                                            return
                                        end

                                        local equipped = scope:Computed(function(use, scope)
                                            return false
                                        end)

                                        local abilityData = AbilitiesInfo.Abilities[key]
                                        if not abilityData then
                                            warn("Ability data not found for", key)
                                            return
                                        end
                                        local rarityColor = AbilitiesInfo.RarityColors[abilityData.Rarity]

                                        return key, abilityItem(scope, {
                                            RarityColor = rarityColor or Color3.fromRGB(255, 255, 255),
                                            Name = key,
                                            Clicked = function()
                                                highlightedAbility:set(key)
                                            end,
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

                                    forValues(scope, abilitiesInShop, function(use, scope, key)

                                        local equipped = scope:Computed(function(use, scope)
                                            return false
                                        end)

                                        local abilityData = AbilitiesInfo.Abilities[key]
                                        local rarityColor = AbilitiesInfo.RarityColors[abilityData.Rarity]

                                        return abilityItem(scope, {
                                            RarityColor = rarityColor or Color3.fromRGB(255, 255, 255),
                                            Name = key,
                                            Clicked = function()
                                                highlightedAbility:set(key)
                                            end,
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

return Abilities
