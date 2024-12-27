local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)

local Children = Fusion.Children
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local Sounds = require(ReplicatedStorage.Source.Shared.Sounds)
local NotificationController = Knit.CreateController {
    Name = "NotificationController";
}

local TextNImage = require(script.Parent.TextNImage)

function NotificationController:KnitStart()
    local UIController = Knit.GetController("UIController")

    self.scope = Fusion.scoped(Fusion)

    self.ScreenGui = self.scope:New "ScreenGui" {

        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
        Name = "NotificationUI",
        ResetOnSpawn = false,
        DisplayOrder = 2,
    }

    self.Frame = self.scope:New "Frame" {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0.8, 0),

        Parent = self.ScreenGui,
        [Children] = {
            self.scope:New "UIListLayout" {
                Padding = UDim.new(0, 10),
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
            },
        },
    }

    task.delay(10, function()
        --text

        self:TextNImage({
            Text = "Hello World",
            Image = Icons.Heart,
            Color = Color3.fromRGB(255, 0, 0),
            Time = 5,
        })

    end)

    local NotificationService = Knit.GetService("NotificationService")

    NotificationService.NotifySignal:Connect(function(notificationName, props)
        if notificationName == "TextNImage" then
            self:TextNImage(props)
        end
    end)

end

function NotificationController:TextNImage(props : {
    Text : string,
    Image : string,
    Color : Color3,
    Time : number,
})

    local innerScope = self.scope:innerScope()

    local newSound = Instance.new("Sound")
    newSound.SoundId = Sounds.Notification
    newSound.Parent = self.ScreenGui

    table.insert(innerScope, newSound)

    game.SoundService:PlayLocalSound(newSound)

    local visible = innerScope:Value(false)

    local newProps = {
        Text = props.Text,
        Image = props.Image,
        Color = props.Color,
        Time = props.Time,
        Parent = self.Frame,
        Visible = visible,
    }

    TextNImage(innerScope, newProps)
    task.delay(props.Time, function()
        visible:set(false)
        task.wait(0.2)
        innerScope:doCleanup()
    end)

    visible:set(true)

end

function NotificationController:KnitInit()

end

return NotificationController