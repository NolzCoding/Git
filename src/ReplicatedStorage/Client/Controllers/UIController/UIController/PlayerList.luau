local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local TextLabelWithStroke = require(script.Parent.Parent.Components.Text.TextLabelWithStroke)
local Players = game:GetService("Players")
local function PlayerList(scope : typeof(Fusion:scoped()),
    props : {
        Players : {Alive : {Player}, Dead : {Player}},
        Size : UDim2?,
        Position : UDim2?,
        AnchorPoint : Vector2?,
        Color : Color3?,
        HorizontalAlignment : Enum.HorizontalAlignment?,
    }

)

    local Alive = scope:Computed(function(use)
        return use(props.Players).Alive
    end)

    local Dead = scope:Computed(function(use)
        return use(props.Players).Dead
    end)

    return scope:New "Frame" {
        Size = props.Size or UDim2.fromScale(0.2, 0.2),
        Position = props.Position or UDim2.fromScale(0.5, 0.5),
        AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        [Children] = {
            scope: New "UIGridLayout" {
                CellSize = UDim2.fromScale(0.2, 0.5),
                CellPadding = UDim2.fromOffset(0, 5),
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = props.HorizontalAlignment or Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Top,
            },
            scope:ForValues(Alive, function(use, scope, value: Player)


                local userId = value.UserId
                local thumbType = Enum.ThumbnailType.HeadShot
                local thumbSize = Enum.ThumbnailSize.Size420x420
                local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

                return scope:New "ImageLabel" {
                    Size = UDim2.fromScale(0.1, 0.1),
                    Image = content,
                    [Children] = {
                        TextLabelWithStroke(scope, {
                            Text = value.Name,
                            Size = UDim2.fromScale(1, 0.2),
                            Position = UDim2.fromScale(0.5, 0.8),
                            StrokeColor = Color3.fromRGB(46, 46, 46),
                            TextColor = Color3.fromRGB(194, 255, 252),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                        }),
                        scope : New "UIAspectRatioConstraint" {
                            AspectRatio = 1,
                        },
                        scope : New "UICorner" {
                            CornerRadius = UDim.new(1, 0),
                        },
                        scope : New "UIStroke" {
                            Color = props.Color or Color3.fromRGB(255, 255, 255),
                            Thickness = 2,
                        },
                    }
                }
            end)
        }
    }

end
return PlayerList