local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ItemController = Knit.CreateController{Name = "ItemController"}
local ItemBaseClient = require(script.ItemBaseClient)
function ItemController:KnitInit()

    self.Modules = {} :: {[string]: ItemBaseClient.NexusInstanceItemBaseClient}
    for _,v in ipairs(script.Items:GetChildren()) do
        if v:IsA("ModuleScript") then
            self.Modules[v.Name] = require(v)
        end
    end

end

function ItemController:KnitStart()

    local CharacterController = Knit.GetController("CharacterController")
    local ItemService = Knit.GetService("ItemService")

    ItemService.ItemAdded:Connect(function(item : Tool, cashedVisual : Model?)
        local itemName = item:GetAttribute("ItemName")
        local newItemObj = self.Modules[itemName].new(itemName, item, cashedVisual)

        print(CharacterController:GetCharacter(), "init")
        task.delay(5, function()
            print(CharacterController:GetCharacter(), "delay")
        end)

        CharacterController:GetCharacter():ToolAdded(item, true)

        item.Destroying:Connect(function()
            CharacterController:GetCharacter():ToolRemoved(item)
        end)

    end)



end

return ItemController