local Door = {}

function Door:Init()

end

function Door:Triggered(prompt : ProximityPrompt, player : Player)

    local hinge = prompt.Parent.Parent :: BasePart

    local open = hinge:GetAttribute("Open")

    local hingeConstraint = hinge:FindFirstChildOfClass("HingeConstraint")

    if open then
        hingeConstraint.TargetAngle = 0
        hinge:SetAttribute("Open", false)
    else
        hingeConstraint.TargetAngle = 100
        hinge:SetAttribute("Open", true)
    end

    local door = hingeConstraint.Attachment1.Parent :: BasePart

end

return Door