local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharacterClientBase = require(script.CharacterClient)
local BabyClient = require(script.Characters.BabyClient)
local ParentClient = require(script.Characters.ParentClient)
local GhostClient = require(script.Characters.GhostClient)
local Knit = require(ReplicatedStorage.Packages.Knit)

local CharacterController = Knit.CreateController {
    Name = "CharacterController",
}


function CharacterController:KnitInit()



    self.Character = nil

    Players.LocalPlayer.CharacterAdded:Connect(function(character)

        --self.Characters.Baby:SpawnAsBaby(Players.LocalPlayer, character)
        --self.Character = BabyClient.new(character)

        while not character:GetAttribute("Character") do
            wait()
        end
        local characterType = character:GetAttribute("Character")

        task.delay(5, function()
            print(character.Parent)

        end)

        local currentCharacter = self.Character

        if self.Character then
            task.spawn(function()
                self.Character:Destroy()
            end)
        end

        if characterType == "Baby" then
            self.Character = BabyClient.new(character)
        end

        if characterType == "Parent" then
            self.Character = ParentClient.new(character)
        end

        if characterType == "Ghost" then
            self.Character = GhostClient.new(character)
        end


    end)

end

function CharacterController:GetCharacter()
    return self.Character
end

return CharacterController
