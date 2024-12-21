local MomGoAway = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Promise = require(Knit.Util.Promise)

local Fusion = require(ReplicatedStorage.Packages.fusion)
local peek = Fusion.peek
Children = Fusion.Children
local SubtitlesUI = require(script.Parent.Parent.UI.Subtitles)
local CinematicBars = require(script.Parent.Parent.UI.CinematicBars)

function MomGoAway:Start()

    local MomCutscene = game:GetService("ReplicatedStorage").Cutscene.MomCutscene:Clone() --script.Parent.Parent.MomCutscene:Clone()
    MomCutscene.Parent = game.Workspace

    local scope = Fusion.scoped(Fusion)

    local promise = Promise.new(function(resolve, reject)

        local camera = workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = MomCutscene.Camera.Part.CFrame

        local subtitles = scope:Value("")
        local voice = script.Parent.Parent.Voice
        local visible = scope:Value(false)

        scope:New "ScreenGui" {
            Parent = game.Players.LocalPlayer.PlayerGui,
            IgnoreGuiInset = true,
            [Children] = {
                SubtitlesUI(scope, {
                    Text = subtitles,
                    Sound = voice
                }),

                CinematicBars(scope, {
                    Visible = visible
                })

            }
        }

        visible:set(true)

        subtitles:set("Mom: Dad is waiting for you, go to him")

        print("MomGoAway Start")

        wait(4)

        subtitles:set("Mom: Make sure to NOT go to the basement and stay out of trouble")

        task.wait(4)


        local track = MomCutscene.Mother.Humanoid.Animator:LoadAnimation(MomCutscene.Mother["High Wave Face"])
        track.Looped = true
        track.Priority = Enum.AnimationPriority.Action4
        track:Play()
        subtitles:set("Mom: Goodbye my children! And dad, make sure they don't hurt themselves")


        task.wait(4)
        track:Stop()

        MomCutscene.Mother.Humanoid:MoveTo(MomCutscene["1"].Position, MomCutscene["1"])
        MomCutscene.Mother.Humanoid.MoveToFinished:Wait()
        MomCutscene.Mother.Humanoid:MoveTo(MomCutscene["2"].Position, MomCutscene["2"])

        MomCutscene.Mother.Humanoid.MoveToFinished:Wait()

        visible:set(false)


        task.wait(1)

        print("MomGoAway End")

        resolve()

    end)

    promise:finally(function()
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
        MomCutscene:Destroy()
        scope:doCleanup()

    end)

    return promise

end



return MomGoAway