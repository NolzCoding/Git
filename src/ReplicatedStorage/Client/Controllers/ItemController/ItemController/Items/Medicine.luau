local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local ItemBase = require(script.Parent.Parent.ItemBaseClient)
local MedicineClient = {}

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children

local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local ActionButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ActionButton)


MedicineClient.__index = MedicineClient
setmetatable(MedicineClient, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type MedicineClient = {
    TestProperty2: string,
} & typeof(setmetatable({}, MedicineClient)) & typeof(ItemBase.new())
export type NexusInstanceMedicineClient = NexusInstance.NexusInstance<MedicineClient>

function MedicineClient.__new(self: NexusInstanceMedicineClient, itemName: string, tool: Tool, cashedVisual : Model?)
    print("MedicineClient")

    self.ItemDescription = {
        Name = "Medicine",
        Description = "Heals the baby",
        Effects = {
            Lungs = 30,
            Heart = 30,
            Stomach = 30,
        }
    }

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



return NexusInstance.ToInstance(MedicineClient) :: NexusInstance.NexusInstanceClass<typeof(MedicineClient), (Input1: string, Input2: string) -> (NexusInstanceMedicineClient)>