local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local BabyServer = require(script.Characters.BabyServer)
local CharacterBaseServer = require(script.CharacterBaseServer)
local ParentServer = require(script.Characters.ParentServer)

local CharacterService = Knit.CreateService{
    Name = "CharacterService",
    Client = {}
}

function CharacterService:KnitInit()


    self.PlayerCharacters = {}
    local count = 0
    Players.PlayerAdded:Connect(function(player)

        self:NewCharacter(player, "Parent")

        if true then return end

        player.CharacterAdded:Connect(function(character)

            if count == 0 then
                self:NewCharacter(player, "Parent")

                --local char = BabyServer.new(player, character)
                --self.PlayerCharacters[player] = char
            else
                self:NewCharacter(player, "Baby")

                --local char = ParentServer.new(player, character)
                --self.PlayerCharacters[player] = char
            end

            count += 1

        end)

    end)

    Players.PlayerRemoving:Connect(function(player)
        -- remove the character
        if self.PlayerCharacters[player] then

            local character = self.PlayerCharacters[player] :: CharacterBaseServer.CharacterBaseServer
            character.Died:Fire() -- fire the died event
            character:Destroy()
            self.PlayerCharacters[player] = nil
        end
    end)

end

function CharacterService:NewCharacter(player, characterName) : CharacterBaseServer.CharacterBaseServer

    local character = player.Character or player.CharacterAdded:Wait()

    if characterName == "Parent" then
        local char = ParentServer.new(player, character)
        self.PlayerCharacters[player] = char
        return char
    else
        local char = BabyServer.new(player, character)
        self.PlayerCharacters[player] = char
        return char
    end

end

function CharacterService:GetCharacter(player)
    return self.PlayerCharacters[player]
end

function CharacterService:CallMethod(methodName, ...) -- server side
    local method = self[methodName]

    if method then
        method(self, ...)
    else
        warn("S Method ", methodName, " not found in ", self)
    end

end


function CharacterService.Client:CallMethod(player, methodName, ...)
    -- check which character the player is using

    local character = player.Character
    if not character then return end

    character = character:GetAttribute("Character")
    local characterModule = self.Characters[character]

    local method = characterModule[methodName]

    if method then
        method(characterModule, player ,...)
    else
        warn("C Method ", methodName, " not found in ", character)
    end

end

function CharacterService:KnitStart()

end

return CharacterService