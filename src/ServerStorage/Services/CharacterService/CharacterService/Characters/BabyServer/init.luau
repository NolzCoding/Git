--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local Overhead = require(script.Overhead)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local CharacterServerBase = require(script.Parent.Parent.CharacterBaseServer)
--Define TestClass1 (potentially in a ModuleScript).

local ragDollModule = require(game.ServerStorage.Source.Utils.Ragdoll)

--Define TestClass2 (potentially in a different ModuleScript).
local BabyServer = {}
BabyServer.__index = BabyServer
setmetatable(BabyServer, CharacterServerBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type BabyServer = {
    scope : any,
    PickedUp: (byPlayerClass : CharacterServerBase.CharacterBaseServer) -> (),
    Released: (byPlayerClass : CharacterServerBase.CharacterBaseServer) -> (),
    BabyDied: () -> (),
    --SetupCharacter: (character : Model) -> (),
} & typeof(setmetatable({}, BabyServer)) & CharacterServerBase.CharacterBaseServer
export type NexusInstanceBabyServer = NexusInstance.NexusInstance<BabyServer>

function BabyServer.SetupCharacter(self: NexusInstanceBabyServer, character : Model): ()
    -- do setup for the character
    character:SetAttribute("Character", "Baby")

    local animateScript = character:WaitForChild("Animate") :: LocalScript
    if animateScript then
        animateScript:Destroy()
    end
    game.ServerStorage.Animate:Clone().Parent = character

    local data = self.DataService:GetData(self.Player) :: table
    local skin = data.Skins.Baby.CurrentSkin

    local skinModel = ReplicatedStorage.Data.Skins:FindFirstChild(skin)
    self:NewMorph(skinModel)

    local humanoid = character:WaitForChild("Humanoid") :: Humanoid
    local Animate  = character:WaitForChild("Animate") :: LocalScript
    (Animate :: any).ScaleDampeningPercent.Value = 0
    local walkAnim  = Animate:WaitForChild("walk"):WaitForChild("WalkAnim") :: Animation
   -- walkAnim.AnimationId = "rbxassetid://72078940860167"
    walkAnim.AnimationId = "rbxassetid://95408738525359"

    local runAnim = Animate:WaitForChild("run"):WaitForChild("RunAnim") :: Animation
    --runAnim.AnimationId = "rbxassetid://72078940860167"
    runAnim.AnimationId = "rbxassetid://95408738525359"

    local idleAnim = Animate:WaitForChild("idle"):WaitForChild("Animation1") :: Animation
    --idleAnim.AnimationId = "rbxassetid://75538111880467"
    idleAnim.AnimationId = "rbxassetid://138996154048751"


    local humanoidDescription = humanoid:WaitForChild("HumanoidDescription") :: HumanoidDescription
    humanoidDescription.HeadScale = 1
    humanoidDescription.DepthScale = 1
    humanoidDescription.HeightScale = 0.75
    humanoidDescription.WidthScale = 1
    humanoidDescription.BodyTypeScale = 1
    task.wait()

    humanoid:ApplyDescription(humanoidDescription)


    humanoid.HipHeight = 2.2

    local lowerTorso = character:WaitForChild("LowerTorso") :: BasePart
    local upperTorso = character:WaitForChild("UpperTorso")  :: BasePart

    upperTorso.CollisionGroup = "NoCollide"
    lowerTorso.CollisionGroup = "NoCollide"

    humanoid.HipHeight = 1

    humanoid.JumpHeight = 3

    -- Brain lungs heart, three attributes that will be used to determine the health of the baby

    local healthAttributes = {
        Lungs = 100,
        Stomach = 100,
        Heart = 100,
    }

    --humanoid:SetAttribute("Lungs", 100) -- less sprinting
    --humanoid:SetAttribute("Stomach", 100) -- blurry vision
    --humanoid:SetAttribute("Heart", 100) -- slower movement

    for name, v in pairs(healthAttributes) do
        humanoid:SetAttribute(name, v)

        humanoid:GetAttributeChangedSignal(name):Connect(function() -- check if playerISDead
            local totalheatlh = 0
            for name, v in pairs(healthAttributes) do
                totalheatlh += humanoid:GetAttribute(name) :: number
                if totalheatlh <= 0 then
                    self:BabyDied()
                end
            end
        end)

    end

    local root = character:WaitForChild("HumanoidRootPart") :: Part

    root:AddTag("Baby")
    root:AddTag("PromptService")

    local holded = self:AddTrackFromId("rbxassetid://104303879907283", "Holded", Enum.AnimationPriority.Action4)
    holded.Looped = true

    self.scope = Fusion.scoped(Fusion)

    Overhead(self.scope, {
        Player = self.Player,
        Parent = character:WaitForChild("Head") :: BasePart,
    })


    humanoid.Touched:Connect(function(a0: BasePart, a1: BasePart)
        -- check velocity
        local root = character:WaitForChild("HumanoidRootPart") :: Part
        local velocity = root.AssemblyLinearVelocity
        print(velocity.Magnitude)
        if velocity.Magnitude > 70 then
            ragDollModule:RagDollCharacter(character, self.Player)
            task.delay(5, function()
                ragDollModule:UnRagDollCharacter(character, self.Player)
            end)
        end
    end)

end

function BabyServer.PickedUp(self : NexusInstanceBabyServer, byPlayerClass : CharacterServerBase.CharacterBaseServer): ()

    local humanoid = self.Player.Character:WaitForChild("Humanoid") :: Humanoid
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)

    local animationTrack = self.AnimationTracks["Holded"]
    animationTrack:Play()
end

function BabyServer.BabyDied(self : NexusInstanceBabyServer): ()
    -- do smth when baby dies
    print("Dead")
end

function BabyServer.Released(self : NexusInstanceBabyServer, byPlayerClass : CharacterServerBase.CharacterBaseServer): ()


    local humanoid = (self :: any).Player.Character:WaitForChild("Humanoid") :: Humanoid
    humanoid:ChangeState(Enum.HumanoidStateType.Freefall)


    local animationTrack = self.AnimationTracks["Holded"]
    animationTrack:Stop()
end

function BabyServer.__new(self: NexusInstanceBabyServer, player : Player, character : Model): ()
    CharacterServerBase.__new(self, player, character) --Remember to call the parent constructor!
    self:SetupCharacter(character)
    print("BabyServer")

end

function BabyServer.Destroy(self: NexusInstanceBabyServer): ()
    self.scope:doCleanup()
    CharacterServerBase.Destroy(self)

end

return NexusInstance.ToInstance(BabyServer) :: NexusInstance.NexusInstanceClass<typeof(BabyServer), (player : Player, character : Model) -> (NexusInstanceBabyServer)>