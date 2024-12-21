
task.wait(2)
local CollectionService = game:GetService("CollectionService")

local Players = game:GetService("Players")
local trampoline = CollectionService:GetTagged("Trampoline") -- returns an array of instances with the tag "Trampoline"

for _,v : BasePart in ipairs(trampoline) do

    v.Touched:Connect(function(hit)
        if hit.Parent == Players.LocalPlayer.Character then
            local humanoid = hit.Parent:FindFirstChild("Humanoid") :: Humanoid
            --humanoid.Jump = true
            local root = Players.LocalPlayer.Character.HumanoidRootPart  :: BasePart
            humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            root.AssemblyLinearVelocity = Vector3.new(0, 85, 0) + root.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
        end
    end)

end