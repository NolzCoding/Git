local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children

local Card = {}


local function Card(scope : typeof(Fusion.scoped(Fusion)), props : {
    Position : UDim2?,
    AnchorPoint : Vector2?,
    Size : UDim2?,
    LayoutOrder : number?,
    AspectRatio : number?,
    Image : string?,
    Build : (scope : any) -> (),
})

    return scope:New "ImageLabel" {
        Name = "Card",
        AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://70566867826486",
        Position = props.Position or UDim2.fromScale(0.5, 0.5),
        Size = props.Size or UDim2.fromScale(0.475, 0.515),
        [Children] = {
            scope:New "UIAspectRatioConstraint" {
                AspectRatio = 1.7,
            },
            props.Build and props.Build(scope),
        }

      }

end

return Card