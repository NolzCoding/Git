local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemUi = {}
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local Knit = require(ReplicatedStorage.Packages.Knit)

local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local ActionButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ActionButton)

local function ItemUi(scope, props : {

})
    local character = game.Players.LocalPlayer.Character

    local tool = scope:Value(nil)
    local function update()
        print(character:FindFirstChildOfClass("Tool"))
        tool:set(character:FindFirstChildOfClass("Tool"))
    end

    local setupConnections = function()
        character.ChildAdded:Connect(update)
        character.ChildRemoved:Connect(update)
    end

    Players.LocalPlayer.CharacterAdded:Connect(function(char)
        character = char
        update()
        setupConnections()

    end)

    if character then
        update()
        setupConnections()
    end

    return scope:New("ScreenGui")({
        Name = "ItemUI",
        IgnoreGuiInset = true,
        ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        [Children] = {
            ActionButton(scope, {
                Visible = scope:Computed(function(use)
                    return use(tool) ~= nil
                end),
                Position = UDim2.new(0.85, 0, 0.85, 0),
                Size = UDim2.new(0.1, 0, 0.1, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(54, 255, 14),
                ButtonText = "Drop Q",
                KeyCode = Enum.KeyCode.Q,
                Image = Icons.Drop,
                ImageSize = UDim2.new(1, 0, 1, 0),
                ButtonUp = function()
                    Knit.GetService("ItemService"):DropItem(Fusion.peek(tool), Fusion.peek(tool).Name)
                end,
            })
        }
    })

end


return ItemUi