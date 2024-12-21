local ReplicatedStorage = game:GetService("ReplicatedStorage")


local Locker = {}

function Locker:Init()



end

function Locker:Hover(Selection : BasePart, player)

end

function Locker:UnHover(Selection : BasePart, player)

end

function Locker:Click(Selection : BasePart, player)

    local IsOpen = Selection:GetAttribute("Open")

    local desiredAngle = IsOpen and 0 or 90

    Selection:SetAttribute("Open", not IsOpen)

    local hingeContraint = Selection:FindFirstChildOfClass("HingeConstraint")

    hingeContraint.TargetAngle = desiredAngle

    Selection:SetNetworkOwner(player) -- set the network owner to the player who clicked it

end



return Locker