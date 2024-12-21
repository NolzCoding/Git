local CollectionService = game:GetService("CollectionService")

local function rotate(obj : BasePart)

    local tweenInfo = TweenInfo.new(obj:GetAttribute("Speed") or 5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false)
    local tween = game:GetService("TweenService"):Create(obj, tweenInfo, {CFrame = obj.CFrame * CFrame.Angles(0, math.rad(180), 0)})

    tween:Play()

    print("Rotating", obj)

end

for _,v in ipairs(CollectionService:GetTagged("Rotate")) do
    rotate(v)
end


CollectionService:GetInstanceAddedSignal("Rotate"):Connect(function(instance)
    rotate(instance)
end)