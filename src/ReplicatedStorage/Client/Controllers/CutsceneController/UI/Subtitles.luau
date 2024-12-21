local Subtitles = {}
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local peek, Children = Fusion.peek, Fusion.Children

local function Subtitles(scope : typeof(Fusion.scoped(Fusion)), props : {
    Text : string,
    Sound : Sound?
})

    local renderedText = scope:Value("")
    local SPEED = 2 -- how many seconds for full text to appear
    scope:Observer(props.Text):onChange(function()
        local newText = peek(props.Text)
        if newText == "" then
            renderedText:set("")

            return
        end
        print("running ", newText)

        renderedText:set("")

        local textLength = #newText
        local timePerChar = SPEED / textLength

        for i = 1, textLength do
            renderedText:set(newText:sub(1, i))
            if props.Sound then

                -- randomize pitch
                props.Sound.PlaybackSpeed = math.random(90, 110) / 100
                SoundService:PlayLocalSound(props.Sound)


            end
            task.wait(timePerChar)
        end

    end)

    return scope:New "TextLabel" {
        Size = UDim2.new(0.5, 0, 0.1, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.85, 0),
        BackgroundTransparency = 1,
        Text = renderedText,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextScaled = false,
        TextSize = 24,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSans,
        [Children] = {
            scope:New "UIStroke" {
                Color = Color3.fromRGB(0, 0, 0),
                Transparency = 0.5,
                Thickness = 2,
            },
        }
    }
end


return Subtitles