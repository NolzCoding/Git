local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Locker = {}



Locker.Visual = script.Parent.Parent.HighlightVisual

function Locker:Init(SelectionController)
    self.SelectionController = SelectionController
    self.SelectionService = Knit.GetService("SelectionService")
end

function Locker:Hover(Selection)

end

function Locker:UnHover(Selection)

end

function Locker:Click(Selection : BasePart)



    self.SelectionService:SelectionClicked(Selection, "Locker"):andThen(function()

  end)

end



return Locker