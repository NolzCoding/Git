local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Component = require(ReplicatedStorage.Packages.Component)


type self = typeof(Component.new({Tag = "Window"}))
local Window = Component.new({Tag = "Window"})




function Window:Construct()

    print("Constructed")
    local part = self.Instance :: Part

    local debounce = false

    part.Touched:Connect(function(hit)
        if hit.Name ~= "HumanoidRootPart" then return end
        --if debounce then return end
        if hit.Parent == game.Players.LocalPlayer.Character then
            local windowName = part.Name

            local argument = self.Instance:GetAttribute("Argument")

            Knit.GetController("UIController"):OpenWindow(windowName, argument)
            debounce = true
            wait(1)
            debounce = false
        end
    end)

    part.TouchEnded:Connect(function(hit)
        if hit.Name ~= "HumanoidRootPart" then return end
        if hit.Parent == game.Players.LocalPlayer.Character then
            local windowName = part.Name
            Knit.GetController("UIController"):CloseWindow(windowName)

        end
    end)

end
