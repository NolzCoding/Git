local AssetService = game:GetService('AssetService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Knit = require(ReplicatedStorage.Packages.Knit)

local Component = require(ReplicatedStorage.Packages.Component)
type self = typeof(Component.new({Tag = "Vent"}))
local Vent = Component.new({Tag = "Vent"})
print("reqiored")

local NotificationService = Knit.GetService("NotificationService")

function Vent:Construct()
    print("Construct Vent")

    self.Prompt = Instance.new("ProximityPrompt")
    self.Prompt.Parent = self.Instance
    self.Prompt.ActionText = "Vent"
    self.Prompt.Style = Enum.ProximityPromptStyle.Custom
    self.Prompt.HoldDuration = 2
    self.Prompt.Exclusivity = Enum.ProximityPromptExclusivity.OneGlobally
    self.Prompt.RequiresLineOfSight = false
    self.Instance:SetAttribute("Text", "Hold: Vent")

    self.ToObject = self.Instance:FindFirstChild("To").Value :: BasePart

    self.Prompt.Triggered:Connect(function(player : Player)

        local character = player.Character

        local characterType = character:GetAttribute("Character") :: string
        if characterType == "Parent" then
            NotificationService:NotifyPlayer("TextNImage" ,{
                Text = "Parents can't vent",
                Image = "",
                Color = Color3.fromRGB(255, 86, 86),
                Time = 2,
            }, player)
            return
        end

        local root = character.HumanoidRootPart
        root.CFrame = self.ToObject.CFrame
    end)

end

return Vent