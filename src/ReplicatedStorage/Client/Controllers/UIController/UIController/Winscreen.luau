local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Fusion = require(game.ReplicatedStorage.Packages.fusion)
local CollectionService = game:GetService("CollectionService")

local Children = Fusion.Children

local Knit = require(ReplicatedStorage.Packages.Knit)

type UsedAs<T> = Fusion.UsedAs<T>

local function Winscren(
	scope: typeof(Fusion.scoped(Fusion)),
	props: {
        Visible : UsedAs<boolean>?,
        WhoWon : UsedAs<string>?,
	}
)

    local text = scope:Value("Parents Win")
    local color = scope:Value(Color3.fromRGB(0, 174, 255))



    scope:Observer(props.WhoWon):onChange(function()

        local whowon = Fusion.peek(props.WhoWon)

        text:set(whowon .. " Won")

    end)

	return scope:New("ScreenGui")({
		Name = "WinScreen",
		DisplayOrder = 5,
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

		[Children] = {
			scope:New("Frame")({
				Name = "Frame",
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = scope:Tween(scope:Computed(function(use)
					return use(props.Visible) and 0.7 or 1
				end), TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
                Visible = props.Visible,

				[Children] = {
					scope:New("Frame")({
						Name = "DoubleText",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = scope:Tween(scope:Computed(function(use)
							return use(props.Visible) and UDim2.fromScale(0.5, 0.365) or UDim2.fromScale(0.5, -0.3)

						end), TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)),
						Size = UDim2.fromOffset(599, 187),

						[Children] = {
							scope:New("TextLabel")({
								Name = "TextLabel",
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
								Position = UDim2.fromScale(0.483, 0.24),
								Size = UDim2.fromScale(0.886, 0.788),
								Text = text,
								TextColor3 = Color3.fromRGB(0, 174, 255),
								TextScaled = true,
								TextSize = 14,
								TextWrapped = true,

								[Children] = {
									scope:New("UIGradient")({
										Name = "UIGradient",
										Color = ColorSequence.new({
											ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
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
		},
	})
end

return Winscren
