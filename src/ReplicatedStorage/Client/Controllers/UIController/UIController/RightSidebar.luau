local RightSideBar = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local new = Fusion.New

local TextLabelWithStroke = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Text.TextLabelWithStroke)
local ImageButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ImageButton)

local Icons = require(ReplicatedStorage.Source.Shared.Icons)

local function RightSideBar(scope : typeof(Fusion.scoped(Fusion)), props : {
    OpenWindow : (name : string) -> (),
})

    return scope:New "Frame" {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.5,
        Size = UDim2.fromScale(0.15, 0.6),
        Position = UDim2.fromScale(0.98, 0.4),
        AnchorPoint = Vector2.new(1, 0.5),
        [Children] = {
            scope:New "UIGridLayout" {
                CellSize = UDim2.fromScale(0.3, 0.3),
                CellPadding = UDim2.fromOffset(0.03, 0),
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                VerticalAlignment = Enum.VerticalAlignment.Top,
            },

            scope : New "UIAspectRatioConstraint" {
                AspectRatio = 1,
            },

            ImageButton(scope, {
                Image = Icons.ShoppingBasket,
                Size = UDim2.fromScale(0.3, 0.3),
                ButtonUp = function()
                    props.OpenWindow("Shop")
                end
            }),

            ImageButton(scope, {
                Image = Icons.EmptyHeart,
                Size = UDim2.fromScale(0.3, 0.3),
                ButtonUp = function()
                    props.OpenWindow("RollItem")
                end
            }),

            ImageButton(scope, {
                Image = Icons.ShoppingBasket,
                Size = UDim2.fromScale(0.3, 0.3),
                ButtonUp = function()
                    props.OpenWindow("Skins")
                end
            }),

            ImageButton(scope, {
                Image = "",
                Size = UDim2.fromScale(0.3, 0.3),
                ButtonUp = function()
                    props.OpenWindow("Shop")
                end,
                Build = function(scope)

                    local rotation = scope:Value(0)

                    task.spawn(function()
                        local count = 0

                        -- make count go from -1 to 0 to 1 in 3 second intervals looping
                        while true do
                            for i = -1, 1 do
                                count = i
                                rotation:set(count * 30)
                                task.wait(3)
                            end
                        end
                    end)

                    return scope:New "ImageLabel" {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Image = Icons.Emojis.Skull,
                        Position = UDim2.fromScale(0.5, 0.5),
                        Rotation = scope:Tween(rotation, TweenInfo.new(2, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut)),
                        ScaleType = Enum.ScaleType.Fit,
                        Size = UDim2.fromScale(1, 1),
                    }

                end
            }),

        }
    }

end

return RightSideBar