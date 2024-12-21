local character = script.Parent.Parent :: Model


-- set all baseparts Collision groups to Player

for _,v in pairs(character:GetDescendants()) do
    if v:IsA("BasePart") then
        v.CollisionGroup = "Player"
    end
end