local ragDollingEvent = game:GetService("ReplicatedStorage"):WaitForChild("RagdollingEvent")
local RunService = game:GetService("RunService")

local ragDolling = false

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
    "Head"
}

RunService.Stepped:Connect(function(delta: number)
    if not ragDolling then return end
    print("ragdolling")
    local character = game.Players.LocalPlayer.Character
    for _,v in ipairs(limbsToEnableInRagdoll) do
        local limb = character:FindFirstChild(v)
        limb.CanCollide = true
        limb.CanTouch = true
    end

end)

local debounceUP = false

ragDollingEvent.OnClientEvent:Connect(function( ragdolling)
    print("Called ragodll")

    if ragdolling then
        game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Head
    else
        game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
        local character = game.Players.LocalPlayer.Character

        if debounceUP then return end

        local humanoid = character:FindFirstChild("Humanoid")

        local root = character:FindFirstChild("HumanoidRootPart")

        root.CFrame += Vector3.new(0, 1, 0)
        root.CFrame = CFrame.fromMatrix(root.CFrame.Position, Vector3.new(1,0,0), Vector3.new(0,1,0), Vector3.new(0,0,1))

        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

        debounceUP = true

        task.delay(0.5, function()
            debounceUP = false
        end)




    end

    ragDolling = ragdolling
end)