local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Toolbar = {}

local Fusion = require(ReplicatedStorage.Packages.fusion)

local Children, OnEvent = Fusion.Children, Fusion.OnEvent
local Module3D = require(ReplicatedStorage.Source.Shared.Module3D)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)

local function ToolBar(scope, props: {

}) -- should be lifetime of the game

    local tools = scope:Value({}) -- list of instances of tools
    local backpack = Players.LocalPlayer:WaitForChild("Backpack")
    local character = Players.LocalPlayer.Character


    local function updated()
        -- update the tools
        local backpackTools = backpack:GetChildren()
        local equippedTool = character:FindFirstChildOfClass("Tool")
        table.insert(backpackTools, equippedTool)

        tools:set(backpackTools)

        print(Fusion.peek(tools))

    end

    backpack.ChildAdded:Connect(updated)
    backpack.ChildRemoved:Connect(updated)

    local characterAdded = function(char)
        backpack = Players.LocalPlayer:WaitForChild("Backpack")
        character = char
        print(character)
        character.ChildAdded:Connect(updated)
        character.ChildRemoved:Connect(updated)
        updated()
    end

    if character then
        characterAdded(character)
    end
    Players.LocalPlayer.CharacterAdded:Connect(characterAdded)

    local equippedTool = scope:Value(nil)

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
				Size = UDim2.fromScale(0.468, 0.102),

				[Children] = {
					scope:New("UIListLayout")({
						Name = "UIListLayout",
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0.025, 0),
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),

					scope:ForValues(tools, function(use, scope, value)


                        local scale = scope:Value(1)

                        scope:Observer(equippedTool):onChange(function()
                            local equipped = Fusion.peek(equippedTool)

                            if equipped == value then
                                scale:set(1.1)
                            else
                                scale:set(1)
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

                                scope:New "ImageButton" {
                                    Size = UDim2.fromScale(1, 1),
                                    ImageTransparency = 1,

                                    BackgroundColor3 = scope:Tween(scope:Computed(function(use)
                                        local equipped = use(equippedTool) == value

                                        return equipped and Color3.fromRGB(36, 255, 72) or Color3.fromRGB(255, 255, 255)

                                    end) , TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)),

                                    [OnEvent("MouseButton1Up")] = function()

                                        if Fusion.peek(equippedTool) == value then
                                            Players.LocalPlayer.Character.Humanoid:UnequipTools()
                                            equippedTool:set(nil)
                                            return
                                        end

                                        Players.LocalPlayer.Character.Humanoid:EquipTool(value)
                                        equippedTool:set(value)
                                        --scale:set(1.1)
                                    end,

                                    [Children] = {
                                        scope:New("UICorner")({
                                            Name = "UICorner",
                                            CornerRadius = UDim.new(0.2, 0),
                                        }),
                                    }

                                },

                                scope:New "ImageLabel" {
                                    Size = UDim2.fromScale(2, 2),
                                    ImageTransparency = 0.5,
                                    Position = UDim2.fromScale(0.5, 0.5),
                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                    ImageColor3 = Color3.fromRGB(0, 0, 0),
                                    BackgroundTransparency = 1,
                                    ZIndex = 0,
                                    Image = Icons.Shadow
                                },

                                scope:New("UIAspectRatioConstraint")({
                                    Name = "UIAspectRatioConstraint",
                                }),


                                scope:New "UIScale" {
                                    Scale = scope:Spring(scale, 100, 0.25),
                                },

                                scope:New("TextLabel")({
                                    Name = "TextLabel",
                                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                    BackgroundTransparency = 1,
                                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                                    BorderSizePixel = 0,
                                    FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
                                    Position = UDim2.fromScale(-0.129, -0.157),
                                    Size = UDim2.fromScale(0.343, 0.357),
                                    Text = "2",
                                    TextColor3 = Color3.fromRGB(136, 255, 24),
                                    TextScaled = true,
                                    TextSize = 14,
                                    TextWrapped = true,

                                    [Children] = {
                                        scope:New("UIStroke")({
                                            Name = "UIStroke",
                                            Thickness = 2,
                                        }),
                                    },
                                }),
                            },
                        })

                        --[[value:WaitForChild("Handle")

                        local module3d = Module3D:Attach3D(hotbar, value)

                        module3d.Visible = true

                        table.insert(scope, module3d)

                        table.insert(scope, game:GetService("RunService").RenderStepped:Connect(function()
                            module3d:SetCFrame(CFrame.Angles(0,tick() % (math.pi * 2),0) * CFrame.Angles(math.rad(-10),0,0))
                        end))]]

                        return hotbar

                    end)
				},
			}),
		},
	})
end


return ToolBar