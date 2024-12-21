local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ParticleService = Knit.CreateService {
    Name = "ParticleService",
    Client = {

        ParticleSignal = Knit.CreateSignal(),

    },
}

function ParticleService:KnitInit()
    self.Particles = {}
end

function ParticleService:KnitStart()
    print("ParticleService has started")
end

function ParticleService:PlayParticle(props : {
    Parent : Instance?,
    Position : Vector3?,
    Particle : Instance,
    Duration : number?,
    EmitAmount : number?,
}, ignoreList : {Player}?)

    self.Client.ParticleSignal:FireAll(props, ignoreList)

end


return ParticleService