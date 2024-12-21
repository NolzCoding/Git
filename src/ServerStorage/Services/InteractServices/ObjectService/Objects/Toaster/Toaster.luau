local TweenService = game:GetService("TweenService")
local BaseCharacter = require(game.ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local Toaster = {}
local Knit = require(game.ReplicatedStorage.Packages.Knit)

function Toaster:Init()
    self.CharacterService = Knit.GetService("CharacterService")
--    local character = Knit.GetService("CharacterService"):GetCharacter(player) :: BaseCharacter.CharacterBaseServer

end

local function _newDragger()
    local dragDetector = Instance.new("DragDetector")
    dragDetector.Name = "DragDetector"
    dragDetector.MaxForce = 2000
    dragDetector.Responsiveness = 200
    --dragDetector.DragStyle = Enum.DragDetectorDragStyle.Scriptable

    --[[local maxDistance = 10 -- Set your desired max distance here

    dragDetector:SetDragStyleFunction(function(ray : Ray)
        local planeNormal = ray.Direction -- Assuming the view plane is horizontal
        local planePoint = dragDetector.Parent.Position -- The point on the plane is the position of the dragged part
        local rayDirection = ray.Direction
        local rayOrigin = ray.Origin

        -- Calculate the intersection of the ray with the plane
        local t = (planePoint - rayOrigin):Dot(planeNormal) / rayDirection:Dot(planeNormal)
        local intersection = rayOrigin + t * rayDirection

        -- Calculate the new CFrame based on the intersection point
        local newCFrame = CFrame.new(intersection)

        -- Calculate the distance from the original position
        local distance = (intersection - planePoint).Magnitude

        -- If the distance is greater than the max distance, adjust the intersection point
        if distance > maxDistance then
            local direction = (intersection - planePoint).Unit
            intersection = planePoint + direction * maxDistance
            newCFrame = CFrame.new(intersection)
        end

        return newCFrame
    end)

    return dragDetector]]

    return dragDetector

end

local defaultProperties = {
    Outlet = nil
}

function Toaster:DisconnectFromOutlet(toasterObject, outletObject, player : Player)

    local toaster = toasterObject
    local small : BasePart = toaster.Small
    local big : BasePart = toaster.Big

    small.Anchored = false

    if player then
        small:SetNetworkOwner(player)
        big:SetNetworkOwner(player)
    end

    local dragDetector = small:FindFirstChildOfClass("DragDetector")
    dragDetector.Enabled = true


end

function Toaster:ConnectToOutlet(toasterObject, outletObject)

    local toaster = toasterObject
    local small : BasePart = toaster.Small
    local big : BasePart = toaster.Big



    if small.Anchored then
        return
    end

    small:SetNetworkOwner()
    big:SetNetworkOwner()

    small.Anchored = true
    local dragDetector = small:FindFirstChildOfClass("DragDetector")
    dragDetector.Enabled = false
    TweenService:Create(small, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {CFrame = outletObject.MeshPart.Part.Attachment.WorldCFrame}):Play()

    return toasterObject

end

function Toaster:Instance(CFrame : CFrame, Parent : Instance, AddPropertiesCallback : (Instance) -> nil)

    local new  = script.Parent.Model:Clone()
    local dragDetector = _newDragger()
    dragDetector.Parent = new.Small

    local dragDetector2 = _newDragger()
    dragDetector2.Parent = new.Big

    AddPropertiesCallback(new or defaultProperties) -- load properties
    new:PivotTo(CFrame)
    new.Parent = Parent

    new:SetAttribute("ObjectType", "Toaster")

    -- setup connections

    local function _onDragStopped(player : Player)
        local character = self.CharacterService:GetCharacter(player) :: BaseCharacter.CharacterBaseServer
        character:UnBindPartFromIKControl("RightArm")
    end

    dragDetector.DragStart:Connect(function(playerWhoDragged)
        new.Small:SetNetworkOwner(playerWhoDragged)
        new.Big:SetNetworkOwner(playerWhoDragged)

        local character = self.CharacterService:GetCharacter(playerWhoDragged) :: BaseCharacter.CharacterBaseServer
        character:BindPartToIKControl("RightArm", new.Small)

    end)


    dragDetector2.DragStart:Connect(function(playerWhoDragged)
        new.Small:SetNetworkOwner(playerWhoDragged)
        new.Big:SetNetworkOwner(playerWhoDragged)

        local character = self.CharacterService:GetCharacter(playerWhoDragged) :: BaseCharacter.CharacterBaseServer
        character:BindPartToIKControl("RightArm", new.Big)

    end)

    dragDetector.DragEnd:Connect(_onDragStopped)
    dragDetector2.DragEnd:Connect(_onDragStopped)


    return new

end

return Toaster