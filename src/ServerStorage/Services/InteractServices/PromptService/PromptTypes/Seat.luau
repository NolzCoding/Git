local Seat = {}

function Seat:Init()

end

function Seat:Triggered(prompt : ProximityPrompt, player : Player)

    local seat = prompt.Parent :: Seat

    seat:Sit((player :: any).Character.Humanoid)

end

return Seat