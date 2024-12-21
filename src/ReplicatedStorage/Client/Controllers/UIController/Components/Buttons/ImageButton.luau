local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local ImageButton = {}

local Fusion = require(game.ReplicatedStorage.Packages.fusion)
local Children, Computed, OnEvent, Value, Spring, peek, Tween = Fusion.Children, Fusion.Computed, Fusion.OnEvent, Fusion.Value, Fusion.Spring, Fusion.peek, Fusion.Tween

local shadowimg = "rbxassetid://11953711609"

local ClickSound = SoundService.UI.Click
local HoverSound = SoundService.UI.Hover


type UsedAs<T> = Fusion.UsedAs<T>

local function ImageButton(
    scope: typeof(Fusion.scoped(Fusion)),
    props: {
        Position: UsedAs<UDim2>?,
        AnchorPoint: UsedAs<Vector2>?,
        Size: UsedAs<UDim2>?,
        Visible : UsedAs<boolean>?,
        LayoutOrder: UsedAs<number>?,
        Rotation : UsedAs<number>?,
        BackgroundColor3: UsedAs<Color3>?,
        ZIndex: UsedAs<number>?,
        Image: UsedAs<string>?,
        ImageSize: UsedAs<UDim2>?,
        Build : UsedAs<() -> ()>?,
        ButtonDown : UsedAs<() -> ()>?,
        ButtonUp : UsedAs<() -> ()>?,
    }
)

    local goal : Fusion.Value = scope:Value(1)
    local Timeuntil : Fusion.Value = scope:Value(0)
    local Lastinput = 0 -- 0 = began 1 = ended

    return scope:New "ImageButton" {

        BackgroundTransparency = 1,
        ImageTransparency = 1,
        BackgroundColor3 = props.BackgroundColor3 or Color3.new(1, 1, 1),
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,
        Visible = props.Visible or true,
        Size = props.Size,
        LayoutOrder = props.LayoutOrder or 1,
        ZIndex = props.ZIndex or 1,
        [OnEvent("MouseButton1Down")] = function(_, numClicks)

            Lastinput = 0

            if peek(Timeuntil) > 0 then
                return
            end

            if props.ButtonDown then
                props.ButtonDown()
            end

            goal:set(0.9)

        end,

        [OnEvent("MouseButton1Up")] = function(_, numClicks)

            Lastinput = 1

            if props.ButtonUp then
                props.ButtonUp()
            end

            SoundService:PlayLocalSound(ClickSound)


            goal:set(1.1)

        end,

        [OnEvent("MouseEnter")] = function(_, numClicks)
            goal:set(1.1)
            SoundService:PlayLocalSound(HoverSound)


        end,

        [OnEvent("MouseLeave")] = function(_, numClicks)

            if Lastinput == 0 and props.ButtonUp then
            end

            goal:set(1)

        end,

        [Children] = {

            scope:New "ImageLabel" {
                BackgroundTransparency = 1,
                Size = props.ImageSize or UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Rotation = props.Rotation or 0,

                Image = props.Image or "",
                [Children] = {
                    scope:New "UIAspectRatioConstraint" {
                        AspectRatio = 1
                    }
                }
            },

            scope:New "UIScale" {

                Scale = scope:Tween(goal, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))

            },


            props.Build and props.Build(scope)


        }


    }
end

return ImageButton