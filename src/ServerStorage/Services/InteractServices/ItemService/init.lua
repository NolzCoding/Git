local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Knit = require(ReplicatedStorage.Packages.Knit)
local SpawnItems = require(script.SpawnItems)
local ServerStorage = game:GetService("ServerStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)
local CharacterBaseServer = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local ItemService = Knit.CreateService{Name = "ItemService" , Client = {
    ItemAdded = Knit.CreateSignal(),
}}

function ItemService:KnitInit()
    self.ItemObjectsIndex = {}
end

function ItemService:KnitStart()

    self.CharacterService = Knit.GetService("CharacterService")

end

function ItemService:GetItemFromTool(tool : Tool)
    return self.ItemObjectsIndex[tool]
end

function ItemService:DropItem(player : Player, tool : Tool, itemName : string)

    local class = script.Items[itemName]

    local visual = class.Visual
    local clone = visual:Clone()
    clone:PivotTo(tool:GetPivot())

    clone.Parent = workspace

    tool:Destroy()

end

function ItemService.Client:DropItem(player : Player, tool : Tool, itemName : string)

    local class = script.Items[itemName]

    local visual = class.Visual
    local clone = visual:Clone()
    clone:PivotTo(tool:GetPivot())

    clone.Parent = workspace

    tool:Destroy()


end

function ItemService:GiveItem(player : Player, itemName : string, equipOnSpawn : boolean)

    local character = self.CharacterService:GetCharacter(player) :: CharacterBaseServer.CharacterBaseServer

    if character then
        if character:GetItemCount() >= character.ItemSlots then
            warn("Player has too many items")
            return
        end
    end

    local class = script.Items[itemName]


    if not class then
        warn("ItemClass not found")
        return
    end

    local item = class:FindFirstChild("Model")

    if not item then
        warn("Item model not found")
        return
    end

    local itemClone = item:Clone()
    itemClone.Name = itemName
    itemClone:SetAttribute("ItemName", itemName)

    if equipOnSpawn then
        itemClone.Parent = player.Backpack
        player.Character.Humanoid:EquipTool(itemClone)
    else
        itemClone.Parent = player.Backpack
    end

    local itemClass = require(class).new(itemName,itemClone, player)

    self.ItemObjectsIndex[itemClone] = itemClass
    itemClone.Destroying:Connect(function()
        self.ItemObjectsIndex[itemClone] = nil
    end)

    self.Client.ItemAdded:Fire(player, itemClone)

    --local clientScript = class:FindFirstChildOfClass("LocalScript"):Clone()

    --clientScript.Parent = itemClone


    return itemClass

end

return ItemService