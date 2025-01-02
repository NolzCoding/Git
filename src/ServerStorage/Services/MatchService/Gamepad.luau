local AssetService = game:GetService('AssetService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerStorage = game:GetService('ServerStorage')
local CharacterBaseServer = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local module = {}
local Knit = require(ReplicatedStorage.Packages.Knit)

local Component = require(ReplicatedStorage.Packages.Component)
type self = typeof(Component.new({Tag = "Gamepad"}))
local Gamepad = Component.new({Tag = "Gamepad"})

function Gamepad:Construct()

    local Collider = self.Instance :: Part
    local GameLobby = self.Instance.GameLobby

    if not GameLobby then
        warn("GameLobby not found")
        return
    end

    local GameLobbyFolder = GameLobby.Value :: Folder

    Collider.Touched:Connect(function(part: BasePart)
        if part.Name ~= "HumanoidRootPart" then
            return
        end

        local player = game.Players:GetPlayerFromCharacter(part.Parent)

        if not player then
            return
        end

        local playerInLobby = GameLobbyFolder:FindFirstChild(player.UserId)

        if playerInLobby then
            return
        end

        local ObjectValue = Instance.new("ObjectValue")
        ObjectValue.Name = player.UserId
        ObjectValue.Value = player

        ObjectValue.Parent = GameLobbyFolder

        print("Player added to lobby ", player)

    end)

    Collider.TouchEnded:Connect(function(part: BasePart)
        if part.Name ~= "HumanoidRootPart" then
            return
        end

        local player = game.Players:GetPlayerFromCharacter(part.Parent)
        if not player then
            return
        end

        local playerInLobby = GameLobbyFolder:FindFirstChild(player.UserId)
        if not playerInLobby then
            return
        end

        playerInLobby:Destroy()

        print("Player removed from lobby ", player)

    end)

end

return module