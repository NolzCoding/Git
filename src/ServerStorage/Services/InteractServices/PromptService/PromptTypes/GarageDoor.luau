local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GarageDoor = {}
local Knit = require(ReplicatedStorage.Packages.Knit)
local CharacterBase = require(game.ServerStorage.Source.Services.CharacterService.CharacterService.CharacterBaseServer)
local TweenServicePlus = require(ReplicatedStorage.Source.Shared.Uitility.TweenServicePlus)

function GarageDoor:Init()
    self.CharacterService = Knit.GetService("CharacterService")

end

function GarageDoor:Triggered(prompt : ProximityPrompt, player : Player)
    local door = prompt.Parent.Parent.Door
    local open = prompt:FindFirstChild("Open")

    if not open then
        open = Instance.new("BoolValue")
        open.Name = "Open"
        open.Parent = prompt
    end

    local SizeValue = door:FindFirstChild("Size")

    if not SizeValue then
        SizeValue = Instance.new("NumberValue")
        SizeValue.Name = "Size"
        SizeValue.Parent = door
        SizeValue.Value = door.Size.Y
    end
    local ysize = 0
    local offset = Vector3.new(0,SizeValue.Value,0)/2

    if open.Value then
        ysize = SizeValue.Value
        offset = Vector3.new(0,-ysize,0)/2

    end

    print(ysize)
    TweenServicePlus:Construct(door, TweenInfo.new(1), {Size = Vector3.new(door.Size.X, ysize, door.Size.Z), CFrame = door.CFrame + offset}):Play()
    open.Value = not open.Value

end

function GarageDoor:HoldStart(prompt : ProximityPrompt, player : Player)
    print("Binding")
    local character = self.CharacterService:GetCharacter(player) :: CharacterBase.CharacterBaseServer
    character:BindPartToIKControl("RightArm", prompt.Parent)

end

function GarageDoor:HoldEnd(prompt : ProximityPrompt, player : Player)

    local character = self.CharacterService:GetCharacter(player) :: CharacterBase.CharacterBaseServer
    character:UnBindPartFromIKControl("RightArm")

end

return GarageDoor