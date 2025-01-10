local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local NexusInstance = require(game:GetService("ReplicatedStorage").Source.Shared.Uitility.NexusInstance)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(ReplicatedStorage.Packages.Promise)

local Maps = require(ReplicatedStorage.Source.Shared.Maps)

local GameSession = {}
GameSession.__index = GameSession
GameSession.States = {}

-- Spawn a new map for the session
-- load the map
-- load the items
-- load the players & devide them into teams, add gamesession to their character object

local GameSessionSlot = workspace.GameSessionSlots

export type GameSessionState = "ChoosingMap" | "Loading" | "Starting" | "Playing" | "Ending" | "Cleanup"
--Exported test class type and Nexus Instance version (optional).
export type GameSession = {
    Players: {Player},
    CharacterService: typeof(Knit.GetService("CharacterService")),
    Map : typeof(ServerStorage.House),
    State : string,
    GameSlot : Part,
    States : {
        ChoosingMap : (self: NexusInstanceGameSession, slot : Part) -> Model,
        Loading : (self: NexusInstanceGameSession, map : Model) -> (),
        Starting : (self: NexusInstanceGameSession) -> (),
        Playing : (self: NexusInstanceGameSession) -> (),
        Ending : (self: NexusInstanceGameSession) -> (),
        Cleanup : (self: NexusInstanceGameSession) -> (),
    },

    OnStateUpdate: NexusInstance.TypedEvent<string, string, number>,
    OnScoreUpdate: NexusInstance.TypedEvent<any>,
    OnVoteUpdate: NexusInstance.TypedEvent<{
        {
            Players : {Player},
            Name : string,
            Image : string,
        }
    }>,
    OnPlayerVote: NexusInstance.TypedEvent<Player, number>,
    SpawnItem : (self: NexusInstanceGameSession, itemName : string) -> (),

} & typeof(setmetatable({}, GameSession))
export type NexusInstanceGameSession = NexusInstance.NexusInstance<GameSession>

--Optional constructor when `new` is called.
function GameSession.__new(self: NexusInstanceGameSession, players: {Player}): ()
    self.Players = players
    self.CharacterService = Knit.GetService("CharacterService")
    -- stateName : string, stateText : string, time : number
    self.OnStateUpdate = self:CreateEvent() :: NexusInstance.TypedEvent<string, string, number>
    self.OnScoreUpdate = self:CreateEvent() :: NexusInstance.TypedEvent<any>
    self.OnVoteUpdate = self:CreateEvent() :: NexusInstance.TypedEvent<{
        {
            Players : {Player},
            Name : string,
            Image : string,
        }
    }>

    self.OnPlayerVote = self:CreateEvent() :: NexusInstance.TypedEvent<Player, number>

end

local function findEmptySlot() : Part?
    for _, slot in ipairs(GameSessionSlot:GetChildren()) do

        local slotOccupied = #slot:GetChildren() > 0
        if not slotOccupied then

            return slot

        end

    end
    return nil
end

local function _newVoteTable()

    local maptbl = {
    }

    for _,v in ipairs(Maps.Maps) do

        table.insert(maptbl, {
            Players = {},
            Name = v.Name,
            Image = v.Image,
        })

    end

    return maptbl

end

function GameSession.SpawnItem(self: NexusInstanceGameSession, itemName : string): ()
    --! meant to be overriden
end

function GameSession.ReviveBaby(self: NexusInstanceGameSession, graveStone : BasePart): ()
    local cframe = graveStone.CFrame

    local plrid = graveStone:GetAttribute("PlayerID") :: number
    local player = game.Players:GetPlayerByUserId(plrid)
    player.Character:Destroy()
    player:LoadCharacter()
    self.CharacterService:NewCharacter(player, "Baby")

    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = cframe

end

function GameSession.Start(self: NexusInstanceGameSession): ()

    return Promise.new(function(resolve, reject)
        local slot = findEmptySlot()
        self.GameSlot = slot -- can be nil but who cares, i dont lol, i dont care about nils, i dont care about anything, i dont care about you, i dont care about me
        local matTable = _newVoteTable()
        local map = self.States.ChoosingMap(self,slot, matTable)
        self.Map = map
        self.States.Loading(self,map)
        self.States.Starting(self)
        local winningTeam = self.States.Playing(self)
        self.States.Ending(self, winningTeam)
        self.States.Cleanup(self)
        resolve()
    end):finally(function()
        print("Destorying game session")
        self:Destroy()
    end)

end

--Custom function.

--Optional destroy function to clear resources.
--Events are cleaned internally (`Changed`, `GetPropertyChangedSignal`, and `CreateEvent` only).
--The version returned by NexusInstance.ToInstance will always have a Destroy method.
function GameSession.Destroy(self: NexusInstanceGameSession): ()
    --Clear resources.
end

--Create the class to return in the ModuleScript, or use within the script.
--The constructor (second generic type) should match inputs for `__new` without the `self`.
return NexusInstance.ToInstance(GameSession) :: NexusInstance.NexusInstanceClass<typeof(GameSession), (players: {Player}) -> (NexusInstanceGameSession)>