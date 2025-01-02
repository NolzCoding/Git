local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)


local GamemodeBase = require(script.GamemodeBase)

local Promise = require(Knit.Util.Promise)

local GameService = Knit.CreateService {
    Name = "GameService",
    Client = {StateSignal = Knit.CreateSignal(),},

}

function GameService:UpdateState(stateName : string, stateText : string, time : number, ...)
    self.Client.StateSignal:FireAll(stateName, stateText, time, ...)
end

function GameService:NewGame() : GamemodeBase.GamemodeBase
    local players = Players:GetPlayers()
    local Map = game.ServerStorage.House
    local newGamemode = GamemodeBase.new(players, Map, function(stateName: string, stateText: string, time: number, ...)

        self:UpdateState(stateName, stateText, time, ...)
    end)

    return newGamemode

end

function GameService:KnitStart()

    if true then return end


    self.CharacterService = Knit.GetService("CharacterService")

    task.spawn(function()

        while true do


            self.Client.StateSignal:FireAll("WaitingForPlayer", "Waiting for more players to join", 0)
            while task.wait(1) do
                self.Client.StateSignal:FireAll("WaitingForPlayer", "Waiting for more players to join", 0)

                if #Players:GetPlayers() > 0 then
                    break
                end
            end

            self:UpdateState("Starting", "Intermission", workspace:GetServerTimeNow() + 100)
            task.wait(100)
            self:UpdateState("Starting", "Loading Map & Starting Game", 0)
            local newGame = self:NewGame() :: GamemodeBase.GamemodeBase
            local time = newGame.TIME
            task.delay(time, function()
                if not newGame then
                    return -- game already ended
                end
                newGame:EndGame()
            end)

            local function _teleportToSpawn(player : Player)
                local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
                player.RespawnLocation = spawn
                if player.Character then
                    player.Character:Destroy()
                end
                player:LoadCharacter()
            end

            newGame.OnBabyDied:Connect(function(player)
                _teleportToSpawn(player)
            end)

            newGame.OnParentDied:Connect(function(player)
                _teleportToSpawn(player)
            end)

            local _team, _winners, _losers = newGame.OnGameEnded:Wait()

            for _, player in ipairs(_winners.Alive) do
                _teleportToSpawn(player)
            end

            for _, player in ipairs(_losers.Alive) do
                _teleportToSpawn(player)
            end

        end

    end)

end

function GameService:KnitInit()
end

return GameService