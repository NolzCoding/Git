local NexusInstance = require(game.ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local Teams = game:GetService("Teams")
local ReplicateStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicateStorage.Packages.Knit)
local Trove = require(ReplicateStorage.Packages.Trove)
local Promise = require(Knit.Util.Promise)
local CharacterBaseServer = require(game.ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local SpawnItems = require(ServerStorage.Source.Services.InteractServices.ItemService.SpawnItems)
local GamemodeBase = {}
GamemodeBase.__index = GamemodeBase

--Exported test class type and Nexus Instance version (optional).
export type GamemodeBase = {
    TIME : number,
    Players: {Player},
    Map : Model,
    UpdateState: (stateName : string, stateText : string, time : number) -> (),
    StartBabyBucks: () -> (),
    OnGameEnded: NexusInstance.TypedEvent<
        Team,
        {
            Alive: {Player},
            Dead: {Player}
        },
        {
            Alive: {Player},
            Dead: {Player}
        }
    >,
    OnBabyDied: NexusInstance.TypedEvent<Player>,
    OnParentDied: NexusInstance.TypedEvent<Player>,
    BabyTeam: Team,
    ParentTeam: Team,
    BabyBucksFolder: Folder,
    BabyBuckPromise: Promise,
    ParentSpawn : SpawnLocation,
    BabySpawn : SpawnLocation,
    Parents: {
        Alive: {Player},
        Dead: {Player}
    },
    Babies: {
        Alive: {Player},
        Dead: {Player}
    },
    CharacterService: {
        GetCharacter: (self : any ,player : Player) -> (CharacterBaseServer.CharacterBaseServer),
        NewCharacter: (self : any, player : Player, characterName : string) -> (CharacterBaseServer.CharacterBaseServer)
    },
    Trove: typeof(Trove.new()),

} & typeof(setmetatable({}, GamemodeBase))
export type NexusInstanceGamemodeBase = NexusInstance.NexusInstance<GamemodeBase>


function GamemodeBase.LoadMap(self : NexusInstanceGamemodeBase)
    self.Map = self.Map:Clone()
    self.Map.Parent = workspace
end

--Optional constructor when `new` is called.
function GamemodeBase.__new(self: NexusInstanceGamemodeBase, players : {Player}, Map : Model, UpdateState : (stateName : string, stateText : string, time : number, ...any) -> ())
    self.UpdateState = UpdateState
    self.Players = players
    self.Map = Map
    self.CharacterService = Knit.GetService("CharacterService")
    self.AwardService = Knit.GetService("AwardService")

    local randomPlayerAsParent = players[math.random(1, #players)]

    self.OnGameEnded = self:CreateEvent()
    self.OnBabyDied = self:CreateEvent()
    self.OnParentDied = self:CreateEvent()
    self.Trove = Trove.new()

    self:LoadMap()

    self.ParentTeam = Instance.new("Team")
    self.ParentTeam.Name = "Parents"
    self.ParentTeam.Parent = Teams
    self.ParentTeam.AutoAssignable = false

    self.BabyTeam = Instance.new("Team")
    self.BabyTeam.Name = "Babies"
    self.BabyTeam.Parent = Teams
    self.BabyTeam.AutoAssignable = false

    self.BabyBucksFolder = self.Map:FindFirstChild("BabyBucks") :: Folder

    self.ParentSpawn = self.Map.Spawns.Parents :: SpawnLocation --! be careful with naming becasue parent is a reserved property of instances in roblox
    self.BabySpawn = self.Map.Spawns.Babies :: SpawnLocation

    self.Parents = {
        Alive = {},
        Dead = {}
    }
    self.Babies = {
        Alive = {},
        Dead = {}
    }

    self.Trove:Add(self.ParentTeam)
    self.Trove:Add(self.BabyTeam)
    print(self.ParentSpawn)
    for _, player in ipairs(players) do
        if player == randomPlayerAsParent then
            player.Team = self.ParentTeam
            player.RespawnLocation = self.ParentSpawn
            if player.Character then
                player.Character:Destroy()
            end
            player:LoadCharacter()
            local character = self.CharacterService:NewCharacter(player, "Parent")
            character.Died:Connect(function()
                self:ParentDied(player)
            end)
            table.insert(self.Parents.Alive, player)
        else
            player.Team = self.BabyTeam
            player.RespawnLocation = self.BabySpawn
            if player.Character then
                player.Character:Destroy()
            end
            player:LoadCharacter()
            local character = self.CharacterService:NewCharacter(player, "Baby")
            character.Died:Connect(function()
                self:BabyDied(player)
            end)
            table.insert(self.Babies.Alive, player)
        end
    end

    Players.PlayerRemoving:Connect(function(player: Player)
        local teamOfPlayer = player.Team

        if teamOfPlayer == self.ParentTeam then
            self.ParentDied(player)
        elseif teamOfPlayer == self.BabyTeam then
            self.BabyDied(player)
        end

    end)

    self.TIME = self.TIME or 100

    -- spawn items

    SpawnItems:Spawn()

    UpdateState("GameStart", "Game Started", self.TIME + workspace:GetServerTimeNow(), self.Parents, self.Babies)

    self:StartBabyBucks()

end

function GamemodeBase.BabyDied(self : NexusInstanceGamemodeBase, player : Player)

    local index = table.find(self.Babies.Alive, player)
    if index then
        table.remove(self.Babies.Alive, index)
        table.insert(self.Babies.Dead, player)
    end

    self.OnBabyDied:Fire(player)

    if #self.Babies.Alive == 0 then
        self:EndGame(self.BabyTeam)
    end

end

function GamemodeBase.StartBabyBucks(self : NexusInstanceGamemodeBase)

    local babybuck = script.Parent.BabyBuck

    local function _spawnBabyBucks()
        for _,v in ipairs(self.BabyBucksFolder:GetChildren()) do

            local maxBabyBucks = v:GetAttribute("Max") or 1 :: number
            if #v:GetChildren() == maxBabyBucks then
                continue
            end

            local newBabyBuck = babybuck:Clone()
            newBabyBuck.Parent = v

            local randomPosBySize = Vector3.new(math.random(-v.Size.X/2, v.Size.X/2), math.random(-v.Size.Y/2, v.Size.Y/2), math.random(-v.Size.Z/2, v.Size.Z/2))
            newBabyBuck.Position = v.Position + randomPosBySize

            local debounce = false

            newBabyBuck.Touched:Connect(function(part: BasePart)
                if part.Name ~= "HumanoidRootPart" then return end
                if debounce then return end

                local player = Players:GetPlayerFromCharacter(part.Parent)
                if not player then return end

                debounce = true

                local playerTeam = player.Team
                if playerTeam == self.ParentTeam then
                    return
                end

                newBabyBuck:Destroy()

                self.AwardService:GiveAward(player, "Cash", 100)

            end)

        end
    end

    self.BabyBuckPromise = Promise.new(function(resolve, reject)

        local TIME = 20

        while true do
            print("Spawning")
            _spawnBabyBucks()

            task.wait(TIME)

        end

    end)

end

function GamemodeBase.ParentDied(self :NexusInstanceGamemodeBase, player : Player)
    self.OnParentDied:Fire(player)
end

function GamemodeBase.EndGame(self : NexusInstanceGamemodeBase, winner : Team?)

    if winner == nil then -- nil means timer ran out and parents won
        self.OnGameEnded:Fire(self.ParentTeam, self.Parents, self.Babies)
    else
        self.OnGameEnded:Fire(winner, self.Babies, self.Parents)
    end
    self.Map:Destroy()
    self:Destroy()

end



--Custom function.


--Optional destroy function to clear resources.
--Events are cleaned internally (`Changed`, `GetPropertyChangedSignal`, and `CreateEvent` only).
--The version returned by NexusInstance.ToInstance will always have a Destroy method.
function GamemodeBase.Destroy(self: NexusInstanceGamemodeBase): ()
    self.Trove:Clean()

    self.BabyBuckPromise:Cancel()

    --Clear resources.
end

--Create the class to return in the ModuleScript, or use within the script.
--The constructor (second generic type) should match inputs for `__new` without the `self`.
return NexusInstance.ToInstance(GamemodeBase) :: NexusInstance.NexusInstanceClass<typeof(GamemodeBase), (players : {Player}, Map : Model, UpdateState : (stateName : string, stateText : string, time : number) -> () ) -> (NexusInstanceGamemodeBase)>