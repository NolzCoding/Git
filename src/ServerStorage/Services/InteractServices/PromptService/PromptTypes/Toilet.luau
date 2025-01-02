local Toilet = {}

function Toilet:Init()

end

function Toilet:Triggered(prompt : ProximityPrompt, player : Player)

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    local stomach = humanoid:GetAttribute("Stomach")
    stomach -= 20
    stomach = math.clamp(stomach, 0, 100)
    humanoid:SetAttribute("Stomach", stomach)

end

return Toilet