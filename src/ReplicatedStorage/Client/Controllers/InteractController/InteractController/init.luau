local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

local Icons = require(ReplicatedStorage.Source.Shared.Icons)

local InteractController = Knit.CreateController({
	Name = "InteractController",
})

function InteractController:KnitStart()
	print("InteractController KnitStart")
end

function InteractController:GetDeviceSpesificImage()

    local image = ""

    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        image = Icons.Prompt.Mobile
    else
        image = Icons.Prompt.Computer
        -- alternative console added later
    end

    return image

end

local SIZE = UDim2.fromScale(2.5, 2.5)

function InteractController:KnitInit()
	local scope = Fusion.scoped(Fusion)

    local promptImage = self:GetDeviceSpesificImage()
    local text = scope:Value("")

    local currentAdornee = scope:Value(nil)

    local scale = scope:Value(UDim2.fromScale(0, 0))
    local easingDirection = Enum.EasingDirection.Out

	local uiScale = scope:Value(1)
	local shadowScale = scope:Value(0.6)

	local holdSize = scope:Value(UDim2.fromScale(1, 0))

	local globalTransparency = scope:Value(0)

	RunService.RenderStepped:Connect(function(delta)
		if not Fusion.peek(currentAdornee) then
			return
		end

		local adornee = Fusion.peek(currentAdornee) :: BasePart
		local Cframe = adornee.CFrame
		if adornee:IsA("Attachment") then
			Cframe = adornee.WorldCFrame
		end

		local distance = (Cframe.Position - workspace.CurrentCamera.CFrame.Position).Magnitude

		local falloffStart = 10
		local falloffEnd = 5
		local transparency = math.clamp((distance - falloffStart) / (falloffEnd - falloffStart), 0.1, 0.9)
		globalTransparency:set(transparency)

	end)

    ProximityPromptService.PromptShown:Connect(function(prompt)
        if prompt then
            currentAdornee:set(prompt.Parent)
            scale:set(SIZE)

            -- check if the prompt has a description
            local description = prompt.Parent:GetAttribute("Text")

            text:set(description or "")

        end
    end)

    ProximityPromptService.PromptHidden:Connect(function(prompt)
        if prompt then
            scale:set(UDim2.fromScale(0, 0))
            task.wait(0.2)
        end
    end)

	ProximityPromptService.PromptTriggered:Connect(function(prompt)
		uiScale:set(0.9)
		shadowScale:set(1)
		task.wait(0.1)
		uiScale:set(1)
		shadowScale:set(0.6)
	end)

	local holdRunning = nil

	ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, playerWhoTriggered)
		uiScale:set(0.9)
		shadowScale:set(1)
		local holdTime = prompt.HoldDuration
		local start = tick()

		if holdRunning then
			holdRunning:Disconnect()
		end

		holdRunning = RunService.RenderStepped:Connect(function(delta)

			local elapsedTime = tick() - start

			local progress = elapsedTime / holdTime

			holdSize:set(UDim2.fromScale(1, progress))

			if elapsedTime >= holdTime then
				holdRunning:Disconnect()
				holdSize:set(UDim2.fromScale(1, 0))
			end

		end)

	end)


	ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt, playerWhoTriggered)
		uiScale:set(1)
		shadowScale:set(0.6)
		if holdRunning then
			holdRunning:Disconnect()
		end

		holdSize:set(UDim2.fromScale(1, 0))

	end)


	scope:New("BillboardGui")({
		Name = "Interact",
		Active = true,
		AlwaysOnTop = true,
        Adornee = currentAdornee,
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
		ClipsDescendants = true,
		LightInfluence = 1,
		Size = scope:Tween(scale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, easingDirection)),
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

		[Children] = {
			scope:New("ImageButton")({
				Name = "ImageButton",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = globalTransparency,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
				ImageTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.5, 0.5),

				[OnEvent("MouseButton1Down")] = function()
					local adornee = Fusion.peek(currentAdornee) :: ProximityPrompt
					local prompt = adornee:FindFirstChildOfClass("ProximityPrompt")
					prompt:InputHoldBegin()
				end,

				[OnEvent("MouseButton1Up")] = function()
					local adornee = Fusion.peek(currentAdornee) :: ProximityPrompt
					local prompt = adornee:FindFirstChildOfClass("ProximityPrompt")

					prompt:InputHoldEnd()
				end,

				[Children] = {
					scope:New("UICorner")({
						Name = "UICorner",
						CornerRadius = UDim.new(1, 0),
					}),

					scope:New("UIStroke")({
						Name = "UIStroke",
						Color = Color3.fromRGB(177, 177, 177),
						Transparency = globalTransparency,
						Thickness = 5.4,
					}),

					scope:New "UIScale" {
						Scale = scope:Tween(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)),
					},

					scope:New("CanvasGroup")({
						Name = "CanvasGroup",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = globalTransparency,
						[Children] = {
							scope:New("Frame")({
								Name = "Cooldown",
								AnchorPoint = Vector2.new(0.5, 1),
								BackgroundColor3 = Color3.fromRGB(59, 150, 255),
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Position = UDim2.fromScale(0.5, 1),
								Size = holdSize,
								ZIndex = 2,
							}),

							scope:New("UICorner")({
								Name = "UICorner",
								CornerRadius = UDim.new(1, 0),
							}),
						},
					}),

					scope:New("ImageLabel")({
						Name = "ImageLabel",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						ImageTransparency = globalTransparency,
                        ImageColor3 = Color3.fromRGB(119, 119, 119),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Image = promptImage,
						Interactable = false,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(0.8, 0.8),
					}),
				},
			}),

			scope:New("TextLabel")({
				Name = "Descript",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0.5, 0.8),
				Size = UDim2.fromScale(1, 0.1),
				TextColor3 = Color3.fromRGB(222, 222, 222),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
                Text = text,
				[Children] = {
					scope:New("UIStroke")({
						Name = "UIStroke",
						Color = Color3.fromRGB(93, 93, 93),
						Thickness = 2,
					}),
				},
			}),

			scope:New "ImageLabel" {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Image = Icons.Shadow,
				ImageColor3 = Color3.new(0, 0, 0),
				ImageTransparency = globalTransparency,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ZIndex = 0,
				[Children] = {
					scope:New "UIScale" {
						Scale = scope:Tween(shadowScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)),
					}
				}
			}

		},
	})
end

return InteractController
