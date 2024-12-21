local Skins = {}
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local computed = Fusion.Computed
local forKeys = Fusion.ForKeys
local forPairs = Fusion.ForPairs
local forValues = Fusion.ForValues
local new = Fusion.New
local Card = require(script.Parent.Parent.Parent.Components.UI.Card)
local Window = require(script.Parent.Parent.Parent.Components.UI.Window)
local DefaultButton = require(script.Parent.Parent.Parent.Components.Buttons.DefaultButton)
local ViewportFrame = require(script.Parent.Parent.Parent.Components.UI.ViewportFrame)
local TextLabelWithStroke = require(script.Parent.Parent.Parent.Components.Text.TextLabelWithStroke)

function Skins:Start() -- knit start

end

function Skins:Build(scope : typeof(Fusion.scoped(Fusion)), open)

    local selectedCatagory = scope:Value("Parent")

    self.DataController = Knit.GetController("DataController")
    self.DataService = Knit.GetService("DataService")


    ready, data = self.DataService.DataProperty:OnReady():await()

    local babySkins = scope:Value(data.Skins.Baby.OwnedSkins)
    local parentSkins = scope:Value(data.Skins.Parent.OwnedSkins)

    self.DataController:OnDataChanged("Skins", function(data)

        babySkins:set(data.Baby)
        parentSkins:set(data.Parent)

    end)

    print("Data ready", data)

    return Window(scope, {
		HeaderText = "Skins",
		Open = open,
		Build = function(scope)
			return {

                DefaultButton(scope, {

                    Position = UDim2.fromScale(0, 0.1),
                    Size = UDim2.fromScale(0.2, 0.2),
                    Text = "Parent",
                    ZIndex = 4,
                    ButtonUp = function()
                        selectedCatagory:set("Parent")
                    end,
                    ButtonDown = function()
                    end,
                }),

                DefaultButton(scope, {

                    Position = UDim2.fromScale(0, 0.25),
                    Size = UDim2.fromScale(0.2, 0.2),
                    Text = "Baby",
                    ZIndex = 4,
                    ButtonUp = function()
                        print("Selected Baby")
                        selectedCatagory:set("Baby")
                    end,
                    ButtonDown = function()
                    end,
                }),

				scope:New "ScrollingFrame" {
                    ZIndex = 3,
                    Visible = scope:Computed(function(use)
                        return use(selectedCatagory) == "Baby"
                    end),
					Size = UDim2.new(0.95, 0, 0.8, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    CanvasSize = UDim2.new(0, 0, 4, 0),
                    [Children] = {
                        scope : New "UIGridLayout" {
                            CellSize = UDim2.fromScale(0.32, 0.2),
                           -- CellPadding = UDim2.fromOffset(0.03, 0),

                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            VerticalAlignment = Enum.VerticalAlignment.Top,
                        },

                        forPairs(scope, babySkins, function(use, scope, key, value)

                            local skins = ReplicatedStorage.Data.Skins
                            local skin = skins:FindFirstChild(key)

                            return 1, scope:New "Frame" {
                                [Children] = {
                                    scope:New "UICorner" {
                                        CornerRadius = UDim.new(0.1, 0),
                                    },

                                    DefaultButton(scope, {
                                        Position = UDim2.fromScale(0.5, 0.8),
                                        Size = UDim2.fromScale(0.7, 0.2),
                                        Text = "Equipped",
                                        ZIndex = 4,
                                        ButtonUp = function()

                                        end,
                                        ButtonDown = function()
                                        end,
                                    }),

                                    ViewportFrame(scope, {
                                        CameraCFrame = CFrame.new(0, 3, 3),
                                        Size = UDim2.fromScale(1, 0.8),
                                        Model = skin,
                                        Build = function(scope)
                                            return {
                                            }
                                        end,
                                        SetupModel = function(model)

                                            wait(0.2)

                                            local humanoid = model:FindFirstChildOfClass("Humanoid")
                                            local animator = humanoid:FindFirstChildOfClass("Animator")
                                            local animationId = "rbxassetid://117975796816717"
                                            local animation = Instance.new("Animation")
                                            animation.Parent = humanoid
                                            animation.AnimationId = animationId
                                            local track = animator:LoadAnimation(animation)

                                            track.Priority = Enum.AnimationPriority.Action4
                                            track.Looped = true
                                            track:Play()

                                            --animator

                                        end,
                                    })

                                }
                            }

                        end)

                    }

                },

                scope:New "ScrollingFrame" {
                    ZIndex = 3,
                    Visible = scope:Computed(function(use)
                        return use(selectedCatagory) == "Parent"
                    end),
					Size = UDim2.new(0.95, 0, 0.77, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.55, 0),
                    BackgroundTransparency = 1,
                    CanvasSize = UDim2.new(0, 0, 4, 0),
                    [Children] = {
                        scope : New "UIGridLayout" {
                            CellSize = UDim2.fromScale(0.32, 0.2),
                           -- CellPadding = UDim2.fromOffset(0.03, 0),

                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            VerticalAlignment = Enum.VerticalAlignment.Top,
                        },

                        forPairs(scope, parentSkins, function(use, scope, key, value)

                            local skins = ReplicatedStorage.Data.Skins
                            local skin = skins:FindFirstChild(key)

                            return key, scope:New "Frame" {
                                [Children] = {
                                    scope:New "UICorner" {
                                        CornerRadius = UDim.new(0.1, 0),
                                    },

                                    DefaultButton(scope, {
                                        Position = UDim2.fromScale(0.5, 0.8),
                                        Size = UDim2.fromScale(0.7, 0.2),
                                        Text = "Equipped",
                                        ZIndex = 4,
                                        ButtonUp = function()
                                        end,
                                        ButtonDown = function()
                                        end,
                                    }),

                                    ViewportFrame(scope, {
                                        CameraCFrame = CFrame.new(0, 3, 5),
                                        Size = UDim2.fromScale(1, 1),
                                        Model = skin,
                                        Build = function(scope)
                                            return {
                                            }
                                        end,
                                        SetupModel = function(model)

                                            wait(0.2)

                                            local humanoid = model:FindFirstChildOfClass("Humanoid")
                                            local animator = humanoid:FindFirstChildOfClass("Animator")
                                            local animationId = "rbxassetid://117975796816717"
                                            local animation = Instance.new("Animation")
                                            animation.Parent = humanoid
                                            animation.AnimationId = animationId
                                            local track = animator:LoadAnimation(animation)

                                            track.Priority = Enum.AnimationPriority.Action4
                                            track.Looped = true
                                            track:Play()

                                            --animator

                                        end,
                                    })

                                }
                            }

                        end)

                    }

                },
			}
		end,
	})
end

return Skins
