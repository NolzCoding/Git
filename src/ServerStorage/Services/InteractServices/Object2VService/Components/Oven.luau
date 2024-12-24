local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local CharacterBaseServer = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local Component = require(ReplicatedStorage.Packages.Component)
type self = typeof(Component.new({Tag = "Oven"}))
local Oven = Component.new({Tag = "Oven"})

print("reqiored")

function Oven:Construct()
    print("Construct Oven")

    self.CharacterService = Knit.GetService("CharacterService")

    self.Prompt = Instance.new("ProximityPrompt")
    self.Prompt.Parent = self.Instance.Door.PrimaryPart
    self.Prompt.ActionText = "Oven"
    self.Prompt.Style = Enum.ProximityPromptStyle.Custom
    self.Prompt.HoldDuration = math.huge -- HoldDuration is infinite so it requires 2 players to trigger
    self.Prompt.Exclusivity = Enum.ProximityPromptExclusivity.OneGlobally
    self.Prompt.RequiresLineOfSight = false
    self.Instance.Door.PrimaryPart:SetAttribute("Text", "Requires 2 players: Oven")

    self.TurnOnPrompt = Instance.new("ProximityPrompt")
    self.TurnOnPrompt.Parent = self.Instance.Prompt
    self.TurnOnPrompt.ActionText = "Turn On"
    self.TurnOnPrompt.Style = Enum.ProximityPromptStyle.Custom
    self.TurnOnPrompt.HoldDuration = 3
    self.TurnOnPrompt.Exclusivity = Enum.ProximityPromptExclusivity.OneGlobally
    self.TurnOnPrompt.RequiresLineOfSight = true
    self.Instance.Prompt:SetAttribute("Text", "Hold: Turn On")

    local light = self.Instance.Light.Value :: PointLight
    local glass = self.Instance.Glass.Value :: Part
    local glassOrginalColor = glass.Color
    local Collider = self.Instance.Collider :: Part

    local playersHolding = {}

    local canOpen = function()
        return #playersHolding == 1 -- later needs to check if its a baby, or parent
    end

    local debounceOpen = false

    self.Prompt.PromptButtonHoldBegan:Connect(function(player : Player)
        table.insert(playersHolding, player)
        if not canOpen() then
            return
        end

        if debounceOpen then
            return
        end

        debounceOpen = true

        task.delay(2, function()
            debounceOpen = false
        end)

        local DoorModel = self.Instance.Door :: Model
        local isOpen = DoorModel:GetAttribute("Open") :: boolean
        if isOpen then
            DoorModel:SetAttribute("Open", false)
            DoorModel:PivotTo(DoorModel:GetPivot() * CFrame.Angles(math.rad(90), 0, 0))
        else
            DoorModel:SetAttribute("Open", true)
            DoorModel:PivotTo(DoorModel:GetPivot() * CFrame.Angles(-math.rad(90), 0, 0))
        end

    end)

    self.Prompt.PromptButtonHoldEnded:Connect(function(player : Player)
        table.remove(playersHolding, table.find(playersHolding, player))
    end)

    local routineFunc = function(...)
        while true do

            print("Doing the thing")

            local Overlap = Collider:GetTouchingParts()
            local burnedPlayers = {}
            for _, part in ipairs(Overlap) do
                local player = game.Players:GetPlayerFromCharacter(part.Parent)
                if player then
                    table.insert(burnedPlayers, player)
                    local character = self.CharacterService:GetCharacter(player) :: CharacterBaseServer.CharacterBaseServer
                    character:ApplyEffect("Burn", 1)
                end
            end

            task.wait(1)


        end
    end

    local rotinue = nil

    self.TurnOnPrompt.Triggered:Connect(function(player: Player)

        light.Enabled = not light.Enabled
        glass.Color = light.Enabled and Color3.fromRGB(255, 81, 0) or glassOrginalColor

        if light.Enabled then
            rotinue = coroutine.create(routineFunc)
            coroutine.resume(rotinue)
        else
            coroutine.close(rotinue)
        end



    end)

end

return Oven