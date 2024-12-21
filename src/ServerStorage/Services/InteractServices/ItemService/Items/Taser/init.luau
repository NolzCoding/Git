local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Ragdoll = require(ServerStorage.Source.Utils.Ragdoll)
local TaserServer = {}
TaserServer.__index = TaserServer
setmetatable(TaserServer, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.
local particles = ReplicatedStorage.Source.Data.Particles
export type TaserServer = {
    TestProperty2: string,
} & typeof(setmetatable({}, TaserServer)) & ItemBase.ItemBase
export type NexusInstanceTaserServer = NexusInstance.NexusInstance<TaserServer>

function TaserServer.__new(self: NexusInstanceTaserServer, itemName: string, tool: Tool, madeFor : Player)

    ItemBase.__new(self, itemName, tool) --Remember to call the parent constructor!
    self.ParticleService = Knit.GetService("ParticleService")
end

function TaserServer.Client.Shoot(self : NexusInstanceTaserServer, player : Player, target : BasePart, hit : Vector3)

    if not target then
        local props = {
            Parent = workspace,
            Particle = particles.Electric1,
            Position = hit,
            Duration = 1,
            EmitAmount = 1,
        }
        self.ParticleService:PlayParticle(props)

        return
    end

    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterDescendantsInstances = {player.Character, self.Tool}
    RaycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local ray = Ray.new(self.Tool.Handle.Position, hit - self.Tool.Handle.Position)

    local result = workspace:Raycast(ray.Origin, ray.Direction * 40, RaycastParams)

    local hitPart = result and result.Instance
    if not hitPart then
        return
    end

    if not hitPart == target then -- doesnt have visiblity
        return
    end

    local shootPlayer = game.Players:GetPlayerFromCharacter(hitPart.Parent)

    if shootPlayer then

        Ragdoll:RagDollCharacter(shootPlayer.Character, shootPlayer)
        task.defer(function()
            local root : Part = shootPlayer.Character.HumanoidRootPart.CFrame
            root.AssemblyLinearVelocity = Vector3.new(0, 100, 0)
        end)
        task.delay(5, function()
            Ragdoll:UnRagDollCharacter(shootPlayer.Character, shootPlayer)
        end)

    end

    local props = {
        Parent = target,
        Particle = particles.Electric1,
        Position = hit,
        Duration = 1,
        EmitAmount = 1,
    }

    self.ParticleService:PlayParticle(props)


end

return NexusInstance.ToInstance(TaserServer) :: NexusInstance.NexusInstanceClass<typeof(TaserServer), (Input1: string, Input2: string) -> (NexusInstanceTaserServer)>