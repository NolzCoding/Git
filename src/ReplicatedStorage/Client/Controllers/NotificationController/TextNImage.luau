local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)

local Children = Fusion.Children
local new = Fusion.New
local function TextNImage(
	scope,
	props: {
		Parent : Instance,
		Size: UDim2?,
		Position: UDim2?,
		Text: string,
		Image: string,
		Color: Color3,
		Visible : boolean,
	}
)

	local rotation = scope:Value(0)

	local textBounds = scope:Value(Vector2.new(0, 0))
	local text = scope:New("TextLabel")({
		Parent = props.Parent,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = props.Position or UDim2.new(0.5, 0, 0.5, 0),
		Size = props.Size or UDim2.new(1, 0, 0.07, 0),
		Text = props.Text,
		Font = Enum.Font.FredokaOne,
		TextScaled = true,
		TextColor3 = props.Color or Color3.fromRGB(255, 255, 255),

		[Children] = {
			scope:New("ImageLabel")({
				BackgroundTransparency = 1,
				Position = scope:Computed(function(use, scope)
					return UDim2.new(0.5, use(textBounds).X/2 + 5, 0.5, 0)
				end),
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0.1, 0, 1, 0),
				Rotation = scope:Tween(rotation, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, -1, true, 0.3)),
				Image = props.Image,
                [Children] = {
                    scope:New("UIAspectRatioConstraint")({
                        AspectRatio = 1,
                    }),
                },
			}),

			scope:New("UIStroke")({
				Color = Color3.fromRGB(20, 20, 20),
				Thickness = 2,
			}),

			scope:New("UIGradient")({
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 236, 236)),
				}),
				Rotation = 90,
			}),


			scope : New "UIScale" {
				Scale = scope:Tween(scope:Computed(function(use,scope)
					return use(props.Visible) and 1 or 0
				end), TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut) ),
			}

		},
	}) :: TextLabel
	rotation:set(30)
	textBounds:set(text.TextBounds)
	text.Changed:Connect(function()
		textBounds:set(text.TextBounds)
	end)
end

return TextNImage
