local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local ItemBase = require(script.Parent.Parent.ItemBaseClient)
local TaserClient = {}
local UserInputService = game:GetService("UserInputService")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local Debris = game:GetService("Debris")
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local ActionButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ActionButton)


TaserClient.__index = TaserClient
setmetatable(TaserClient, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type TaserClient = {
    TestProperty2: string,
} & typeof(setmetatable({}, TaserClient)) & typeof(ItemBase.new())
export type NexusInstanceTaserClient = NexusInstance.NexusInstance<TaserClient>




function TaserClient.__new(self: NexusInstanceTaserClient, itemName: string, tool: Tool, cashedVisual : Model?)
    print("TaserClient")

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


    local debounce = false

    local inputBegan = function(input : InputObject)
        if debounce then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local Params = RaycastParams.new()
            Params.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, self.Tool}
            Params.FilterType = Enum.RaycastFilterType.Exclude
            local ray = workspace.CurrentCamera:ScreenPointToRay(input.Position.X, input.Position.Y)
            local result = workspace:Raycast(ray.Origin, ray.Direction * 40, Params)

            local hitPos = nil

            if result and result.Instance then
                self.Server.Shoot( result.Instance, result.Position)
                hitPos = result.Position
            else
                self.Server.Shoot( nil, ray.Direction * 40 + ray.Origin) --
                hitPos = ray.Direction * 40 + ray.Origin
            end

            -- spawn part between tool and hitPos

            local barrel = self.Tool:FindFirstChild("Barrel", true) :: Attachment

            local part = Instance.new("Part")
            part.Size = Vector3.new(0.1, 0.1, (self.Tool.Handle.Position - hitPos).Magnitude)
            part.Anchored = true
            part.CanCollide = false
            part.Parent = workspace
            part.CFrame = CFrame.new(barrel.WorldCFrame.Position, hitPos) * CFrame.new(0, 0, -part.Size.Z / 2)
            part.Transparency = 0.5
            part.Color = Color3.fromRGB(138, 255, 249)
            part.Material = Enum.Material.Neon

            Debris:AddItem(part, 0.25)

            debounce = true

            task.wait(0.5)

            debounce = false

        end
    end

    local connection = nil

    tool.Equipped:Connect(function(a0: Mouse)

        connection = UserInputService.InputBegan:Connect(inputBegan)

    end)

    tool.Unequipped:Connect(function()
        connection:Disconnect()
    end)

   -- self.Server:DropItem()
   ItemBase.__new(self, itemName, tool, cashedVisual) --Remember to call the parent constructor!

end



return NexusInstance.ToInstance(TaserClient) :: NexusInstance.NexusInstanceClass<typeof(TaserClient), (Input1: string, Input2: string) -> (NexusInstanceTaserClient)>