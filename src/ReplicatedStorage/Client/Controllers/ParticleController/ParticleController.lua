local Debris = game:GetService("Debris")
local HapticService = game:GetService("HapticService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)


local ParticleController = Knit.CreateController{Name = "ParticleController"}


function ParticleController:KnitInit()

    self.Particle = ReplicatedStorage.Source.Data.Particles

end

function ParticleController:PlayParticleOnce(ParticleName, Position, Parent, EmitAmount, TimeToDestory)

    local Particle = self.Particle:FindFirstChild(ParticleName):Clone()
    Particle.Parent = Parent
    Particle.Position = Position

    for _,v in ipairs(Particle:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v:Emit(EmitAmount)
        end
    end

    Debris:AddItem(Particle, TimeToDestory)

    return Particle

end

function ParticleController:PlaySoundDestoryOnce(Sound, Parent)

    local Sound = Sound:Clone()
    Sound.Parent = Parent

    Sound:Destroy()

end

function ParticleController:KnitStart()

    --local UIController = Knit.GetController("UIController")

    local ParticleService = Knit.GetService("ParticleService")
    local ParticleSignal = ParticleService.ParticleSignal

    ParticleSignal:Connect(function(props : {
        Parent : Instance?,
        Position : Vector3?,
        Particle : Instance,
        Duration : number?,
        EmitAmount : number?,
    }, ignoreList : {Player})

        local Particle = props.Particle:Clone()



        Particle.Parent = props.Parent
        Particle.Position = props.Position or Particle.Parent.CFrame.Position
        if Particle.Parent:IsA("BasePart") then
            -- weldconstraint

            local WeldConstraint = Instance.new("WeldConstraint")
            WeldConstraint.Parent = Particle
            WeldConstraint.Part0 = Particle
            WeldConstraint.Part1 = Particle.Parent
            Particle.Anchored = false

        end



        for _,v in ipairs(Particle:GetDescendants()) do
            if v:IsA("ParticleEmitter") then
                v:Emit(props.EmitAmount)
            end
        end

        Debris:AddItem(Particle, props.Duration)

        return Particle

    end)




end






return ParticleController



