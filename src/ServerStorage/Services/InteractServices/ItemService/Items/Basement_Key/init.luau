local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)

local Basement_KeyServer = {}
Basement_KeyServer.__index = Basement_KeyServer
setmetatable(Basement_KeyServer, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type Basement_KeyServer = {
    TestProperty2: string,
} & typeof(setmetatable({}, Basement_KeyServer)) & ItemBase.ItemBase
export type NexusInstanceBasement_KeyServer = NexusInstance.NexusInstance<Basement_KeyServer>

function Basement_KeyServer.__new(self: NexusInstanceBasement_KeyServer, itemName: string, tool: Tool, madeFor : Player)

    ItemBase.__new(self, itemName, tool) --Remember to call the parent constructor!
    self:DisableCollisons()

end

function Basement_KeyServer.Client.EatItem(self : NexusInstanceBasement_KeyServer, player : Player)

end

return NexusInstance.ToInstance(Basement_KeyServer) :: NexusInstance.NexusInstanceClass<typeof(Basement_KeyServer), (Input1: string, Input2: string) -> (NexusInstanceBasement_KeyServer)>