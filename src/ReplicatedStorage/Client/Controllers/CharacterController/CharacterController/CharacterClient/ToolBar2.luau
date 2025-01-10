local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Toolbar = {}

local Fusion = require(ReplicatedStorage.Packages.fusion)
local new = Fusion.New

local Children, OnEvent = Fusion.Children, Fusion.OnEvent
local Module3D = require(ReplicatedStorage.Source.Shared.Module3D)
local ViewportUtils = require(ReplicatedStorage.Source.Shared.Uitility.ViewportUtils)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)



local function ToolBar(
	scope,
	props: {
		Slots: number,
        Tools : table,
        EquippedTool : Tool?,
        ClickedTool : Tool?,
	}
)
	local tools = props.Tools -- list of instances of tool

    print(Fusion.peek(tools))


	local equippedTool = props.EquippedTool

    local originalImagePos = UDim2.fromScale(0.14, 0.426)
    local equippedImagePos = UDim2.fromScale(0.14, 0.2)

	return scope:New("ScreenGui")({
		Name = "ToolBarUI",
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

		[Children] = {
			scope:New("Frame")({
				Name = "Frame",
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.989),
				Size = UDim2.fromScale(0.468, 0.12),

				[Children] = {
					scope:New("UIListLayout")({
						Name = "UIListLayout",
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0.025, 0),
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),

					scope:Computed(function(use, scope)
						local slots = {}

						for i = 1, props.Slots do
                            local value = use(tools)[i]
							local scale = scope:Value(1)
                            local imagepos = scope:Value(originalImagePos)
                            local currentImage = scope:Value("")
                            local rotation = scope:Value(0)
                            print(Fusion.peek(tools))

							scope:Observer(equippedTool):onChange(function()
								local equipped = Fusion.peek(equippedTool)

								if equipped == value.Tool and value.Tool ~= nil then
									scale:set(1.1)
                                    rotation:set(20)
                                    imagepos:set(equippedImagePos)
                                    currentImage:set(Icons.ItemImages[value.Tool.Name] or "")

								else
									scale:set(1)
                                    rotation:set(0)
                                    imagepos:set(originalImagePos)
                                    currentImage:set(value.Tool and Icons.ItemImages[value.Tool.Name] or "")
                                end



							end)

							local hotbar = scope:New("Frame")({
								Name = "Frame",
								Active = false,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundTransparency = 1,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Selectable = false,
								Size = UDim2.fromScale(1, 1),

								[Children] = {

									scope:New("ImageButton")({
										Size = UDim2.fromScale(1, 1),
										ImageTransparency = 1,
                                        BackgroundTransparency = 1,
										BackgroundColor3 = scope:Tween(
											scope:Computed(function(use)
												local equipped = use(equippedTool) == value.Tool and value.Tool ~= nil

												return equipped and Color3.fromRGB(36, 255, 72)
													or Color3.fromRGB(255, 255, 255)
											end),
											TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
										),

										[OnEvent("MouseButton1Up")] = function()

											if props.ClickedTool then
                                                props.ClickedTool(i)
                                            end

											--[[if Fusion.peek(equippedTool) == value.Tool then
												equippedTool:set(nil)
												return
											end

											equippedTool:set(value.Tool)]]

											--scale:set(1.1)
										end,

										[Children] = {
											scope:New "Frame" {
                                                Name = "Frame",
                                                AnchorPoint = Vector2.new(0.5, 0.5),
                                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                                BackgroundTransparency = 1,
                                                BorderColor3 = Color3.fromRGB(0, 0, 0),
                                                BorderSizePixel = 0,
                                                Position = UDim2.fromScale(0.5, 0.5),
                                                Size = UDim2.fromScale(1, 1),

                                                [Children] = {
                                                    scope:New "ImageLabel" {
                                                    Name = "Front",
                                                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                                    BackgroundTransparency = 1,
                                                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                                                    BorderSizePixel = 0,
                                                    Image = "rbxassetid://87580065940218",
                                                    Position = UDim2.fromScale(0, 0.688),
                                                    Size = UDim2.fromScale(1, 0.28),
                                                  },

                                                  scope:New "ImageLabel" {
                                                    Name = "Back",
                                                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                                    BackgroundTransparency = 1,
                                                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                                                    BorderSizePixel = 0,
                                                    Image = "rbxassetid://106962592037207",
                                                    Position = UDim2.fromScale(0, 0.578),
                                                    Size = UDim2.fromScale(1, 0.28),
                                                    ZIndex = 0,
                                                  },

                                                  scope:New "UIAspectRatioConstraint" {
                                                    Name = "UIAspectRatioConstraint",
                                                  },

                                                  scope:New "CanvasGroup" {
                                                    Name = "CanvasGroup",
                                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                                    BackgroundTransparency = 1,
                                                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                                                    BorderSizePixel = 0,
                                                    Position = UDim2.fromScale(0.49, 0.301),
                                                    Size = UDim2.fromScale(1, 0.975),
                                                    ZIndex = 0,

                                                    [Children] = {
                                                        scope:New "ImageLabel" {
                                                        Name = "ImageLabel",
                                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                                        BackgroundTransparency = 1,
                                                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                                                        BorderSizePixel = 0,
                                                        Image = currentImage,
                                                        Rotation = scope:Tween(rotation, TweenInfo.new(0.15, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)),
                                                        Position = scope:Tween(imagepos, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)),
                                                        ScaleType = Enum.ScaleType.Fit,
                                                        Size = UDim2.fromScale(0.82, 0.841),
                                                        [Children] = {
                                                            scope:New "UIAspectRatioConstraint" {
                                                            Name = "UIAspectRatioConstraint",
                                                          },
                                                        }
                                                      },
                                                    }
                                                  },

                                                  scope:New "TextLabel" {
                                                    Name = "TextLabel",
                                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                                    BackgroundTransparency = 1,
                                                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                                                    BorderSizePixel = 0,
                                                    FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
                                                    Position = UDim2.fromScale(0.495, 0.877),
                                                    Size = UDim2.fromScale(0.5, 0.2),
                                                    Text = i,
                                                    TextColor3 = Color3.fromRGB(255, 255, 255),
                                                    TextScaled = true,
                                                    TextSize = 14,
                                                    TextWrapped = true,
                                                  },
                                                }
                                              }
										},
									}),

									scope:New("ImageLabel")({
										Size = UDim2.fromScale(2, 2),
										ImageTransparency = 0.75,
										Position = UDim2.fromScale(0.5, 0.75),
										AnchorPoint = Vector2.new(0.5, 0.5),
										ImageColor3 = Color3.fromRGB(0, 0, 0),
										BackgroundTransparency = 1,

										ZIndex = 0,
										Image = Icons.Shadow,
									}),

									scope:New("UIAspectRatioConstraint")({
										Name = "UIAspectRatioConstraint",
									}),

									--[[scope:New("UIScale")({
										Scale = scope:Spring(scale, 100, 0.25),
									}),]]


								},
							})

                            table.insert(slots, hotbar)

                            local tool = value.Tool

                            if tool then
                                currentImage:set(value.Tool and Icons.ItemImages[value.Tool.Name] or "")

                            end

						end





						return slots
					end),
				},
			}),
		},
	})
end

return ToolBar
