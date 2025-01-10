local Achievements = {}
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Fusion = require(ReplicatedStorage.Packages.fusion)
local Children = Fusion.Children
local computed = Fusion.Computed
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
function Achievements:Start() -- knit start
end

local AchivementInfo = require(ReplicatedStorage.Source.Shared.Achievements)

local function Achivement(scope, props: {

    Title : string,
    Description : string,
    Points : number,
    MaxPoints : number,
    Claimed : boolean,
    Claim : () -> (),

    RewardImage : string,
    RewardAmount : number,

})



    local progress = scope:Computed(function(use)

        print(Fusion.peek(use(props.Points)), Fusion.peek(use(props.MaxPoints)))

        return UDim2.fromScale(use(props.Points) / use(props.MaxPoints), 1)
    end)

    local showClaim = scope:Computed(function(use)
        return use(props.Points) >= use(props.MaxPoints)
    end)

	return scope:New("ImageLabel")({
		Name = "1",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(27, 42, 53),
		Image = "rbxassetid://4966060128",
		Position = UDim2.fromScale(0, 4.36e-08),
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromScale(0.92, 0.0818),

		ZIndex = 3,

		[Children] = {


			scope:New("ImageLabel")({
				Name = "AchivementBG",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				Image = "rbxassetid://4966059892",
				Position = UDim2.fromScale(0.05, 0.133),
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromScale(0.188, 0.682),
				ZIndex = 3,
                [Children] = {
                    scope:New("UIAspectRatioConstraint")({
                        AspectRatio = 1,
                    }),

                    scope:New("ImageLabel")({
                        Name = "ImageLabel",
                        BackgroundTransparency = 1,
                        Image = props.RewardImage,
                        Position = UDim2.fromScale(0.5, 0.5),
                        ScaleType = Enum.ScaleType.Fit,
                        Size = UDim2.fromScale(0.95,0.95),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        ZIndex = 1,

                    }),

                    scope:New("TextLabel")({
                        Name = "TextLabel",
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(27, 42, 53),
                        FontFace = Font.new(
                            "rbxasset://fonts/families/GothamSSm.json",
                            Enum.FontWeight.Heavy,
                            Enum.FontStyle.Normal
                        ),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.8),
                        Size = UDim2.fromScale(1, 0.3),
                        Text = scope:Computed(function(use)
                            return use(props.RewardAmount) .. "x"
                        end),
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextScaled = true,
                        TextSize = 14,
                        TextStrokeColor3 = Color3.fromRGB(201, 143, 84),
                        TextStrokeTransparency = 0.4,
                        TextWrapped = true,
                        ZIndex = 3,
                    }),

                },
			}),

			scope:New("TextLabel")({
				Name = "TextLabel",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Heavy,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.21, 0.211),
				Size = UDim2.fromScale(0.8, 0.2),
				Text = props.Description,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextStrokeColor3 = Color3.fromRGB(201, 143, 84),
				TextStrokeTransparency = 0.4,
				TextWrapped = true,
				ZIndex = 3,
			}),

            scope:New("TextLabel")({
				Name = "TextLabel",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3.fromRGB(27, 42, 53),
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Heavy,
					Enum.FontStyle.Normal
				),
				Position = UDim2.fromScale(0.05, -0.12),
				Size = UDim2.fromScale(0.5, 0.4),
				Text = props.Title,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextStrokeTransparency = 0.4,
				TextWrapped = true,
				ZIndex = 3,
                [Children] = {
                    scope:New("UIStroke")({
                        Color = Color3.fromRGB(104, 74, 44),
                        Thickness = 2,
                    }),
                },
			}),

            DefaultButton(scope, {
                Visible = showClaim,
                Text = scope:Computed(function(use)
                    return use(props.Claimed) and "Claimed" or "Claim"
                end),
                ButtonUp = function()

                    if Fusion.peek(props.Claimed) then
                        return
                    end

                    props.Claim()

                end,
                ButtonDown = function()

                end,

                BackgroundColor3 = scope:Computed(function(use)
                    return use(props.Claimed) and Color3.fromRGB(163, 163, 163) or Color3.fromRGB(136, 255, 0)
                end),

                Size = UDim2.fromScale(0.563, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.6, 0.65),

            }),

			scope:New("CanvasGroup")({
				Name = "Progress",
                Visible = scope:Computed(function(use)
                    return not use(showClaim)
                end),
				BackgroundColor3 = Color3.fromRGB(255, 221, 170),
				Position = UDim2.fromScale(0.386, 0.457),
				Size = UDim2.fromScale(0.563, 0.304),
				ZIndex = 3,
                [Children] = {

                    scope:New("UICorner")({
                        CornerRadius = UDim.new(1, 0),
                    }),

                    scope:New "UIStroke" {
                        Color = Color3.fromRGB(230, 188, 147),
                        Thickness = 2,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    },

                    scope:New "Frame" {
                        Size = progress,
                        BackgroundColor3 = Color3.fromRGB(196, 255, 33),
                    }

                }

			}),
		},
	})
