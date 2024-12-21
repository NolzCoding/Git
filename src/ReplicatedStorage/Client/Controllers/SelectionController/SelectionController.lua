local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
local HapticService = game:GetService("HapticService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local SelectionController = Knit.CreateController{Name = "SelectionController"}

local InteractedLastVisual = nil
local InteractedLast = nil

-- settings


local SelectBan = nil



function SelectionController:SelectionClicked(Selection : BasePart)

    if SelectBan == Selection then
        return
    end

    local name = "Selection"

    for _, v in ipairs(Selection:GetTags()) do
        if self.Handlers[v] and v ~= "Selection" then
            name = v
            break
        end
    end

    if InteractedLast and InteractedLastVisual then
        -- handle deselecting the last selection
        InteractedLastVisual:UnHovered(InteractedLast)

    end

    -- handle selecting the new selection

    InteractedLastVisual = self.Handlers[name].Visual

    InteractedLastVisual:Clicked(Selection, InteractedLast) -- pass last selected incase of clicking the same thing
    InteractedLast = Selection

    self.Handlers[name]:Click(Selection)

    -- end?



end

function SelectionController:SelectionHovered(Selection : BasePart)

    if SelectBan == Selection then
        return
    end

    local name = "Selection"

    for _, v in ipairs(Selection:GetTags()) do
        if self.Handlers[v] and v ~= "Selection" then
            name = v
            break
        end
    end

    if InteractedLast and InteractedLastVisual then
        -- handle deselecting the last selection
        InteractedLastVisual:UnHovered(InteractedLast)

    end

    -- handle selecting the new selection

    InteractedLastVisual = self.Handlers[name].Visual

    InteractedLastVisual:Hovered(Selection, InteractedLast) -- pass last selected incase of clicking the same thing
    InteractedLast = Selection

    --#endregion



    self.Handlers[name]:Hover(Selection)

end

function SelectionController:SelectionUnHovered(Selection : BasePart)

    if SelectBan == Selection then
        return
    end

    local name = "Selection"

    for _, v in ipairs(Selection:GetTags()) do
        if self.Handlers[v] and v ~= "Selection" then
            name = v
            break
        end
    end

    InteractedLastVisual = nil
    InteractedLast = nil
    self.Handlers[name].Visual:UnHovered(Selection, InteractedLast) -- pass last selected incase of clicking the same thing


    self.Handlers[name]:UnHover(Selection)

end

function SelectionController:UnselectCurrent(Object)
    SelectBan = Object
    --InteractClone.CFrame = CFrame.new(0, 0, 0)

end


function SelectionController:KnitInit()

    self.Handlers = {}



end

function SelectionController:RegisterSelection(selectionHandler, name)

    local SelectionModule = require(selectionHandler)
    SelectionModule:Init(SelectionController)

    self.Handlers[name] = SelectionModule

    return SelectionModule

end

function SelectionController:KnitStart()


    --local UIController = Knit.GetController("UIController")

    local VisualsMap = {}

    for _, selectionHandler in ipairs(script.Parent.SelectionTypes:GetChildren()) do

        if selectionHandler.ClassName == "ModuleScript" then

            local name = string.gsub(selectionHandler.Name, ".lua", "")

            local module = self:RegisterSelection(selectionHandler, name)

            local visual = module.Visual or script.Parent.SelectionVisual

            if VisualsMap[visual] then
                module.Visual = VisualsMap[visual]
            else
                local Visual = require(visual)
                Visual:Init(self)
                VisualsMap[visual] = Visual
                module.Visual = Visual
            end

        end

    end

    local mouse = game.Players.LocalPlayer:GetMouse()

    local lasthovered = nil

    mouse.Move:Connect(function() -- handle hover

        local Selection = mouse.Target

        if Selection == nil then
            if lasthovered then self:SelectionUnHovered(lasthovered); lasthovered = nil  end return
        end

        if lasthovered ~= Selection then self:SelectionUnHovered(lasthovered) lasthovered = nil   end
        if not Selection:HasTag("Selection") then return end


        if lasthovered == Selection then return end

        lasthovered = Selection
        self:SelectionHovered(Selection)

    end)


    UserInputService.InputBegan:Connect(function(input, gameProcessed)

        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

            local Selection = mouse.Target

            if Selection and Selection:HasTag("Selection") then

                self:SelectionClicked(Selection)

            end

        end

    end)

    -- create indicator

    local objects = CollectionService:GetTagged("Selection")
    local Indicator = game.Players.LocalPlayer.PlayerGui:WaitForChild("Indicator")

    for _,v in ipairs(objects) do
        Indicator:Clone().Parent = v
    end

    CollectionService:GetInstanceAddedSignal("Selection"):Connect(function(v)
        if v:FindFirstChild("Indicator") then return end
        Indicator:Clone().Parent = v
    end)




end

return SelectionController



