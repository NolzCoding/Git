local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local function Section(scope, props: {

    Name : string?,
    Build : (scope : any) -> (),
	Size : UDim2?,
	AutomaticSize : Enum.AutomaticSize?,
	Padding : number?,

})
	return scope:New("Frame")({
		Name = "Section",
		AutomaticSize = props.AutomaticSize or Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,

		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = props.Size or UDim2.new(1, 0, 0, 50),

		[Children] = {
			scope:New("Frame")({
				Name = "Padding",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(5.05e-08, 0),
				Size = UDim2.new(1, 0, 0, 50),
			}),

            scope : New "UICorner" {
                CornerRadius = UDim.new(0.1, 0),
            },

			scope:New("TextLabel")({
				Name = "Title",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.5, 0.193),
				Size = UDim2.fromScale(0.166, 0.367),
				Text = props.Name or "Shop",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,

				[Children] = {
					scope:New("UIStroke")({
						Name = "UIStroke",
						Color = Color3.fromRGB(57, 54, 12),
						LineJoinMode = Enum.LineJoinMode.Miter,
						Thickness = 3,
					}),

					scope:New("UIAspectRatioConstraint")({
						Name = "UIAspectRatioConstraint",
						AspectRatio = 2.31,
					}),
				},
			}),

			scope:New("TextLabel")({
				Name = "Lines",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0, 0.176),
				Size = UDim2.fromScale(0.432, 0.402),
				Text = "--------------------",
				TextColor3 = Color3.fromRGB(130, 116, 73),
				TextSize = 40,
				TextWrapped = true,

				[Children] = {
					scope:New("UIAspectRatioConstraint")({
						Name = "UIAspectRatioConstraint",
						AspectRatio = 7,
					}),
				},
			}),

			scope:New("TextLabel")({
				Name = "Lines",
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(1, 0.176),
				Size = UDim2.fromScale(0.432, 0.402),
				Text = "--------------------",
				TextColor3 = Color3.fromRGB(130, 116, 73),
				TextSize = 40,
				TextWrapped = true,

				[Children] = {
					scope:New("UIAspectRatioConstraint")({
						Name = "UIAspectRatioConstraint",
						AspectRatio = 7,
					}),
				},
			}),

			scope:New("Frame")({
				Name = "Container",
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(0, props.Padding or 50),
				Size = UDim2.new(1, 0, 0, 50),
                [Children] = {
                    props.Build(scope),
                }
			}),
		},
	})
end

return Section
