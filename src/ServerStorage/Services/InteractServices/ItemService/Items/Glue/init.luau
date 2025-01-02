local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local BabyCharacter = require(ServerStorage.Source.Services.CharacterService.CharacterService.Characters.BabyServer)
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)
local Knit = require(ReplicatedStorage.Packages.Knit)
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local particles = ReplicatedStorage.Source.Data.Particles
local GlueServer = {}
local GluePuddle = ServerStorage.Source.Services.InteractServices.Object2VService.Objects.GluePuddle
GlueServer.__index = GlueServer
setmetatable(GlueServer, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type GlueServer = {
    TestProperty2: string,
    Player: Player,
} & typeof(setmetatable({}, GlueServer)) & ItemBase.ItemBase
export type NexusInstanceGlueServer = NexusInstance.NexusInstance<GlueServer>

function GlueServer.__new(self: NexusInstanceGlueServer, itemName: string, tool: Tool, madeFor : Player)
    self.Player = madeFor
    ItemBase.__new(self, itemName, tool) --Remember to call the parent constructor!
    self:DisableCollisons()

    self.Tool.Activated:Connect(function()
        self:Use()
    end)

end

function GlueServer:Use()
    local puddle = GluePuddle:Clone()
    puddle.Parent = workspace
    puddle:PivotTo(self.Player.Character.LeftFoot.CFrame)
    self.Tool:Destroy()
end

return NexusInstance.ToInstance(GlueServer) :: NexusInstance.NexusInstanceClass<typeof(GlueServer), (Input1: string, Input2: string) -> (NexusInstanceGlueServer)>