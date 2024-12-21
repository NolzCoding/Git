local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProfileService = require(ServerStorage.Source.ProfileService)
--local ReplicaService = require(ServerStorage.Source.ReplicaService)
local Knit = require(ReplicatedStorage.Packages.Knit)

local Promise = require(Knit.Util.Promise)


local StarterData =
{
    Cash = 0,
    Gamepasses = {},
    Skins = {
        Baby = {
            CurrentSkin = "Baby",
            OwnedSkins = {
                Baby = true
            }
        },
        Parent = {
            CurrentSkin = "Parent",
            OwnedSkins = {
                Parent = true,
                Mom = true,
            }
        }
    }
}

local DataService = Knit.CreateService{
    Name = "DataService",
    Client = {
        DataProperty = Knit.CreateProperty(),
        DataSetSignal = Knit.CreateSignal(),
    },
    PlayerProfileStore = nil,
    Profiles = {},
    DataReplicas = {},
    JoinListeners = {},
    PlayerCurrencies = {}, -- will always store bignum values to save on conversion
    BeforeLeaveListeners = {}
}



function DataService:OnPlayerAdded(player : Player)

    local PlayerProfile = self.PlayerProfileStore:LoadProfileAsync("CashProfileStore"..player.UserId,"ForceLoad")

    if PlayerProfile ~= nil then

        PlayerProfile:ListenToRelease(function()
            self.Profiles[player] = nil
            --self.DataReplicas[player]:Destroy()
            --self.DataReplicas[player] = nil
        end)

        if player:IsDescendantOf(Players) then


            self.Profiles[player] = PlayerProfile

            self.Client.DataProperty:SetFor(player, PlayerProfile.Data)

            print(PlayerProfile.Data)

            --[[local DataReplica = ReplicaService.NewReplica({
                ClassToken = ReplicaService.NewClassToken("DataToken_"..player.UserId), -- since a player's user id is unique, we will name it according to their user id to create a unique name for the class token.
                Data = PlayerProfile.Data,
                Replication = player -- this player that joined the game can only access to this replica!
            })
            self.DataReplicas[player] = DataReplica
]]


        else
            PlayerProfile:Release()
        end

        -- call all functions that require data on join

        print(RunService:IsStudio())


        if RunService:IsStudio() then

            Promise.delay(1):andThenCall( function()

                print(self.JoinListeners)

                print(PlayerProfile)

                for _, v in ipairs(self.JoinListeners) do



                    v(player, PlayerProfile)

                end
            end)

            return

        end

        for _, v in ipairs(self.JoinListeners) do

            task.spawn(function()

                v(player, PlayerProfile)

            end)

        end

    else
        player:Kick("Unable to load your data. Please rejoin.")
    end

end

function DataService:OnPlayerRemoved(player : Player)

    local PlayerProfile = self.Profiles[player]

    if PlayerProfile then
        PlayerProfile:Release()
    end

end

function DataService:BeforePlayerLeave( callback : () -> ())

    table.insert(self.BeforeLeaveListeners,  callback)
end


function DataService:GetData(player : Player)

	while self.Profiles[player] == nil and player do

        task.wait()

    end

    if not player then

        return nil

    end


	return self.Profiles[player].Data

end

function DataService.Client:GetData(player)

    return self.Server:GetData(player)

end



function DataService:SetData(player,dataToSet : string,newDataValue)
	local PlayerProfile = self.Profiles[player]


	if PlayerProfile then
		local OldDataValueType = typeof(PlayerProfile.Data[dataToSet])

		if OldDataValueType == typeof(newDataValue) then
			PlayerProfile.Data[dataToSet] = newDataValue
            --DataReplica:SetValue({dataToSet}, newDataValue)

            self.Client.DataProperty:SetFor(player, PlayerProfile.Data)
            self.Client.DataSetSignal:Fire(player, dataToSet, newDataValue)

		end
	end

end



function DataService:ListenForJoin(callback : (player: Player, playerProfile : table) ->())

    table.insert(self.JoinListeners, callback)

end


function DataService:KnitInit()

    self.PlayerProfileStore = ProfileService.GetProfileStore("CashProfileStore", StarterData)

    self.Client.DataProperty:Set(table.clone(StarterData))

    -- Events
    Players.PlayerAdded:Connect( function(player)

        self:OnPlayerAdded(player)

    end)
    Players.PlayerRemoving:Connect(function(player)

        for _, v in ipairs(self.BeforeLeaveListeners) do

            Promise.new(function(resolve, reject)

                v(player)
                resolve()

            end):await()


        end

        self:OnPlayerRemoved(player)

    end)


end

function DataService:KnitStart()

end

return DataService