local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)
local CharacterBaseServer = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local Knit = require(ReplicatedStorage.Packages.Knit)
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

    self.Client.Use = function (self : NexusInstanceSoapServer, player : Player)
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

        print("Called soap use ", player)

        self.CharacterService = Knit.GetService("CharacterService")
        local character = self.CharacterService:GetCharacter(player) :: CharacterBaseServer.CharacterBaseServer

        character:ApplyEffect("Slippery", 20)

        self.Tool:Destroy()
    end

end



return NexusInstance.ToInstance(SoapServer) :: NexusInstance.NexusInstanceClass<typeof(SoapServer), (Input1: string, Input2: string) -> (NexusInstanceSoapServer)>