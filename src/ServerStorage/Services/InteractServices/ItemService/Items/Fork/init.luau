local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)

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

return NexusInstance.ToInstance(ForkServer) :: NexusInstance.NexusInstanceClass<typeof(ForkServer), (Input1: string, Input2: string) -> (NexusInstanceForkServer)>