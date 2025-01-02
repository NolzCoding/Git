local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemBase = require(script.Parent.Parent.ItemBaseClient)
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local GlueClient = {}

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children

local ActionButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ActionButton)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)


GlueClient.__index = GlueClient
setmetatable(GlueClient, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type GlueClient = {
    TestProperty2: string,
} & typeof(setmetatable({}, GlueClient)) & typeof(ItemBase.new())
export type NexusInstanceGlueClient = NexusInstance.NexusInstance<GlueClient>

function GlueClient.__new(self: NexusInstanceGlueClient, itemName: string, tool: Tool, cashedVisual : Model?)
    print("GlueClient")
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



return NexusInstance.ToInstance(GlueClient) :: NexusInstance.NexusInstanceClass<typeof(GlueClient), (Input1: string, Input2: string) -> (NexusInstanceGlueClient)>