end

function Achievements:Build(scope: typeof(Fusion.scoped(Fusion)), open)
	self.UIController = Knit.GetController("UIController")
	self.DataService = Knit.GetService("DataService")
	self.DataController = Knit.GetController("DataController")
    self.AchievementService = Knit.GetService("AchievementService")
    self.NotificationController = Knit.GetController("NotificationController")

    local AchievementNotified = {

    } :: {[string] : boolean}

	local ready, data = self.DataService.DataProperty:OnReady():await()

    print(data)

    local claimedAchievements = scope:Value(data.Achievements.Claimed)
    local actions = scope:Value(data.Achievements.Actions)

    self.DataController:OnDataChanged("Achievements", function(achievements)
        claimedAchievements:set(achievements.Claimed)
        actions:set(achievements.Actions)
    end)

	return Window(scope, {
		HeaderText = "Achievements",
        Size = UDim2.fromScale(0.5, 0.5),
        HeaderSize = UDim2.fromScale(0.3, 0.23),
        AnchorPoint = Vector2.new(0.5, 0.5),
		Open = open,
		Build = function(scope)
			local absoluteCanvasSize = scope:Value(Vector2.new(500,500))

            local scrollingFrame : ScrollingFrame = scope:New "ScrollingFrame" {
                ZIndex = 3,
                Size = UDim2.new(0.95, 0, 0.8, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1,
                CanvasSize = UDim2.new(0, 0, 4, 0),
                [Children] = {
                    scope:New "UIGridLayout" {
                        CellSize = AbsoluteScaleComputed(scope, absoluteCanvasSize, UDim2.fromScale(0.32, 0.2)),
                        --CellPadding = UDim2.new(0.05, 0, 0.05, 0),
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        VerticalAlignment = Enum.VerticalAlignment.Top,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                    },

                    scope:ForPairs(AchivementInfo.Rewards, function(use,scope, key, value : typeof(AchivementInfo.Rewards["Beginner Baby"])) -- : typeof(AchivementInfo.Rewards)

                        local points = scope:Computed(function(use)
                            return use(actions)[value.Action] or 0
                        end)

                        local isClaimed = scope:Computed(function(use)
                            return use(claimedAchievements)[key]
                        end)

                        local canClaim = scope:Computed(function(use)
                            return use(points) >= value.Amount
                        end)

                        scope:Observer(canClaim):onChange(function()

                            local claimable = Fusion.peek(canClaim)

                            if not AchievementNotified[key] and claimable and not Fusion.peek(isClaimed) then
                                self.NotificationController:TextNImage({
                                    Text = "Achievement " .. value.Title .. " Unlocked",
                                    Color = Color3.fromRGB(255, 205, 148),
                                    Icon = Icons.BrownBook264,
                                    Time = 5,
                                })

                                AchievementNotified[key] = true
                            end

                        end)

                        print(Fusion.peek(points))

                        return key, Achivement(scope, {
                            Title = value.Title,
                            Points = points,
                            Description = value.Description,
                            MaxPoints = value.Amount,
                            RewardImage = AchivementInfo.RewardImages[value.RewardType],
                            RewardAmount = value.Props.Amount,
                            Claimed = isClaimed,
                            Claim = function()
                                self.AchievementService:Claim(key)
                            end
                        })
                    end)

                }
            }

            absoluteCanvasSize:set(scrollingFrame.AbsoluteWindowSize)

            scrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
                absoluteCanvasSize:set(scrollingFrame.AbsoluteWindowSize)
            end)

            return {
                scrollingFrame
            }

		end,
	})
end

return Achievements
