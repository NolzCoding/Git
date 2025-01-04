local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)
local CharacterBaseServer = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
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

    self.Client.Use = function (self : NexusInstanceBatteryServer, player : Player)
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

        self.CharacterService = Knit.GetService("CharacterService")
        local character = self.CharacterService:GetCharacter(player) :: CharacterBaseServer.CharacterBaseServer

        character:DamageAttributes({
            Stomach = 25,
        })

        task.spawn(function()
            local AchievementService = Knit.GetService("AchievementService")
            AchievementService:PerformedAction(player, "Battery", 1)
        end)

        self.Tool:Destroy()
    end

end



return NexusInstance.ToInstance(BatteryServer) :: NexusInstance.NexusInstanceClass<typeof(BatteryServer), (Input1: string, Input2: string) -> (NexusInstanceBatteryServer)>