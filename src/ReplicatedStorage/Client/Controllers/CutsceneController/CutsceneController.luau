local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local CutsceneController = Knit.CreateController {
    Name = "CutsceneController";
}

function CutsceneController:KnitInit()
    local Cutscenes = {
        MomGoAway = require(script.Parent.Cutscenes.MomGoAway)
    }
    if true then return end

    task.delay(10, function()
        Cutscenes.MomGoAway:Start()
    end)

end

function CutsceneController:KnitStart()
    print("CutsceneController KnitStart")
end

return CutsceneController