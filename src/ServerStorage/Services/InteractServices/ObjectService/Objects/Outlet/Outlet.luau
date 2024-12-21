local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Outlet = {}
local Knit = require(ReplicatedStorage.Packages.Knit)
function Outlet:Init()

    self.PromptService = Knit.GetService("PromptService")
    self.ObjectService = Knit.GetService("ObjectService")
    self.PromptService:GetSignal("Outlet").Triggered:Connect(function(prompt : ProximityPrompt, player : Player)
        local outlet = prompt.Parent.Parent

        local connectedObjectValue = outlet:FindFirstChild("ConnectedObject")

        if not connectedObjectValue then
            return
        end

        local objectType = connectedObjectValue.Value:GetAttribute("ObjectType")
        outlet:SetAttribute("ConnectedObject", nil)

        outlet.MeshPart:RemoveTag("Outlet")
        outlet.MeshPart:RemoveTag("PromptService")

        outlet.MeshPart:FindFirstChildOfClass("ProximityPrompt"):Destroy()

        self.ObjectService:CallMethod(objectType, "DisconnectFromOutlet", connectedObjectValue.Value, outlet)
        connectedObjectValue:Destroy()

    end)

end



local defaultProperties = {
    LastConnectTime = tick()
}

function Outlet:Instance(CFrame : CFrame, Parent : Instance, AddPropertiesCallback : (Instance) -> nil)

    local new  = script.Parent.Model:Clone()
    AddPropertiesCallback(new or defaultProperties) -- load properties
    new:PivotTo(CFrame)
    new.Parent = Parent


    new.MeshPart.Part.Touched:Connect(function(hit)

        if new:GetAttribute("LastConnectTime") then
            if tick() - new:GetAttribute("LastConnectTime") < 5 then
                return
            end
        end

        if hit.Name == "Small" and hit.Parent:GetAttribute("ObjectType") and hit.Parent:GetAttribute("ObjectType") == "Toaster" then

            local connectedObject = self.ObjectService:CallMethod(hit.Parent:GetAttribute("ObjectType"),"ConnectToOutlet", hit.Parent, new) -- connect toaster to outlet

            if not connectedObject then
                return
            end

            new:SetAttribute("LastConnectTime", tick())

            -- add prompt to disconnect toaster
            new.MeshPart:SetAttribute("Text", "Disconnect Toaster")
            new.MeshPart:AddTag("Outlet")
            new.MeshPart:AddTag("PromptService")

            local connectedObjectValue = Instance.new("ObjectValue")
            connectedObjectValue.Parent = new
            connectedObjectValue.Name = "ConnectedObject"
            connectedObjectValue.Value = connectedObject

        end
    end)

    -- setup connections

    return new

end

return Outlet