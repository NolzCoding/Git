local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)


for _,v in ipairs(ReplicatedStorage.Source.Client.Controllers:GetDescendants()) do
    print("v.Name")
    if v:IsA("ModuleScript") and v.Name:match("Controller$") then

        require(v)

    end

end



Knit.Start():andThen(function()

    print("Knit started")

end):catch(warn)