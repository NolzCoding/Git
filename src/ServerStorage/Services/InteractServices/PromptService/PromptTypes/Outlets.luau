local Outlet = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local BaseCharacter = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local ParentCharacter = require(ServerStorage.Source.Services.CharacterService.CharacterService.Characters.ParentServer)
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)
local BabyCharacter = require(ServerStorage.Source.Services.CharacterService.CharacterService.Characters.BabyServer)

local Knit = require(ReplicatedStorage.Packages.Knit)
function Outlet:Init()

    self.CharacterService = Knit.GetService("CharacterService")
    self.ItemService = Knit.GetService("ItemService")
end

function Outlet:Triggered(prompt : ProximityPrompt, player : Player)




    -- check if item has behavior that overrides default behavior

    local charactertype = (player :: any).Character:GetAttribute("Character")

    if not charactertype or charactertype == "Parent" then
        return
    end

    local babyserver = self.CharacterService:GetCharacter(player) :: BabyCharacter.BabyServer

    if (player :: any).Character:FindFirstChildOfClass("Tool") then
        local itemClass = self.ItemService:GetItemFromTool((player :: any).Character:FindFirstChildOfClass("Tool"))
        if itemClass then
            if itemClass.PromptInteract then
                itemClass:PromptInteract("Outlets", babyserver)
                return
            end
        end
    end

end

return Outlet