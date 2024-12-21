local CollectionService = game:GetService("CollectionService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)

local PromptService = Knit.CreateService {
    Name = "PromptService",
    Client = {}
}


function PromptService:KnitInit()

    self.Modules = {}
    self.Signals = {}

    -- require modules
    local PromptTypes = script.PromptTypes

    for _, moduleScript in ipairs(PromptTypes:GetChildren()) do

        self.Modules[moduleScript.Name] = require(moduleScript)
        self.Signals[moduleScript.Name] = {
            Triggered = Signal.new()
        }

    end

    -- create prompts

    local function AddPrompt(taged : Instance, type)
        local newProximityPrompt = Instance.new("ProximityPrompt")
        newProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
        newProximityPrompt.RequiresLineOfSight = taged:GetAttribute("LineOfSight") or false
        newProximityPrompt.Exclusivity = Enum.ProximityPromptExclusivity.OneGlobally
        newProximityPrompt.HoldDuration = taged:GetAttribute("Hold") or 0
        newProximityPrompt.ClickablePrompt = true
        newProximityPrompt:AddTag(type)
        print("Added Prompt", type)
        newProximityPrompt.Parent = taged
    end

    for _,v : Instance in ipairs(CollectionService:GetTagged("PromptService")) do

        -- find a prompt type that matches the tag

        for index, tag in (v:GetTags()) do
            if self.Modules[tag] then
                if not v:IsDescendantOf(game.Workspace) then
                    continue
                end
                AddPrompt(v, tag)
            end

        end

    end

    CollectionService:GetInstanceAddedSignal("PromptService"):Connect(function(instance)

        for index, tag in (instance:GetTags()) do

            if self.Modules[tag] then
                if not instance:IsDescendantOf(game.Workspace) then
                    continue
                end
                AddPrompt(instance, tag)
                break
            end

        end

    end)

end

function PromptService:GetSignal(promptType : string) : Signal.Signal

    if not self.Signals[promptType] then
        error("signal not found " .. promptType)
    end

    return self.Signals[promptType]
end

function PromptService:KnitStart()
    -- init all when all services are loaded

    for _, module in pairs(self.Modules) do

        if module.Init then
            module:Init()
        end

    end

    local function _triggered(prompt, player)

        local promptType = prompt:GetTags()[1]

        -- fire signal
        if not self.Signals[promptType] then
            return
        end
        self.Signals[promptType].Triggered:Fire(prompt, player)

        if self.Modules[promptType] then
            self.Modules[promptType]:Triggered(prompt, player)
        end

    end

    local function _holdBegan(prompt, player)

        local promptType = prompt:GetTags()[1]

        if self.Modules[promptType] and self.Modules[promptType].HoldEnd then
            self.Modules[promptType]:HoldStart(prompt, player)
        end

    end

    local function _holdEnded(prompt, player)

        local promptType = prompt:GetTags()[1]

        if self.Modules[promptType] and self.Modules[promptType].HoldEnd then
            self.Modules[promptType]:HoldEnd(prompt, player)
        end

    end


    ProximityPromptService.PromptTriggered:Connect(function(prompt, player)

        _triggered(prompt, player)

    end)

    ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, player)

        _holdBegan(prompt, player)

    end)

    ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt, player)

        _holdEnded(prompt, player)

    end)

end


return PromptService

