local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local CollectionService = game:GetService("CollectionService")
local CharacterClient = require(script.Parent.Parent.CharacterClient)
local HealthBar = require(script.HealthBar)

--Define TestClass1 (potentially in a ModuleScript).



--Define TestClass2 (potentially in a different ModuleScript).
local BabyClient = {}
BabyClient.__index = BabyClient
setmetatable(BabyClient, CharacterClient) --TestClass1NexusInstance would be returned instead of TestClass1.

export type BabyClient = {

    TestProperty2: string,
} & typeof(setmetatable({}, BabyClient)) & CharacterClient.CharacterClient
export type NexusInstanceBabyClient = NexusInstance.NexusInstance<BabyClient>

function BabyClient.__new(self: NexusInstanceBabyClient, character : Model?): ()

    self.BuildUI = function(scope)
        return HealthBar(scope, {})
    end

    CharacterClient.__new(self, character) --Remember to call the parent constructor!

    -- disable all proximity prompts with the tag "Baby"

    local function callback(instance)
        local prompt = instance:FindFirstChild("ProximityPrompt") :: ProximityPrompt
        if prompt then
            prompt.Enabled = false
        end
    end

    table.insert(self.Connections, CollectionService:GetInstanceAddedSignal("Baby"):Connect(callback)) -- need to disconnect this signal when the character is destroyed

    for _, instance in ipairs(CollectionService:GetTagged("Baby")) do
        callback(instance)
    end

end

function BabyClient.ServerSignal.AddForce(self : NexusInstanceBabyClient, force : Vector3)
    print("Thrown", force)
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") :: Part
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") :: Humanoid
    humanoid.PlatformStand = true
    root.AssemblyLinearVelocity += force

end

function BabyClient.Destroy(self: NexusInstanceBabyClient): ()
    CharacterClient.Destroy(self)
    CollectionService:GetInstanceAddedSignal("Baby"):Disconnect()
end

return NexusInstance.ToInstance(BabyClient) :: NexusInstance.NexusInstanceClass<typeof(BabyClient), (Input1: string, Input2: string) -> (NexusInstanceBabyClient)>