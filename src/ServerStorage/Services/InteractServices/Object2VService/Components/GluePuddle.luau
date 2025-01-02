local AssetService = game:GetService('AssetService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerStorage = game:GetService('ServerStorage')
local CharacterBaseServer = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)

local Knit = require(ReplicatedStorage.Packages.Knit)

local Component = require(ReplicatedStorage.Packages.Component)
type self = typeof(Component.new({Tag = "GluePuddle"}))
local GluePuddle = Component.new({Tag = "GluePuddle"})
print("reqiored")

local NotificationService = Knit.GetService("NotificationService")
local CharacterService = Knit.GetService("CharacterService")
function GluePuddle:Construct()
    print("Construct GluePuddle")

    self.Instance.Collider.Touched:Connect(function(hit)
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if not player then
            return
        end



        local character = CharacterService:GetCharacter(player) :: CharacterBaseServer.CharacterBaseServer
        character:ApplyEffect("Slowness", 3)
    end)

end

return GluePuddle