local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Baby = {}
local BaseCharacter = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local ParentCharacter = require(ServerStorage.Source.Services.CharacterService.CharacterService.Characters.ParentServer)
local BabyCharacter = require(ServerStorage.Source.Services.CharacterService.CharacterService.Characters.BabyServer)
local Knit = require(ReplicatedStorage.Packages.Knit)
function Baby:Init()

    self.CharacterService = Knit.GetService("CharacterService")

end

function Baby:Triggered(prompt : ProximityPrompt, player : Player)
    local baby = Players:GetPlayerFromCharacter(prompt.Parent.Parent)
    local babyCharacterClass : BabyCharacter.BabyServer = self.CharacterService:GetCharacter(baby)
    local parentCharacterClass = self.CharacterService:GetCharacter(player) :: ParentCharacter.ParentServer
    if not babyCharacterClass or not parentCharacterClass then
        return
    end
    parentCharacterClass:PickupPlayer(babyCharacterClass)

end

return Baby