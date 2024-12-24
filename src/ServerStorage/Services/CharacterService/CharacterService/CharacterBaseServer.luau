--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)


local CharacterBaseServer = {}
CharacterBaseServer.__index = CharacterBaseServer
CharacterBaseServer.Client = {}


export type CharacterBaseServer = {
    Remote: RemoteFunction,
    ClientSignal: {
        [string] : (... any) -> (),
    },
    RemoteEvent: RemoteEvent,
    AddTrackFromId: (self: NexusInstanceCharacterBaseServer, id: string, name : string) -> (AnimationTrack),
    AnimationTracks : {
        [string] : AnimationTrack,
    },
    IKControls : {
        [string] : IKControl,
    },
    ItemSlots : number,
    Player : Player,
    EffectHandlers : {
        [string] : (duration : number, multiplier : number) -> (),
    },
    ActiveEffects : {
        [string] : number,
    },
    Died : NexusInstance.TypedEvent<>,
    ragdollModule : typeof(require(game.ServerStorage.Source.Utils.Ragdoll)),
    ParticleService : typeof(Knit.GetService("ParticleService")),
    DataService : typeof(Knit.GetService("DataService")),
    Server: {

    },
} & typeof(setmetatable({}, CharacterBaseServer))
export type NexusInstanceCharacterBaseServer = NexusInstance.NexusInstance<CharacterBaseServer>

function CharacterBaseServer.__new(self: NexusInstanceCharacterBaseServer, player : Player, character : Model): ()

    self.Player = player
    character.Destroying:Connect(function()
        self:Destroy()
    end)

    self.Remote = Instance.new("RemoteFunction")
    self.Remote.Parent = character

    self.Died = self:CreateEvent()

    self.RemoteEvent = Instance.new("RemoteEvent")
    self.RemoteEvent.Parent = character

    print(print(self.Remote))

    self.Remote.OnServerInvoke = function(player, methodName, ...)
        local method = self.Client[methodName]
        if method then
            return method(self, player, ...)
        end
    end

    local clientSignalMetaTable = {
        __index = function(table, index)
            return function (...)
                self.RemoteEvent:FireClient(self.Player, index, ...)
                print("Sending... ",self.Player, index, ...)
            end
        end,
    }

    self.DataService = Knit.GetService("DataService")
    self.ClientSignal = setmetatable({}, clientSignalMetaTable)
    self.AnimationTracks = {}
    self.ItemSlots = self.ItemSlots or 2

    task.delay(1, function()

        self.ClientSignal.Test("Client Comm Test")

    end)

    self.IKControls = {}

    local RightHand = character:WaitForChild("RightHand") :: BasePart
    local RightUpperArm = character:WaitForChild("RightUpperArm") :: BasePart

    self:NewIKControl("RightArm", RightHand, RightUpperArm)

    self.EffectHandlers = {}
    self.ActiveEffects = {}

    self.ParticleService = Knit.GetService("ParticleService")

    self.EffectHandlers["Burn"] = function(duration : number, multiplier : number)
        multiplier = multiplier or 1
        local humanoid = character:WaitForChild("Humanoid") :: Humanoid
        local damagepersecond = 10
        local damage = damagepersecond * multiplier
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
            Parent = character.HumanoidRootPart,
            Position = nil, -- empty position = center of the parent
            Duration = duration,
            EmitAmount = 0,
            Particle = ReplicatedStorage.Source.Data.Particles.Flames,
        } :: props)


        while tick() < endTime do
            humanoid:TakeDamage(damage)
            task.wait(1)
        end

    end

    task.delay(10, function()
        self:ApplyEffect("Burn", 5, 1)
    end)
end

function CharacterBaseServer.GetIKControl(self: NexusInstanceCharacterBaseServer, name : string): (IKControl)
    return self.IKControls[name]
end

function CharacterBaseServer.BindPartToIKControl(self: NexusInstanceCharacterBaseServer, name : string, part : BasePart): ()
    local ikControl = self.IKControls[name]
    if not ikControl then
        warn("IKControl ", name, " not found")
        return
    end
    ikControl.Enabled = true
    ikControl.Weight = 1
    ikControl.Target = part
end

function CharacterBaseServer.UnBindPartFromIKControl(self: NexusInstanceCharacterBaseServer, name : string): ()
    local ikControl = self.IKControls[name]
    if not ikControl then
        warn("IKControl ", name, " not found")
        return
    end
    ikControl.Enabled = false
    ikControl.Weight = 0
    ikControl.Target = workspace.Baseplate

