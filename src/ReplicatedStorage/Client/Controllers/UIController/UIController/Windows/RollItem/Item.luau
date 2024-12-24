local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Item = {}

local Fusion = require(ReplicatedStorage.Packages.fusion)
local value = Fusion.Value

local Children, OnEvent = Fusion.Children, Fusion.OnEvent
local Icons = require(ReplicatedStorage.Source.Shared.Icons)

local function Item(scope, props: {

    Size : UDim2,
    Position : UDim2,
    Image : string,
    Name : string,
    RarityColor : Color3,
    RollSignal : RBXScriptSignal,
    OffsetTiming : number,
})



    local rotation = scope:Value(0)
    local scale = scope:Value(1)

    --[[scope:Observer(props.Name):onChange(function()
        scale:set(1.1)
        rotation:set(20)
        task.wait(0.1)
        rotation:set(0)
        scale:set(1)

    end)]]

    props.RollSignal:Connect(function()
        rotation:set(5)
        task.wait(0.1)
        rotation:set(0)
    end)

	return scope:New("Frame")({
		Name = "2",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = props.Position,
		Size = props.Size,
		ZIndex = 0,
        Rotation = scope:Tween(rotation, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)),
		[Children] = {

            scope:New "UIScale" {
                Scale = scope:Tween(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)),
            },

			scope:New("ImageLabel")({
				Name = "ImageLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				Image = "rbxassetid://11953711609",
				ImageColor3 = scope:Tween(props.RarityColor, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(2, 2),
				SliceCenter = Rect.new(20, 20, 108, 108),
				ZIndex = 0,
			}),

			scope:New("ImageLabel")({
				Name = "ItemImage",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				Image = props.Image,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				SliceCenter = Rect.new(20, 20, 108, 108),
			}),

			scope:New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
			}),

			scope:New("TextLabel")({
				Name = "TextLabel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new(
					"rbxasset://fonts/families/LuckiestGuy.json",
					Enum.FontWeight.ExtraLight,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.501, -0.0238),
				Size = UDim2.fromScale(1.05, 0.137),
				Text = props.Name,
				TextColor3 = Color3.fromRGB(20, 20, 20),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,

				[Children] = {
					scope:New("UIStroke")({
						Name = "UIStroke",
						Color = props.RarityColor,
					}),
				},
			}),
		},
	})
end

return Item
