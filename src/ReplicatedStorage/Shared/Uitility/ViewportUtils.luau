local module = {}

function module:UpdateCFrame(model : Model | Tool, camera : Camera, cframeOffset : CFrame, depthMultiplier : number?)
    local BoundingCFrame,BoundingSize = model:GetBoundingBox()
    local ModelCenter = BoundingCFrame.p

    --Determine the distance back.
    local MaxSize = math.max(BoundingSize.X,BoundingSize.Y,BoundingSize.Z)
    local DistanceBack = ((MaxSize/math.tan(math.rad(camera.FieldOfView)))) * (depthMultiplier or 1)
    local Center = CFrame.new(ModelCenter)
    camera.CFrame = Center * cframeOffset * CFrame.new(0,0,(MaxSize/2) + DistanceBack)
    camera.Focus = Center
end



return module