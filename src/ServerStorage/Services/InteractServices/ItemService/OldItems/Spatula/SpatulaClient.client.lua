local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RemoteEvent : RemoteEvent = script.Parent:WaitForChild("Remote")

local CASTSIZE = Vector3.new(2, 10, 2);
local _Character = Players.LocalPlayer.Character
local _HumanoidRootPart = _Character:WaitForChild("HumanoidRootPart")
local _Humanoid = _Character:WaitForChild("Humanoid")
local _Animator : Animator = _Humanoid:WaitForChild("Animator")

local Knit = require(ReplicatedStorage.Packages.Knit)

local ParticleController = Knit.GetController("ParticleController")
--function ParticleController:PlayParticleOnce(ParticleName, Position, Parent, EmitAmount, TimeToDestory)

local AnimTracks = {}

function _LoadAnims()

    local HitAnims = script.Parent:WaitForChild("HitAnims")

    for _,v in ipairs(HitAnims:GetChildren()) do
        local anim = _Animator:LoadAnimation(v)
        anim.Priority = Enum.AnimationPriority.Action
        table.insert(AnimTracks, anim)
    end

end

function _PlayRandomAnim()

    local randomAnim = AnimTracks[math.random(1, #AnimTracks)]

    randomAnim:Play()

end

function _PlayRandomSound()

    local randomSound = script.Parent:WaitForChild("Sounds"):GetChildren()[math.random(1, #script.Parent:WaitForChild("Sounds"):GetChildren())]
    randomSound:Play()
end


function _Activated()

    _PlayRandomAnim()
    _PlayRandomSound()
    local params = RaycastParams.new();
    params.FilterDescendantsInstances = {_Character};
    params.FilterType = Enum.RaycastFilterType.Blacklist;

    local result : RaycastResult = Workspace:Blockcast(_HumanoidRootPart.CFrame + Vector3.new(0,0,0), CASTSIZE, _HumanoidRootPart.CFrame.LookVector * 5, params);

    if not result then
        return
    end

    print("Same same")

    local particeName = "A - NORMAL STRIKE [A]"

    ParticleController:PlayParticleOnce(particeName, result.Position, workspace, 2, 2)
    local player = Players:GetPlayerFromCharacter(result.Instance.Parent);


    if not player then
        return
    end



end

_LoadAnims()

script.Parent.Activated:Connect(_Activated)