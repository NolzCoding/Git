local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local children = Fusion.Children
local Children, OnEvent, peek = Fusion.Children, Fusion.OnEvent, Fusion.peek
local Settings = require(ReplicatedStorage.Source.Shared.Settings)
local DefaultButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.DefaultButton)

type scope = typeof(Fusion.scoped(Fusion))
local function ItemDescription(scope: scope, props: {

    Name : string,
    Description : string,
    Effects : {
        Lungs : number,
        Heart : number,
        Stomach : number,
    }

})


    return scope:New("Frame")({
		Name = "Frame",
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.995, 0.641),
		Size = UDim2.fromScale(0.134, 0.152),

        [Children] = {
            scope:New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
				AspectRatio = 1.5,
			}),

            DefaultButton(scope, {
                Name = "TextButton",
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(81, 255, 0),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                ButtonUp = function()
                    Settings.ShowItem:set(not peek(Settings.ShowItem))
                end,

                ButtonDown = function()
                    print("ButtonDown")
                end,

                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                Position = UDim2.fromScale(0.75, -0.2),
                Size = UDim2.fromScale(0.474, 0.284),
                Text = scope:Computed(function(use)

                    return use(Settings.ShowItem) and "Hide" or "Show"

                end),
                TextColor3 = Color3.fromRGB(0, 0, 0),
                TextSize = 14,
            }),

            scope:New("Frame")({
                Name = "Frame",
                Visible = Settings.ShowItem,
                AnchorPoint = Vector2.new(0,0),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.55,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(1, 1),

                [Children] = {

                    scope:New("UICorner")({
                        Name = "UICorner",
                        CornerRadius = UDim.new(0.1, 0),
                    }),

                    scope:New("Frame")({
                        Name = "Frame",
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Color3.fromRGB(48, 255, 65),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.fromScale(1, 0.133),
                        Size = UDim2.fromScale(1, 0.266),

                        [Children] = {
                            scope:New("UICorner")({
                                Name = "UICorner",
                                CornerRadius = UDim.new(0.4, 0),
                            }),

                            scope:New("TextLabel")({
                                Name = "TextLabel",
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                BackgroundTransparency = 1,
                                BorderColor3 = Color3.fromRGB(0, 0, 0),
                                BorderSizePixel = 0,
                                FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
                                Position = UDim2.fromScale(-5.15e-05, -1.07),
                                Size = UDim2.fromScale(0.941, 0.779),
                                Text = props.Name,
                                TextColor3 = Color3.fromRGB(255, 255, 255),
                                TextScaled = true,
                                TextSize = 14,
                                TextWrapped = true,
                                TextXAlignment = Enum.TextXAlignment.Left,

                                [Children] = {
                                    scope:New("UIStroke")({
                                        Name = "UIStroke",
                                        Thickness = 2,
                                    }),
                                },
                            }),
                        },
                    }),

                    scope:New("Frame")({
                        Name = "Frame",
                        AnchorPoint = Vector2.new(0, 1),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.fromScale(0.021, 0.989),
                        Size = UDim2.fromScale(0.896, 0.355),

                        [Children] = {
                            scope:New("UIListLayout")({
                                Name = "UIListLayout",
                                FillDirection = Enum.FillDirection.Horizontal,
                                Padding = UDim.new(0.025, 0),
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                            }),

                            scope:New("ImageLabel")({
                                Name = "Heart",
                                Visible = props.Effects.Heart > 0,
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                BackgroundTransparency = 1,
                                BorderColor3 = Color3.fromRGB(0, 0, 0),
                                BorderSizePixel = 0,
                                Position = UDim2.fromScale(0.5, -0.316),
                                Size = UDim2.fromScale(0.348, 1),

                                [Children] = {
                                    scope:New("UIAspectRatioConstraint")({
                                        Name = "UIAspectRatioConstraint",
                                    }),

                                    scope:New("ImageLabel")({
                                        Name = "Icon",
                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                        BackgroundTransparency = 1,
                                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                                        BorderSizePixel = 0,
                                        Image = "rbxassetid://104332494686921",
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        Size = UDim2.fromScale(1, 1),
                                    }),

                                    scope:New("TextLabel")({
                                        Name = "TextLabel",
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                        BackgroundTransparency = 1,
                                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                                        BorderSizePixel = 0,
                                        FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
                                        Position = UDim2.fromScale(0.113, 0.5),
                                        Size = UDim2.fromScale(0.981, 0.721),
                                        Text = props.Effects.Heart .. "%",
                                        TextColor3 = Color3.fromRGB(255, 255, 255),
                                        TextScaled = true,
                                        TextSize = 14,
                                        TextWrapped = true,

                                        [Children] = {
                                            scope:New("UIStroke")({
                                                Name = "UIStroke",
                                                Color = Color3.fromRGB(29, 16, 16),
                                                LineJoinMode = Enum.LineJoinMode.Miter,
                                                Thickness = 2,
                                            }),
                                        },
                                    }),

                                    scope:New("ImageLabel")({
                                        Name = "ImageLabel",
                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                        BackgroundTransparency = 1,
                                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                                        BorderSizePixel = 0,
                                        Image = "rbxassetid://11953711609",
                                        ImageColor3 = Color3.fromRGB(255, 0, 0),
                                        ImageTransparency = 1,
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        Size = UDim2.fromScale(1.5, 1.5),
                                        ZIndex = 0,

                                        [Children] = {
                                            scope:New("UIScale")({
                                                Name = "UIScale",
                                            }),
                                        },
                                    }),
                                },
                            }),

                            scope:New("ImageLabel")({
                                Name = "Stomach",
                                Visible = props.Effects.Stomach > 0,
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                BackgroundTransparency = 1,
                                BorderColor3 = Color3.fromRGB(0, 0, 0),
                                BorderSizePixel = 0,
                                Position = UDim2.fromScale(0.5, -0.316),
                                Size = UDim2.fromScale(0.348, 1),

                                [Children] = {
                                    scope:New("UIAspectRatioConstraint")({
                                        Name = "UIAspectRatioConstraint",
                                    }),

                                    scope:New("ImageLabel")({
                                        Name = "Icon",
                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                        BackgroundTransparency = 1,
                                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                                        BorderSizePixel = 0,
                                        Image = "rbxassetid://115605857677675",
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        Size = UDim2.fromScale(1, 1),
                                    }),

                                    scope:New("ImageLabel")({
                                        Name = "ImageLabel",
                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                        BackgroundTransparency = 1,
                                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                                        BorderSizePixel = 0,
                                        Image = "rbxassetid://11953711609",
                                        ImageColor3 = Color3.fromRGB(255, 0, 0),
                                        ImageTransparency = 1,
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        Size = UDim2.fromScale(1.5, 1.5),
                                        ZIndex = 0,

                                        [Children] = {
                                            scope:New("UIScale")({
                                                Name = "UIScale",
                                            }),
                                        },
                                    }),

                                    scope:New("TextLabel")({
                                        Name = "TextLabel",
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                        BackgroundTransparency = 1,
                                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                                        BorderSizePixel = 0,
                                        FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
                                        Position = UDim2.fromScale(0.113, 0.5),
                                        Size = UDim2.fromScale(0.981, 0.721),
                                        Text = props.Effects.Stomach .. "%",
                                        TextColor3 = Color3.fromRGB(255, 255, 255),
                                        TextScaled = true,
                                        TextSize = 14,
                                        TextWrapped = true,

                                        [Children] = {
                                            scope:New("UIStroke")({
                                                Name = "UIStroke",
                                                Color = Color3.fromRGB(29, 16, 16),
                                                LineJoinMode = Enum.LineJoinMode.Miter,
                                                Thickness = 2,
                                            }),
                                        },
                                    }),
                                },
                            }),

                            scope:New("ImageLabel")({
                                Name = "Lungs",
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                BackgroundTransparency = 1,
                                BorderColor3 = Color3.fromRGB(0, 0, 0),
                                BorderSizePixel = 0,
                                Position = UDim2.fromScale(0.5, -0.316),
                                Size = UDim2.fromScale(0.348, 1),

                                Visible = props.Effects.Lungs > 0,

                                [Children] = {
                                    scope:New("UIAspectRatioConstraint")({
                                        Name = "UIAspectRatioConstraint",
                                    }),

                                    scope:New("ImageLabel")({
                                        Name = "Icon",
                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                        BackgroundTransparency = 1,
                                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                                        BorderSizePixel = 0,
                                        Image = "rbxassetid://135545228007462",
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        Size = UDim2.fromScale(1, 1),
                                    }),

                                    scope:New("ImageLabel")({
                                        Name = "ImageLabel",
                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                        BackgroundTransparency = 1,
                                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                                        BorderSizePixel = 0,
                                        Image = "rbxassetid://11953711609",
                                        ImageColor3 = Color3.fromRGB(255, 0, 0),
                                        ImageTransparency = 1,
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        Size = UDim2.fromScale(1.5, 1.5),
                                        ZIndex = 0,

                                        [Children] = {
                                            scope:New("UIScale")({
                                                Name = "UIScale",
                                            }),
                                        },
                                    }),

                                    scope:New("TextLabel")({
                                        Name = "TextLabel",
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                        BackgroundTransparency = 1,
                                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                                        BorderSizePixel = 0,
                                        FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
                                        Position = UDim2.fromScale(0.113, 0.5),
                                        Size = UDim2.fromScale(0.981, 0.721),
                                        Text = props.Effects.Lungs .. "%",
                                        TextColor3 = Color3.fromRGB(255, 255, 255),
                                        TextScaled = true,
                                        TextSize = 14,
                                        TextWrapped = true,

                                        [Children] = {
                                            scope:New("UIStroke")({
                                                Name = "UIStroke",
                                                Color = Color3.fromRGB(29, 16, 16),
                                                LineJoinMode = Enum.LineJoinMode.Miter,
                                                Thickness = 2,
                                            }),
                                        },
                                    }),
                                },
                            }),
                        },
                    }),

                    scope:New("UIStroke")({
                        Name = "UIStroke",
                        Thickness = 2,
                        Transparency = 0.46,
                    }),

                    scope:New("TextLabel")({
                        Name = "TextLabel",
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
                        Position = UDim2.fromScale(0.0196, 0),
                        Size = UDim2.fromScale(0.967, 0.634),
                        Text = props.Description,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextScaled = true,
                        TextSize = 14,
                        TextWrapped = true,

                        [Children] = {
                            scope:New("UIStroke")({
                                Name = "UIStroke",
                                Color = Color3.fromRGB(29, 16, 16),
                                LineJoinMode = Enum.LineJoinMode.Miter,
                                Thickness = 2,
                            }),
                        },
                    }),


                },
            })

        }

    })


end

return ItemDescription
