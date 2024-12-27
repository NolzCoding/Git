local TextLabelWithStroke = {}

local Fusion = require(game.ReplicatedStorage.Packages.fusion)
local Children, UICorner = Fusion.Children



type UsedAs<T> = Fusion.UsedAs<T>

local function TextLabelWithStroke(
    scope: Fusion.Scope,
    props: {
        Position: UsedAs<UDim2>?,
        AnchorPoint: UsedAs<Vector2>?,
        Size: UsedAs<UDim2>?,
        LayoutOrder: UsedAs<number>?,
        TextColor : UsedAs<Color3>?,
        Visible : UsedAs<boolean>?,
        TextXAlignment : UsedAs<Enum.TextXAlignment>?,
        Rotation : UsedAs<number>?,
        StrokeColor : UsedAs<Color3>?,
        Thickness : UsedAs<number>?,
        Text: UsedAs<string>,
        Build : UsedAs<{}>?,
    }
)

    if not props.Build then
        props.Build = function() end
    end

    return scope:New "TextLabel" {
        BackgroundTransparency = 1,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,
        TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center,
        Size = props.Size,
        LayoutOrder = props.LayoutOrder,
        Visible = props.Visible,
        Text = props.Text,
        TextScaled = true,
        Rotation = props.Rotation or 0,
        Font = Enum.Font.FredokaOne,
        TextColor3 = Color3.new(1, 1, 1),
        [Children] = {
            scope:New "UIStroke" {
                Thickness = props.Thickness or 2,
                Color = props.StrokeColor or Color3.new(0, 0, 0),
                LineJoinMode = Enum.LineJoinMode.Miter
            },

            props.Build(scope)
        }


    }
end

return TextLabelWithStroke