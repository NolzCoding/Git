local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Fusion = require(ReplicatedStorage.Packages.fusion) -- initialise Fusion here however you please!
local scoped = Fusion.scoped
local Children = Fusion.Children
type UsedAs<T> = Fusion.UsedAs<T>

local SPIN_DEGREES_PER_SECOND = 180
local SPIN_SIZE = 50

local function Spinner(
    scope: Fusion.Scope,
    props: {
        Layout: {
            LayoutOrder: UsedAs<number>?,
            Position: UsedAs<UDim2>?,
            AnchorPoint: UsedAs<Vector2>?,
            ZIndex: UsedAs<number>?
        },
        CurrentTime: UsedAs<number>,
    }
): Fusion.Child
    return scope:New "ImageLabel" {
        Name = "Spinner",

        LayoutOrder = props.Layout.LayoutOrder,
        Position = props.Layout.Position,
        AnchorPoint = props.Layout.AnchorPoint,
        ZIndex = props.Layout.ZIndex,

        Size = UDim2.fromOffset(SPIN_SIZE, SPIN_SIZE),

        BackgroundTransparency = 1,
        Image = "rbxassetid://73432109587941", -- replace this!

        Rotation = scope:Computed(function(use)
            return (use(props.CurrentTime) * SPIN_DEGREES_PER_SECOND) % 360
        end)
    }
end

return Spinner