local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local ActionButton = {}

local Fusion = require(game.ReplicatedStorage.Packages.fusion)
local Children, Computed, OnEvent, Value, Spring, peek, Tween = Fusion.Children, Fusion.Computed, Fusion.OnEvent, Fusion.Value, Fusion.Spring, Fusion.peek, Fusion.Tween
local TextLabelWithStroke = require(script.Parent.Parent.Text.TextLabelWithStroke)
local shadowimg = "rbxassetid://11953711609"

local ClickSound = SoundService.UI.Click
local HoverSound = SoundService.UI.Hover


type UsedAs<T> = Fusion.UsedAs<T>

local function ActionButton(
    scope: Fusion.Scope,
    props: {
        Position: UsedAs<UDim2>?,
        AnchorPoint: UsedAs<Vector2>?,
        Size: UsedAs<UDim2>?,
        LayoutOrder: UsedAs<number>?,
        ButtonText: UsedAs<string>,
        BackgroundColor3: UsedAs<Color3>?,
        Image: UsedAs<string>?,
        ImageSize: UsedAs<UDim2>?,
        ScaleType : UsedAs<Enum.ScaleType>?,
        KeyCode : UsedAs<Enum.KeyCode>?,
        ButtonDown : UsedAs<() -> ()>?,
        ButtonUp : UsedAs<() -> ()>?,
        Cooldown : UsedAs<number>?,
        Visible : UsedAs<boolean>?,
    }
)

    local isPressed : Fusion.Value = scope:Value(false)
    local goal : Fusion.Value = scope:Value(1)
    local shadowColor : Fusion.Value = scope:Value(Color3.fromRGB(0, 0, 0))
    local Timeuntil : Fusion.Value = scope:Value(0)
    local Lastinput = 0 -- 0 = began 1 = ended

    local function startCooldown()
        Timeuntil:set(props.Cooldown)

        task.spawn(function()
            while peek(Timeuntil) > 0 do
                task.wait(1)
                Timeuntil:set(peek(Timeuntil) - 1)
            end
        end)

    end

    if props.KeyCode then
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == props.KeyCode then

                if peek(Timeuntil) > 0 then
                    return
                end

                if props.Cooldown or props.Cooldown then
                    startCooldown()
                end

                shadowColor:set(props.BackgroundColor3)
                goal:set(0.9)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == props.KeyCode then
                goal:set(1)
                shadowColor:set(Color3.fromRGB(0, 0, 0))
            end
        end)
    end



    return scope:New "ImageButton" {
        BackgroundColor3 = props.BackgroundColor3 or Color3.new(1, 1, 1),
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,
        Size = props.Size,
        LayoutOrder = props.LayoutOrder or 1,
        Visible = props.Visible,
        [OnEvent("MouseButton1Down")] = function(_, numClicks)

            Lastinput = 0

            if peek(Timeuntil) > 0 then
                return
            end

            if props.ButtonDown then
                props.ButtonDown()
            end

            shadowColor:set(props.BackgroundColor3)
            goal:set(0.9)

            SoundService:PlayLocalSound(HoverSound)

            if props.Cooldown or props.Cooldown then
                startCooldown()
            end

        end,

        [OnEvent("MouseButton1Up")] = function(_, numClicks)

            Lastinput = 1

            if props.ButtonUp then
                props.ButtonUp()
            end

            SoundService:PlayLocalSound(ClickSound)


            goal:set(1.1)
            shadowColor:set(Color3.new(props.BackgroundColor3.R/2, props.BackgroundColor3.G/2, props.BackgroundColor3.B/2))

        end,

        [OnEvent("MouseEnter")] = function(_, numClicks)
            goal:set(1.1)
            shadowColor:set(Color3.new(props.BackgroundColor3.R/2, props.BackgroundColor3.G/2, props.BackgroundColor3.B/2))

        end,

        [OnEvent("MouseLeave")] = function(_, numClicks)

            if Lastinput == 0 and props.ButtonUp then
                --props.ButtonUp()
            end

            goal:set(1)
            shadowColor:set(Color3.fromRGB(0, 0, 0))

        end,

        [Children] = {
            scope:New "UICorner" {
                CornerRadius = UDim.new(1, 0)
            },
            scope:New "UIStroke" {
                Thickness = 4,
                Color = scope:Computed(function()

                    return props.BackgroundColor3 or Color3.new(1, 1, 1)
                end),
                Transparency = 0.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            },
            scope:New "UIAspectRatioConstraint" {
                AspectRatio = 1
            },
            scope:New "ImageLabel" {
                BackgroundTransparency = 1,
                Size = props.ImageSize or UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Image = props.Image or "",
                ScaleType = props.ScaleType,
                [Children] = {
                    scope:New "UIAspectRatioConstraint" {
                        AspectRatio = 1
                    }
                }
            },

            scope:New "UIScale" {

                Scale = scope:Tween(goal, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))

            },

            TextLabelWithStroke(scope, {
                Position = UDim2.new(0.5, 0, -0.2, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(1, 0, 0.2, 0),
                LayoutOrder = 1,
                TextColor = Color3.new(1, 1, 1),
                StrokeColor = Color3.new(0, 0, 0),
                Text = props.ButtonText or ""
            }),

            scope:New "ImageLabel" {

                Name = "Shadow",
                Size = UDim2.fromScale(3,3),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Image = shadowimg,
                ImageColor3 = scope:Tween(shadowColor, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)),
                BackgroundTransparency = 1,
                ZIndex = -1,

            },

            scope:New "TextLabel" { -- cooldown text
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 0,
                BackgroundColor3 = props.BackgroundColor3 or Color3.new(1, 1, 1),
                Text = scope:Computed(function(use)
                    use(Timeuntil)
                    if peek(Timeuntil) > 0 then
                        return math.ceil(peek(Timeuntil))
                    else
                        return ""
                    end
                end),
                Visible = scope:Computed(function(use)
                    return use(Timeuntil) > 0
                end),
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.SourceSansBold,
                TextSize = 40,
                ZIndex = 2,
                [Children] = {
                    scope:New "UICorner" {
                        CornerRadius = UDim.new(1, 0)
                    },
                    scope:New "UIStroke" {
                        Thickness = 2,
                        Color = Color3.new(props.BackgroundColor3.R/2, props.BackgroundColor3.G/2, props.BackgroundColor3.B/2) or Color3.new(0.078431, 0.078431, 0.078431),
                        Transparency = 0.5,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
                    }
                }
            }



        }


    }
end

return ActionButton