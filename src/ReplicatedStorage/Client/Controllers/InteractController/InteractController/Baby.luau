local Baby = {}

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

function Baby:Init()

    self.CharacterController = Knit.GetController("CharacterController")

end


function Baby:Shown(prompt : ProximityPrompt)

    local character = game.Players.LocalPlayer.Character
    local characterType = character:GetAttribute("Character")

    if (characterType or "") == "Baby" then
        prompt.Enabled = false
    end

end

function Baby:Hidden(prompt : ProximityPrompt)

end

function Baby:Triggered(prompt : ProximityPrompt)


end

return Baby