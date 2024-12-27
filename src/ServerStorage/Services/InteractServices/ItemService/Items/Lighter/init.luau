local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)
local CharacterBaseServer = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local Knit = require(ReplicatedStorage.Packages.Knit)
local LighterServer = {}
LighterServer.__index = LighterServer
setmetatable(LighterServer, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type LighterServer = {
    TestProperty2: string,
    Tool : typeof(game.ServerStorage.Data.Items.Lighter.Model),
} & typeof(setmetatable({}, LighterServer)) & ItemBase.ItemBase
export type NexusInstanceLighterServer = NexusInstance.NexusInstance<LighterServer>

function LighterServer.__new(self: NexusInstanceLighterServer, itemName: string, tool: Tool, madeFor : Player)

    ItemBase.__new(self, itemName, tool) --Remember to call the parent constructor!
    self:DisableCollisons()

end

function LighterServer.Client.ToggleLighter(self : NexusInstanceLighterServer, player : Player)

    self.CharacterService = Knit.GetService("CharacterService")
    local character = self.CharacterService:GetCharacter(player) :: CharacterBaseServer.CharacterBaseServer

    local particle = self.Tool.FlamePart.Flame1
    local light = self.Tool.FlamePart.PointLight

    particle.Enabled = not particle.Enabled
    light.Enabled = not light.Enabled

    if light.Enabled then
        if character.ActiveEffects["Gasoline"] then
            character:ApplyEffect("Burn", 10)
        end
    end

end

return NexusInstance.ToInstance(LighterServer) :: NexusInstance.NexusInstanceClass<typeof(LighterServer), (Input1: string, Input2: string) -> (NexusInstanceLighterServer)>