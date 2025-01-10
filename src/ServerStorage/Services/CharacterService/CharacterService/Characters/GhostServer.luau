local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local BabyServer = require(script.Parent.BabyServer)

local GhostServer = {}
GhostServer.__index = GhostServer
setmetatable(GhostServer, BabyServer) --TestClass1NexusInstance would be returned instead of TestClass1.

export type GhostServer = {
    Gravestone : MeshPart,
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

function GhostServer.SpawnGravestone(self : NexusInstanceGhostServer, character : Model)
    local player = self.Player
    local gravestone = ReplicatedStorage.Data.Gravestone:Clone()
    gravestone.Parent = game.Workspace
    gravestone:SetAttribute("PlayerID", player.UserId)

    local Highlight = Instance.new("Highlight")
    Highlight.Parent = gravestone
    Highlight.FillTransparency = 0.75
    Highlight.FillColor = Color3.fromRGB(255, 255, 255)

    gravestone.CFrame = (character:: any):WaitForChild("HumanoidRootPart").CFrame

    local SurfaceGui = gravestone.SurfaceGui :: SurfaceGui
    local TextLabel = SurfaceGui.TextLabel :: TextLabel
    TextLabel.Text = "RIP " .. player.Name

    self.Gravestone = gravestone

    return gravestone

end


function GhostServer.Destroy(self: NexusInstanceGhostServer)
    if self.Gravestone then
        self.Gravestone:Destroy()
    end
    BabyServer.Destroy(self)
end


return NexusInstance.ToInstance(GhostServer) :: NexusInstance.NexusInstanceClass<typeof(GhostServer), (player : Player, character : Model) -> (NexusInstanceGhostServer)>