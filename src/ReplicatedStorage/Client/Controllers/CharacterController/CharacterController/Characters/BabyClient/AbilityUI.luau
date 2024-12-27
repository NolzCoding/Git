local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)

local Children, OnEvent = Fusion.Children, Fusion.OnEvent
local Module3D = require(ReplicatedStorage.Source.Shared.Module3D)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local ActionButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ActionButton)
local Abilities = require(ReplicatedStorage.Source.Shared.Abilities)
local AbilityInfo = require(ReplicatedStorage.Source.Shared.Abilities)
local UserInputService = game:GetService("UserInputService")
local TextLabelWithStroke =
	require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Text.TextLabelWithStroke)

local function AbilityUI(scope, props: {

    CurrentAbilities: {},
    OwnedAbilities: {},
    AbilityUsed : () -> (),
}) -- should be lifetime of the game

    local Keybinds = {
        [1] = Enum.KeyCode.G,
        [2] = Enum.KeyCode.H,
    }

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            for key, value in pairs(Keybinds) do
                if input.KeyCode == value then
                    props.AbilityUsed(Fusion.peek(props.CurrentAbilities)[key])
                end
            end
        end
    end)

    return scope:New "ScreenGui" {
        Name = "AbilityUI",
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
        [Children] = {
            scope:New "Frame" {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0.06, 0.3),
                Position = UDim2.fromScale(0.95, 0.4),
                AnchorPoint = Vector2.new(1, 0.5),
                [Children] = {
                    scope:New "UIListLayout" {
                        Padding = UDim.new(0.05, 0),
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalAlignment = Enum.HorizontalAlignment.Right,
                        VerticalAlignment = Enum.VerticalAlignment.Top,

                    },
                    scope:ForPairs(props.CurrentAbilities, function(use,scope,key, value)

                        local key = Keybinds[key]

                        local coolDown = scope:Value(0)

                        return key, ActionButton(scope, {
                            Image = AbilityInfo.Abilities[value].Image,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Cooldown = 8,
                            KeyCode = key,
                            BackgroundColor3 = Color3.new(0.035294, 0.486275, 1.000000),
                            Size = UDim2.fromScale(1, 0.5),

                            ButtonText = scope:Computed(function(use, scope)
                                return value .. " x" .. (use(props.OwnedAbilities)[value] or 0) .. " (" .. key.Name .. ")"
                            end),
                            ButtonUp = function()
                                props.AbilityUsed(value)
                            end,
                            ButtonDown = function()
                            end,
                        })

                    end)
                }
            }
        }
    }



end

return AbilityUI
