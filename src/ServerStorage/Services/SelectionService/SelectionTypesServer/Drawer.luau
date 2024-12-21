local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenServicePlus = require(ReplicatedStorage.Source.Shared.Uitility.TweenServicePlus)


local Knit = require(ReplicatedStorage.Packages.Knit)
local Drawer = {}


function Drawer:Init()

end

function Drawer:Hover(Selection : BasePart, player)

end

function Drawer:UnHover(Selection : BasePart, player)

end

local debounce = {

}

function Drawer:Click(Selection : BasePart, player)

    if debounce[Selection] then
        return
    end

    local Open = Selection:GetAttribute("Open")
    local distance = Selection:GetAttribute("Distance") or 1.5 -- studs
    local offset = Selection.CFrame.LookVector * (Open and -distance or distance)

    Selection:SetAttribute("Open", not Open)

    TweenServicePlus:Construct(Selection, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {CFrame = Selection.CFrame + offset}):Play()

    local sound = Selection:FindFirstChild("Close")
    if not Open then
        sound = Selection:FindFirstChild("Open")
    end
    sound:Play()
    debounce[Selection] = true
    task.delay(1, function()
        debounce[Selection] = false
    end)

end



return Drawer