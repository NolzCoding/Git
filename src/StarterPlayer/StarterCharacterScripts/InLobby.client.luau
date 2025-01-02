local Camera = game.Workspace.CurrentCamera
local Players = game:GetService("Players")
local originalFOV = Camera.FieldOfView
local CollectionService = game:GetService("CollectionService")
local player = Players.LocalPlayer

local TweenService = game:GetService("TweenService")

if player then
    if not CollectionService:HasTag(player, "InLobby") then
        Camera.FieldOfView = 70
    end
end

CollectionService:GetInstanceAddedSignal("InLobby"):Connect(function(instance)
    if instance == player then
        TweenService:Create(Camera, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {FieldOfView = 50}):Play()
        --Camera.FieldOfView = 50
    end
end)

CollectionService:GetInstanceRemovedSignal("InLobby"):Connect(function(instance)
    if instance == player then
        TweenService:Create(Camera, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {FieldOfView = originalFOV}):Play()
        --Camera.FieldOfView = originalFOV
    end
end)