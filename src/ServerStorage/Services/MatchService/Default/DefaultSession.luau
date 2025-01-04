local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local NexusInstance = require(game:GetService("ReplicatedStorage").Source.Shared.Uitility.NexusInstance)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(ReplicatedStorage.Packages.Promise)

local SpawnItems = require(ServerStorage.Source.Services.InteractServices.ItemService.SpawnItems)

local DefaultSession = {}
DefaultSession.__index = DefaultSession

local GameSession = require(script.Parent.Parent.GameSession)


setmetatable(DefaultSession, GameSession) --TestClass1NexusInstance would be returned instead of TestClass1.


export type DefaultSession = {

    HandleGame : (self : NexusInstanceDefaultSession, callback : () -> any) -> (),
    Trove : typeof(Trove.new()),
    Parents : {

        Alive : {Player},
        Dead : {Player}

    },
    Babies : {

        Alive : {Player},
        Dead : {Player}

    }

} & typeof(setmetatable({}, DefaultSession)) & GameSession.GameSession
export type NexusInstanceDefaultSession = NexusInstance.NexusInstance<DefaultSession>

function DefaultSession.__new(self: NexusInstanceDefaultSession, players: {Player})
    GameSession.__new(self, players) --Remember to call the parent constructor!

    self.Trove = Trove.new()

    self.Parents = {
        Alive = {},
        Dead = {}
    }
    self.Babies = {
        Alive = {},
        Dead = {}
    }
    self:Start():andThen(function()
        print("started")
    end):catch(function(err)
        warn(err)
    end)

end

function DefaultSession:SpawnPlayer(player : Player, spawnPoint : Part, characterType : string) : ()

    player:AddTag("InGame")
    if player.Character then
        player.Character:Destroy()
    end

    player:LoadCharacter()

    local newChar = self.CharacterService:NewCharacter(player, characterType)
    newChar.GameSession = self

    task.defer(function()

        local character = player.Character
        local root = character:WaitForChild("HumanoidRootPart")
        root.CFrame = spawnPoint.CFrame + Vector3.new(0, 5, 0)

    end)

end

function DefaultSession.SpawnItem(self : NexusInstanceDefaultSession, itemName : string ) : ()
    return SpawnItems:SpawnIndividualItem(itemName, self.Map)
end

function DefaultSession.States.ChoosingMap(self :  NexusInstanceDefaultSession, slot : Part) : Model

    self.OnStateUpdate:Fire("ChoosingMap", "Choosing map", workspace:GetServerTimeNow() + 5)

    local map = ServerStorage.House
    wait(1)
    return map
end

function DefaultSession.States.Loading(self : NexusInstanceDefaultSession, map : Model) : ()

    self.OnStateUpdate:Fire("Loading", "Loading map", workspace:GetServerTimeNow() + 5)
    local cloneMap = map:Clone()
    cloneMap.Parent = self.GameSlot
    cloneMap:PivotTo(self.GameSlot.CFrame)
    self.Map = cloneMap

end

