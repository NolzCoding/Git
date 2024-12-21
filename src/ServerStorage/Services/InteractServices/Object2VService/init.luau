local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Object2VService = Knit.CreateService {
    Name = "Object2VService";
}


function Object2VService:KnitInit()
    print("Object2VService KnitInit")
end

function Object2VService:KnitStart()
    print()
    self.Components = {

        Vent = require(script.Components.Vent);
        Oven = require(script.Components.Oven);

    }



end


return Object2VService