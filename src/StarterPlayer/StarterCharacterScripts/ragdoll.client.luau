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

ragDollingEvent.OnClientEvent:Connect(function( ragdolling)
    print("Called ragodll")

    if ragdolling then
        game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Head
    else
        game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid

    end

    ragDolling = ragdolling
end)