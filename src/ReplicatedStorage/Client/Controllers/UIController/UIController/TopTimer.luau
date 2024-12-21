local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TextLabelWithStroke = require(ReplicatedStorage.Source.Client.Controllers.UIController.Components.Text.TextLabelWithStroke)

local Fusion = require(game.ReplicatedStorage.Packages.fusion)


local Children, UICorner = Fusion.Children
local TopTimer = {}

local Knit = require(ReplicatedStorage.Packages.Knit)

type UsedAs<T> = Fusion.UsedAs<T>

local function TopTimer(
    scope: typeof(Fusion.scoped(Fusion)),
    props: {
        Position: UsedAs<UDim2>?,
        AnchorPoint: UsedAs<Vector2>?,
        Size: UsedAs<UDim2>?,
        LayoutOrder: UsedAs<number>?,
        AspectRatio: UsedAs<number>?,
    }
)

    local scale  = scope:Value(1)
    local text  = scope:Value("Hello World")
    local timeTillnext = 0
    local futureTimeText  = scope:Value("")

    local GameService = Knit.GetService("GameService")

    GameService.StateSignal:Connect(function(state, stateText, time)
        text:set(stateText)
        timeTillnext = time
    end)

    RunService.Heartbeat:Connect(function()

        if timeTillnext == 0 then
            futureTimeText:set("00:00")
            return
        end

        local difference = timeTillnext - workspace:GetServerTimeNow()

        local minutes = math.floor(difference / 60)
        local seconds = math.floor(difference % 60)

        if string.format("%02d:%02d", minutes, seconds) == Fusion.peek(futureTimeText) then
            return
        end

        futureTimeText:set(string.format("%02d:%02d", minutes, seconds))

        print("a")
        scale:set(1.1)
        wait(0.1)
        scale:set(1)

    end)

    return scope:New "Frame" {
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,
        Size = props.Size,
        LayoutOrder = props.LayoutOrder,


        [Children] = {
            scope:New "UIStroke" {
                Thickness = 3,
                Color = Color3.fromRGB(61, 33, 0),
                Transparency = 0.5
            },
            scope:New "UIAspectRatioConstraint" {
                AspectRatio = props.AspectRatio or 1,
            },

            scope:New "UICorner" {
                CornerRadius = UDim.new(0.3, 0)
            },

            TextLabelWithStroke(scope, {
                Position = UDim2.new(0.5, 0, 0.2, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0.8, 0, 0.5, 0),
                Text = text,
                StrokeColor = Color3.new(0.078431, 0.078431, 0.078431),
            }),

            TextLabelWithStroke(scope, {
                Position = UDim2.new(0.5, 0, 0.7, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0.8, 0, 0.5, 0),
                Text = futureTimeText,
                StrokeColor = Color3.new(0.078431, 0.078431, 0.078431),
                Build = function(newScope)
                    return newScope:New "UIScale" {
                        Scale = scope:Tween(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
                    }
                end
            }),

            scope:New "ImageLabel" {
                Position = UDim2.new(1, 0, 0.5, 0),
                Rotation = 20,

                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0.5, 0, 1.2, 0),
                Image = "rbxassetid://96327058483878",

                BackgroundTransparency = 1,
                Name = "HourGlass",
                [Children] = {
                    scope:New "UIAspectRatioConstraint" {
                        AspectRatio = 1
                    }
                }
            },

            scope:New "UIGradient" {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 195, 66)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 136, 0))
                }),
                Rotation = 90,

            }

        }


    }
end

return TopTimer