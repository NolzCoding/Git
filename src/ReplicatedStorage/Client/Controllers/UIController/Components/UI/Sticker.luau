local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local function Sticker(scope, props: {

    Size : UDim2,
    Position : UDim2,
    Text : string,
    Color : Color3?,
    TextColor : Color3?,

})



	return scope:New("ImageButton")({
		Name = "Sticker",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = props.Color or Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Image = "rbxassetid://98223269314130",
		ImageColor3 = Color3.fromRGB(255, 69, 69),
		Position = props.Position or UDim2.fromScale(0.218, 0.468),
		Size = props.Size or UDim2.fromScale(0.195, 0.0903),

		[Children] = {
			scope:New("TextLabel")({
				Name = "TextLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.388, 0.5),
				Size = UDim2.fromScale(0.729, 0.952),
                Text = props.Text,
				TextColor3 = props.TextColor or Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
			}),

			scope:New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
				AspectRatio = 4,
			}),
		},
	})
end

return Sticker
