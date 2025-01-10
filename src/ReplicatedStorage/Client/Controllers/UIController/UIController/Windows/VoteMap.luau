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

	local signal = self.MatchService.VoteSignal

	local voteData = scope:Value({})

	local timee = scope:Value(0)

	signal:Connect(function(newVoteData, nextTime)
		print(newVoteData)
		voteData:set(newVoteData)

		if Fusion.peek(timee) == 0 then
			timee:set(10)
			for i = 1, 10 do
				wait(1)
				timee:set(Fusion.peek(timee) - 1)
			end
		end

	end)

	return Window(scope, {
		HeaderText = scope:Computed(function(use)
			return "Vote: " .. use(timee)
		end),
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
					scope:New("UIListLayout")({
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly,
						Padding = UDim.new(0, 0),
						--SortOrder = Enum.SortOrder.LayoutOrder,
					}),

					scope:Computed(function(use, scope)
						local children = {}

						for i = 1, 2 do
							table.insert(
								children,
								scope:New("Frame")({
									Name = "Frame",
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Position = UDim2.fromScale(0.5, 0.5),
									Size = UDim2.fromScale(0.5, 0.5),

									[Children] = {
										scope:New("ImageButton")({
											Name = "ImageButton",
											AnchorPoint = Vector2.new(0.5, 0.5),
											Image = scope:Computed(function()
												return use(voteData)[i] and use(voteData)[i].Image or ""
											end),
											Position = UDim2.fromScale(0.5, 0.5),
											Size = UDim2.fromScale(1, 1),

											[OnEvent("MouseButton1Click")] = function()
												print("Clicked")
												self.MatchService:Vote(i)
											end,

											[Children] = {
												scope:New("TextLabel")({
													Name = "TextLabel",
													AnchorPoint = Vector2.new(0.5, 0.5),
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BackgroundTransparency = 1,

													BorderColor3 = Color3.fromRGB(0, 0, 0),
													BorderSizePixel = 0,
													FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
													Position = UDim2.fromScale(0.5, 0.134),
													Size = UDim2.fromScale(0.934, 0.146),
													Text = scope:Computed(function(use)
														return use(voteData)[i] and use(voteData)[i].Name or ""
													end),
													TextColor3 = Color3.fromRGB(0, 200, 255),
													TextScaled = true,
													TextSize = 14,
													TextWrapped = true,

													[Children] = {
														scope:New("UIStroke")({
															Name = "UIStroke",
															Thickness = 2,
														}),
													},
												}),

												scope:New("UICorner")({
													Name = "UICorner",
													CornerRadius = UDim.new(0.15, 0),
												}),

												scope:New("UIStroke")({
													Name = "UIStroke",
													Thickness = 2,
												}),
											},
										}),

										scope:New("UIAspectRatioConstraint")({
											Name = "UIAspectRatioConstraint",
										}),

										scope:New("Frame")({
											Name = "Frame",
											AnchorPoint = Vector2.new(0.5, 0.5),
											BackgroundColor3 = Color3.fromRGB(0, 0, 0),
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											Position = UDim2.fromScale(0.52, 0.52),
											Size = UDim2.fromScale(1, 1),
											ZIndex = 0,

											[Children] = {
												scope:New("UICorner")({
													Name = "UICorner",
													CornerRadius = UDim.new(0.15, 0),
												}),
											},
										}),

										scope:New("Frame")({
											Name = "PlayerList",
											BackgroundColor3 = Color3.fromRGB(255, 255, 255),
											BackgroundTransparency = 1,
											BorderColor3 = Color3.fromRGB(0, 0, 0),
											BorderSizePixel = 0,
											Position = UDim2.fromScale(-0.12, 0.91),
											Size = UDim2.fromScale(1.22, 0.192),
											ZIndex = 2,

											[Children] = {
												scope:New("UIListLayout")({
													Name = "UIListLayout",
													FillDirection = Enum.FillDirection.Horizontal,
													HorizontalAlignment = Enum.HorizontalAlignment.Center,
													Padding = UDim.new(0.03, 0),
													SortOrder = Enum.SortOrder.LayoutOrder,
												}),

												scope:Computed(function(use, scope)
													local value = use(voteData)[i]

													if not value then
														return {}
													end

													return scope:ForValues(value.Players, function(use, scope, player)
														-- get player thumbnail

														local userId = player.UserId
														local thumbType = Enum.ThumbnailType.HeadShot
														local thumbSize = Enum.ThumbnailSize.Size420x420
														local content, _isReady = game.Players:GetUserThumbnailAsync(
															userId,
															thumbType,
															thumbSize
														)

														return scope:New("ImageLabel")({
															Name = "PlayerImage",
															BackgroundColor3 = Color3.fromRGB(255, 255, 255),
															BorderColor3 = Color3.fromRGB(0, 0, 0),
															BorderSizePixel = 0,
															Image = content,
															Size = UDim2.fromScale(1, 1),

															[Children] = {
																scope:New("UIAspectRatioConstraint")({
																	Name = "UIAspectRatioConstraint",
																}),

																scope:New("UICorner")({
																	Name = "UICorner",
																	CornerRadius = UDim.new(1, 0),
																}),

																scope:New("UIStroke")({
																	Name = "UIStroke",
																	Color = Color3.fromRGB(91, 171, 200),
																	Thickness = 2,
																}),
															},
														})
													end)
												end),
											},
										}),
									},
								})
							)
						end

						return children
					end),
				},
			})
		end,
	})
end

return VoteMap
