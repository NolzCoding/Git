local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local ItemUi = require(script.ItemUi)
local Promise = require(ReplicatedStorage.Packages.Knit).Util.Promise
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children, peek = Fusion.Children, Fusion.peek
local ItemDescription = require(script.ItemDescription)
local ItemBaseClient = {}
ItemBaseClient.__index = ItemBaseClient

--Exported test class type and Nexus Instance version (optional).


export type ItemBaseClient = {
    TestProperty: string?, --No constructor initializes this.
    ItemName: string,
    CashedVisual: Model?,
    Tool : Tool,
    Remote: RemoteFunction,
    Connections: {RBXScriptConnection},
    BuildUI: (scope : any) -> (),
    Server : {
        DropItem: (self: ItemBaseClient) -> (),
    },
    EquippedConnections: {RBXScriptConnection}?,
    OnEquipped : (() -> {RBXScriptConnection}),
    OnUnequipped : (() -> ()),
    ItemDescription: {
        Name: string,
        Description: string,
        Effects: {
            Lungs: number,
            Heart: number,
            Stomach: number,
        }
    },
    Equipped: (self: ItemBaseClient) -> (),
    Unequipped: (self: ItemBaseClient) -> (),

} & typeof(setmetatable({}, ItemBaseClient))
export type NexusInstanceItemBaseClient = NexusInstance.NexusInstance<ItemBaseClient>




function ItemBaseClient.__new(self: NexusInstanceItemBaseClient, itemName: string, tool: Tool, cashedVisual : Model?): () -- cashed visual is optional needs a primary part
    self.Events = {}
    self.ItemName = itemName
    self.CashedVisual = cashedVisual
    self.Tool = tool
    self.Connections = {}
    self.ItemDescription = self.ItemDescription or {
        Name = "Item",
        Description = "This is an item",
        Effects = {
            Lungs = 25,
            Heart = 25,
            Stomach = 0,
        }
    }
    self.BuildUI = self.BuildUI or function()

    end
    -- listen for the tool to be destroyed
    tool.Destroying:Connect(function()
        self:Destroy() -- destroy the itemclass
    end)

    -- also listen for tool to be parented to backpack or character otherwise destroy

    local dropitem = nil

    tool.Equipped:Connect(function()
        dropitem = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Q then
                self:DropItem()
            end
        end)
        self:Equipped()
    end)

    tool.Unequipped:Connect(function()
        if dropitem then
            dropitem:Disconnect()
        end
        self:Unequipped()
    end)

    -- newRemoteFunction
    self.Remote = tool:WaitForChild("RemoteFunction")

    local serverMetaTable = {
        __index = function(table, index)
            return function (...)
                return self.Remote:InvokeServer(index, ...)
            end
        end,
    }

    self.Server = setmetatable({}, serverMetaTable)


end

function ItemBaseClient.DropItem(self: NexusInstanceItemBaseClient)
    self.Server.DropItem()
end

function ItemBaseClient.ThrowItem(self: NexusInstanceItemBaseClient, input: InputObject)

    local serverTime = Workspace:GetServerTimeNow()
    local cashedVisual = self.CashedVisual

    cashedVisual:PivotTo(self.Tool:GetPivot())

    local rootCFrame = Players.LocalPlayer.Character.HumanoidRootPart.CFrame

    cashedVisual.PrimaryPart.AssemblyLinearVelocity = (rootCFrame.LookVector * 50) + Vector3.new(0, 25, 0)

    if not cashedVisual then
        self.Server.ThrowItem(serverTime)
        return
    end

    self.Server.ThrowItem()
end

function ItemBaseClient.Equipped(self: NexusInstanceItemBaseClient)



    self.scope = Fusion.scoped(Fusion)

    self.scope : New "ScreenGui" {
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
        Name = "ItemUI",
        IgnoreGuiInset = true,
        ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,

        [Children] = {
            ItemUi(self.scope, {
                ButtonUp = function()
                    self:DropItem()
                end
            }),

            ItemDescription(self.scope,  {
                Name = self.ItemDescription.Name,
                Description = self.ItemDescription.Description,
                Effects = self.ItemDescription.Effects,
            }),

            self.BuildUI(self.scope)
        }
    }

    if self.OnEquipped then

        if self.EquippedConnections then
            for _, connection in pairs(self.EquippedConnections) do
                connection:Disconnect()
            end
        end

        self.EquippedConnections = self:OnEquipped()

    end


end

function ItemBaseClient.Unequipped(self: NexusInstanceItemBaseClient)

    self.scope:doCleanup()

    if self.EquippedConnections then
        for _, connection in pairs(self.EquippedConnections) do
            connection:Disconnect()
        end
    end

    self.EquippedConnections = nil

    if self.OnUnequipped then


        self:OnUnequipped()
    end

end



--Custom function.

function ItemBaseClient.Destroy(self: NexusInstanceItemBaseClient): ()
    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end

    if self.EquippedConnections then
        for _, connection in pairs(self.EquippedConnections) do
            connection:Disconnect()
        end
    end

    print("Destroying item client")



end
-- functions called by the client


--Create the class to return in the ModuleScript, or use within the script.
return NexusInstance.ToInstance(ItemBaseClient) :: NexusInstance.NexusInstanceClass<typeof(ItemBaseClient), () -> (NexusInstanceItemBaseClient)>