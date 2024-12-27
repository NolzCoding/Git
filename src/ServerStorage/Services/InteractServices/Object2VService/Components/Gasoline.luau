local AssetService = game:GetService('AssetService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerStorage = game:GetService('ServerStorage')
local CharacterBaseServer = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)

local Knit = require(ReplicatedStorage.Packages.Knit)

local Component = require(ReplicatedStorage.Packages.Component)
type self = typeof(Component.new({Tag = "Gasoline"}))
local Gasoline = Component.new({Tag = "Gasoline"})
print("reqiored")

local NotificationService = Knit.GetService("NotificationService")
local CharacterService = Knit.GetService("CharacterService")
function Gasoline:Construct()
    print("Construct Gasoline")


    self.Prompt = Instance.new("ProximityPrompt")
    self.Prompt.Parent = self.Instance
    self.Prompt.ActionText = "Gasoline"
    self.Prompt.Style = Enum.ProximityPromptStyle.Custom
    self.Prompt.HoldDuration = 5
    self.Prompt.Exclusivity = Enum.ProximityPromptExclusivity.OneGlobally
    self.Prompt.RequiresLineOfSight = false
    self.Instance:SetAttribute("Text", "Hold: Drench in Gasoline")

    self.Prompt.Triggered:Connect(function(player : Player)
        local character = CharacterService:GetCharacter(player) :: CharacterBaseServer.CharacterBaseServer
        character:ApplyEffect("Gasoline", 30)
        NotificationService:NotifyPlayer("TextNImage", {
            Text = "You drenched in gasoline, find a lighter ;)",
            Image = "",
            Color = Color3.fromRGB(153, 0, 255),
            Time = 5,
        }, player)
    end)

end

return Gasoline