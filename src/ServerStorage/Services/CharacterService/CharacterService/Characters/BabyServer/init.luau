--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharacterServerBase = require(script.Parent.Parent.CharacterBaseServer)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local Overhead = require(script.Overhead)
--Define TestClass1 (potentially in a ModuleScript).
local ragDollModule = require(game.ServerStorage.Source.Utils.Ragdoll)
local sounds = require(ReplicatedStorage.Source.Shared.Sounds)

--Define TestClass2 (potentially in a different ModuleScript).
local BabyServer = {}
BabyServer.__index = BabyServer
setmetatable(BabyServer, CharacterServerBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type BabyServer = {
    scope : any,

    MakePrompt : boolean,
    HasOverhead : boolean,

    Abilities : {
        [string] : () -> (),
    },
    SetupAbilities : () -> (),
    PickedUp: (byPlayerClass : CharacterServerBase.CharacterBaseServer) -> (),
    Released: (byPlayerClass : CharacterServerBase.CharacterBaseServer) -> (),
    BabyDied: () -> (),
    HealAttributes: (attributes : {Lungs: number?, Stomach: number?, Heart: number? }) -> (),
    DamageAttributes: (attributes :  {Lungs: number?, Stomach: number?, Heart: number? }) -> (),
    --SetupCharacter: (character : Model) -> (),
} & typeof(setmetatable({}, BabyServer)) & CharacterServerBase.CharacterBaseServer
export type NexusInstanceBabyServer = NexusInstance.NexusInstance<BabyServer>


function BabyServer.BabyDamaged(self: NexusInstanceBabyServer) : ()

    local randomBabySound = sounds.Baby.CryNoises[math.random(1, #sounds.Baby.CryNoises)]

    local sound = Instance.new("Sound")
    sound.SoundId = randomBabySound
    sound.Parent = self.Player.Character:WaitForChild("Head") :: BasePart
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)

end

function BabyServer.SetupCharacter(self: NexusInstanceBabyServer, character : Model): ()
    -- do setup for the character

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
    humanoidDescription.DepthScale = 0.6
    humanoidDescription.HeightScale = 0.6
    humanoidDescription.WidthScale = 0.6
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
            print("Attribute Changed" .. name)
            self:BabyDamaged()

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

    if self.MakePrompt then
        root:SetAttribute("Text", "Pick up")
        root:SetAttribute("MaxDistance", 5)
        root:AddTag("Baby")
        root:AddTag("PromptService")

    end

    local holded = self:AddTrackFromId("rbxassetid://104303879907283", "Holded", Enum.AnimationPriority.Action4)
    holded.Looped = true

    self.scope = Fusion.scoped(Fusion)

    if self.HasOverhead then
        Overhead(self.scope, {
            Player = self.Player,
            Parent = character:WaitForChild("Head") :: BasePart,
        })

    end


    humanoid.Touched:Connect(function(a0: BasePart, a1: BasePart)
        -- check velocity
        local root = character:WaitForChild("HumanoidRootPart") :: Part
        local velocity = root.AssemblyLinearVelocity
        if velocity.Magnitude > 70 then
            ragDollModule:RagDollCharacter(character, self.Player)
            task.delay(5, function()
                ragDollModule:UnRagDollCharacter(character, self.Player)
            end)
        end
    end)

    local RightHand = character:WaitForChild("RightHand") :: BasePart
    local RightUpperArm = character:WaitForChild("RightUpperArm") :: BasePart

    self:NewIKControl("RightArm", RightHand, RightUpperArm)


end

function BabyServer.SetupEffects(self: NexusInstanceBabyServer): ()
    self.EffectHandlers["Slippery"] = function(duration : number, multiplier : number)
        multiplier = multiplier or 1
        local character = self.Player.Character :: Model
        local startTime = tick()
        local endTime = startTime + duration

        type props = {
            Parent : Instance?,
            Position : Vector3?,
            Particle : Instance,
            Duration : number?,
            EmitAmount : number?,
        }

        self.ParticleService:PlayParticle( {
            Parent = (character :: any).HumanoidRootPart,
            Position = nil, -- empty position = center of the parent
            Duration = duration,
            EmitAmount = 0,
            Particle = ReplicatedStorage.Source.Data.Particles.Bubbles,
        } :: props)


        while tick() < endTime do
            task.wait(1)
        end

    end

    self.EffectHandlers["Gasoline"] = function(duration : number, multiplier : number)
        multiplier = multiplier or 1
        local character = self.Player.Character :: Model
        local startTime = tick()
        local endTime = startTime + duration

        type props = {
            Parent : Instance?,
            Position : Vector3?,
            Particle : Instance,
            Duration : number?,
            EmitAmount : number?,
        }

        self.ParticleService:PlayParticle( {
            Parent = (character :: any).HumanoidRootPart,
            Position = nil, -- empty position = center of the parent
            Duration = duration,
            EmitAmount = 0,
            Particle = ReplicatedStorage.Source.Data.Particles.Smoke,
        } :: props)


        while tick() < endTime do
            task.wait(1)
        end

    end

    self.EffectHandlers["Burn"] = function(duration : number, multiplier : number)
        multiplier = multiplier or 1

        print(multiplier)

        local startTime = tick()
        local endTime = startTime + duration

        local character = self.Player.Character :: Model

        type props = {
            Parent : Instance?,
            Position : Vector3?,
            Particle : Instance,
            Duration : number?,
            EmitAmount : number?,
        }

        self.ParticleService:PlayParticle( {
            Parent = (character :: any).HumanoidRootPart,
            Position = nil, -- empty position = center of the parent
            Duration = duration,
            EmitAmount = 0,
            Particle = ReplicatedStorage.Source.Data.Particles.Flames,
        } :: props)


        while tick() < endTime do
            print("Damaging baby")
            self:DamageAttributes({
                Lungs = multiplier,
                Stomach = multiplier,
                Heart = multiplier,
            })

            task.wait(1)
        end

    end

    self.EffectHandlers["Drowning"] = function(duration : number, multiplier : number)
        multiplier = multiplier or 1
        local character = self.Player.Character :: Model
        local startTime = tick()
        local endTime = startTime + duration

        type props = {
            Parent : Instance?,
            Position : Vector3?,
            Particle : Instance,
            Duration : number?,
            EmitAmount : number?,
        }

        self.ParticleService:PlayParticle({
            Parent = (character :: any).HumanoidRootPart,
            Position = nil, -- empty position = center of the parent
            Duration = duration,
            EmitAmount = 0,
            Particle = ReplicatedStorage.Source.Data.Particles.Bubbles,
        } :: props)

        while tick() < endTime do
            self:DamageAttributes({
                Lungs = multiplier,
            })

            task.wait(1)
        end

    end

end

function BabyServer.SetupAbilities(self : NexusInstanceBabyServer): ()

    self.Abilities["Invisibility"] = function()

        local character = self.Player.Character :: Model

        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") or part:IsA("Decal") then

                if not part:GetAttribute("Transparency") then
                    part:SetAttribute("Transparency", part.Transparency)
                end
                (part :: Part).Transparency = 1
            end
        end

        task.delay(15, function()
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    (part :: Part).Transparency = (part :: Part):GetAttribute("Transparency") :: number
                end
            end
        end)

    end

    self.Abilities["Jump"] = function()
        --[[local character = game.Players.LocalPlayer.Character
        local humanoid = character:FindFirstChild("Humanoid") :: Humanoid

        local root = character:FindFirstChild("HumanoidRootPart") :: Part

        humanoid:ChangeState(Enum.HumanoidStateType.Flying)

        local newVelocity = root.CFrame.LookVector * 50 + Vector3.new(0, 50, 0)

        root.AssemblyLinearVelocity += newVelocity]]

    end

    self.Abilities["Speed"] = function()

        local character = game.Players.LocalPlayer.Character
        local humanoid = character:FindFirstChild("Humanoid") :: Humanoid

        humanoid.WalkSpeed = 50

        task.delay(5, function()
            humanoid.WalkSpeed = 20
        end)

    end

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

function BabyServer.HealAttributes(self : NexusInstanceBabyServer, attributes : {string : number}): ()

    local humanoid = (self :: any).Player.Character:WaitForChild("Humanoid") :: Humanoid

    for name, v in pairs(attributes) do
        local current = humanoid:GetAttribute(name) :: number
        humanoid:SetAttribute(name, math.clamp(current + v, 0, 100))
    end

end


type HealthAttributes = { Lungs: number, Stomach: number, Heart: number }
type PartialHealthAttributes = { Lungs: number?, Stomach: number?, Heart: number? }

function BabyServer.DamageAttributes(self : NexusInstanceBabyServer, attributes: PartialHealthAttributes): ()
    local humanoid = (self :: any).Player.Character:WaitForChild("Humanoid") :: Humanoid

    local totalDamage = 0

    for name, v in pairs(attributes) do
        local current = humanoid:GetAttribute(name) :: number
        totalDamage += v
        humanoid:SetAttribute(name, math.clamp(current - v, 0, 100))
    end

    self.AchievementService:PerformedAction(self.Player, "Damage", totalDamage)

end

function BabyServer.Released(self : NexusInstanceBabyServer, byPlayerClass : CharacterServerBase.CharacterBaseServer): ()


    local humanoid = (self :: any).Player.Character:WaitForChild("Humanoid") :: Humanoid
    humanoid:ChangeState(Enum.HumanoidStateType.Freefall)


    local animationTrack = self.AnimationTracks["Holded"]
    animationTrack:Stop()
end

function BabyServer.__new(self: NexusInstanceBabyServer, player : Player, character : Model, makePrompt : boolean, hasOverhead : boolean): ()
    CharacterServerBase.__new(self, player, character) --Remember to call the parent constructor!

    self.MakePrompt = makePrompt
    self.HasOverhead = hasOverhead

    if self.MakePrompt == nil then
        self.MakePrompt = true
    end

    if self.HasOverhead == nil then
        self.HasOverhead = true
    end

    self.Abilities = {}
    self:SetupCharacter(character)
    self:SetupEffects()
    self:SetupAbilities()
    print("BabyServer")

end

function BabyServer.Destroy(self: NexusInstanceBabyServer): ()
    self.scope:doCleanup()
    CharacterServerBase.Destroy(self)

end


function BabyServer.Client.UseAbility(self: NexusInstanceBabyServer,player, abilityName): ()
    print("Ability Used server", abilityName)

    local ability = self.Abilities[abilityName]
    if not ability then
        warn("Ability not found ", abilityName)
        return
    end

    local data = self.DataService:GetData(self.Player)
    local amount = data.Abilities.OwnedAbilities[abilityName] or 0
    if amount <= 0 then
        return
    end

    data.Abilities.OwnedAbilities[abilityName] = amount - 1

    self.DataService:SetData(self.Player, "Abilities", data.Abilities)

    ability()

end

return NexusInstance.ToInstance(BabyServer) :: NexusInstance.NexusInstanceClass<typeof(BabyServer), (player : Player, character : Model) -> (NexusInstanceBabyServer)>