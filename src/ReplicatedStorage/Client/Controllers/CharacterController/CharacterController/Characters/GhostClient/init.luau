local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NexusInstance = require(ReplicatedStorage.Source.Shared.Uitility.NexusInstance)
local BabyClient = require(script.Parent.BabyClient)
local GhostClient = {}

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children

GhostClient.__index = GhostClient
setmetatable(GhostClient, BabyClient) --TestClass1NexusInstance would be returned instead of TestClass1.

export type GhostClient = {
    TestProperty2: string,
} & typeof(setmetatable({}, GhostClient)) & BabyClient.BabyClient
export type NexusInstanceGhostClient = NexusInstance.NexusInstance<GhostClient>

function GhostClient.__new(self: NexusInstanceGhostClient, character : Model?)
    self.ItemSlots = 0
    self.BuildUI = function(scope)

        return {
            scope:New "Frame" {
                Size = UDim2.new(0.2, 0, 0.2, 0),
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.new(0.5, 0, 0.9, 0),

                [Children] = {
                    scope:New "TextLabel" {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = "You're Dead (That's good)",
                        Font = Enum.Font.FredokaOne,
                        TextColor3 = Color3.fromRGB(255, 31, 31),
                        TextScaled = true,
                        [Children] = {
                            scope:New "UIStroke" {
                                Color = Color3.fromRGB(8, 8, 8),
                                Thickness = 2,
                            }
                        }
                    },
                    scope:New "UIAspectRatioConstraint" {
                        AspectRatio = 0.5,
                    }
                }

            }
        }

    end

    BabyClient.__new(self, character, true) --Remember to call the parent constructor!

    local function onTransparencyChanged()
        print("Transparency Changed")
        for _,v in ipairs((game.Players.LocalPlayer.Character :: Model):GetDescendants()) do

            if v.Name == "HumanoidRootPart" then
                continue
            end

            if v:IsA("BasePart") then
                v.Transparency = 0.5
                v.Material = Enum.Material.ForceField
            elseif v:IsA("Decal") then
                v.Transparency = 0.5
            end
        end
    end
task.delay(5, function()
    onTransparencyChanged()

end)

    print("Hello does this even run")
    local upperTorso = (character):WaitForChild("Head") :: Part

    print(upperTorso.Transparency)

    if upperTorso.Transparency == 1 then
        onTransparencyChanged()
    else
        upperTorso:GetPropertyChangedSignal("Transparency"):Connect(function(...: any)
            onTransparencyChanged()
        end)
    end

    task.wait(5)
    print(character.Parent)





end



return NexusInstance.ToInstance(GhostClient) :: NexusInstance.NexusInstanceClass<typeof(GhostClient), (character : Model?) -> (NexusInstanceGhostClient)>