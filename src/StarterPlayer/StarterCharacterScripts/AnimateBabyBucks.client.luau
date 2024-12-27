local rootPart = script.Parent.Parent:FindFirstChild("HumanoidRootPart") :: Part
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Sounds = require(ReplicatedStorage.Source.Shared.Sounds)

local newSound = SoundService:FindFirstChild("PickupSound") :: Sound

if not newSound then
    newSound = Instance.new("Sound")
    newSound.SoundId = Sounds.Pickup
    newSound.Parent = SoundService
    newSound.Name = "PickupSound"
end

print(rootPart)
rootPart.Touched:Connect(function(part : BasePart)
    print("part")
    if part:HasTag("BabyBuck") then

        print(part)

        local cframe = part.CFrame
        local clonedPart = part:Clone()
        clonedPart:RemoveTag("BabyBuck")
        clonedPart.Parent = workspace
        clonedPart.CFrame = cframe
        part:Destroy()

        -- lerp with 50 steps

        local billboardgui = clonedPart:FindFirstChildOfClass("BillboardGui")

        for i = 1, 25 do

            clonedPart.CFrame = clonedPart.CFrame:Lerp(rootPart.CFrame, i/25)
            billboardgui.Size = billboardgui.Size:Lerp(UDim2.fromScale(0, 0), i/25)
            task.wait()
        end

        clonedPart:Destroy()

        SoundService:PlayLocalSound(newSound)

    end

end)