local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local CollectionService = game:GetService("CollectionService")
local CharacterClient = require(script.Parent.Parent.CharacterClient)
local HealthBar = require(script.HealthBar)
local AbilityUI = require(script.AbilityUI)
local AbilityInfo = require(ReplicatedStorage.Source.Shared.Abilities)
--Define TestClass1 (potentially in a ModuleScript).
local Knit = require(ReplicatedStorage.Packages.Knit)
local Trove = require(ReplicatedStorage.Packages.Trove)

--Define TestClass2 (potentially in a different ModuleScript).
local BabyClient = {}
BabyClient.__index = BabyClient
setmetatable(BabyClient, CharacterClient) --TestClass1NexusInstance would be returned instead of TestClass1.

export type BabyClient = {
    Trove : typeof(Trove.new()),
    SetupAbilities : () -> (),
    UseAbility : (ability : string) -> (),
    AbilityDebounce : {[string] : boolean},
    AbilityHandlers : {
        [string] : (any) -> (),
    },
} & typeof(setmetatable({}, BabyClient)) & CharacterClient.CharacterClient
export type NexusInstanceBabyClient = NexusInstance.NexusInstance<BabyClient>

function BabyClient.__new(self: NexusInstanceBabyClient, character : Model?, ignoreUI : boolean?): ()

    self.DataService = Knit.GetService("DataService")
    local DataController = Knit.GetController("DataController")
    self.Trove = Trove.new()
    self.AbilityHandlers = {}
    self.AbilityDebounce = {}

    if not ignoreUI then
        self.BuildUI = function(scope)

            local _ready, data = self.DataService.DataProperty:OnReady():await()
            print(data, "Recived")
            local abilitiesData = scope:Value(data.Abilities)

            local currentAbilities = scope:Value(data.Abilities.CurrentAbilities)
            local ownedAbilities = scope:Value(data.Abilities.OwnedAbilities)

            DataController:OnDataChanged("Abilities", function(data)
                abilitiesData:set(data)
                currentAbilities:set(data.CurrentAbilities)
                ownedAbilities:set(data.OwnedAbilities)
            end)

            return {
                AbilityUI(scope, {
                    CurrentAbilities = currentAbilities,
                    OwnedAbilities = ownedAbilities,

                    AbilityUsed = function(ability)
                        self:UseAbility(ability)
                    end

                }),
                HealthBar(scope, {})
            }
        end
    end

    CharacterClient.__new(self, character) --Remember to call the parent constructor!

    -- disable all proximity prompts with the tag "Baby"

    --[[local function callback(instance)
        local prompt = instance:FindFirstChild("ProximityPrompt") :: ProximityPrompt
        if prompt then
            prompt.Enabled = false
        end
    end

    table.insert(self.Connections, CollectionService:GetInstanceAddedSignal("Baby"):Connect(callback)) -- need to disconnect this signal when the character is destroyed

    for _, instance in ipairs(CollectionService:GetTagged("Baby")) do
        callback(instance)
    end]]

    self:SetupAbilities()

end


function BabyClient.UseAbility(self : NexusInstanceBabyClient, ability : string)

    local data = self.DataService.DataProperty:Get()
    local abilitiesData = data.Abilities
    local amount = abilitiesData.OwnedAbilities[ability] or 0

    if amount == 0 then
        return
    end

    if self.AbilityDebounce[ability :: any] then
        return
    end

    self.AbilityHandlers[ability]()
    self.Server.UseAbility(ability)

    self.AbilityDebounce[ability] = true

    local Cooldown = AbilityInfo.Abilities[ability].Cooldown

    task.delay(Cooldown, function()
        self.AbilityDebounce[ability] = false
    end)

end

function BabyClient.SetupAbilities(self : NexusInstanceBabyClient): ()

    self.AbilityHandlers["Invisibility"] = function()

        local character = game.Players.LocalPlayer.Character
        local humanoid = character:FindFirstChild("Humanoid") :: Humanoid

        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") or part:IsA("Decal") then

                if not part:GetAttribute("Transparency") then
                    part:SetAttribute("Transparency", part.Transparency)
                end
                part.Transparency = 1
            end
        end

        task.delay(15, function()
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = part:GetAttribute("Transparency")
                end
            end
        end)

    end

    self.AbilityHandlers["Jump"] = function()
        local character = game.Players.LocalPlayer.Character
        local humanoid = character:FindFirstChild("Humanoid") :: Humanoid

        local root = character:FindFirstChild("HumanoidRootPart") :: Part

        humanoid:ChangeState(Enum.HumanoidStateType.Flying)

        local newVelocity = root.CFrame.LookVector * 50 + Vector3.new(0, 50, 0)

        root.AssemblyLinearVelocity += newVelocity

    end

    self.AbilityHandlers["Speed"] = function()

        local character = game.Players.LocalPlayer.Character
        local humanoid = character:FindFirstChild("Humanoid") :: Humanoid

        humanoid.WalkSpeed = 50

        task.delay(5, function()
            humanoid.WalkSpeed = 20
        end)

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
end

return NexusInstance.ToInstance(BabyClient) :: NexusInstance.NexusInstanceClass<typeof(BabyClient), (Input1: string, Input2: string) -> (NexusInstanceBabyClient)>