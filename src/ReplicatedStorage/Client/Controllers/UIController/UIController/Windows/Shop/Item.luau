local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)
local value = Fusion.Value

local Children, OnEvent = Fusion.Children, Fusion.OnEvent
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local DefaultButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.DefaultButton)
local TextLabelWithStroke = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Text.TextLabelWithStroke)

function Item (scope, props : {
    RarityColor : Color3,
    Name : string,
    Clicked : () -> (),
    Equipped : boolean,
    ImageSize : UDim2?,
    Amount : number,
    Image : string,
})

    return scope:New "Frame" {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        [Children] = {

            scope : New "ImageButton" {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Image = "rbxassetid://85650865183366",
                ImageColor3 = props.RarityColor,
                ClipsDescendants = true,
                [Children] = {

                    scope:New "ImageLabel" {
                        Image = props.Image,
                        Size = props.ImageSize or UDim2.fromScale(1, 1),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                    },

                    scope : New "UIAspectRatioConstraint" {
                        AspectRatio = 1,
                    },

                },

                [OnEvent("MouseButton1Click")] = function()
                    props.Clicked()
                end,

            },

            DefaultButton(scope, {
                Size = UDim2.fromScale(0.6, 0.2),
                Position = UDim2.fromScale(0.5, 0.8),
                Text = "Open",
                ButtonDown= function()
                end,
                ButtonUp = function()
                    props.Clicked()
                end,
                ZIndex = 1,
            }),

            scope : New "ImageLabel" {
                Image = Icons.CheckMark64,
                Size = UDim2.fromScale(0.2, 0.2),
                Position = UDim2.fromScale(0.1, 0.1),
                BackgroundTransparency = 1,
                Visible = props.Equipped,
            },

            scope : New "UIAspectRatioConstraint" {
                AspectRatio = 1,
            },

            TextLabelWithStroke(scope, {
                Text = props.Name,
                Size = UDim2.fromScale(1, 0.2),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                StrokeColor3 = props.RarityColor,
                Thickness = 2,
                ZIndex = 1,
            }),

            TextLabelWithStroke(scope, {
                Text = scope:Computed(function(use)
                    return use(props.Amount) .. "x"
                end),
                Size = UDim2.fromScale(0.2, 0.2),
                Position = UDim2.fromScale(0.8, 0.8),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                StrokeColor3 = props.RarityColor,
                Thickness = 2,
                ZIndex = 1,
            })

        }

    }

end

return Item