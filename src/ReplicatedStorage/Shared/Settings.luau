local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children, OnEvent, peek = Fusion.Children, Fusion.OnEvent, Fusion.peek

local scope = Fusion:scoped()
local module = {}

module.ShowItem = scope:Value(true)

return module