local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Baby = {}
local BaseCharacter = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local ParentCharacter = require(ServerStorage.Source.Services.CharacterService.CharacterService.Characters.ParentServer)
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)
local BabyCharacter = require(ServerStorage.Source.Services.CharacterService.CharacterService.Characters.BabyServer)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local Knit = require(ReplicatedStorage.Packages.Knit)
function Baby:Init()

    self.CharacterService = Knit.GetService("CharacterService")
    self.NotificationService = Knit.GetService("NotificationService")
    self.ItemService = Knit.GetService("ItemService")
end

function Baby:Triggered(prompt : ProximityPrompt, player : Player)
    local baby = Players:GetPlayerFromCharacter(prompt.Parent.Parent)
    local babyCharacterClass : BabyCharacter.BabyServer = self.CharacterService:GetCharacter(baby)
    local parentCharacterClass = self.CharacterService:GetCharacter(player) :: ParentCharacter.ParentServer
    if not babyCharacterClass or not parentCharacterClass then
        return
    end

    if (player :: any).Character:FindFirstChildOfClass("Tool") then
        local itemClass = self.ItemService:GetItemFromTool((player :: any).Character:FindFirstChildOfClass("Tool"))
        if itemClass then

            if itemClass.PromptInteract then
                itemClass:PromptInteract("Baby", parentCharacterClass, babyCharacterClass)

                self.NotificationService:NotifyPlayer("TextNImage", {
                    Text = "You used the " .. " Medicine " .. " on the baby",
                    Image = "rbxassetid://7716784021",
                    Color = Color3.fromRGB(129, 255, 45),
                    Time = 5,
                }, player)

                return

            end

        end
    end

    if babyCharacterClass.ActiveEffects["Slippery"] then
        print("Baby is slippery")

        self.NotificationService:NotifyPlayer("TextNImage", {
            Text = "You can't pick up a slippery baby, because they're soaped up",
            Image = Icons.ItemImages.Soap,
            Color = Color3.fromRGB(255, 45, 45),
            Time = 5,
        }, player)

        return
    end

    -- check if item has behavior that overrides default behavior




    parentCharacterClass:PickupPlayer(babyCharacterClass)

end

return Baby