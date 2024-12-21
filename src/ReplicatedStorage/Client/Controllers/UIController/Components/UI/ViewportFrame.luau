local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children

local ViewportFrame = {}


local function ViewportFrame(scope : typeof(Fusion.scoped(Fusion)), props : {
    Position : UDim2?,
    AnchorPoint : Vector2?,
    Size : UDim2?,
    LayoutOrder : number?,
    AspectRatio : number?,
    Model : Model,
    Build : (scope : any) -> (),
    SetupModel : (model : Model) -> (),
    CameraCFrame : Vector3?,
})

    local createModel = function()
        local newModel = props.Model:Clone()
        local newFusionModel = scope:Hydrate(newModel) {

        }



        newModel:PivotTo(CFrame.new())
        task.defer(function()
            props.SetupModel(newModel)
        end)
        return newFusionModel

    end

    local ViewportFrame = scope:New "ViewportFrame" {
        Name = "ViewportFrame",
        AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = props.Position or UDim2.fromScale(0.5, 0.5),
        Size = props.Size or UDim2.fromScale(0.475, 0.515),
        [Children] = {
            scope:New "UIAspectRatioConstraint" {
                AspectRatio = props.AspectRatio or 0.5,
            },

            scope:New "Camera" {
                CFrame = props.CameraCFrame,
            },
            scope:New "WorldModel" {
                [Children] = {
                    createModel(),
                },
            },
            props.Build and props.Build(scope),
        }

    } :: ViewportFrame

    ViewportFrame.CurrentCamera = ViewportFrame:WaitForChild("Camera")

    return ViewportFrame

end

return ViewportFrame