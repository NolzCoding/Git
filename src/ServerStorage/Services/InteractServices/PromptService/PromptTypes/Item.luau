local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseCharacter = require(game.ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local DebrisService = game:GetService("Debris")
local Item = {}

function Item:Init()

end

local Knit = require(ReplicatedStorage.Packages.Knit)

function Item:Triggered(prompt : ProximityPrompt, player : Player)

    local parent = prompt.Parent.Parent

    local class = Knit.GetService("ItemService"):GiveItem(player, prompt.Parent:GetAttribute("ItemName"), true)

    if not class then
        return -- probably means they dont have enough space to hold the item
    end

    -- for ik
    local newPart = Instance.new("Part")
    newPart.Size = Vector3.new(1, 1, 1)
    newPart.Anchored = true
    newPart.CanCollide = false
    newPart.Transparency = 1
    newPart.Parent = workspace

    local character = Knit.GetService("CharacterService"):GetCharacter(player) :: BaseCharacter.CharacterBaseServer
    character:PlayIKControl("RightArm", newPart, 0.1, 0.25)
    DebrisService:AddItem(newPart, 2) -- 0.25*2 + 0.5 = 1
    -- destroy the item

    parent:Destroy()

end


return Item