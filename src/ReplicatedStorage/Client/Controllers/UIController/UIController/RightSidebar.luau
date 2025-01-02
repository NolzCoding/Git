local RightSideBar = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local new = Fusion.New

local TextLabelWithStroke = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Text.TextLabelWithStroke)
local ImageButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ImageButton)

local Icons = require(ReplicatedStorage.Source.Shared.Icons)

local function RightSideBar(scope : typeof(Fusion.scoped(Fusion)), props : {
    OpenWindow : (name : string) -> (),
    Cash : number,
})

    return scope:New "Frame" {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(0.15, 0.6),
        Position = UDim2.fromScale(0.013, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),

        [Children] = {
            scope : New "UIAspectRatioConstraint" {
                AspectRatio = 1,
            },

            scope:New "Frame" {
                BackgroundColor3 = Color3.fromRGB(172, 255, 37),
                BackgroundTransparency = 0,
                Size = UDim2.fromScale(1, 0.2),
                Position = UDim2.fromScale(0, 0.8),
                AnchorPoint = Vector2.new(0, 0.5),
                [Children] = {
                    scope:New "UIAspectRatioConstraint" {
                        AspectRatio = 4,
                    },

                    scope : New "UICorner" {
                        CornerRadius = UDim.new(0.4, 0),
                    },

                    scope : New "UIStroke" {
                        Color = Color3.fromRGB(47, 97, 18),
                        Thickness = 3,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    },

                    scope : New "ImageLabel" {
                        BackgroundTransparency = 1,
                        Image = Icons.BabyBucks,
                        Size = UDim2.fromScale(0.4, 2),
                        Position = UDim2.new(0.95, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Rotation = 45,
                        [Children] = {
                            scope : New "UIAspectRatioConstraint" {
                                AspectRatio = 1,
                            }
                        }
                    },

                    TextLabelWithStroke(scope, {
                        Text = props.Cash or 0,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Size = UDim2.fromScale(0.8, 1),
                        Position = UDim2.fromScale(0.05, 0.5),
                        AnchorPoint = Vector2.new(0, 0.5),
                        TextSize = 20,
                        StrokeColor3 = Color3.fromRGB(47, 97, 18),
                        TextColor3 = Color3.fromRGB(222, 255, 185),
                    })
                }
            },

            scope:New "Frame" {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromScale(0.5,0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                [Children] = {
                    scope:New "UIGridLayout" {
                        CellSize = UDim2.fromScale(0.3, 0.3),
                        CellPadding = UDim2.fromOffset(0.03, 0),
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Right,
                        VerticalAlignment = Enum.VerticalAlignment.Top,
                    },



                    ImageButton(scope, {
                        Image = Icons.ShoppingBasket,
                        Size = UDim2.fromScale(0.3, 0.3),
                        ButtonUp = function()
                            props.OpenWindow("Shop")
                        end
                    }),

                    ImageButton(scope, {
                        Image = Icons.EmptyHeart,
                        Size = UDim2.fromScale(0.3, 0.3),
                        ButtonUp = function()
                            props.OpenWindow("RollItem")
                        end
                    }),

                    ImageButton(scope, {
                        Image = Icons.ShoppingBasket,
                        Size = UDim2.fromScale(0.3, 0.3),
                        ButtonUp = function()
                            props.OpenWindow("Skins")
                        end
                    }),

                    ImageButton(scope, {
                        Image = Icons.BrownBook264,
                        Size = UDim2.fromScale(0.3, 0.3),
                        ButtonUp = function()
                            props.OpenWindow("Achivements")
                        end
                    }),

                    ImageButton(scope, {
                        Image = Icons.YellowLightning,
                        Size = UDim2.fromScale(0.3, 0.3),
                        ButtonUp = function()
                            props.OpenWindow("Abilities")
                        end
                    }),

                    ImageButton(scope, {
                        Image = "",
                        Size = UDim2.fromScale(0.3, 0.3),
                        ButtonUp = function()
                            props.OpenWindow("Shop")
                        end,
                        Build = function(scope)

                            local rotation = scope:Value(0)

                            task.spawn(function()
                                local count = 0

                                -- make count go from -1 to 0 to 1 in 3 second intervals looping
                                while true do
                                    for i = -1, 1 do
                                        count = i
                                        rotation:set(count * 30)
                                        task.wait(3)
                                    end
                                end
                            end)

                            return scope:New "ImageLabel" {
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                BackgroundTransparency = 1,
                                BorderColor3 = Color3.fromRGB(0, 0, 0),
                                BorderSizePixel = 0,
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Image = Icons.Emojis.Skull,
                                Position = UDim2.fromScale(0.5, 0.5),
                                Rotation = scope:Tween(rotation, TweenInfo.new(2, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut)),
                                ScaleType = Enum.ScaleType.Fit,
                                Size = UDim2.fromScale(1, 1),
                            }

                        end
                    }),

                }
            }

        },



    }


end

return RightSideBar