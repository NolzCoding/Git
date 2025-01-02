local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local BabyServer = require(script.Parent.BabyServer)

local GhostServer = {}
GhostServer.__index = GhostServer
setmetatable(GhostServer, BabyServer) --TestClass1NexusInstance would be returned instead of TestClass1.

export type GhostServer = {
} & typeof(setmetatable({}, GhostServer)) & BabyServer.BabyServer
export type NexusInstanceGhostServer = NexusInstance.NexusInstance<GhostServer>

function GhostServer.__new(self: NexusInstanceGhostServer, player : Player, character : Model)
    self.ItemSlots = 0
    BabyServer.__new(self, player, character, false, false) --Remember to call the parent constructor!
    for _,v in ipairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 1
            v.Material = Enum.Material.ForceField
        elseif v:IsA("Decal") then
            v.Transparency = 1
        end
    end



end


return NexusInstance.ToInstance(GhostServer) :: NexusInstance.NexusInstanceClass<typeof(GhostServer), (player : Player, character : Model) -> (NexusInstanceGhostServer)>