local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children, OnEvent, peek = Fusion.Children, Fusion.OnEvent, Fusion.peek
local alerts = {}
alerts.scope = Fusion:scoped()

alerts.GamepassAlert = alerts.scope:Value(false)
alerts.CratesAlert = alerts.scope:Value(true)

return alerts