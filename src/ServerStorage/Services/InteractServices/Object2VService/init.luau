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
        Gasoline = require(script.Components.Gasoline);
        Bathtub = require(script.Components.Bathtub);
        GluePuddle = require(script.Components.GluePuddle);
        BabyBed = require(script.Components.BabyBed);
    }



end


return Object2VService