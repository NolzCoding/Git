local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local ItemBase = require(ServerStorage.Source.Services.InteractServices.ItemService.ItemBase)

local BabyCharacter = require(ServerStorage.Source.Services.CharacterService.CharacterService.Characters.BabyServer)
local ParentCharacter = require(ServerStorage.Source.Services.CharacterService.CharacterService.Characters.ParentServer)

local MedicineServer = {}
MedicineServer.__index = MedicineServer
setmetatable(MedicineServer, ItemBase)

local HEAL_AMOUNT = 25

export type MedicineServer = {
} & typeof(setmetatable({}, MedicineServer)) & ItemBase.ItemBase
export type NexusInstanceMedicineServer = NexusInstance.NexusInstance<MedicineServer>

function MedicineServer.__new(self: NexusInstanceMedicineServer, itemName: string, tool: Tool, madeFor : Player)

    ItemBase.__new(self, itemName, tool) --Remember to call the parent constructor!
    self:DisableCollisons()

end

function MedicineServer.Client.EatItem(self : NexusInstanceMedicineServer, player : Player)

end

function MedicineServer.PromptInteract(self : NexusInstanceMedicineServer, promptName: string, ...)

    local parentCharacterClass : ParentCharacter.ParentServer, babyCharacterClass : BabyCharacter.BabyServer = ...

    local healAttributes = {
        Lungs = HEAL_AMOUNT,
        Heart = HEAL_AMOUNT,
        Stomach = HEAL_AMOUNT,
    }

    babyCharacterClass:HealAttributes(healAttributes)



end

return NexusInstance.ToInstance(MedicineServer) :: NexusInstance.NexusInstanceClass<typeof(MedicineServer), (Input1: string, Input2: string) -> (NexusInstanceMedicineServer)>