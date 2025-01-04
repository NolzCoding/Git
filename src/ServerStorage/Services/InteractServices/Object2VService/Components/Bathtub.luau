local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CharacterBaseServer = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
type self = typeof(Component.new({Tag = "Bathtub"}))
local Bathtub = Component.new({Tag = "Bathtub"})
local AchievementService = Knit.GetService("AchievementService")

print("reqiored")

function Bathtub:Construct()
    print("Construct Bathtub")

    self.CharacterService = Knit.GetService("CharacterService")


    self.TurnOnPrompt = Instance.new("ProximityPrompt")
    self.TurnOnPrompt.Parent = self.Instance.Tap
    self.TurnOnPrompt.ActionText = "Turn On"
    self.TurnOnPrompt.Style = Enum.ProximityPromptStyle.Custom
    self.TurnOnPrompt.HoldDuration = 3
    self.TurnOnPrompt.Exclusivity = Enum.ProximityPromptExclusivity.OneGlobally
    self.TurnOnPrompt.RequiresLineOfSight = false
    self.Instance.Tap:SetAttribute("Text", "Hold: Turn On")

    local Collider = self.Instance.Collider :: Part

    self.enabled = false

    local routineFunc = function(...)
        while true do

            print("Doing the thing")

            local Overlap = Collider:GetTouchingParts()
            local drowningPlayers = {}
            for _, part in ipairs(Overlap) do

                local player = game.Players:GetPlayerFromCharacter(part.Parent)

                if table.find(drowningPlayers, player) then
                    continue
                end

                if player then
                    table.insert(drowningPlayers, player)
                    local character = self.CharacterService:GetCharacter(player) :: CharacterBaseServer.CharacterBaseServer
                    character:ApplyEffect("Drowning", 1, 5)
                end
            end

            task.wait(1)

        end
    end

    local rotinue = nil

    self.TurnOnPrompt.Triggered:Connect(function(player: Player)

        self.enabled = not self.enabled

        for _,v : Instance in ipairs(self.Instance.Tap:GetDescendants()) do

            if v:IsA("ParticleEmitter") then
                v.Enabled = self.enabled
            end

        end

        self.Instance.Water.Transparency = self.enabled and 0 or 1

        if self.enabled then
            rotinue = coroutine.create(routineFunc)
            coroutine.resume(rotinue)
        else
            coroutine.close(rotinue)
        end

        AchievementService:PerformedAction(player, "Bath", 1)

    end)

end

return Bathtub