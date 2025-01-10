local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local MatchService = Knit.CreateService {
    Name = "MatchService",
    Client = {

        StateSignal = Knit.CreateSignal(),
        ScoreSignal = Knit.CreateSignal(),
        VoteSignal = Knit.CreateSignal(),
    },
}

local GameSession = require(script.Parent.GameSession)
local DefaultSession = require(script.Parent.Default.DefaultSession)


function MatchService:KnitStart()

    local Gamepad = require(script.Parent.Gamepad)
    local GameLobby = require(script.Parent.GameLobby)

    self.CharacterService = Knit.GetService("CharacterService")
    self.DataService = Knit.GetService("DataService")

end

function MatchService:KnitInit()

    self.Players = {}

    game.Players.PlayerRemoving:Connect(function(player : Player)
        self.Players[player] = nil
    end)

end

function MatchService:Vote(player : Player, map : number)



    local gameSession = self.Players[player] :: GameSession.GameSession

    if not gameSession then
        return
    end

    gameSession.OnPlayerVote:Fire(player, map)

end

function MatchService.Client:Vote(player : Player, map : number)
    self.Server:Vote(player, map)
end

function MatchService:NewGameSession(players : {Player})
    print("Starting new game session")
    local newGameSession = DefaultSession.new(players)

    newGameSession.OnStateUpdate:Connect(function(stateName : string, stateText : string, time : number, ...)
        print(stateName)
        if stateName == "Cleanup" then
            local players = newGameSession.Players
            for _, player : Player in ipairs(players) do


                if not player then
                    continue
                end
                if player.Character then
                    player.Character:Destroy()
                end

                if player:IsDescendantOf(game.Players) then
                    player:LoadCharacter()
                    self.CharacterService:NewCharacter(player, "Baby")
                end

            end
        end


        for _, player : Player in ipairs(newGameSession.Players) do
            if player then
                self.Client.StateSignal:Fire(player, stateName, stateText, time, ...)
            end
        end

    end)

    newGameSession.OnScoreUpdate:Connect(function(...)
        for _, player : Player in ipairs(newGameSession.Players) do
            if player then
                self.Client.ScoreSignal:Fire(player, ...)
            end
        end
    end)

    newGameSession.OnVoteUpdate:Connect(function(...)
        for _, player : Player in ipairs(newGameSession.Players) do
            if player then
                self.Client.VoteSignal:Fire(player, ...)
            end
        end
    end)

    for _,v in ipairs(players) do
        self.Players[v] = newGameSession
        if v.Character then
            v.Character:Destroy()
        end
    end

    newGameSession:Start():andThen(function()
        print("Game session ended")
    end):catch(function(err)
        warn(err)
    end)

    return newGameSession

end

return MatchService