local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)

local Knit = require(ReplicatedStorage.Packages.Knit)

local ItemBase = {}
ItemBase.__index = ItemBase

--Exported test class type and Nexus Instance version (optional).

-- to handle prompts define PromptInteract method

export type ItemBase = {
    TestProperty: string?, --No constructor initializes this.
    VisualCache : Model?,
    Tool : Tool,
    Client : {},
} & typeof(setmetatable({}, ItemBase))
export type NexusInstanceItemBase = NexusInstance.NexusInstance<ItemBase>

export type ItemBaseClient = {
    Server : NexusInstanceItemBase,
    DropItem: (self: ItemBaseClient) -> (),
}



function ItemBase.__new(self: NexusInstanceItemBase, itemName: string, tool: Tool, madeFor : Player): ()
    self.ItemName = itemName
    self.Tool = tool
    self.Client = {}
    -- listen for the tool to be destroyed
    tool.Destroying:Connect(function()
        print("Destroying " .. itemName, " , module name" .. script.Parent.Name)
        self:Destroy() -- destroy the itemclass
    end)
    -- newRemoteFunction
    self.Remote = Instance.new("RemoteFunction")
    self.Remote.Parent = tool

    print(self.Remote, " remote created for", itemName, tool)

    self.Remote.OnServerInvoke = function(player, methodName, ...)
        local method = self.Client[methodName]
        if method then
            return method(self, player, ...)
        end
    end

    self.Client.ThrowItem = function (self: NexusInstanceItemBase, player : Player, serverTime : number)
        self.VisualCache.PrimaryPart:SetNetworkOwner(player)
        self.Tool:Destroy()
        -- get difference between server time now and the time the item was thrown
        --local timeDifference = workspace:GetServerTimeNow() - serverTime


    end

    self.Client.DropItem = function (self: NexusInstanceItemBase, player : Player)

        local ItemService = Knit.GetService("ItemService")

        ItemService:DropItem(player,self.Tool, self.ItemName)
        print("Ragdolling")
    end

end

function ItemBase.DisableCollisons(self: NexusInstanceItemBase): () -- This is a method. duh but what does it do? it disables collisions for the tool.
    for _, part in ipairs(self.Tool:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

function ItemBase.Equipped(self: NexusInstanceItemBase): ()
    -- implemented by subclasses

    if self.VisualCache then
        local player = Players:GetPlayerFromCharacter(self.Tool.Parent)
        if not player then return end
        self:DumpToVisual(self.VisualCache)
        self.VisualCache.PrimaryPart:SetNetworkOwner(player)
    end

end

function ItemBase.DumpToVisual(self: NexusInstanceItemBase, visual: Model)
    -- implemented by subclasses
end

function ItemBase.ConstructFromVisual(self: NexusInstanceItemBase, visual: Model): ()
    -- implemented by subclasses
end

--Custom function.
function ItemBase.ChangeValue(self: NexusInstanceItemBase, newValue: string): ()
    self.TestProperty = newValue
end

function ItemBase.SetVisualCache(self: NexusInstanceItemBase, visual: Model)
    self.VisualCache = visual

end
-- functions called by the client



--Create the class to return in the ModuleScript, or use within the script.
return NexusInstance.ToInstance(ItemBase) :: NexusInstance.NexusInstanceClass<typeof(ItemBase), () -> (NexusInstanceItemBase)>