local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local Knit = require(ReplicatedStorage.Packages.Knit)
local CharacterClientBase = require(script.Parent.Parent.CharacterClient)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
--Define TestClass1 (potentially in a ModuleScript).
local ActionButton = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Buttons.ActionButton)
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
--Define TestClass2 (potentially in a different ModuleScript).
local ParentClient = {}
ParentClient.__index = ParentClient
setmetatable(ParentClient, CharacterClientBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type ParentClient = {
    ThrowBabyVisible : boolean,
} & typeof(setmetatable({}, ParentClient)) & CharacterClientBase.CharacterClient
export type NexusInstanceParentClient = NexusInstance.NexusInstance<ParentClient>

function ParentClient.__new(self: NexusInstanceParentClient, character : Model?): ()


    local function throwBaby ()

        self.Server:ThrowBaby()

        if self.PickedUp then
            self.PickedUp.WeldConstraint:Destroy()

            local playerToThrow = self.PickedUp.Player :: Player
            local toThrowRoot = playerToThrow.Character:WaitForChild("HumanoidRootPart") :: Part
            local toThrowHumanoid = playerToThrow.Character:WaitForChild("Humanoid") :: Humanoid

            local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") :: Part
            toThrowHumanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
            toThrowHumanoid.PlatformStand = true
            toThrowRoot.AssemblyLinearVelocity = root.CFrame.LookVector * 500
        end

    end



    self.BuildUI = function(scope)
        self.ThrowBabyVisible = scope:Value(false)

        return scope: New "ScreenGui" {
            Name = "ParentUI",
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            [Children] = {
                ActionButton(scope, {
                    Visible = self.ThrowBabyVisible :: any,
                    BackgroundColor3 = Color3.fromRGB(255, 14, 14),
                    ButtonText = "Throw baby (R)",
                    Image = Icons.StrongArm,
                    ImageSize = UDim2.new(0.8, 0, 0.8, 0),
                    Size = UDim2.new(0.1, 0, 0.1, 0),
                    Position = UDim2.new(0.5, 0, 0.8, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ButtonUp = function()
                        throwBaby()
                    end,
                    ButtonDown = function()
                    end,
                })
            },
        }
    end

    CharacterClientBase.__new(self, character :: Model,5) --Remember to call the parent constructor!

    -- enable baby proximity prompts

    self.NotificationController = Knit.GetController("NotificationController")

    local babyPrompts = CollectionService:GetTagged("Baby")

    for _, promptParent in ipairs(babyPrompts) do
        local prompt = promptParent:FindFirstChild("ProximityPrompt") :: ProximityPrompt

        prompt.Enabled = true

    end

    table.insert(self.Connections, UserInputService.InputBegan:Connect(function(a0: InputObject, a1: boolean)

        if a0.KeyCode == Enum.KeyCode.R then
            throwBaby()
        end

    end))

end

function ParentClient.ServerSignal.onPlayerPickup(self : NexusInstanceParentClient, player : Player, weld)
    self.PickedUp = {
        Player = player,
        WeldConstraint = weld,
    }
    self.ThrowBabyVisible:set(true)
    self.Weld = weld

    if player:HasTag("NoBabyBed") then
        self.NotificationController:TextNImage({
            Text = "You can't but the baby in the bed yet",
            Image = "rbxassetid://7711634021",
            Time = 2,
            Color = Color3.fromRGB(255, 255, 255)
        })
        return
    end

    --find proximiy prompt

    local babyPrompt = player.Character.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt") :: ProximityPrompt
    babyPrompt.Enabled = false

    local babyBed = CollectionService:GetTagged("BabyBed")

    for _, bed in ipairs(babyBed) do
        local highlight = bed:FindFirstChildOfClass("Highlight") :: Highlight

        highlight.Enabled = true

    end

end

function ParentClient.ServerSignal.onPlayerDrop(self : NexusInstanceParentClient)
    self.ThrowBabyVisible:set(false)

    if not self.PickedUp then return end

    local player = self.PickedUp.Player :: Player
    self.PickedUp = nil

    local babyPrompt = player.Character.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt") :: ProximityPrompt
    babyPrompt.Enabled = true

    local babyBed = CollectionService:GetTagged("BabyBed")

    for _, bed in ipairs(babyBed) do
        local highlight = bed:FindFirstChildOfClass("Highlight") :: Highlight

        highlight.Enabled = false

    end

end

return NexusInstance.ToInstance(ParentClient) :: NexusInstance.NexusInstanceClass<typeof(ParentClient), (Input1: string, Input2: string) -> (NexusInstanceParentClient)>