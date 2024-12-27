local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)


local Children = Fusion.Children


-- uses AbsoluteCanvasSize to calculate offset of UDim2
local function AbsoluteScaleComputed(scope : typeof(Fusion.scoped(Fusion)), AbsoluteCanvasSize, udim2 : UDim2)

    return scope:Computed(function(use, scope)

        local absoluteCanvasSize = use(AbsoluteCanvasSize)

        local x = udim2.X.Scale * absoluteCanvasSize.X + udim2.X.Offset
        local y = udim2.Y.Scale * absoluteCanvasSize.Y + udim2.Y.Offset

        return UDim2.new(0, x, 0, y)

    end)

end

return AbsoluteScaleComputed