local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SelectionVisual = {}

local hoverTransparency = 0.5
local clickTransparency = 0

function SelectionVisual:Init(SelectionController)

    self.Highlight = Instance.new("Highlight")
    self.Highlight.Parent = script.Parent
    self.Highlight.OutlineColor = Color3.fromRGB(255, 174, 0)
    self.Highlight.FillTransparency = 1
    self.Highlight.FillColor = Color3.fromRGB(255, 209, 111)
    self.Highlight.OutlineTransparency = 1

end

function SelectionVisual:Clicked(Selection : BasePart, InteractedLast)

    local highLightedObject = Selection

    if Selection.Transparency == 1 then -- if the object is transparent, we want to highlight the parent since highlight doesnt work on transparent objects
        highLightedObject = Selection.Parent
    end

    if self.Highlight.Parent ~= highLightedObject then
        self.Highlight.FillTransparency = 1
        self.Highlight.OutlineTransparency = 1
    end

    TweenService:Create(self.Highlight, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {FillTransparency = clickTransparency, OutlineTransparency = clickTransparency}):Play()

    self.Highlight.Parent = highLightedObject

    task.delay(0.1, function()
        TweenService:Create(self.Highlight, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {FillTransparency = hoverTransparency, OutlineTransparency = hoverTransparency}):Play()
    end)

end

function SelectionVisual:Hovered(Selection, InteractedLast)

    local highLightedObject = Selection

    if Selection.Transparency == 1 then -- if the object is transparent, we want to highlight the parent since highlight doesnt work on transparent objects
        highLightedObject = Selection.Parent
    end

    self.Highlight.FillTransparency = 1
    self.Highlight.OutlineTransparency = 1

    TweenService:Create(self.Highlight, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {FillTransparency = hoverTransparency, OutlineTransparency = hoverTransparency}):Play()

    self.Highlight.Parent = highLightedObject

end

function SelectionVisual:UnHovered(Selection)

    TweenService:Create(self.Highlight, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false), {FillTransparency = 1, OutlineTransparency = 1}):Play()

    self.Highlight.Parent = script.Parent

end



return SelectionVisual