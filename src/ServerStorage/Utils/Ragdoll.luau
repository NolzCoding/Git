-- See my work @Rookstun for more stuff! You can support me by buying my UGC on the catalog. Thanks!

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--local clientDiedEvent = ReplicatedStorage:WaitForChild("onClientCharDied")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local RagdollCounterSys = ServerStorage.RagdollCounterSys
local ragDollingEvent = Instance.new("RemoteEvent")
ragDollingEvent.Name = "RagdollingEvent"
ragDollingEvent.Parent = ReplicatedStorage
--local character = script.Parent
local lDModeOn

local module = {}



--[[local function ragdollMe(character)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.AutoRotate = false
	character.HumanoidRootPart.CollisionGroup = "Body"
	character.HumanoidRootPart.CanCollide = false

	if RagdollCounterSys.ragdollsExisted.Value > RagdollCounterSys.ragdollsLdMax.Value then
		lDModeOn = true
	else
		lDModeOn = false
	end

	if RagdollCounterSys.charactersDied.Value >= RagdollCounterSys.charactersDiedMax.Value then
		task.wait(0.1 * RagdollCounterSys.charactersDied.Value) --Activate ragdoll delay, tenth x per character
	end

	if RagdollCounterSys.ragdollsLdEnable.Value == true and lDModeOn == true then --If LD mode is on
		if character.UpperTorso then
			for i,motor6d : Motor6D in pairs(character.UpperTorso:GetChildren()) do

				if motor6d:IsA("Motor6D") then
					(motor6d.Parent :: BasePart).CollisionGroup = "Body"
					(motor6d.Parent :: BasePart).CanTouch = false
					--motor6d:Destroy()
                    motor6d.Enabled = false
					ballSocket = Instance.new("BallSocketConstraint")
					ballSocket.Parent = motor6d.Parent


				end
			end
		end

		if character.LeftFoot then
			for i,motor6d in pairs(character.LeftFoot:GetChildren()) do
				if motor6d:IsA("Motor6D") then
					(motor6d.Parent :: BasePart).CollisionGroup = "Body"
					(motor6d.Parent :: BasePart).CanTouch = true
					--motor6d:Destroy()
                    motor6d.Enabled = false

				end
			end
		end

		if character.RightFoot then
			for i,motor6d in pairs(character.RightFoot:GetChildren()) do
				if motor6d:IsA("Motor6D") then
					(motor6d.Parent :: BasePart).CollisionGroup = "Body"
					(motor6d.Parent :: BasePart).CanTouch = true
					--motor6d:Destroy()
                    motor6d.Enabled = false

				end
			end
		end

		if character.Head then
			for i,motor6d in pairs(character.Head:GetChildren()) do
				if motor6d:IsA("Motor6D") then	--Getting motor6D joints as joints. Their parents are the parts.
                    (motor6d.Parent :: BasePart).CollisionGroup = "Body"
                    (motor6d.Parent :: BasePart).CanTouch = true
					--motor6d:Destroy()
                    motor6d.Enabled = false

				end
			end
		end
	else --If LD mode is off
		RagdollCounterSys.ragdollsExisted.Value += 1
		for i,limbs in pairs(character:GetChildren()) do
			for i,motor6d : Motor6D in pairs(limbs:GetChildren()) do
				if motor6d:IsA("Motor6D") then	--Getting motor6D joints as joints. Their parents are the parts.
                    (motor6d.Parent :: BasePart).CollisionGroup = "Body"
					--print("Rookstun ", motor6d.Parent.CollisionGroup, " ", motor6d.Parent.CollisionGroupId, " ", motor6d.Parent)
					(motor6d.Parent :: BasePart).CanCollide = true
                    motor6d.Enabled = false

					--motor6d:Destroy()
				end
			end
		end
	end
end

local function unRagdollMe(character)

	if character.UpperTorso then
		for i,motor6d : Motor6D in pairs(character.UpperTorso:GetChildren()) do

			if motor6d:IsA("Motor6D") then
				(motor6d.Parent :: BasePart).CollisionGroup = "Body"
				(motor6d.Parent :: BasePart).CanTouch = false
				--motor6d:Destroy()
				motor6d.Enabled = true
				ballSocket = Instance.new("BallSocketConstraint")
				ballSocket.Parent = motor6d.Parent


			end
		end
	end

	if character.LeftFoot then
		for i,motor6d in pairs(character.LeftFoot:GetChildren()) do
			if motor6d:IsA("Motor6D") then
				(motor6d.Parent :: BasePart).CollisionGroup = "Body"
				(motor6d.Parent :: BasePart).CanTouch = true
				--motor6d:Destroy()
				motor6d.Enabled = true

			end
		end
	end

	if character.RightFoot then
		for i,motor6d in pairs(character.RightFoot:GetChildren()) do
			if motor6d:IsA("Motor6D") then
				(motor6d.Parent :: BasePart).CollisionGroup = "Body"
				(motor6d.Parent :: BasePart).CanTouch = true
				--motor6d:Destroy()
				motor6d.Enabled = true

			end
		end
	end

	if character.Head then
		for i,motor6d in pairs(character.Head:GetChildren()) do
			if motor6d:IsA("Motor6D") then	--Getting motor6D joints as joints. Their parents are the parts.
				(motor6d.Parent :: BasePart).CollisionGroup = "Body"
				(motor6d.Parent :: BasePart).CanTouch = true
				--motor6d:Destroy()
				motor6d.Enabled = true

			end
		end
	end
	for i,limbs in pairs(character:GetChildren()) do
		for i,motor6d : Motor6D in pairs(limbs:GetChildren()) do
			if motor6d:IsA("Motor6D") then	--Getting motor6D joints as joints. Their parents are the parts.
				(motor6d.Parent :: BasePart).CollisionGroup = "Body"
				--print("Rookstun ", motor6d.Parent.CollisionGroup, " ", motor6d.Parent.CollisionGroupId, " ", motor6d.Parent)
				(motor6d.Parent :: BasePart).CanCollide = true
				motor6d.Enabled = true

				--motor6d:Destroy()
			end
		end
	end


end]]

