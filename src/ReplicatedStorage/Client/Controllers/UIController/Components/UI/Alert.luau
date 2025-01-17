local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children, OnEvent, peek = Fusion.Children, Fusion.OnEvent, Fusion.peek
type scope = typeof(Fusion.scoped(Fusion))
local function Alert(scope: scope, props: {

    Position : UDim2?,
    Size : UDim2?,
    Visible : boolean?,

})
	return scope:New("ImageLabel")({
		Name = "Alert",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
		BorderColor3 = Color3.fromRGB(27, 42, 53),
		Position = props.Position or UDim2.fromScale(1, 0),
		Size = props.Size or UDim2.fromScale(0.2, 0.2),
        Visible = props.Visible or false,
		[Children] = {
			scope:New("Frame")({
				Name = "Text",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				Size = UDim2.new(1, 0, 1, -5),
				ZIndex = 2,

				[Children] = {
					scope:New("TextLabel")({
						Name = "TextLabel",
						AnchorPoint = Vector2.new(0.5, 0.35),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						FontFace = Font.new("rbxasset://fonts/families/LuckiestGuy.json"),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1, 1),
						Text = "!",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 25,
						ZIndex = 2,
                        TextScaled = true,
						[Children] = {
							scope:New("UIStroke")({
								Name = "UIStroke",
							}),

							scope:New("UITextSizeConstraint")({
								Name = "UITextSizeConstraint",
								MinTextSize = 1,
							}),
						},
					}),

					scope:New("TextLabel")({
						Name = "TextLabel - Stroke",
						AnchorPoint = Vector2.new(0.5, 0.35),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						FontFace = Font.new("rbxasset://fonts/families/LuckiestGuy.json"),
						Position = UDim2.new(0.5, 0, 0.5, 3),
						Size = UDim2.fromScale(1, 1),
						Text = "!",
						TextColor3 = Color3.fromRGB(0, 0, 0),
						TextSize = 25,
                        TextScaled = true,

						[Children] = {
							scope:New("UITextSizeConstraint")({
								Name = "UITextSizeConstraint",
								MinTextSize = 1,
							}),
						},
					}),
				},
			}),

			scope:New("Frame")({
				Name = "Background",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				Size = UDim2.fromScale(1, 1),

				[Children] = {
					scope:New("ImageLabel")({
						Name = "Color 2",
						AnchorPoint = Vector2.new(0.5, 1),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						Image = "rbxassetid://11953889677",
						ImageColor3 = Color3.fromRGB(185, 22, 22),
						ImageTransparency = 0.5,
						Position = UDim2.fromScale(0.5, 0.9),
						Size = UDim2.fromScale(0.7, 0.5),
						ZIndex = 4,
					}),

					scope:New("ImageLabel")({
						Name = "Shadow",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						Image = "rbxassetid://11953889677",
						ImageColor3 = Color3.fromRGB(0, 0, 0),
						ImageTransparency = 0.8,
						Position = UDim2.new(0.5, 0, 0.5, 5),
						Size = UDim2.fromScale(1, 1),
					}),

					scope:New("ImageLabel")({
						Name = "Color 1",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						Image = "rbxassetid://11953889677",
						ImageColor3 = Color3.fromRGB(255, 50, 50),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1, 1),
						ZIndex = 3,
					}),

					scope:New("ImageLabel")({
						Name = "Stroke",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						Image = "rbxassetid://11953889677",
						ImageColor3 = Color3.fromRGB(0, 0, 0),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.new(1, 2, 1, 2),
						ZIndex = 2,
					}),
				},
			}),
		},
	})
end

return Alert
