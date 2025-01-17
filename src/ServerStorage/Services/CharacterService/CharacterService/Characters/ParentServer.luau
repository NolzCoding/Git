--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local Knit = require(ReplicatedStorage.Packages.Knit)
local CharacterServerBase = require(script.Parent.Parent.CharacterBaseServer)
local Promise = require(Knit.Util.Promise)
local ragDollModule = require(game.ServerStorage.Source.Utils.Ragdoll)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children

--Define TestClass1 (potentially in a ModuleScript).

--Define TestClass2 (potentially in a different ModuleScript).
local ParentServer = {}
ParentServer.__index = ParentServer
setmetatable(ParentServer, CharacterServerBase) --TestClass1NexusInstance would be returned instead of TestClass1.

export type ParentServer = {
	PickupPlayer: (self: NexusInstanceParentServer, playerToPickup: BabyServer.BabyServer) -> (),
	StopPickingUp: (self: NexusInstanceParentServer) -> (),
	CarryBabyAttachment: Attachment,
	PickedUp: {
		WeldConstraint: WeldConstraint,
		babyPlayerClass: CharacterServerBase.CharacterBaseServer,
        scope: Fusion.Scope,
        Promise: Promise,
	} | nil,
	SetupCharacter: (self: NexusInstanceParentServer, character: Model) -> (),
} & typeof(setmetatable({}, ParentServer)) & CharacterServerBase.CharacterBaseServer
export type NexusInstanceParentServer = NexusInstance.NexusInstance<ParentServer>

function ParentServer.SetupCharacter(self: NexusInstanceParentServer, character: Model): ()
	-- do setup for the character

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

	local RightHand = character:WaitForChild("RightHand") :: BasePart
	local RightUpperArm = character:WaitForChild("UpperTorso") :: BasePart

	self:NewIKControl("RightArm", RightHand, RightUpperArm)

	self.Client.ThrowBaby = function(self: NexusInstanceParentServer): ()
		print(self)

		local playerToThrow = (self.PickedUp :: any).babyPlayerClass.Player :: Player
		ragDollModule:RagDollCharacter(playerToThrow.Character, playerToThrow)
		task.delay(5, function()
			ragDollModule:UnRagDollCharacter(playerToThrow.Character, playerToThrow)
		end)
		local babyclass = self.PickedUp.babyPlayerClass
		self:StopPickingUp()
		local root = self.Player.Character:FindFirstChild("HumanoidRootPart") :: Part
		babyclass.ClientSignal.AddForce(root.CFrame.LookVector * 90 + Vector3.new(0, 100, 0))
	end

	self.NotificationService = Knit.GetService("NotificationService")
end

function ParentServer.StopPickingUp(self: NexusInstanceParentServer): ()
	if self.PickedUp then
		self.PickedUp.WeldConstraint:Destroy()
        Fusion.doCleanup(self.PickedUp.scope)
        if self.PickedUp.Promise then
            self.PickedUp.Promise:cancel()
        end
        self.PickedUp = nil

	end

	self.AnimationTracks["Holding"]:Stop()

	self.ClientSignal.onPlayerDrop()
end

function ParentServer.PickupPlayer(self: NexusInstanceParentServer, playerClassToPickup: BabyServer.BabyServer): ()
	if playerClassToPickup.Player:HasTag("NoBabyBed") then
		self.NotificationService:NotifyPlayer("TextNImage", {
			Text = "Baby pickup is on cooldown, since they were just in a baby bed",
			Image = "",
			Color = Color3.fromRGB(255, 45, 45),
			Time = 5,
		}, self.Player)

		return
	end

	if self.PickedUp then
		self:StopPickingUp()
	end

	assert(playerClassToPickup, "Player is nil")

	local babyPlayer: Player = playerClassToPickup.Player
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
		scope = Fusion:scoped(),
	}
	self.AnimationTracks["Holding"]:Play()

	self.PickedUp.Promise = Promise.new(function(resolve, reject)
		local scope = self.PickedUp.scope

        local timer = scope:Value(10)

		scope:New("BillboardGui")({
			Name = "Timer",
			Active = true,
			ClipsDescendants = true,
            Parent = babyRoot,
            StudsOffsetWorldSpace = Vector3.new(0, 3, 0),
			LightInfluence = 1,
			Size = UDim2.fromScale(3, 3),
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

			[Children] = {
				scope:New("TextLabel")({
					Name = "TextLabel",
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),
					Text = timer,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextScaled = true,
					TextSize = 4,
					TextStrokeColor3 = Color3.fromRGB(255, 255, 255),
					TextWrapped = true,
					[Children] = {
						scope:New("UIStroke")({
							Name = "UIStroke",
							Thickness = 2,
						}),
					},
				}),
			},
		})

        for i = 1, 10 do
            task.wait(1)
            timer:set(10 - i)
        end

        resolve()

	end):andThen(function()
        self:StopPickingUp()
    end)

	task.spawn(function()
		self.AchievementService:PerformedAction(self.Player, "BabyPickup", 1)
	end)
end

function ParentServer.__new(self: NexusInstanceParentServer, player: Player, character: Model): ()
	assert(character, "Character is nil")
	self.ItemSlots = 5
	CharacterServerBase.__new(self, player, character) --Remember to call the parent constructor!

	self:SetupCharacter(character)
	print("ParentServer")
end

-- destroy

function ParentServer.Destroy(self: NexusInstanceParentServer): ()
	self:StopPickingUp()
	CharacterServerBase.Destroy(self)
end

return NexusInstance.ToInstance(
		ParentServer
	) :: NexusInstance.NexusInstanceClass<
		typeof(ParentServer),
		(player: Player, character: Model) -> NexusInstanceParentServer
	>
