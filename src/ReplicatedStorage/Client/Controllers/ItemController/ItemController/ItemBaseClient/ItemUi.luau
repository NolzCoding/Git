local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemUi = {}
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local Knit = require(ReplicatedStorage.Packages.Knit)

local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local ActionButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ActionButton)

local function ItemUi(scope, props : {
    ButtonUp : () -> ()
})


    return
            ActionButton(scope, {
                Position = UDim2.new(0.85, 0, 0.85, 0),
                Size = UDim2.new(0.1, 0, 0.1, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(54, 255, 14),
                ButtonText = "Drop Q",
                KeyCode = Enum.KeyCode.Q,
                Image = Icons.Drop,
                ImageSize = UDim2.new(1, 0, 1, 0),
                ButtonUp = function()
                    props.ButtonUp()
                end,
            })


end


return ItemUi