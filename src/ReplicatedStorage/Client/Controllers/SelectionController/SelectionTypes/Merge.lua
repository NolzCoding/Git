local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local FoodCounter = {}




FoodCounter.Visual = script.Parent.Parent.HighlightVisual

function FoodCounter:Init(SelectionController)
    self.SelectionController = SelectionController
    self.SelectionService = Knit.GetService("SelectionService")
end

function FoodCounter:Hover(Selection)
  print("Hovering")
end

function FoodCounter:UnHover(Selection)

end

function FoodCounter:Click(Selection : BasePart)



    --self.SelectionService:SelectionClicked(Selection, "Merge"):andThen(function()

  --end)

end



return FoodCounter