local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SelectionVisual = {}

local Interact = script.Parent.Interact
local InteractClone = nil

local InteractSurfaceGui : SurfaceGui = nil
local InteractImageLabel : ImageLabel = nil


local InitiatedSize = UDim2.new(0.2, 0, 0.2, 0)

local NormalSize = UDim2.new(0.5, 0, 0.5, 0)

local HoverSize = UDim2.new(0.6, 0, 0.6, 0)

local ClickSize = UDim2.new(0.4, 0, 0.4, 0)

local HoverTween = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local ClickTween = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local InitiatedTween = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

function SelectionVisual:Init(SelectionController)

    InteractClone = Interact:Clone()

    InteractClone.Parent = workspace

    InteractSurfaceGui = InteractClone:WaitForChild("SurfaceGui")

    InteractImageLabel = InteractSurfaceGui:WaitForChild("ImageLabel")

end

function SelectionVisual:Clicked(Selection, InteractedLast)

    local startSize = InteractImageLabel.Size

    if InteractedLast ~= Selection then
        startSize = InitiatedSize
    end

    InteractedLast = Selection

    InteractImageLabel.Size = startSize

    InteractClone.CFrame = Selection.CFrame - Vector3.new(0,1,0) * Selection.Size.Y/2

    TweenService:Create(InteractImageLabel, ClickTween, {Size = ClickSize}):Play()


    task.wait(0.2)
    TweenService:Create(InteractImageLabel, ClickTween, {Size = NormalSize}):Play()

end

function SelectionVisual:Hovered(Selection, InteractedLast)

    print("Hovered")

    local startSize = InteractImageLabel.Size

    if InteractedLast ~= Selection then
        startSize = InitiatedSize
    end

    InteractedLast = Selection


    InteractImageLabel.Size = startSize

    InteractClone.CFrame = Selection.CFrame - Vector3.new(0,1,0) * Selection.Size.Y/2
    TweenService:Create(InteractImageLabel, HoverTween, {Size = HoverSize}):Play()

end

function SelectionVisual:UnHovered(Selection)



    InteractClone.CFrame = CFrame.new() --Selection.CFrame - Vector3.new(0,1,0) * Selection.Size.Y/2

    TweenService:Create(InteractImageLabel, HoverTween, {Size = NormalSize}):Play()



end



return SelectionVisual