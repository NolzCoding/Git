local AssetService = game:GetService('AssetService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Knit = require(ReplicatedStorage.Packages.Knit)
local ServerStorage = game:GetService('ServerStorage')
local Component = require(ReplicatedStorage.Packages.Component)
type self = typeof(Component.new({Tag = "BabyBed"}))
local BabyBed = Component.new({Tag = "BabyBed"})
print("reqiored")

local BabyServer = require(ServerStorage.Source.Services.CharacterService.CharacterService.Characters.BabyServer)
local ParentServer = require(ServerStorage.Source.Services.CharacterService.CharacterService.Characters.ParentServer)

local CharacterService = Knit.GetService("CharacterService")



function BabyBed:Construct()

    local collider = self.Instance.Collider :: Part
    local teleport = self.Instance.Teleport :: Part
    local TIME = 10

    collider.Touched:Connect(function(basePart: BasePart)

        if basePart.Name ~= "HumanoidRootPart" then
            return
        end

        local player = game.Players:GetPlayerFromCharacter(basePart.Parent)
        if player.Character:GetAttribute("Character") ~= "Parent" then
            return
        end

        local parentServer = CharacterService:GetCharacter(player) :: ParentServer.ParentServer
        if not parentServer.PickedUp and not parentServer.PickedUp.babyPlayerClass then
            return -- Parent is not holding a baby
        end

        local babyPlayer = parentServer.PickedUp.babyPlayerClass

        if babyPlayer.Player:HasTag("NoBabyBed") then
            return
        end

        babyPlayer.Player:AddTag("NoBabyBed")

        task.delay(TIME*2, function()
            babyPlayer.Player:RemoveTag("NoBabyBed")
        end)

        parentServer:StopPickingUp()

        local babyRoot = babyPlayer.Player.Character.HumanoidRootPart :: Part
        babyRoot.CFrame = teleport.CFrame
        babyRoot.Anchored = true

        local proximity = babyRoot:FindFirstChild("ProximityPrompt") :: ProximityPrompt
        if proximity then
            proximity.Enabled = false
        end

        task.wait(TIME)

        if proximity then
            proximity.Enabled = true
        end

        babyRoot.Anchored = false

    end)

end

return BabyBed