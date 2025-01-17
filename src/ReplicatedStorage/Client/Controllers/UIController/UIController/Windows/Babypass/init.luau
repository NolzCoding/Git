local Babypass = {}
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local computed = Fusion.Computed
local forValues = Fusion.ForValues
local event = Fusion.OnEvent
local Card = require(script.Parent.Parent.Parent.Components.UI.Card)
local Window = require(script.Parent.Parent.Parent.Components.UI.Window)
local DefaultButton = require(script.Parent.Parent.Parent.Components.Buttons.DefaultButton)
local Battlepass = require(ReplicatedStorage.Source.Shared.Battlepass)
local TextLabelWithStroke = require(script.Parent.Parent.Parent.Components.Text.TextLabelWithStroke)
local Section = require(script.Parent.Parent.Parent.Components.UI.Section)
local Sticker = require(script.Parent.Parent.Parent.Components.UI.Sticker)
local AbsoluteScaleComputed = require(ReplicatedStorage.Source.Shared.Uitility.AbsoluteScaleComputed)
local ImageButton = require(script.Parent.Parent.Parent.Components.Buttons.ImageButton)
local PassComponent = require(script.PassComponent)
local Icons = require(ReplicatedStorage.Source.Shared.Icons)
local TweenService = game:GetService("TweenService")
local Alerts = require(ReplicatedStorage.Source.Shared.Alerts)
local Endsin = require(script.Parent.Parent.Parent.Components.Util.Endsin)
function Babypass:Start() -- knit start
end

local AchivementInfo = require(ReplicatedStorage.Source.Shared.Achievements)

function Babypass:OnOpen(...)
end

function Babypass:Build(scope: typeof(Fusion.scoped(Fusion)), open)
	open:set(true)

	local DataService = Knit.GetService("DataService")
	local DataController = Knit.GetController("DataController")
	local BattlepassService = Knit.GetService("BattlepassService")
	local success, data = DataService.DataProperty:OnReady():await()

	local battlepassData = scope:Value(data.Battlepass)

	local season1Free = scope:Value(data.Battlepass.Passes.FreePassS1 or {})
	local season1Premium = scope:Value(data.Battlepass.Passes.PremiumPassS1 or {})

	DataController:OnDataChanged("Battlepass",function(data)

		season1Free:set(data.Passes.FreePassS1 or {})
		season1Premium:set(data.Passes.PremiumPassS1 or {})

	end)

	local endsin = Endsin(scope, {
		Expires = 1742140106
	})

	return Window(scope, {
		HeaderText = "Babypass",
		Size = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Open = open,
		Build = function(scope)

			return

			{TextLabelWithStroke(scope, {
				Text = scope:Computed(function(use)
					return "Season ends: " .. use(endsin)
				end),
				ZIndex = 6,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.fromScale(0.8, 0.08),
			}),


			scope:New("Frame")({
				BackgroundTransparency = 1,
				ZIndex = 3,
				Size = UDim2.fromScale(1, 1),
				[Children] = {



					PassComponent(scope, {
						Size = UDim2.fromScale(0.998, 0.391),
						Position = UDim2.fromScale(0, 0.13),
						Locked = scope:Computed(function(use)
							return not use(season1Premium).Claimed
						end),
						Pass = Battlepass.PremiumPassS1,
						PassEXP = scope:Computed(function(use)
							return use(season1Free).Exp or 0 -- use the free pass exp for now
						end),
						Claimed = scope:Computed(function(use)
							return use(season1Premium).Claimed or {}
						end),
						OnClaim = function(index)

							-- check if the player has the required amount of exp to claim the reward and has not already claimed it

							if Fusion.peek(season1Free).Exp >= Battlepass.PremiumPassS1[index].RequiredEXP and not Fusion.peek(season1Premium).Claimed[index] then
								BattlepassService:Claim("PremiumPassS1", index)
								game.SoundService:PlayLocalSound(game.SoundService["magic ramen done"])
							else

							end

						end,

						AvailableToClaim = Alerts.GamepassAlert


					}),

					PassComponent(scope, {
						Position = UDim2.fromScale(0, 0.57),
						Size = UDim2.fromScale(0.998, 0.391),
						Locked = false,
						Pass = Battlepass.FreePassS1,
						PassEXP = scope:Computed(function(use)
							return use(season1Free).Exp or 0
						end),
						Claimed = scope:Computed(function(use)
							return use(season1Free).Claimed or {}
						end),

						OnClaim = function(index)

							-- check if the player has the required amount of exp to claim the reward and has not already claimed it

							if Fusion.peek(season1Free).Exp >= Battlepass.FreePassS1[index].RequiredEXP and not Fusion.peek(season1Free).Claimed[index] then
								BattlepassService:Claim("FreePassS1", index)
								game.SoundService:PlayLocalSound(game.SoundService["magic ramen done"])
							end

						end,
						AvailableToClaim = Alerts.GamepassAlert

					}),

					DefaultButton(scope, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(145, 255, 19),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Visible = scope:Computed(function(use)
							return not use(season1Premium).Claimed
						end),
						BorderSizePixel = 0,
						FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
						Position = UDim2.fromScale(0.5, 0.498),
						Size = UDim2.fromOffset(200, 50),
						Text = "UNLOCK 489",
						TextColor3 = Color3.fromRGB(0, 0, 0),
						TextSize = 14,

						Build = function(scope)
							return scope:New("ImageLabel")({
								BackgroundTransparency = 1,
								Size = UDim2.fromScale(1, 1),
								ZIndex = 4,
								AnchorPoint = Vector2.new(0.5, 0.5),
								Rotation = 30,
								Position = UDim2.new(1.1, 0, 0.5, 0),
								Image = Icons.Lock256,
								[Children] = {
									scope:New("UIAspectRatioConstraint")({
										AspectRatio = 1,
									}),
								},
							})
						end,

						ButtonDown = function()

							MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, 2700938303)

						end,
						ButtonUp = function() end,
					}),


				},
			})}
		end,
	})
end

return Babypass
