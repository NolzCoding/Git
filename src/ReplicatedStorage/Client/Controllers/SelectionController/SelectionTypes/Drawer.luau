local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Drawer = {}

Drawer.Visual = script.Parent.Parent.HighlightVisual

function Drawer:Init(SelectionController)
    self.SelectionController = SelectionController
    self.SelectionService = Knit.GetService("SelectionService")
end

function Drawer:Hover(Selection)
  print("Hovering")
end

function Drawer:UnHover(Selection)

end

function Drawer:Click(Selection : BasePart)

    self.SelectionService:SelectionClicked(Selection, "Drawer"):andThen(function()

    end)

end

return Drawer
