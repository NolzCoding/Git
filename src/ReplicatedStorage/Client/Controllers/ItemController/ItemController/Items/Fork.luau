local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local ItemBase = require(script.Parent.Parent.ItemBaseClient)
local ForkClient = {}

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children

local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local ActionButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ActionButton)


ForkClient.__index = ForkClient
setmetatable(ForkClient, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type ForkClient = {
    TestProperty2: string,
} & typeof(setmetatable({}, ForkClient)) & typeof(ItemBase.new())
export type NexusInstanceForkClient = NexusInstance.NexusInstance<ForkClient>

function ForkClient.__new(self: NexusInstanceForkClient, itemName: string, tool: Tool, cashedVisual : Model?)
    print("ForkClient")

    self.BuildUI = function(scope)
        --[[return ActionButton(scope, {
            Position = UDim2.new(0.8, 0, 0.85, 0),
            Size = UDim2.new(0.1, 0, 0.1, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 14, 14),
            ButtonText = "Eat E",
            KeyCode = Enum.KeyCode.E,
            Image = Icons.Drop,
            ImageSize = UDim2.new(0.5, 0, 0.5, 0),
            ButtonUp = function()
                self.Server:EatItem()
            end,
        })]]
    end

    self.ItemDescription = {
        Name = "Fork",
        Description = "When put into an outlet damages the babies heart",
        Effects = {
            Lungs = 0,
            Heart = 50,
            Stomach = 0,
        }
    }

    ItemBase.__new(self, itemName, tool, cashedVisual) --Remember to call the parent constructor!

   -- self.Server:DropItem()

end



return NexusInstance.ToInstance(ForkClient) :: NexusInstance.NexusInstanceClass<typeof(ForkClient), (Input1: string, Input2: string) -> (NexusInstanceForkClient)>