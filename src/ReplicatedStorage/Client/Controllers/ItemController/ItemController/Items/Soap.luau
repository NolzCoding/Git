local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ItemBase = require(script.Parent.Parent.ItemBaseClient)
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local SoapClient = {}
local UserInputService = game:GetService("UserInputService")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children

local ActionButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ActionButton)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)


SoapClient.__index = SoapClient
setmetatable(SoapClient, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type SoapClient = {
    TestProperty2: string,
} & typeof(setmetatable({}, SoapClient)) & typeof(ItemBase.new())
export type NexusInstanceSoapClient = NexusInstance.NexusInstance<SoapClient>

function SoapClient.__new(self: NexusInstanceSoapClient, itemName: string, tool: Tool, cashedVisual : Model?)
    print("SoapClient")


    local character = Players.LocalPlayer.Character

    local isBaby = character:GetAttribute("Character") == "Baby"


    self.OnEquipped = function()

        if not isBaby then

            return

        end

        return {UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.F then
                self.Server:Use()
            end
        end)}
    end


    if isBaby then
        self.BuildUI = function(scope)
            return ActionButton(scope, {
                Position = UDim2.new(0.8, 0, 0.85, 0),
                Size = UDim2.new(0.1, 0, 0.1, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 14, 14),
                ButtonText = "Bathe in Soap F",
                KeyCode = Enum.KeyCode.F,
                ScaleType = Enum.ScaleType.Fit,
                Image = Icons.ItemActions.Bubbles,
                ImageSize = UDim2.new(0.8, 0, 0.8, 0),
                ButtonUp = function()
                    self.Server:Use()
                end,
            })
        end

    end

    self.ItemDescription = {
        Name = "Soap",
        Description = "Makes baby slippery and can't be picked up",
        Effects = {
            Lungs = 0,
            Heart = 0,
            Stomach = 0,
        }
    }

    ItemBase.__new(self, itemName, tool, cashedVisual) --Remember to call the parent constructor!


   -- self.Server:DropItem()

end



return NexusInstance.ToInstance(SoapClient) :: NexusInstance.NexusInstanceClass<typeof(SoapClient), (Input1: string, Input2: string) -> (NexusInstanceSoapClient)>