function DefaultSession.States.Starting(self : NexusInstanceDefaultSession) : ()

    local parentSize = 1
    if #self.Players >= 4 then
        parentSize = 2
    end

    -- pickout random players for team 1

    local copyPlayers = table.clone(self.Players)

    for i = 1, parentSize do
        local player = table.remove(copyPlayers, math.random(1, #copyPlayers))
        table.insert(self.Parents.Alive, player)
    end

    -- add the rest of the players to team 2

    for _, player in ipairs(copyPlayers) do
        table.insert(self.Babies.Alive, player)
    end

    -- spawn players

    for _, player in ipairs(self.Babies.Alive) do
        self:SpawnPlayer(player, self.Map.Spawns.Babies, "Baby")
    end

    for _, player in ipairs(self.Parents.Alive) do
        self:SpawnPlayer(player, self.Map.Spawns.Parents, "Parent")
    end
    print(self.Parents, self.Babies)
    self.OnStateUpdate:Fire("Starting", "Starting game", workspace:GetServerTimeNow() + 5, self.Parents, self.Babies)


    task.wait(5)

    SpawnItems:Spawn(self.Map)


end

function DefaultSession.HandleGame(self : NexusInstanceDefaultSession, callback : () -> any) : ()



    local function babyDied(player)

        -- check if its already dead
        local isDead = table.find(self.Babies.Dead, player)

        if isDead then
            return
        end

        table.remove(self.Babies.Alive, table.find(self.Babies.Alive, player))

        task.delay(0.1, function()
            if #self.Babies.Alive == 0 then
                callback()
            end
        end)

        -- spawn as a ghost

        -- destory old character

        local rootCFrame = player.Character.HumanoidRootPart.CFrame

        player.Character:Destroy()
        task.wait()
        player:LoadCharacter()
        self.CharacterService:NewCharacter(player, "Ghost")

        local newCharacter = player.Character
        local root = newCharacter:WaitForChild("HumanoidRootPart")
        root.CFrame = rootCFrame

    end

    for _,v in ipairs(self.Babies.Alive) do

        local healthAttributeNames = {
            "Lungs",
            "Heart",
            "Stomach"
        }

        local humanoid = v.Character.Humanoid :: Humanoid

        for _, healthAttributeName in ipairs(healthAttributeNames) do

            self.Trove:Connect(humanoid:GetAttributeChangedSignal(healthAttributeName),function()

                if humanoid:GetAttribute(healthAttributeName) <= 0 then

                    babyDied(v)

                end
            end)
        end

        self.Trove:Connect(v.Character.Humanoid.Died, function()
            babyDied(v)

        end)

        -- if leaves game

        self.Trove:Connect(Players.PlayerRemoving, function(player : Player)

            if player == v then

                babyDied(v)

            end

        end)

        -- dead = when humanoid dies or when any of the 3 healthAttributes reach 0

    end

end

function DefaultSession.States.Playing(self : NexusInstanceDefaultSession) : ()

    self.OnStateUpdate:Fire("Playing", "Playing", workspace:GetServerTimeNow() + 100)

    local GAME_TIME = 100
    local winner = nil

    local function allBabiesDeadCallback()
        winner = self.Babies
        GAME_TIME = 0
    end

    self:HandleGame(allBabiesDeadCallback)

    while GAME_TIME > 0 do

        task.wait(1)
        GAME_TIME -= 1

    end

    winner = winner or self.Parents

    return winner

    -- returns the winner team


end

function DefaultSession.States.Ending(self : NexusInstanceDefaultSession, winningTeam : {Alive : {Player}, Dead : {Player}}) : ()

    local winningteamname = "Parents"
    print(winningTeam == self.Babies, "Did babies win?")
    if winningTeam == self.Babies then
        winningteamname = "Babies"
    end


    for _, player in ipairs(self.Players) do
        player:RemoveTag("InGame")
    end
    self.OnStateUpdate:Fire("Ending", "Ending", workspace:GetServerTimeNow() + 5, winningteamname)
    task.wait(5)

end

function DefaultSession.States.Cleanup(self : NexusInstanceDefaultSession) : ()

    self.Map:Destroy()

    for _, player in ipairs(self.Players) do
        player:RemoveTag("InGame")
    end

    self.Parents = nil
    self.Babies = nil

    self.OnStateUpdate:Fire("Cleanup", "Cleanup", workspace:GetServerTimeNow() + 5)

end

function DefaultSession.Destroy(self : NexusInstanceDefaultSession) : ()
    self.Parents = nil
    self.Babies = nil
    self.Map = nil
    self.GameSlot = nil
    self.Trove:Clean()
    GameSession.Destroy(self)
end

return NexusInstance.ToInstance(DefaultSession) :: NexusInstance.NexusInstanceClass<typeof(DefaultSession), (players : {Player}) -> (NexusInstanceDefaultSession)>

