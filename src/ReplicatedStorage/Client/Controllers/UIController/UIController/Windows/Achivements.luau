local Achivements = {}
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
function Achivements:Start() -- knit start
end

local AchivementInfo = require(ReplicatedStorage.Source.Shared.Achivements)

local function Achivement(scope, props: {

    Title : string,
    Points : number,
    MaxPoints : number,

})

    local progress = scope:Computed(function(use)
        return UDim2.fromScale(use(props.Points) / use(props.MaxPoints), 1)
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
                        Image = Icons.BrownBook264,
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
                        Text = "1x",
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
				Text = props.Title,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextStrokeColor3 = Color3.fromRGB(201, 143, 84),
				TextStrokeTransparency = 0.4,
				TextWrapped = true,
				ZIndex = 3,
			}),

			scope:New("CanvasGroup")({
				Name = "Progress",
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

function Achivements:Build(scope: typeof(Fusion.scoped(Fusion)), open)
	self.UIController = Knit.GetController("UIController")
	self.DataService = Knit.GetService("DataService")
	self.DataController = Knit.GetController("DataController")

	local ready, data = self.DataService.DataProperty:OnReady():await()

    local claimedAchivements = scope:Value(data.Achivements.Claimed)
    local actions = scope:Value(data.Achivements.Actions)

	return Window(scope, {
		HeaderText = "Achivements",
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
                        CellSize = AbsoluteScaleComputed(scope, absoluteCanvasSize, UDim2.fromScale(0.32, 0.17)),
                        --CellPadding = UDim2.new(0.05, 0, 0.05, 0),
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        VerticalAlignment = Enum.VerticalAlignment.Top,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                    },

                    scope:ForPairs(AchivementInfo.Rewards, function(use,scope, key, value)



                        return key, Achivement(scope, {
                            Title = value.Title,
                            Points = action,
                            MaxPoints = value.Amount,
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

return Achivements
