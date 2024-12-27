local NexusInstance = require(game.ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local Teams = game:GetService("Teams")
local ReplicateStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicateStorage.Packages.Knit)
local Trove = require(ReplicateStorage.Packages.Trove)
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
    --Clear resources.
end

--Create the class to return in the ModuleScript, or use within the script.
--The constructor (second generic type) should match inputs for `__new` without the `self`.
return NexusInstance.ToInstance(GamemodeBase) :: NexusInstance.NexusInstanceClass<typeof(GamemodeBase), (players : {Player}, Map : Model, UpdateState : (stateName : string, stateText : string, time : number) -> () ) -> (NexusInstanceGamemodeBase)>