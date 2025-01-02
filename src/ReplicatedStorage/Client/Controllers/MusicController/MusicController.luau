local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local SoundService = game:GetService("SoundService")
local Promise = require(ReplicatedStorage.Packages.Promise)
local MusicController = Knit.CreateController {
    Name = "MusicController";
}

function MusicController:KnitStart()

    self:PlayCatagory("Lobby")

end

function MusicController:ChangeVolume(volume : number)
    self.Volume = volume
    for _, catagory in pairs(self.Catagory) do
        for _, sound in pairs(catagory.Sounds) do
            sound.Volume = volume
        end
    end

end

function MusicController:Stop()
    for _, catagory in pairs(self.Catagory) do
        if catagory.Playing then
            catagory.Playing:Stop()
            catagory.Playing = nil
        end
    end

    if self.CurrentPromise then
        self.CurrentPromise:cancel()
    end

end

function MusicController:PlayCatagory(catagory : string)
    if self.Catagory[catagory].Playing then
        return
    end

    self:Stop()

    if self.CurrentPromise then
        self.CurrentPromise:cancel()
    end

    -- new index for the catagory
    self.Catagory[catagory].Index = self.Catagory[catagory].Index + 1

    self.CurrentPromise = Promise.new(function(resolve, reject)

        while true do

            local sound = self.Catagory[catagory].Sounds[self.Catagory[catagory].Index]
            sound:Play()
            self.Catagory[catagory].Playing = sound

            sound.Ended:Wait()

            if self.Catagory[catagory].Index == #self.Catagory[catagory].Sounds then
                self.Catagory[catagory].Index = 1
            else
                self.Catagory[catagory].Index = self.Catagory[catagory].Index + 1
            end

        end

    end)

end

function MusicController:KnitInit()

    local LobbyMusic = SoundService:WaitForChild("Lobby")
    local InGameMusic = SoundService:WaitForChild("InGame")

    self.CurrentPromise = nil

    self.Volume = 0.5

    self.Catagory = {
        Lobby = {
            Sounds = LobbyMusic:GetChildren(),
            Playing = nil,
            Index = 1,
        },
        InGame = {
            Sounds = InGameMusic:GetChildren(),
            Playing = nil,
            Index = 1,
        },
    }

end


return MusicController