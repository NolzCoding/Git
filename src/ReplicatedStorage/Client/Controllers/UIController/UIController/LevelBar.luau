local LevelBar = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children

local TextLabelWithStroke =
	require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Text.TextLabelWithStroke)
local ImageButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ImageButton)

local Icons = require(ReplicatedStorage.Source.Shared.Icons)

local function LevelBar(
	scope: typeof(Fusion.scoped(Fusion)),
	props: {
		Level: number,
		Exp: number,
		NextLevelExp: number,
		Label: string,
        Size : UDim2,
        Position : UDim2,
	}
)

    local sizeOfBar = scope:Computed(function(use)
        return UDim2.fromScale(use(props.Exp) / use(props.NextLevelExp), 1)
    end)

	return scope:New("Frame")({
		Name = "Level",
		AnchorPoint = Vector2.new(0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = props.Position or UDim2.fromScale(0.0136, 0.106),
		Size = props.Size or UDim2.fromScale(0.52, 0.0485),


		[Children] = {
			scope:New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
				AspectRatio = 7.27,
			}),

			scope:New("Frame")({
				Name = "Outline",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(38, 27, 97),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1.04, 1.3),
				ZIndex = 0,

				[Children] = {
					scope:New("UICorner")({
						Name = "UICorner",
						CornerRadius = UDim.new(1, 0),
					}),
				},
			}),

			scope:New("CanvasGroup")({
				Name = "CanvasGroup",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),

				[Children] = {
					scope:New("Frame")({
						Name = "Container",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(10, 7, 28),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1, 1),

						[Children] = {
							scope:New("Frame")({
								Name = "Bar",
								AnchorPoint = Vector2.new(0, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Position = UDim2.fromScale(0, 0.5),
								Size = scope:Tween(sizeOfBar, TweenInfo.new(0.35, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)),

								[Children] = {
									scope:New("UIGradient")({
										Name = "UIGradient",
										Color = ColorSequence.new({
											ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 112, 204)),
											ColorSequenceKeypoint.new(0.72, Color3.fromRGB(0, 156, 228)),
											ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 204, 255)),
										}),
									}),

									scope:New("ImageLabel")({
										Name = "Highlight",
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BackgroundTransparency = 1,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Image = "rbxassetid://138146546458323",
										Position = UDim2.fromScale(0.0053, -0.855),
										ScaleType = Enum.ScaleType.Tile,
										Size = UDim2.fromScale(0.995, 1.92),
										TileSize = UDim2.fromOffset(337, 37),
									}),

									scope:New("ImageLabel")({
										Name = "Thickness",
										AnchorPoint = Vector2.new(0.5, 0.5),
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BackgroundTransparency = 1,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Image = "rbxassetid://76874431116917",
										Position = UDim2.fromScale(1, 0.5),
										Size = UDim2.fromScale(1, 1.2),

										[Children] = {
											scope:New("UIAspectRatioConstraint")({
												Name = "UIAspectRatioConstraint",
												AspectRatio = 0.38,
											}),
										},
									}),

									scope:New("ImageLabel")({
										Name = "Glow",
										AnchorPoint = Vector2.new(0.5, 0.5),
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										BackgroundTransparency = 1,
										BorderColor3 = Color3.fromRGB(0, 0, 0),
										BorderSizePixel = 0,
										Image = "rbxassetid://11953711609",
										ImageColor3 = Color3.fromRGB(76, 213, 255),
										ImageTransparency = 0.18,
										Position = UDim2.fromScale(1, 0.5),
										Size = UDim2.fromScale(1, 3),

										[Children] = {
											scope:New("UIAspectRatioConstraint")({
												Name = "UIAspectRatioConstraint",
												AspectRatio = 0.38,
											}),
										},
									}),
								},
							}),
						},
					}),

					scope:New("UICorner")({
						Name = "UICorner",
						CornerRadius = UDim.new(1, 0),
					}),
				},
			}),

			scope:New("TextLabel")({
				Name = "Experience",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.502, 0.499),
				Size = UDim2.fromScale(0.869, 0.735),
				Text = scope:Computed(function(use)
                    return use(props.Exp) .. " / " .. use(props.NextLevelExp)
                end),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,

				[Children] = {
					scope:New("UIStroke")({
						Name = "UIStroke",
						Color = Color3.fromRGB(19, 14, 50),
						LineJoinMode = Enum.LineJoinMode.Miter,
						Thickness = 2,
					}),
				},
			}),

			scope:New("TextLabel")({
				Name = "Level",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.267, 1.42),
				Size = UDim2.fromScale(0.475, 0.551),
				Text = scope:Computed(function(use)
                    return "Level " .. use(props.Level)
                end),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,

				[Children] = {
					scope:New("UIStroke")({
						Name = "UIStroke",
						Color = Color3.fromRGB(19, 14, 50),
						LineJoinMode = Enum.LineJoinMode.Miter,
						Thickness = 2,
					}),
				},
			}),

			scope:New("TextLabel")({
				Name = "LevelLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.752, 1.42),
				Size = UDim2.fromScale(0.435, 0.551),
				Text = props.Label,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Right,

				[Children] = {
					scope:New("UIStroke")({
						Name = "UIStroke",
						Color = Color3.fromRGB(19, 14, 50),
						LineJoinMode = Enum.LineJoinMode.Miter,
						Thickness = 2,
					}),
				},
			}),

			scope:New("Frame")({
				Name = "Falldown",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(38, 27, 97),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Position = UDim2.fromScale(0.5, 1.01),
				Size = UDim2.fromScale(1.04, 1.76),
				ZIndex = 0,

				[Children] = {
					scope:New("UICorner")({
						Name = "UICorner",
						CornerRadius = UDim.new(0.3, 0),
					}),
				},
			}),
		},
	})
end

return LevelBar