local limbsToEnableInRagdoll = {
	"LeftUpperArm",
	"RightUpperArm",
	"LeftLowerArm",
	"RightLowerArm",
	"LeftHand",
	"RightHand",
	"LeftUpperLeg",
	"RightUpperLeg",
	"LeftLowerLeg",
	"RightLowerLeg",
}

module.ActiveRagdolls = {}
--[[RunService.Stepped:Connect(function(delta: number)

	for _,character in ipairs(module.ActiveRagdolls) do
		print(character)
		for _,v in ipairs(limbsToEnableInRagdoll) do
			local limb = character:FindFirstChild(v)
			limb.CanCollide = true
			limb.CanTouch = true
		end
	end
end)]]


local function ragdollMe(character : Model)
	if character:GetAttribute("Ragdolled") then
		warn("Called ragdollMe on a ragdolled character")
		return
	end
	character:SetAttribute("Ragdolled", true)
	for _,v in ipairs(character:GetChildren()) do
		local motor6d = v:FindFirstChildOfClass("Motor6D")
		if motor6d then
			motor6d.Enabled = false
		end
	end

	table.insert(module.ActiveRagdolls, character)

end

local function unRagdollMe(character : Model)
	character:SetAttribute("Ragdolled", false)
	for _,v in ipairs(character:GetChildren()) do
		local motor6d = v:FindFirstChildOfClass("Motor6D")
		if motor6d then
			motor6d.Enabled = true
		end
	end

	table.remove(module.ActiveRagdolls, table.find(module.ActiveRagdolls, character))
	--local humanoid = character:FindFirstChildOfClass("Humanoid")
	--humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
	--local root = character:FindFirstChild("HumanoidRootPart")
	--root.CFrame = root.CFrame + Vector3.new(0, 1, 0)

end

