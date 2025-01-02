local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)
local BabyCharacter = require(ServerStorage.Source.Services.CharacterService.CharacterService.Characters.BabyServer)
local Knit = require(ReplicatedStorage.Packages.Knit)
local particles = ReplicatedStorage.Source.Data.Particles
local ForkServer = {}
ForkServer.__index = ForkServer
setmetatable(ForkServer, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type ForkServer = {
    TestProperty2: string,
} & typeof(setmetatable({}, ForkServer)) & ItemBase.ItemBase
export type NexusInstanceForkServer = NexusInstance.NexusInstance<ForkServer>

function ForkServer.__new(self: NexusInstanceForkServer, itemName: string, tool: Tool, madeFor : Player)

    ItemBase.__new(self, itemName, tool) --Remember to call the parent constructor!
    self:DisableCollisons()


end

function ForkServer.Client.EatItem(self : NexusInstanceForkServer, player : Player)

end

function ForkServer.PromptInteract(self : NexusInstanceForkServer, promptName: string, ...)

    local ParticleService = Knit.GetService("ParticleService")

    print(promptName)
    if promptName == "Outlets" then

        local babyserver : BabyCharacter.BabyServer = ...

        (babyserver :: any):DamageAttributes({
            Heart = 50,
        })

        local root = (babyserver :: any).Player.Character.HumanoidRootPart :: Part

        local props = {
            Parent = workspace,
            Particle = particles.Electric1,
            Position = root.Position,
            Duration = 1,
            EmitAmount = 1,
        }

        ParticleService:PlayParticle(props)


        local gameSession = babyserver.GameSession
        if gameSession then
            gameSession:SpawnItem("Fork")
        end

        self.Tool:Destroy()

    end

end

return NexusInstance.ToInstance(ForkServer) :: NexusInstance.NexusInstanceClass<typeof(ForkServer), (Input1: string, Input2: string) -> (NexusInstanceForkServer)>