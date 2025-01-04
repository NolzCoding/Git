local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)

local Children = Fusion.Children
local ImageButton = require(script.Parent.Parent.Buttons.ImageButton)
local Window = {}
local SoundService = game:GetService("SoundService")
local Sounds = require(ReplicatedStorage.Source.Shared.Sounds)

local function Window(scope: typeof(Fusion.scoped(Fusion)), props: {

    HeaderText : string?,
    Build : (scope : any) -> (),
    Open : boolean?,
	ZIndex : number?,
    Position : UDim2?,
    AnchorPoint : Vector2?,
    Size : UDim2?,

	HeaderSize : UDim2?,
	HeaderPosition : UDim2?,

})


	local openSound = Instance.new("Sound")
	openSound.SoundId = Sounds.OpenWindow
	openSound.Parent = SoundService

	local closeSound = Instance.new("Sound")
	closeSound.SoundId = Sounds.CloseWindow
	closeSound.Parent = SoundService

	scope:Observer(props.Open):onChange(function()

		local open = Fusion.peek(props.Open)
		print("Hello?")
		if open then
			SoundService:PlayLocalSound(openSound)
		else
			SoundService:PlayLocalSound(closeSound)
		end

	end)

    local desiredSize = scope:Computed(function(use)
        local openSize = props.Size or UDim2.fromScale(0.321, 0.431)

        if use(props.Open) then
            return openSize
        else
            return UDim2.fromScale(0, 0)
        end

    end)

    local tweenSize = scope:Tween(desiredSize, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.InOut))

	return scope:New("Frame")({
		ZIndex = props.ZIndex or 1,
		Name = "Basic Frame",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(27, 42, 53),
        AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		Position = props.Position or UDim2.fromScale(0.5, 0.5),
		Size = tweenSize,
       -- Visible = props.Open or false,

        Visible = scope:Computed(function(use)
            local size : UDim2 = use(tweenSize)

            -- when size on scale and offset is 0, it is considered hidden

            return not (size.X.Scale == 0 and size.X.Offset == 0 and size.Y.Scale == 0 and size.Y.Offset == 0)


        end),

		[Children] = {
			scope:New("ImageLabel")({
				Name = "Background",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				Image = "rbxassetid://4965331045",
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 3,
			}),

			ImageButton(scope ,{
				Name = "XButton",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
                ZIndex = 2,
				Image = "rbxassetid://4963445748",
				Position = UDim2.fromScale(0.98,0.05),
                AnchorPoint = Vector2.new(0.5, 0.5),
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromScale(0.142, 0.143),
				ZIndex = 4,
                ButtonUp = function()
                    (props :: any).Open:set(false)
                end,
			}),

			scope:New("Frame")({
				Name = "Header",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				Position = props.HeaderPosition or UDim2.fromScale(0.23, -0.0753),
				Size = props.HeaderSize or UDim2.fromScale(0.538, 0.286),
				ZIndex = 4,

				[Children] = {
					scope:New("ImageLabel")({
						Name = "Header",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						Image = "rbxassetid://4963486264",
						Position = UDim2.fromScale(4.48e-08, 0),
						ScaleType = Enum.ScaleType.Fit,
						Size = UDim2.fromScale(1, 1),

						[Children] = {
							scope:New("TextLabel")({
								Name = "TextLabel",
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(27, 42, 53),
								FontFace = Font.new(
									"rbxasset://fonts/families/GothamSSm.json",
									Enum.FontWeight.Heavy,
									Enum.FontStyle.Normal
								),
								Position = UDim2.fromScale(0.22, 0.251),
								Size = UDim2.fromScale(0.56, 0.489),
								Text = props.HeaderText,
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextScaled = true,
								TextSize = 14,
								TextStrokeColor3 = Color3.fromRGB(134, 201, 34),
								TextStrokeTransparency = 0,
								TextWrapped = true,
								ZIndex = 3,
							}),
						},
					}),

					scope:New("UIAspectRatioConstraint")({
						Name = "UIAspectRatioConstraint",
						AspectRatio = 2.97,
						AspectType = Enum.AspectType.ScaleWithParentSize,
					}),
				},
			}),

			scope:New("UIAspectRatioConstraint")({
				Name = "UIAspectRatioConstraint",
				AspectRatio = 1.58,
				AspectType = Enum.AspectType.ScaleWithParentSize,
			}),

            props.Build and props.Build(scope),
		},
	})
end

return Window