local function activateVelocity(player)
	player.character.HumanoidRootPart.AngularVelocity.Enabled = true
	player.character.HumanoidRootPart.LinearVelocity.Enabled = true
	if player.character:FindFirstChild("LeftUpperLeg") and player.character:FindFirstChild("RightUpperLeg") then
		player.character.LeftUpperLeg.AngularVelocity.Enabled = true
		player.character.RightUpperLeg.AngularVelocity.Enabled = true
	end
end

local function deactivateVelocity(player)
	player.character.HumanoidRootPart.AngularVelocity.Enabled = false
	player.character.HumanoidRootPart.LinearVelocity.Enabled = false
	if player.character:FindFirstChild("LeftUpperLeg") and player.character:FindFirstChild("RightUpperLeg") then
		player.character.LeftUpperLeg.AngularVelocity.Enabled = false
		player.character.RightUpperLeg.AngularVelocity.Enabled = false
	end
end

local function ragdollFreeze(character, state)
	if character and RagdollCounterSys.ragdollFreezeEnable.Value and state == Enum.HumanoidStateType.Dead then
		local upperTorso = character:WaitForChild("UpperTorso")
		repeat
			local lastPos = upperTorso.Position
			wait(RagdollCounterSys.ragdollFreezeTime.Value) --Time left before it checks body.
			local newPos = upperTorso.Position
			local distanceDiff = (lastPos - newPos).magnitude 		--print("DistanceDiff", distanceDiff)
		until distanceDiff < 2 		--Distance a body must be close from its original check to be anchored

		for i,v in pairs(character:GetChildren()) do
			if v:IsA("MeshPart") then
				v.Anchored = true
			end
		end
		character.HumanoidRootPart.Anchored = true
	end
	if RagdollCounterSys.ragdollsExisted.Value ~= 0  then
		RagdollCounterSys.ragdollsExisted.Value -= 1
	end
end

local function resyncClothes(player)
	for i,v in pairs(player.character:GetChildren()) do --Hack. Refreshes and resyncs layered clothing.
		if v:IsA("Accessory") then
			for i2,v2 in pairs(v.Handle:GetChildren()) do
				if v2:IsA("WrapLayer") then
					local refWT = Instance.new("WrapTarget")
					refWT.Parent = v2.Parent
					refWT:Destroy()
					refWT.Parent = nil
				end
			end
		end
	end
end

local function stopAnims(humanoid)
	local AnimTrack = humanoid:GetPlayingAnimationTracks()
	for i, track in pairs (AnimTrack) do
		track:Stop()
	end
end

--[[Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")

		clientDiedEvent.OnServerEvent:Connect(activateVelocity)

		humanoid.Died:Connect(function()

			humanoid:UnequipTools() --Allow for ragdoll and any tool to sync serverside
			for i, tool in pairs(player.Backpack:GetChildren()) do --If you are looking for :Unequip(), see localscript
				tool:Destroy()
			end
			RagdollCounterSys.charactersDied.Value += 1
			stopAnims(humanoid)
			activateVelocity(player)
			ragdollMe(player.character)
			resyncClothes(player)
			task.wait() --Without this physics may not activate on platformstand
			deactivateVelocity(player)
			ragdollFreeze(player.character, humanoid:GetState())
		end)
	end)
end)]]

function module:RagDollCharacter(character : Model, player : Player)
    stopAnims(character.Humanoid)
    --activateVelocity(player)
	local humanoid = character:WaitForChild("Humanoid") :: Humanoid
	humanoid.RequiresNeck = false
    ragdollMe(character)
	humanoid.PlatformStand = true
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	ragDollingEvent:FireClient(player, true)


	--resyncClothes(player)
	--task.wait() --Without this physics may not activate on platformstand
	--

	--deactivateVelocity(player)

end

function module:UnRagDollCharacter(character : Model, player : Player)
	local humanoid = character:WaitForChild("Humanoid") :: Humanoid
	unRagdollMe(character)
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	humanoid.PlatformStand = false
	ragDollingEvent:FireClient(player, false)

end

return module