local AssetService = game:GetService('AssetService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerStorage = game:GetService('ServerStorage')
local CharacterBaseServer = require(ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local module = {}
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children, peek = Fusion.Children, Fusion.peek
local Component = require(ReplicatedStorage.Packages.Component)
type self = typeof(Component.new({Tag = "GameLobby"}))
local GameLobby = Component.new({Tag = "GameLobby"})

local MatchService = Knit.GetService("MatchService")

function GameLobby:Construct()

    local Folder = self.Instance :: Folder

    local scope = Fusion:scoped()
    local countDown = scope:Value(0)
    local requiredPlayers = 1 -- Change this value to set the required number of players
    local maxPlayers = 6 -- Change this value to set the maximum number of players

    local isCounting = false
    local countDownConnection

    local startGame = function()
        local players = Folder:GetChildren()

        local list = {}

        for _, player in ipairs(players) do
            table.insert(list, player.Value)
        end

        MatchService:NewGameSession(list)

        -- remove all players from the lobby

        for _, player in ipairs(players) do
            player:Destroy()
        end

    end

    local startCountDown = function()
        countDown:set(10)

        while peek(countDown) > 0 do
            wait(1)
            local playerCount = #Folder:GetChildren()
            countDown:set(peek(countDown) - 1)

            if playerCount < requiredPlayers then
                countDown:set(0)
                print("Waiting for " .. requiredPlayers .. " players")
                countDown:set("Waiting for " .. requiredPlayers .. " players")
                return
            end
        end

        print("Game Started")
        startGame()
    end

    local Billboard = scope : New "BillboardGui" {
        Parent = Folder.Parent.GUIPosition,
        Size = UDim2.new(5, 0, 5, 0),
        AlwaysOnTop = false,
        LightInfluence = 0,
        Brightness = 1,
        [Children] = {
            scope : New "TextLabel" {
                BackgroundTransparency = 1,
                Size = UDim2.new(0.85, 0, 0.85, 0),
                Text = countDown,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                Font = Enum.Font.FredokaOne,
                [Children] = {
                    scope : New "UIStroke" {
                        Color = Color3.fromRGB(192, 9, 9),
                        Thickness = 2,
                    }
                }
            }
        }
    }

    local function updateCountDown()
        local playerCount = #Folder:GetChildren()
        if playerCount >= requiredPlayers then
            if not isCounting then
                isCounting = true
                countDownConnection = startCountDown()
            end
        else
            if isCounting then
                isCounting = false
                if countDownConnection then
                    countDownConnection:Disconnect()
                    countDownConnection = nil
                end
                countDown:set(0)
                print("Waiting for " .. requiredPlayers .. " players")
            end
        end
    end

    Folder.ChildAdded:Connect(function(child)
        if child:IsA("ObjectValue") then
            local playerCount = #Folder:GetChildren()
            if playerCount <= maxPlayers then
                local player = child.Value :: Player
                player:AddTag("InLobby")
                updateCountDown()
            else

                -- push back the player
                child:Destroy()
                print("Lobby is full. Max players: " .. maxPlayers)
            end
        end
    end)

    Folder.ChildRemoved:Connect(function(child)
        if child:IsA("ObjectValue") then
            local player = child.Value :: Player
            player:RemoveTag("InLobby")
            updateCountDown()
        end
    end)

end

return module