local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)

local ItemBase = require(script.Parent.Parent.ItemBaseClient)
local BatteryClient = {}
local UserInputService = game:GetService("UserInputService")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children

local ActionButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ActionButton)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)


BatteryClient.__index = BatteryClient
setmetatable(BatteryClient, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type BatteryClient = {
    TestProperty2: string,
} & typeof(setmetatable({}, BatteryClient)) & typeof(ItemBase.new())
export type NexusInstanceBatteryClient = NexusInstance.NexusInstance<BatteryClient>

function BatteryClient.__new(self: NexusInstanceBatteryClient, itemName: string, tool: Tool, cashedVisual : Model?)
    print("BatteryClient")


    local character = Players.LocalPlayer.Character

    local isBaby = character:GetAttribute("Character") == "Baby"
    print("isBaby BATTERY", isBaby)
    if isBaby then
        self.BuildUI = function(scope)
            return ActionButton(scope, {
                Position = UDim2.new(0.8, 0, 0.85, 0),
                Size = UDim2.new(0.1, 0, 0.1, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 14, 14),
                ButtonText = "Eat F",
                KeyCode = Enum.KeyCode.F,
                Image = Icons.ItemActions.Eat,
                ScaleType = Enum.ScaleType.Fit,

                ImageSize = UDim2.new(0.8, 0, 0.8, 0),
                ButtonUp = function()
                    print("clicking gui BATTERY", isBaby)

                    self.Server:Use()
                end,
            })
        end

    end

    self.OnEquipped = function()
        return {UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.F then
                print("CLICKING E BATTERY", isBaby)

                self.Server:Use()
            end
        end)}
    end

    self.ItemDescription = {
        Name = "Battery",
        Description = "Hurts babies stomach when eaten",
        Effects = {
            Lungs = 0,
            Heart = 0,
            Stomach = 25,
        }
    }

    ItemBase.__new(self, itemName, tool, cashedVisual) --Remember to call the parent constructor!
   -- self.Server:DropItem()

end



return NexusInstance.ToInstance(BatteryClient) :: NexusInstance.NexusInstanceClass<typeof(BatteryClient), (Input1: string, Input2: string) -> (NexusInstanceBatteryClient)>