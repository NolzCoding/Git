local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Fusion = require(game.ReplicatedStorage.Packages.fusion)
local CollectionService = game:GetService("CollectionService")

local Children = Fusion.Children

local Knit = require(ReplicatedStorage.Packages.Knit)

type UsedAs<T> = Fusion.UsedAs<T>

local function LoadingScreen(
	scope: typeof(Fusion.scoped(Fusion)),
	props: {
		Visible: UsedAs<boolean>?,
	}
)
	local text = scope:Value("Loading")


    task.spawn(function()
        while true do
            text:set("Loading")
            wait(0.5)
            text:set("Loading.")
            wait(0.5)
            text:set("Loading..")
            wait(0.5)
            text:set("Loading...")
            wait(0.5)
        end
    end)


	return scope:New("ScreenGui")({
		Name = "Loading",
		DisplayOrder = 5,
        Enabled = props.Visible,
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

		[Children] = {
			scope:New("Frame")({
				Name = "Frame",
				BackgroundColor3 = Color3.fromRGB(9, 2, 18),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),

				[Children] = {
					scope:New("Frame")({
						Name = "DoubleText",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.5, 0.913),
						Size = UDim2.fromOffset(301, 94),

						[Children] = {
							scope:New("TextLabel")({
								Name = "TextLabel",
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
								Position = UDim2.fromScale(0.482, 0.232),
								Size = UDim2.fromScale(0.895, 0.799),
								Text = text,
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextScaled = true,
								TextSize = 14,
								TextWrapped = true,

								[Children] = {
									scope:New("UIGradient")({
										Name = "UIGradient",
										Color = ColorSequence.new({
											ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
											ColorSequenceKeypoint.new(0.491, Color3.fromRGB(253, 253, 253)),
											ColorSequenceKeypoint.new(0.789, Color3.fromRGB(150, 150, 150)),
											ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 145, 145)),
										}),
										Rotation = 90,
									}),

									scope:New("UIStroke")({
										Name = "UIStroke",
										LineJoinMode = Enum.LineJoinMode.Miter,
										Thickness = 4,
									}),
								},
							}),

							scope:New("TextLabel")({
								Name = "TextLabel",
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
								Position = UDim2.fromScale(0.5, 0.275),
								Size = UDim2.fromScale(0.886, 0.788),
								Text = text,
								TextColor3 = Color3.fromRGB(0, 0, 0),
								TextScaled = true,
								TextSize = 14,
								TextWrapped = true,
								ZIndex = 0,
							}),

							scope:New("UICorner")({
								Name = "UICorner",
								CornerRadius = UDim.new(0.2, 0),
							}),
						},
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
				Image = "rbxassetid://109227209402255",
				Position = UDim2.fromScale(0.0391, 0.872),
				Size = UDim2.fromOffset(59, 59),

				[Children] = {
					scope:New("UIAspectRatioConstraint")({
						Name = "UIAspectRatioConstraint",
					}),
				},
			}),

			scope:New("TextLabel")({
				Name = "TextLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.138, 0.875),
				Size = UDim2.fromScale(0.136, 0.0995),
				Text = "Satisfy Games",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,

				[Children] = {
					scope:New("UIGradient")({
						Name = "UIGradient",
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
							ColorSequenceKeypoint.new(0.583, Color3.fromRGB(251, 251, 251)),
							ColorSequenceKeypoint.new(0.592, Color3.fromRGB(255, 238, 0)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 145, 0)),
						}),
						Rotation = 93,
					}),

					scope:New("UIStroke")({
						Name = "UIStroke",
						LineJoinMode = Enum.LineJoinMode.Miter,
						Thickness = 4,
					}),
				},
			}),
		},
	})
end

return LoadingScreen
