local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)

local ToolBar = require(script.ToolBar2)

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children, peek = Fusion.Children, Fusion.peek


local CharacterClient = {}
CharacterClient.__index = CharacterClient
CharacterClient.ServerSignal = {}

export type CharacterClient = {
    Remote: RemoteFunction,
    RemoteEvent: RemoteEvent,
    Connections : {
        [string] : RBXScriptConnection,
    },
    ServerSignal: {

    },
    ItemSlots : number,
    BuildUI : (scope : any) -> (),
    Server: {

    },
} & typeof(setmetatable({}, CharacterClient))
export type NexusInstanceCharacterClient = NexusInstance.NexusInstance<CharacterClient>

function CharacterClient.__new(self: NexusInstanceCharacterClient, character : Model, itemSlots : number): ()

    character.Destroying:Connect(function()
        print("Calling destroy")
        self:Destroy()
    end)
    self.Connections = {}
    self.Remote = character:WaitForChild("RemoteFunction")
    self.RemoteEvent = character:WaitForChild("RemoteEvent")
    local serverMetaTable = {
        __index = function(table, index)
            return function (...)
                return self.Remote:InvokeServer(index, ...)
            end
        end,
    }

    self.Server = setmetatable({}, serverMetaTable)

    self.RemoteEvent.OnClientEvent:Connect(function(method, ...: any)
        self.ServerSignal[method](self, ...)
    end)

    self.ItemSlots = itemSlots or 2

    self:CreateUI()

    self:HandleToolKeycodes()

end

function CharacterClient.ServerSignal:Test(self : NexusInstanceCharacterClient, soemthing : string): ()
    print(soemthing)

end

function CharacterClient.EquipToolFromSlot(self : NexusInstanceCharacterClient, index)

    local tools = peek(self.Tools)
    local tooltable = tools[index]

    if not tooltable then
        return
    end

    if Fusion.peek(self.EquippedTool) == tooltable.Tool then -- already equipped
        local humanoid = Players.LocalPlayer.Character:WaitForChild("Humanoid")
        humanoid:UnequipTools()
        self.EquippedTool:set(nil)
        return
    end

    self.EquippedTool:set(tooltable.Tool)

    -- equip for humanoid
    local humanoid = Players.LocalPlayer.Character:WaitForChild("Humanoid")
    if tooltable.Tool == nil then
        humanoid:UnequipTools()
        return
    end
    humanoid:EquipTool(tooltable.Tool)

end

local WORDS = {
    [0] = "Zero",
    [1] = "One",
    [2] = "Two",
    [3] = "Three",
    [4] = "Four",
    [5] = "Five",
    [6] = "Six",
    [7] = "Seven",
    [8] = "Eight",
    [9] = "Nine",
    [10] = "Ten",
}

local function _numberToWord(integer)
    return WORDS[integer]
end

function CharacterClient.HandleToolKeycodes(self : NexusInstanceCharacterClient)

    table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)

        for i = 1, self.ItemSlots do
            if Enum.KeyCode[_numberToWord(i)] == input.KeyCode then
                print(i)
                self:EquipToolFromSlot(i)
            end
        end

    end))

end

function CharacterClient.ToolAdded(self : NexusInstanceCharacterClient, Tool : Tool, equip : boolean?)

    -- check if tool already exists
    for _, tooltable in ipairs(peek(self.Tools)) do
        if tooltable.Tool == Tool then
            return
        end
    end

    -- check for empty slot

    local emptyIndex = nil

    for i, tooltable in ipairs(peek(self.Tools)) do
        if tooltable.Tool == nil then
            emptyIndex = i
            break
        end
    end

    if not emptyIndex then -- TODOD show notification
        print("no empty slot")
        return
    end

    local tools = peek(self.Tools)
    tools[emptyIndex] = {
        Tool = Tool,
    }

    self.Tools:set(tools)

    if equip then
        self:EquipToolFromSlot(emptyIndex)
    end

    return emptyIndex

end

function CharacterClient.ToolRemoved(self : NexusInstanceCharacterClient, Tool : Tool)

    local tools = peek(self.Tools)

    for i, tooltable in ipairs(tools) do
        if tooltable.Tool == Tool then
            tools[i] = {
                Tool = nil,
            }
            break
        end
    end

    if Fusion.peek(self.EquippedTool) == Tool then
        self.EquippedTool:set(nil)
    end

    self.Tools:set(tools)

end

function CharacterClient.CreateUI(self : NexusInstanceCharacterClient): ()

    self.scope = Fusion.scoped(Fusion)

    self.Tools = self.scope:Value({})

    for _ = 1, self.ItemSlots do

        local tools = peek(self.Tools)

        table.insert(tools, {
            Tool = nil,
        })

        self.Tools:set(tools)

    end

    if not self.BuildUI then
        print("is nil")
        self.BuildUI = function() end
    end
    self.EquippedTool = self.scope:Value(nil)
    self.scope:New "ScreenGui" {
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
        Name = "CharacterUI",
        ResetOnSpawn = false,
        [Children] = {
            ToolBar(self.scope, {
                Slots = self.ItemSlots,
                Tools = self.Tools,
                EquippedTool = self.EquippedTool,
                ClickedTool = function(index)
                        print(index)
                        self:EquipToolFromSlot(index)
                end,
            }),
            self.BuildUI(self.scope),
        }
    }

end

function CharacterClient.MorphInLobby(self: NexusInstanceCharacterClient, skinName): ()

    self.Server.Morph(skinName)

end

function CharacterClient.Destroy(self: NexusInstanceCharacterClient): ()
    self.scope:doCleanup()

    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end
end

return NexusInstance.ToInstance(CharacterClient) :: NexusInstance.NexusInstanceClass<typeof(CharacterClient), (character : Model, itemSlots : number) -> (NexusInstanceCharacterClient)>
