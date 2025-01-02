local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local MatchService = Knit.CreateService {
    Name = "MatchService",
    Client = {

        StateSignal = Knit.CreateSignal(),

    },
}

local GameSession = require(script.Parent.GameSession)
local DefaultSession = require(script.Parent.Default.DefaultSession)


function MatchService:KnitStart()

    local Gamepad = require(script.Parent.Gamepad)
    local GameLobby = require(script.Parent.GameLobby)

    self.CharacterService = Knit.GetService("CharacterService")

end

function MatchService:KnitInit()

end

function MatchService:NewGameSession(players : {Player})
    print("Starting new game session")
    local newGameSession = DefaultSession.new(players)

    newGameSession.OnStateUpdate:Connect(function(stateName : string, stateText : string, time : number, ...)

        if stateName == "Cleanup" then
            local players = newGameSession.Players
            for _, player in ipairs(players) do
                player.Character:Destroy()
                player:LoadCharacter()
                self.CharacterService:NewCharacter(player, "Baby")
            end
        end

        self.Client.StateSignal:FireAll(stateName, stateText, time, ...)
    end)

    return newGameSession

end

return MatchService