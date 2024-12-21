local Door = {}


local DoorOpenSound = Instance.new("Sound")
DoorOpenSound.SoundId = "rbxassetid://6058561902"
DoorOpenSound.Parent = script.Parent
DoorOpenSound.PlayOnRemove = true

local DoorCloseSound = Instance.new("Sound")
DoorCloseSound.SoundId = "rbxassetid://8490301305"
DoorCloseSound.Parent = script.Parent
DoorCloseSound.PlayOnRemove = true



function Door:Init()

end

function Door:Triggered(prompt : ProximityPrompt, player : Player)

    local hinge = prompt.Parent.Parent :: BasePart

    local open = hinge:GetAttribute("Open")

    local hingeConstraint = hinge:FindFirstChildOfClass("HingeConstraint")
    hingeConstraint.TargetAngle = 0
    hingeConstraint.ServoMaxTorque = 10000
    hingeConstraint.AngularSpeed = 50

    if open then
        hingeConstraint.TargetAngle = 0
        hinge:SetAttribute("Open", false)
        local newSound = DoorCloseSound:Clone()
        newSound.Parent = hinge
        task.defer(function()
            newSound:Destroy()
        end)
    else
        hingeConstraint.TargetAngle = 100
        hinge:SetAttribute("Open", true)
        local newSound = DoorOpenSound:Clone()
        newSound.Parent = hinge
        task.defer(function()
            newSound:Destroy()
        end)
    end

    local door = hingeConstraint.Attachment1.Parent :: BasePart
    door:SetNetworkOwner(player)

end

return Door