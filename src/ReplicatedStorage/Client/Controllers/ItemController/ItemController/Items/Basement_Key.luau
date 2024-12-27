local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local ItemBase = require(script.Parent.Parent.ItemBaseClient)
local Basement_KeyClient = {}

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children

local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local ActionButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ActionButton)


Basement_KeyClient.__index = Basement_KeyClient
setmetatable(Basement_KeyClient, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type Basement_KeyClient = {
    TestProperty2: string,
} & typeof(setmetatable({}, Basement_KeyClient)) & typeof(ItemBase.new())
export type NexusInstanceBasement_KeyClient = NexusInstance.NexusInstance<Basement_KeyClient>

function Basement_KeyClient.__new(self: NexusInstanceBasement_KeyClient, itemName: string, tool: Tool, cashedVisual : Model?)
    print("Basement_KeyClient")
    ItemBase.__new(self, itemName, tool, cashedVisual) --Remember to call the parent constructor!

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

   -- self.Server:DropItem()

end



return NexusInstance.ToInstance(Basement_KeyClient) :: NexusInstance.NexusInstanceClass<typeof(Basement_KeyClient), (Input1: string, Input2: string) -> (NexusInstanceBasement_KeyClient)>