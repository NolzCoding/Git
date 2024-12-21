--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local Knit = require(ReplicatedStorage.Packages.Knit)
local CharacterServerBase = require(script.Parent.Parent.CharacterBaseServer)

local ragDollModule = require(game.ServerStorage.Source.Utils.Ragdoll)

--Define TestClass1 (potentially in a ModuleScript).

--Define TestClass2 (potentially in a different ModuleScript).
local ParentServer = {}
ParentServer.__index = ParentServer
setmetatable(ParentServer, CharacterServerBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type ParentServer = {
    PickupPlayer: (self: NexusInstanceParentServer, playerToPickup : BabyServer.BabyServer) -> (),
    StopPickingUp: (self: NexusInstanceParentServer) -> (),
    CarryBabyAttachment : Attachment,
    PickedUp: {
        WeldConstraint : WeldConstraint,
        babyPlayerClass : CharacterServerBase.CharacterBaseServer,
    } | nil,
    SetupCharacter: (self: NexusInstanceParentServer, character : Model) -> (),
} & typeof(setmetatable({}, ParentServer)) & CharacterServerBase.CharacterBaseServer
export type NexusInstanceParentServer = NexusInstance.NexusInstance<ParentServer>

function ParentServer.SetupCharacter(self: NexusInstanceParentServer, character : Model): ()
    -- do setup for the character
    character:SetAttribute("Character", "Parent")

    local HumanoidRootPart = character:WaitForChild("HumanoidRootPart") :: Part

    local humanoid = character:WaitForChild("Humanoid") :: Humanoid

    humanoid.Died:Connect(function(...: any)
        self.Died:Fire()
    end)


    local data = self.DataService:GetData(self.Player) :: table
    local skin = data.Skins.Parent.CurrentSkin

    local skinModel = ReplicatedStorage.Data.Skins:FindFirstChild(skin)


    self:NewMorph(skinModel)


    self.CarryBabyAttachment = Instance.new("Attachment")
    self.CarryBabyAttachment.Parent = HumanoidRootPart
    self.CarryBabyAttachment.CFrame = CFrame.new(0, 0.5, -2)

    local track = self:AddTrackFromId("rbxassetid://136850555364141", "Holding")
    track.Looped = true


end

function ParentServer.Client.ThrowBaby(self: NexusInstanceParentServer): ()
    print(self)

    local playerToThrow = (self.PickedUp :: any).babyPlayerClass.Player :: Player
    ragDollModule:RagDollCharacter(playerToThrow.Character, playerToThrow)
    task.delay(5, function()
        ragDollModule:UnRagDollCharacter(playerToThrow.Character, playerToThrow)
    end)
    local babyclass = self.PickedUp.babyPlayerClass
    self:StopPickingUp()
    local root = self.Player.Character:FindFirstChild("HumanoidRootPart") :: Part
    babyclass.ClientSignal.AddForce(root.CFrame.LookVector * 200 + Vector3.new(0, 500, 0))

end

function ParentServer.StopPickingUp(self: NexusInstanceParentServer): ()



    if self.PickedUp then
        self.PickedUp.WeldConstraint:Destroy()
        self.PickedUp = nil
    end

    self.AnimationTracks["Holding"]:Stop()

    self.ClientSignal.onPlayerDrop()


end

function ParentServer.PickupPlayer(self : NexusInstanceParentServer, playerClassToPickup : BabyServer.BabyServer): ()

    if self.PickedUp then
        self:StopPickingUp()
    end


    assert(playerClassToPickup, "Player is nil")

    local babyPlayer : Player = playerClassToPickup.Player
    local babyCharacter = babyPlayer.Character :: Model
    local babyRoot = babyCharacter:WaitForChild("HumanoidRootPart") :: Part

    local parentCharacter = self.Player.Character :: Model
    local parentRoot = parentCharacter:WaitForChild("HumanoidRootPart") :: Part
    babyRoot.CFrame = self.CarryBabyAttachment.WorldCFrame

    local newWeld = Instance.new("WeldConstraint")
    newWeld.Parent = babyRoot
    newWeld.Part0 = babyRoot
    newWeld.Part1 = parentRoot

    self.ClientSignal.onPlayerPickup(playerClassToPickup.Player, newWeld)


    babyRoot:SetNetworkOwner(self.Player)

    self.PickedUp = {
        WeldConstraint = newWeld,
        babyPlayerClass = playerClassToPickup :: any,
    }
    print(self)
    self.AnimationTracks["Holding"]:Play()

    task.delay(10, function()
        self:StopPickingUp()
    end)

end



function ParentServer.__new(self: NexusInstanceParentServer, player : Player, character : Model): ()
    assert(character, "Character is nil")
    CharacterServerBase.__new(self, player, character) --Remember to call the parent constructor!

    self:SetupCharacter(character)
    print("ParentServer")

end

return NexusInstance.ToInstance(ParentServer) :: NexusInstance.NexusInstanceClass<typeof(ParentServer), (player : Player, character : Model) -> (NexusInstanceParentServer)>