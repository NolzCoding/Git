local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local ItemBase = require(script.Parent.Parent.ItemBaseClient)
local KnifeClient = {}

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children

local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local ActionButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ActionButton)

local ANIMATION_ID = "rbxassetid://77416752017851"

KnifeClient.__index = KnifeClient
setmetatable(KnifeClient, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type KnifeClient = {
    TestProperty2: string,
} & typeof(setmetatable({}, KnifeClient)) & typeof(ItemBase.new())
export type NexusInstanceKnifeClient = NexusInstance.NexusInstance<KnifeClient>

function KnifeClient.__new(self: NexusInstanceKnifeClient, itemName: string, tool: Tool, cashedVisual : Model?)
    print("KnifeClient")

    self.Animation = Instance.new("Animation")
    self.Parent = self.Tool
    self.Animation.AnimationId = ANIMATION_ID

    local Animator = game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):WaitForChild("Animator") :: Animator

    self.AnimationTrack = Animator:LoadAnimation(self.Animation)
    self.AnimationTrack.Priority = Enum.AnimationPriority.Action4

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

    self.Connections = {}

    local debounce = false

    table.insert(self.Connections, self.Tool.Activated:Connect(function()
        if debounce then return end
        self.AnimationTrack:Play()
        self.Server:Attack()

        debounce = true

        task.wait(0.5)

        debounce = false

    end))

   -- self.Server:DropItem()

   ItemBase.__new(self, itemName, tool, cashedVisual) --Remember to call the parent constructor!


end

function KnifeClient.Destroy(self : NexusInstanceKnifeClient)
    self.Animation:Destroy()
    self.AnimationTrack:Destroy()
    -- call the base class destroy method
    ItemBase.Destroy(self)
end


return NexusInstance.ToInstance(KnifeClient) :: NexusInstance.NexusInstanceClass<typeof(KnifeClient), (Input1: string, Input2: string) -> (NexusInstanceKnifeClient)>