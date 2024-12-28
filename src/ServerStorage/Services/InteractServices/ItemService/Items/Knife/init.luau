local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)
local Knit = require(ReplicatedStorage.Packages.Knit)
local KnifeServer = {}
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
KnifeServer.__index = KnifeServer
setmetatable(KnifeServer, ItemBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type KnifeServer = {
    TestProperty2: string,
} & typeof(setmetatable({}, KnifeServer)) & ItemBase.ItemBase
export type NexusInstanceKnifeServer = NexusInstance.NexusInstance<KnifeServer>

function KnifeServer.__new(self: NexusInstanceKnifeServer, itemName: string, tool: Tool, madeFor : Player)

    ItemBase.__new(self, itemName, tool) --Remember to call the parent constructor!
    self:DisableCollisons()

    self.CharacterService = Knit.GetService("CharacterService")
    self.NotificationService = Knit.GetService("NotificationService")

end

function KnifeServer.Client.Attack(self : NexusInstanceKnifeServer, player : Player)


    local overlappingParams = OverlapParams.new()
    overlappingParams.FilterType = Enum.RaycastFilterType.Exclude
    overlappingParams.FilterDescendantsInstances = {player.Character}

    local root = (player :: any).Character.HumanoidRootPart :: Part

    local parts = workspace:GetPartBoundsInBox(root.CFrame + root.CFrame.LookVector *1, Vector3.new(4,4,4), overlappingParams)
    for _, part in ipairs(parts) do
        if part.Parent:FindFirstChild("Humanoid") then
            local attackedPlayer = game.Players:GetPlayerFromCharacter(part.Parent)
            if not attackedPlayer then return end
            if player.Team == attackedPlayer.Team then return end
            local typeOfCharacter = attackedPlayer.Character:GetAttribute("Character")
            if not typeOfCharacter then return end
            if typeOfCharacter == "Parent" then
                local walkspeedbefore = attackedPlayer.Character.Humanoid.WalkSpeed
                attackedPlayer.Character.Humanoid.WalkSpeed = 1
                self.NotificationService:NotifyPlayer("TextNImage", {
                    Text = "You stabbed your parent in the foot, you couldnt get it out",
                    Image = Icons.Emojis.Skull,
                    Color = Color3.fromRGB(140, 0, 255),
                    Time = 5,
                }, player)
                task.delay(10, function()
                    attackedPlayer.Humanoid.WalkSpeed = walkspeedbefore

                end)
                self.Tool:Destroy()
                return
            else
                --self.CharacterService:DamageCharacter(attackedPlayer, 5)
                return
            end

        end
    end

end

return NexusInstance.ToInstance(KnifeServer) :: NexusInstance.NexusInstanceClass<typeof(KnifeServer), (Input1: string, Input2: string) -> (NexusInstanceKnifeServer)>