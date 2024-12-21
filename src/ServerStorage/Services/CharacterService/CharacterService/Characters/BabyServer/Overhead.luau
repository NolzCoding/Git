local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OverHead = {}

local Fusion = require(ReplicatedStorage.Packages.fusion)

local Children, OnEvent = Fusion.Children, Fusion.OnEvent
local Module3D = require(ReplicatedStorage.Source.Shared.Module3D)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)

local TextLabelWithStroke =
	require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Text.TextLabelWithStroke)

local function OverHead(scope, props: {

    Parent : Instance,
    Player : Player,

}) -- should be lifetime of the game
	local healths = {
		{ AttributeName = "Heart", Icon = Icons.OrganHeart, Value = scope:Value(100) },
		{ AttributeName = "Stomach", Icon = Icons.OrganStomach, Value = scope:Value(100) },
		{ AttributeName = "Lungs", Icon = Icons.OrganLungs, Value = scope:Value(100) },
	}

    local humanoid = (props :: any).Player.Character:WaitForChild("Humanoid") :: Humanoid

    for i, attributeName in ipairs(healths) do
        humanoid:GetAttributeChangedSignal("attributeName"):Connect(function()
            healths[i].Value:set(humanoid:GetAttribute(attributeName))
        end)
    end

	return scope:New("BillboardGui")({
		Name = "HealthBarUI",
        Size = UDim2.fromScale(5, 3),
        Parent = props.Parent,
        PlayerToHideFrom = props.Player,
        StudsOffset = Vector3.new(0, 3, 0),
		[Children] = {
			scope:New "Frame" {
				Name = "Frame",
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.021, 0.989),
				Size = UDim2.fromScale(1, 1),

				[Children] = {
					scope:New("UIListLayout")({
						Name = "UIListLayout",
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0.025, 0),
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),

					scope:Computed(function(use)
						local hearts = {}
						for i = 1, 3 do
							local tbl = healths[i]
                            local shadowScale = scope:Value(1)
                            local shadowTransparency = scope:Value(1)
                            local organRotation = scope:Value(0)
                            scope:Observer(tbl.Value):onChange(function()
                                local value = Fusion.peek(tbl.Value)
                                shadowScale:set(1.5)
                                shadowTransparency:set(0)
                                organRotation:set(30)
                                task.wait(0.15)
                                organRotation:set(0)
                                shadowScale:set(1)
                                shadowTransparency:set(100/value)
                            end)

							hearts[#hearts + 1] = scope:New("ImageLabel")({
								Name = "Heart",
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Image = nil,
								Position = UDim2.fromScale(0.5, -0.316),
								Size = UDim2.fromScale(0.348, 1),

								[Children] = {
									scope:New("UIAspectRatioConstraint")({
										Name = "UIAspectRatioConstraint",
										AspectRatio = 1,
									}),

                                    scope:New("ImageLabel")({
                                        Name = "Icon",
                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                        BackgroundTransparency = 1,
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        Size = UDim2.fromScale(1, 1),
                                        Image = tbl.Icon,
                                        Rotation = scope:Tween(organRotation, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)),

                                    }),

									TextLabelWithStroke(scope, {
										Position = UDim2.fromScale(0.5, 0.5),
										Size = UDim2.fromScale(0.5, 0.5),
										Text = scope:Computed(function(use)
                                            return use(tbl.Value) .. "%"
                                        end),
										TextColor = Color3.fromRGB(255, 204, 204),
										StrokeColor = Color3.fromRGB(29, 16, 16),
										Thickness = 2,
									}),

                                    scope : New "ImageLabel" {
                                        Size = UDim2.fromScale(1.5, 1.5),
                                        Image = Icons.Shadow,
                                        ZIndex = 0,
                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        BackgroundTransparency = 1,
                                        ImageTransparency = scope:Tween(shadowTransparency, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)),
                                        ImageColor3 = Color3.fromRGB(255, 0, 0),
                                        [Children] = {
                                            scope:New "UIScale" {
                                                Scale = scope:Tween(shadowScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)),
                                            }
                                        },
                                    }

								},
							})
						end

						return hearts
					end),
				},
			},
		},
	})
end

return OverHead
