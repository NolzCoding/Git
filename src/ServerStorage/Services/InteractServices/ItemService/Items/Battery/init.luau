local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)
local Knit = require(ReplicatedStorage.Packages.Knit)
local BatteryServer = {}
BatteryServer.__index = BatteryServer
setmetatable(BatteryServer, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type BatteryServer = {
    TestProperty2: string,
} & typeof(setmetatable({}, BatteryServer)) & ItemBase.ItemBase
export type NexusInstanceBatteryServer = NexusInstance.NexusInstance<BatteryServer>

function BatteryServer.__new(self: NexusInstanceBatteryServer, itemName: string, tool: Tool, madeFor : Player)

    ItemBase.__new(self, itemName, tool) --Remember to call the parent constructor!
    self:DisableCollisons()

end

function BatteryServer.Client.EatItem(self : NexusInstanceBatteryServer, player : Player)
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

    local stomach = humanoid:GetAttribute("Stomach")
    stomach -= 25
    stomach = math.clamp(stomach, 0, 100)
    humanoid:SetAttribute("Stomach", stomach)

    local CharacterService = Knit.GetService("CharacterService")

    local character = CharacterService:GetCharacter(player)

    local gameSession = character.GameSession
    if gameSession then
        gameSession:SpawnItem("Battery")
    end

    self.Tool:Destroy()
end

return NexusInstance.ToInstance(BatteryServer) :: NexusInstance.NexusInstanceClass<typeof(BatteryServer), (Input1: string, Input2: string) -> (NexusInstanceBatteryServer)>