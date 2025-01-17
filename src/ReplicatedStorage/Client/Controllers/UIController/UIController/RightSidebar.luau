local RightSideBar = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local new = Fusion.New

local TextLabelWithStroke = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Text.TextLabelWithStroke)
local ImageButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ImageButton)
local Knit = require(ReplicatedStorage.Packages.Knit)

local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local Alerts = require(ReplicatedStorage.Source.Shared.Alerts)
local Alert = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.UI.Alert)
local function RightSideBar(scope : typeof(Fusion.scoped(Fusion)), props : {
    OpenWindow : (name : string) -> (),
    Cash : number,
})

    local musicison = true
    local MusicController = Knit.GetController("MusicController")

    MusicController:ChangeVolume(0.25)

    return scope:New "Frame" {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(0.15, 0.6),
        Position = UDim2.fromScale(0.013, 0.45),
        AnchorPoint = Vector2.new(0, 0.5),

        [Children] = {
            scope : New "UIAspectRatioConstraint" {
                AspectRatio = 1,
            },

            scope:New "Frame" {
                BackgroundColor3 = Color3.fromRGB(172, 255, 37),
                BackgroundTransparency = 0,
                Size = UDim2.fromScale(1, 0.2),
                Position = UDim2.fromScale(0, 1),
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

                            return {scope:New "ImageLabel" {
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                BackgroundTransparency = 1,
                                BorderColor3 = Color3.fromRGB(0, 0, 0),
                                BorderSizePixel = 0,
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Image = Icons.ShoppingBasket,
                                Position = UDim2.fromScale(0.5, 0.5),
                                Rotation = scope:Tween(rotation, TweenInfo.new(2, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut)),
                                ScaleType = Enum.ScaleType.Fit,
                                Size = UDim2.fromScale(1, 1),
                            },


                            TextLabelWithStroke(scope, {
                                Text = "Shop",
                                Size = UDim2.fromScale(1, 0.3),
                                Position = UDim2.fromScale(0.5, 0.8),
                                ZIndex = 2,
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Thickness = 2,
                                StrokeColor = Color3.fromRGB(20, 18, 8),
                                TextColor = Color3.fromRGB(231, 216, 148),
                            })


                        }



                        end
                    }),

                    ImageButton(scope, {
                        Image = Icons.GiftBoxes.Green.Group,
                        Size = UDim2.fromScale(0.3, 0.3),
                        ButtonUp = function()
                            props.OpenWindow("Shop", 2)

                            Alerts.CratesAlert:set(false)
                        end,

                        Build = function(scope)

                            return {TextLabelWithStroke(scope, {
                                Text = "Crates",
                                Size = UDim2.fromScale(1, 0.3),
                                Position = UDim2.fromScale(0.5, 0.8),
                                ZIndex = 2,
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Thickness = 2,
                                StrokeColor = Color3.fromRGB(20, 18, 8),
                                TextColor = Color3.fromRGB(231, 216, 148),
                            }),

                            Alert(scope, {
                                Visible = Alerts.CratesAlert,
                                Size = UDim2.fromScale(0.7, 0.7),
                            })

                            }

                        end

                    }),

                    ImageButton(scope, {
                        Image = Icons.BabyBucks,
                        Size = UDim2.fromScale(0.3, 0.3),
                        ButtonUp = function()
                            props.OpenWindow("Skins")
                        end,

                        Build = function(scope)

                            return {TextLabelWithStroke(scope, {
                                Text = "Skins",
                                Size = UDim2.fromScale(1, 0.3),
                                Position = UDim2.fromScale(0.5, 0.8),
                                ZIndex = 2,
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Thickness = 2,
                                StrokeColor = Color3.fromRGB(20, 18, 8),
                                TextColor = Color3.fromRGB(231, 216, 148),
                            })}

                        end

                    }),

                    ImageButton(scope, {
                        Image = Icons.BrownBook264,
                        Size = UDim2.fromScale(0.3, 0.3),
                        ButtonUp = function()
                            props.OpenWindow("Achievements")
                        end,

                        Build = function(scope)

                            return {TextLabelWithStroke(scope, {
                                Text = "Achievements",
                                Size = UDim2.fromScale(1, 0.3),
                                Position = UDim2.fromScale(0.5, 0.8),
                                ZIndex = 2,
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Thickness = 2,
                                StrokeColor = Color3.fromRGB(20, 18, 8),
                                TextColor = Color3.fromRGB(231, 216, 148),
                            })}

                        end

                    }),

                    ImageButton(scope, {
                        Image = Icons.YellowLightning,
                        Size = UDim2.fromScale(0.3, 0.3),
                        ButtonUp = function()
                            props.OpenWindow("Abilities")
                        end,

                        Build = function(scope)

                            return {TextLabelWithStroke(scope, {
                                Text = "Abilities",
                                Size = UDim2.fromScale(1, 0.3),
                                Position = UDim2.fromScale(0.5, 0.8),
                                ZIndex = 2,
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Thickness = 2,
                                StrokeColor = Color3.fromRGB(20, 18, 8),
                                TextColor = Color3.fromRGB(231, 216, 148),
                            })}

                        end

                    }),

                    ImageButton(scope, {
                        Image = Icons.Ticket264,
                        Size = UDim2.fromScale(0.3, 0.3),
                        ButtonUp = function()
                            props.OpenWindow("Babypass")

                            Alerts.GamepassAlert:set(false)

                        end,

                        Build = function(scope)

                            return {TextLabelWithStroke(scope, {
                                Text = "Babypass",
                                Size = UDim2.fromScale(1, 0.3),
                                Position = UDim2.fromScale(0.5, 0.8),
                                ZIndex = 2,
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Thickness = 2,
                                StrokeColor = Color3.fromRGB(20, 18, 8),
                                TextColor = Color3.fromRGB(231, 216, 148),
                            }),

                            Alert(scope, {
                                Visible = Alerts.GamepassAlert,
                                Size = UDim2.fromScale(0.7, 0.7),
                            })


                        }

                        end

                    }),

                    ImageButton(scope, {
                        Image = Icons.Sounds,
                        Size = UDim2.fromScale(0.3, 0.3),
                        ButtonUp = function()
                            local MusicController = Knit.GetController("MusicController")

                            if musicison then
                                MusicController:ChangeVolume(0)
                                musicison = false
                            else
                                MusicController:ChangeVolume(0.25)
                                musicison = true
                            end

                        end,

                        Build = function(scope)

                            return {TextLabelWithStroke(scope, {
                                Text = "Music",
                                Size = UDim2.fromScale(1, 0.3),
                                Position = UDim2.fromScale(0.5, 0.8),
                                ZIndex = 2,
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Thickness = 2,
                                StrokeColor = Color3.fromRGB(20, 18, 8),
                                TextColor = Color3.fromRGB(231, 216, 148),
                            })}

                        end

                    }),



                }
            }

        },



    }


end

return RightSideBar