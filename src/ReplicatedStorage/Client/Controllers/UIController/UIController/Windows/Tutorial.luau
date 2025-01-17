local VoteMap = {}
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children, OnEvent = Fusion.Children, Fusion.OnEvent
local computed = Fusion.Computed
local forPairs = Fusion.ForPairs
local forValues = Fusion.ForValues
local Card = require(script.Parent.Parent.Parent.Components.UI.Card)
local Window = require(script.Parent.Parent.Parent.Components.UI.Window)
local DefaultButton = require(script.Parent.Parent.Parent.Components.Buttons.DefaultButton)
local TextLabelWithStroke = require(script.Parent.Parent.Parent.Components.Text.TextLabelWithStroke)
local Section = require(script.Parent.Parent.Parent.Components.UI.Section)
local AbsoluteScaleComputed = require(ReplicatedStorage.Source.Shared.Uitility.AbsoluteScaleComputed)
local ImageButton = require(script.Parent.Parent.Parent.Components.Buttons.ImageButton)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local TweenService = game:GetService("TweenService")
function VoteMap:Start() -- knit start
end

function VoteMap:Build(scope: typeof(Fusion.scoped(Fusion)), open)
	self.UIController = Knit.GetController("UIController")
	self.DataService = Knit.GetService("DataService")
	self.DataController = Knit.GetController("DataController")
	self.MatchService = Knit.GetService("MatchService")
	self.AchievementService = Knit.GetService("AchievementService")
	self.NotificationController = Knit.GetController("NotificationController")



	return Window(scope, {
		HeaderText = "Hey New Player!",
		Size = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Open = open,
		Build = function(scope)
			return scope:New("Frame")({
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 5,
				Position = UDim2.new(0.5, 0, 0.75, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				[Children] = {

                    TextLabelWithStroke(scope, {
                        RichText    = true,
                        Text = 'Goal of <font color="#FF005D"> Parents </font> is to make sure all babies are safe',
                        Size = UDim2.fromScale(0.5, 0.2),
                        Position = UDim2.fromScale(0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                    }),

                    TextLabelWithStroke(scope, {
                        Text = 'Goal of <font color="#006eff"> Babies </font> is to get their lungs, heart and stomach to 0%',
                        Size = UDim2.fromScale(0.5, 0.2),
                        Position = UDim2.fromScale(0.5, 0.2),
                        RichText    = true,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                    }),

                    scope: New "ImageLabel" {
                        Size = UDim2.fromScale(0.5, 0.25),
                        Position = UDim2.fromScale(0.5, 0.43),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Image = "rbxassetid://81001117587598",
                        ScaleType = Enum.ScaleType.Fit,
                    },

				},
			})
		end,
	})
end

return VoteMap