end

function CharacterBaseServer.PlayIKControl(self: NexusInstanceCharacterBaseServer, name : string, target : BasePart, time : number, delay : number): ()

    local ikControl = self.IKControls[name]
    if not ikControl then
        warn("IKControl ", name, " not found")
        return
    end
    if ikControl.Enabled then
        warn("IKControl ", name, " already playing")
        return
    end

    ikControl.Weight = 0 -- Start at 0
    ikControl.Enabled = true
    ikControl.Target = target

    local newTween = TweenService:Create(ikControl, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true, delay), {Weight = 1})
    newTween:Play()

    task.delay(time*2 + delay, function()
        ikControl.Enabled = false
    end)

end

function CharacterBaseServer.NewIKControl(self: NexusInstanceCharacterBaseServer, name : string, endEffector : BasePart, chainRoot : BasePart): ()

    local ikControl = Instance.new("IKControl")
    ikControl.Name = name
    ikControl.Parent = endEffector
    ikControl.ChainRoot = chainRoot
    ikControl.EndEffector = endEffector
    ikControl.SmoothTime = 0.2
    ikControl.Weight = 0
    ikControl.Enabled = false
    ikControl.Type = Enum.IKControlType.Position
    self.IKControls[name] = ikControl

    return ikControl

end

function CharacterBaseServer.AddTrackFromId(self: NexusInstanceCharacterBaseServer, id: string, name : string, priority : Enum.AnimationPriority): ()
    local animation = Instance.new("Animation")
    animation.AnimationId = id
    animation.Name = name
    self.AnimationTracks[name] = (self :: any).Player.Character.Humanoid.Animator:LoadAnimation(animation)
    self.AnimationTracks[name].Priority = priority or Enum.AnimationPriority.Action
    return self.AnimationTracks[name]
end

function CharacterBaseServer.Destroy(self: NexusInstanceCharacterBaseServer): ()

end

function CharacterBaseServer.GetItemCount(self: NexusInstanceCharacterBaseServer): (number)

    local backpack = self.Player:FindFirstChild("Backpack") :: Backpack
    local toolInCharacter = (self :: any).Player.Character:FindFirstChildOfClass("Tool")

    local count = #backpack:GetChildren()

    if toolInCharacter then
        count += 1
    end

    return count

end

function CharacterBaseServer.ApplyEffect(self: NexusInstanceCharacterBaseServer, effect : string, duration : number, multiplier : number?): ()

    multiplier = multiplier or 1
    local effectHandler = self.EffectHandlers[effect]

    if not effectHandler then
        warn("Effect ", effect, " not found")
        return
    end

    task.spawn(function()
        effectHandler(duration, multiplier :: number)
    end)

    self.ActiveEffects[effect] = multiplier :: number
    task.delay(duration, function()
        self.ActiveEffects[effect] = nil
    end)

    --self.RemoteEvent:FireClient(self.Player, "ApplyEffect", effect, duration)
end

function CharacterBaseServer.NewMorph(self: NexusInstanceCharacterBaseServer, model)
    local player = self.Player
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local morphHumanoid : Humanoid = model:FindFirstChildOfClass("Humanoid")
    if not morphHumanoid then return end

    local HumanoidDescription = morphHumanoid:GetAppliedDescription()

    humanoid:ApplyDescription(HumanoidDescription)

    local char = player.Character :: Model

	for _, accessory : Instance in pairs(char:GetChildren()) do
		if accessory:IsA("Accessory") or accessory:IsA("Shirt") or accessory:IsA("Pants") or accessory:IsA("ShirtGraphic")  then

            accessory:Destroy()
            if accessory:IsA("BodyColors")then
                print("Found accesory in" , accessory.Parent)
            end
		end
	end

    for _, accessory : Instance in pairs(model:GetChildren()) do
        if accessory:IsA("Accessory") or accessory:IsA("Shirt") or accessory:IsA("Pants") or accessory:IsA("ShirtGraphic") then
            local clone = accessory:Clone()
            clone.Parent = char


        end
    end




end

return NexusInstance.ToInstance(CharacterBaseServer) :: NexusInstance.NexusInstanceClass<typeof(CharacterBaseServer), (Argument: string) -> (NexusInstanceCharacterBaseServer)>
