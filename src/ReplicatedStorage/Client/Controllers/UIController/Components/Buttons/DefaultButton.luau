local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local ImageButton = require(script.Parent.ImageButton)

local DefaultButton = {}

local function DefaultButton(
	scope,
	props: {
		Size: UDim2?,
		AnchorPoint: Vector2?,
		Position: UDim2?,
		ZIndex: number?,
		Text: string?,
		BackgroundColor3: Color3?,
		StrokeColor3: Color3?,
		ButtonUp: () -> (),
		ButtonDown: () -> (),
	}
)
	return ImageButton(scope, {
		Size = props.Size or UDim2.fromScale(0.5, 0.5),
		Image = "",
		ZIndex = props.ZIndex or 1,
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		Position = props.Position or UDim2.fromScale(0.5, 0.5),
        ButtonUp = props.ButtonUp,
        ButtonDown = props.ButtonDown,
        Build = function(scope)

            return {scope:New("ImageLabel")({
                Name = "ImageLabel",
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = props.StrokeColor3 or Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                ImageColor3 = props.StrokeColor3 or Color3.fromRGB(255, 255, 255),
                Image = "rbxassetid://85650865183366",
                Position = UDim2.fromScale(0.5, 0.5),
                ScaleType = Enum.ScaleType.Fit,
                Size = UDim2.fromScale(1, 1),
            }),
            scope:New("UIAspectRatioConstraint")({
                Name = "UIAspectRatioConstraint",
                AspectRatio = 2.44,
            }),
            scope:New("ImageLabel")({
                Name = "ImageLabel",
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Image = "rbxassetid://100970593225856",
                ImageColor3 = props.BackgroundColor3 or Color3.fromRGB(136, 255, 0),
                Position = UDim2.fromScale(0.5, 0.5),
                ScaleType = Enum.ScaleType.Fit,
                Size = UDim2.fromScale(1, 1),
                ZIndex = 2,
            }),
            scope:New("TextLabel")({
                Name = "TextLabel",
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.fromRGB(27, 42, 53),
                BorderMode = Enum.BorderMode.Middle,
                BorderSizePixel = 0,
                FontFace = Font.new(
                    "rbxasset://fonts/families/GothamSSm.json",
                    Enum.FontWeight.Heavy,
                    Enum.FontStyle.Normal
                ),
                Position = UDim2.fromScale(0.5, 0.478),
                Size = UDim2.fromScale(0.82, 0.685),
                Text = props.Text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextSize = 14,
                TextStrokeColor3 = Color3.fromRGB(134, 201, 34),
                TextStrokeTransparency = 0,
                TextWrapped = true,
                ZIndex = 3,

                [Children] = {
                    scope:New("UIStroke")({
                        Name = "UIStroke",
                        Transparency = 0.42,
                    }),
                },
            })}

        end
    })
end








return DefaultButton
