local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)

local SoapServer = {}
SoapServer.__index = SoapServer
setmetatable(SoapServer, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type SoapServer = {
    TestProperty2: string,
} & typeof(setmetatable({}, SoapServer)) & ItemBase.ItemBase
export type NexusInstanceSoapServer = NexusInstance.NexusInstance<SoapServer>

function SoapServer.__new(self: NexusInstanceSoapServer, itemName: string, tool: Tool, madeFor : Player)

    ItemBase.__new(self, itemName, tool) --Remember to call the parent constructor!
    self:DisableCollisons()

end

function SoapServer.Client.EatItem(self : NexusInstanceSoapServer, player : Player)
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

    local stomach = humanoid:GetAttribute("Stomach")
    stomach -= 10
    stomach = math.clamp(stomach, 0, 100)
    humanoid:SetAttribute("Stomach", stomach)
    self.Tool:Destroy()
end

return NexusInstance.ToInstance(SoapServer) :: NexusInstance.NexusInstanceClass<typeof(SoapServer), (Input1: string, Input2: string) -> (NexusInstanceSoapServer)>